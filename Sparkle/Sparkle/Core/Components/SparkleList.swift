//
//  SparkleList.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//

import UIKit
import SwiftData

class SparkleListView: UIView {
    
    let container = try? ModelContainer(for: SparkleModel.self)
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        listConfig()
        loadSavedSparkles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func listConfig() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func addSparkle(_ newSparkle: SparkleModel) {
        container?.mainContext.insert(newSparkle)
        try? container?.mainContext.save()
        
        let card = SparkleCardView()
        card.load(com: newSparkle)
        stackView.addArrangedSubview(card)
    }
    
    func loadSavedSparkles() {
        let descriptor = FetchDescriptor<SparkleModel>()
        guard let saved = try? container?.mainContext.fetch(descriptor) else { return }
        
        for sparkle in saved {
            createCardOnStack(para: sparkle)
        }
    }
    
    private func createCardOnStack(para sparkle: SparkleModel) {
        let card = SparkleCardView()
        card.load(com: sparkle)
        card.loadState = { [weak self] isChecked in
            sparkle.isDone = isChecked
            try? self?.container?.mainContext.save()
        }
        stackView.addArrangedSubview(card)
    }
}


