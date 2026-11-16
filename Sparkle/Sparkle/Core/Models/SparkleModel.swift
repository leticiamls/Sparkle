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
    var reminder: Date
    var repetition: String
    var isDone: Bool = false
    
    init(name: String, classification: String, reminder: Date, repetition: String, isDone: Bool = false) {
        self.name = name
        self.classification = classification
        self.reminder = reminder
        self .repetition = repetition
        self.isDone = isDone
    }
}
