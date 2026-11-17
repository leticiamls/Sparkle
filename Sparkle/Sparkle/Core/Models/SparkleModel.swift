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
    
    init(name: String, classification: String, reminder: String, repetition: String, startDate: Date, isDone: Bool = false) {
        self.name = name
        self.classification = classification
        self.reminder = reminder
        self .repetition = repetition
        self .startDate = startDate
        self.isDone = isDone
    }
}
