//
//  SparkleList.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//

import UIKit
import SwiftData

class SparkleListView: UIView {
    
    private let repository = SparkleRepository()
    
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
        repository.insert(newSparkle)
        createCardOnStack(para: newSparkle)
    }
    
    func loadSavedSparkles() {
        let saved = repository.fetchAll()
        for sparkle in saved {
            createCardOnStack(para: sparkle)
        }
    }
    
    private func createCardOnStack(para sparkle: SparkleModel) {
        let card = SparkleCardView()
        card.load(com: sparkle)
        
        card.loadState = { [weak self] isChecked in
            sparkle.isDone = isChecked
            self?.repository.save()
        }
        
        card.onDelete = { [weak self, weak card] in
            guard let self = self, let card = card else { return }
            self.repository.delete(sparkle)
            
            UIView.animate(withDuration: 0.25) {
                self.stackView.removeArrangedSubview(card)
                card.removeFromSuperview()
                self.stackView.layoutIfNeeded()
            }
        }
        
        stackView.addArrangedSubview(card)
    }
}


