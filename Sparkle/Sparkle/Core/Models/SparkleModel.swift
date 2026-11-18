//
//  SparkleModel.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//

import UIKit
import SwiftData

@Model
class SparkleModel: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var classification: String
    var reminder: String
    var repetition: String
    var startDate: Date
    var isDone: Bool = false
    var excludedDates: [Date] = []
    var endDate: Date? = nil
    var completedDates: [Date] = []
    
    func shouldAppear(em targetDate: Date = Date()) -> Bool {
        let calendar = Calendar.current
        
        let start = calendar.startOfDay(for: startDate)
        let target = calendar.startOfDay(for: targetDate)
        
        if target < start {
            return false
        }
        
        if let endDate = endDate, target >= calendar.startOfDay(for: endDate) {
            return false
        }
        
        if excludedDates.contains(where: {calendar.isDate($0, inSameDayAs: target)}) {
            return false
        }
        
        let pastDays = calendar.dateComponents([.day], from: start, to: target).day ?? 0
        
        switch SparkleRepetition(rawValue: repetition) {
        case .diariamente:
            return true
            
        case .aCadaDoisDias:
            return pastDays % 2 == 0
            
        case .semanalmente:
            return pastDays % 7 == 0
            
        case .aCadaDuasSemanas:
            return pastDays % 14 == 0
            
        case .mensalmente:
            let startDay = calendar.component(.day, from: start)
            let targetDay = calendar.component(.day, from: target)
            return startDay == targetDay
            
        case .anualmente:
            let startComponent = calendar.dateComponents([.day, .month], from: start)
            let targetComponent = calendar.dateComponents([.day, .month], from: target)
            return startComponent.month == targetComponent.month && startComponent.day == targetComponent.day
            
        case .none:
            return pastDays == 0
        }
    }
    
    func isCompleted(em date: Date) -> Bool {
            completedDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
        }
    
    func setCompleted(_ completed: Bool, em date: Date) {
            let day = Calendar.current.startOfDay(for: date)
            completedDates.removeAll { Calendar.current.isDate($0, inSameDayAs: day) }
            if completed {
                completedDates.append(day)
            }
        }
    
    init(name: String, classification: String, reminder: String, repetition: String, startDate: Date, isDone: Bool = false) {
        self.name = name
        self.classification = classification
        self.reminder = reminder
        self .repetition = repetition
        self .startDate = startDate
        self.isDone = isDone
    }
}
