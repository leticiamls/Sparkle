//
//  SparkleOptions.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//

import UIKit

enum SparkleCategory: String, CaseIterable, Identifiable {
    case cabelo = "Cabelo"
    case pele = "Pele"
    case unhas = "Unhas"
    
    var id: Self { self }
}

enum SparkleRepetition: String, CaseIterable, Identifiable {
    case diariamente = "Diariamente"
    case semanalmente = "Semanalmente"
    case aCadaDuasSemanas = "A Cada 2 Semanas"
    case mensalmente = "Mensalmente"
    case anualmente = "Anualmente"
    
    var id: Self { self }
}

enum SparkleReminder: String, CaseIterable, Identifiable {
    case desativado = "Desativado"
    case meiaHoraAntes = "Meia hora antes"
    case umDiaAntes = "Um dia antes"
    case doisDiasAntes = "Dois dias antes"
    
    var id: Self { self }
}
