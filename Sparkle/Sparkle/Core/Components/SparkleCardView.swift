//
//  TodoCard.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 13/11/26.
//
import UIKit

class SparkleCardView: UIView {
    
    var loadState: ((Bool) -> Void)?
    var onDelete: (() -> Void)?
    
    // Camada branca da frente (que desliza no arraste)
    private let cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Botão de lixeira que fica escondido no fundo vermelho
    private lazy var deleteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "trash.fill")
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(confirmDelete), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        setupBindings()
        setupSwipeToDelete()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurarCard() {
        backgroundColor = .systemRed
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(deleteButton)
        addSubview(cardContainerView)
        
        cardContainerView.addSubview(sparkleTitleView)
        cardContainerView.addSubview(todoCheckbox)
        cardContainerView.addSubview(icon)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 345),
            heightAnchor.constraint(equalToConstant: 88),
            
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 44),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            
            cardContainerView.topAnchor.constraint(equalTo: topAnchor),
            cardContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            sparkleTitleView.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
            sparkleTitleView.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 16),
            
            icon.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 16),
            
            todoCheckbox.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
            todoCheckbox.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -16)
        ])
    }
    
    func load(com sparkle: SparkleModel) {
        sparkleTitleView.text = sparkle.name
        icon.defineColor(para: sparkle.classification)
        todoCheckbox.isChecked = sparkle.isDone
    }
    
    private func setupBindings() {
        todoCheckbox.onToggle = { [weak self] isChecked in
            self?.loadState?(isChecked)
        }
    }
    
    private func setupSwipeToDelete() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        cardContainerView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .changed:
            if translation.x < 0 {
                cardContainerView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            } else if cardContainerView.transform.tx < 0 {
                let newX = min(0, -80 + translation.x)
                cardContainerView.transform = CGAffineTransform(translationX: newX, y: 0)
            }
            
        case .ended, .cancelled:
            if translation.x < -160 {
                confirmDelete()
            } else if translation.x < -60 {
                UIView.animate(withDuration: 0.2) {
                    self.cardContainerView.transform = CGAffineTransform(translationX: -80, y: 0)
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.cardContainerView.transform = .identity
                }
            }
            
        default:
            break
        }
    }
    
    @objc private func confirmDelete() {
        UIView.animate(withDuration: 0.2, animations: {
            self.cardContainerView.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
            self.alpha = 0
        }, completion: { _ in
            self.onDelete?()
        })
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
