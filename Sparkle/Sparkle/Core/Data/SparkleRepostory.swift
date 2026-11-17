//
//  SparkleRepostory.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//
import Foundation
import SwiftData

class SparkleRepository {
    static let sharedContainer: ModelContainer? = {
        do {
            return try ModelContainer(for: SparkleModel.self)
        } catch {
            print("Banco antigo incompatível detectado, recriando store: \(error)")
            // Apaga o default.store antigo incompatível (inclusive no #Preview) e recria
            let storeURL = URL.applicationSupportDirectory.appending(path: "default.store")
            for ext in ["", "-shm", "-wal"] {
                let fileURL = URL(filePath: storeURL.path() + ext)
                try? FileManager.default.removeItem(at: fileURL)
            }
            return try? ModelContainer(for: SparkleModel.self)
        }
    }()
    
    var container: ModelContainer? {
        Self.sharedContainer
    }
    
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
