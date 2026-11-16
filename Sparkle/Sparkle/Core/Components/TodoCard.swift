//
//  TodoCard.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 13/11/26.
//
import UIKit

class SparkleCardView: UIView {
    
    let sparkleTitleView: UILabel = {
        let label = UILabel()
        label.text = "Pintar Unhas"
        label.textColor = .labelColor
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let icon = SparkleIcon()
    
    private let todoCheckbox = Checkbox(isChecked: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurarCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurarCard() {
        backgroundColor = .white
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(sparkleTitleView)
        addSubview(todoCheckbox)
        addSubview(icon)
        
        NSLayoutConstraint.activate([
            
            widthAnchor.constraint(equalToConstant: 345),
            heightAnchor.constraint(equalToConstant: 88),
            
            sparkleTitleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            sparkleTitleView.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 16),
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            todoCheckbox.centerYAnchor.constraint(equalTo: centerYAnchor),
            todoCheckbox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupBindings() {
        todoCheckbox.onToggle = { isChecked in
            print("Feito")
        }
    }
}

#Preview {
    let telaFundo = UIView()
    telaFundo.backgroundColor = UIColor(red: 255/255.0, green: 226/255.0, blue: 238/255.0, alpha: 1.0)
    
    let card = SparkleCardView()
    telaFundo.addSubview(card)
    
    NSLayoutConstraint.activate([
        card.centerXAnchor.constraint(equalTo: telaFundo.centerXAnchor),
        card.centerYAnchor.constraint(equalTo: telaFundo.centerYAnchor)
    ])
    
    return telaFundo
}
