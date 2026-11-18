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
    private var currentDate: Date = Date()
    
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
        
        if newSparkle.shouldAppear(em: currentDate) {
            createCardOnStack(para: newSparkle)
        }
    }
    
    func loadSavedSparkles(para date: Date = Date()) {
        currentDate = date
        let saved = repository.fetchAll()
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for sparkle in saved {
            if sparkle.shouldAppear(em: currentDate){
                createCardOnStack(para: sparkle)
            }
        }
    }
    
    private func createCardOnStack(para sparkle: SparkleModel) {
        let card = SparkleCardView()
        card.load(com: sparkle, data: currentDate)
        
        card.loadState = { [weak self] isChecked in
            guard let self = self else { return }
            sparkle.setCompleted(isChecked, em: self.currentDate)
            self.repository.save()
        }
        
        card.onDelete = { [weak self, weak card] in
            guard let self = self, let card = card else { return }
            self.presentDeleteAlert(for: sparkle, card: card)
        }
        
        stackView.addArrangedSubview(card)
    }
    
    private func presentDeleteAlert(for sparkle: SparkleModel, card: SparkleCardView) {
        let alert = UIAlertController(
            title: "Apagar Sparkle recorrente",
            message: nil,
            preferredStyle: .alert
        )
        
        // Apenas este evento
        alert.addAction(UIAlertAction(title: "Apenas este evento", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            sparkle.excludedDates.append(self.currentDate)
            self.repository.save()
            self.removeCardFromStack(card)
        })
        
        // Este e os próximos eventos
        alert.addAction(UIAlertAction(title: "Este e os próximos eventos", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            sparkle.endDate = Calendar.current.startOfDay(for: self.currentDate)
            self.repository.save()
            self.removeCardFromStack(card)
        })
        
        // Todos os eventos
        alert.addAction(UIAlertAction(title: "Todos os eventos", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.repository.delete(sparkle)
            self.removeCardFromStack(card)
        })
        
        // Cancelar
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            card.resetSwipe()
        })
        
        window?.rootViewController?.present(alert, animated: true)
    }
    
    private func removeCardFromStack(_ card: SparkleCardView) {
        card.animateRemoval { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.25) {
                self.stackView.removeArrangedSubview(card)
                card.removeFromSuperview()
                self.stackView.layoutIfNeeded()
            }
        }
    }
}
