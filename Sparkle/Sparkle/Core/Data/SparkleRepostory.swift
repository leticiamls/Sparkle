//
//  SparkleRepostory.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//
import Foundation
import SwiftData

class SparkleRepository {
    let container: ModelContainer? = {
        do {
            return try ModelContainer(for: SparkleModel.self)
        } catch {
            print("Erro ao criar o modelContainer: \(error)")
            return nil
        }
    }()
    
    func fetchAll() -> [SparkleModel] {
        let descriptor = FetchDescriptor<SparkleModel>()
        return (try? container?.mainContext.fetch(descriptor)) ?? []
    }
    
    func insert(_ sparkle: SparkleModel) {
        container?.mainContext.insert(sparkle)
        save()
    }
    
    func save() {
        try? container?.mainContext.save()
    }
    
    func delete(_ sparkle: SparkleModel) {
        container?.mainContext.delete(sparkle)
        save()
    }
}
