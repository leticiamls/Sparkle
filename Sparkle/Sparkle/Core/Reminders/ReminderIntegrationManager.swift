//
//  ReminderIntegrationManager.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 18/11/26.
//

import Foundation
import EventKit

class ReminderIntegrationManager {
    private let eventStore = EKEventStore()
    static let shared = ReminderIntegrationManager()
    
    func saveReminder(
        title: String,
        dueDate: Date?,
        repetition: SparkleRepetition,
        notes: String? = nil,
        completion: @escaping (String?, Error?) -> Void
    ) {
        eventStore.requestFullAccessToReminders { [weak self] granted, error in
            guard let self = self else { return }
            
            guard granted, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let reminder = EKReminder(eventStore: self.eventStore)
            reminder.title = title
            reminder.notes = notes
            reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
            
            if let dueDate = dueDate {
                let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
                reminder.dueDateComponents = components
                reminder.addAlarm(EKAlarm(absoluteDate: dueDate))
            }
            
            reminder.addRecurrenceRule(self.makeRecurrenceRule(for: repetition))
            
            do {
                try self.eventStore.save(reminder, commit: true)
                let savedId = reminder.calendarItemIdentifier
                DispatchQueue.main.async {
                    completion(savedId, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func deleteReminder(withId id: String?) {
        guard let id = id else { return }
        
        eventStore.requestFullAccessToReminders { [weak self] granted, _ in
            guard let self = self, granted,
                  let reminder = self.eventStore.calendarItem(withIdentifier: id) as? EKReminder else { return }
            
            try? self.eventStore.remove(reminder, commit: true)
        }
    }
    
    private func makeRecurrenceRule(for repetition: SparkleRepetition) -> EKRecurrenceRule {
        switch repetition {
        case .diariamente:
            return EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)
        case .aCadaDoisDias:
            return EKRecurrenceRule(recurrenceWith: .daily, interval: 2, end: nil)
        case .semanalmente:
            return EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil)
        case .aCadaDuasSemanas:
            return EKRecurrenceRule(recurrenceWith: .weekly, interval: 2, end: nil)
        case .mensalmente:
            return EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, end: nil)
        case .anualmente:
            return EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil)
        }
    }
}
