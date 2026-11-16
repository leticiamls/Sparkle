//
//  Untitled.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 11/11/26.
//
import UIKit

class SparkleSheet: UIViewController {
    
    var toSave: ((SparkleModel) -> Void)?
    
    static let labelColor = UIColor(red: 89/255.0, green: 61/255.0, blue: 96/255.0, alpha: 1.0)
    static let buttonLabelColor = UIColor(red: 163/255.0, green: 76/255.0, blue: 117/255.0, alpha: 1.0)
    
    let sheetTitle: UILabel = {
        let label = UILabel()
        label.text = "Novo Sparkle"
        label.font = .systemFont(ofSize: 34, weight: .semibold)
        label.textColor = labelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cards: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.spacing = 20
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let inputCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondInputCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sparkleName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nome"
        textField.layer.cornerRadius = 26
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let sparkleClassification: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Selecionar"
        config.baseForegroundColor = buttonLabelColor
        
        let button = UIButton(configuration: config)
        
        button.menu = UIMenu(children: [
            UIAction(title: "Cabelo", handler: { action in
                button.setTitle(action.title, for: .normal)
            }),
            UIAction(title: "Pele", handler: { action in
                button.setTitle(action.title, for: .normal)
            }),
            UIAction(title: "Unhas", handler: { action in
                button.setTitle(action.title, for: .normal)
            })
        ])
        
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sparkleRepetition: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Selecionar"
        config.baseForegroundColor = buttonLabelColor
        
        let button = UIButton(configuration: config)
        
        button.menu = UIMenu(children: [
            UIAction(title: "Diariamente", handler: { action in
                button.setTitle(action.title, for: .normal)
            }),
            UIAction(title: "Semanalmente", handler: { action in
                button.setTitle(action.title, for: .normal)
            }),
            UIAction(title: "Quinzenalmente", handler: { action in
                button.setTitle(action.title, for: .normal)
            }),
            UIAction(title: "Mensalmente", handler: { action in
                button.setTitle(action.title, for: .normal)
            })
        ])
        
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sparkleReminder: UIDatePicker = {
        let date = UIDatePicker()
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    let reminderLabel: UILabel = {
        let label = UILabel()
        label.text = "Lembrete"
        label.font = .systemFont(ofSize: 16)
        label.textColor = labelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Categoria"
        label.font = .systemFont(ofSize: 16)
        label.textColor = labelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repetitionLabel: UILabel = {
        let label = UILabel()
        label.text = "Repetição"
        label.font = .systemFont(ofSize: 16)
        label.textColor = labelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saveButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Salvar"
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 26
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aplicarGradiente()
        aplicarGradienteNoBotao()
        configurarLayout()
        saveButton.addTarget(self, action: #selector(saveSparkle), for: .touchUpInside)
    }
    
    @objc func saveSparkle() {
        let newSparkle = SparkleModel(
            name: sparkleName.text ?? "",
            classification: sparkleClassification.currentTitle ?? "Selecionar",
            reminder: sparkleReminder.date,
            repetition: sparkleRepetition.currentTitle ?? "Definir"
        )
        print("Sparkle Salvo")
        toSave?(newSparkle)
        dismiss(animated: true)
    }
    
    func aplicarGradiente() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let snowColor = UIColor(red: 255/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        let softPinkColor = UIColor(red: 255/255.0, green: 226/255.0, blue: 238/255.0, alpha: 1.0)
        
        gradientLayer.colors = [
            snowColor.cgColor,
            softPinkColor.cgColor,
            UIColor.white.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func aplicarGradienteNoBotao() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = saveButton.bounds
        
        let rosaClaro = UIColor(red: 215/255.0, green: 137/255.0, blue: 169/255.0, alpha: 1.0)
        let rosaMedio = UIColor(red: 197/255.0, green: 107/255.0, blue: 146/255.0, alpha: 1.0)
        let rosaEscuro = UIColor(red: 182/255.0, green: 84/255.0, blue: 128/255.0, alpha: 1.0)
        
        gradientLayer.colors = [
            rosaClaro.cgColor,
            rosaMedio.cgColor,
            rosaEscuro.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        saveButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
        if let buttonGradient = saveButton.layer.sublayers?.first as? CAGradientLayer {
            buttonGradient.frame = saveButton.bounds
        }
    }
    
    func configurarLayout() {
        view.addSubview(sheetTitle)
        view.addSubview(cards)
        cards.addArrangedSubview(inputCard)
        cards.addArrangedSubview(secondInputCard)
        
        inputCard.addSubview(sparkleName)
        inputCard.addSubview(separatorLine)
        inputCard.addSubview(sparkleClassification)
        inputCard.addSubview(categoryLabel)
        
        secondInputCard.addSubview(sparkleRepetition)
        secondInputCard.addSubview(secondSeparatorLine)
        secondInputCard.addSubview(sparkleReminder)
        secondInputCard.addSubview(repetitionLabel)
        secondInputCard.addSubview(reminderLabel)
        
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            sheetTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            sheetTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            
            cards.topAnchor.constraint(equalTo: sheetTitle.bottomAnchor, constant: 40),
            cards.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cards.widthAnchor.constraint(equalToConstant: 345),
            
            inputCard.heightAnchor.constraint(equalToConstant: 128),
            
            sparkleName.topAnchor.constraint(equalTo: inputCard.topAnchor),
            sparkleName.leadingAnchor.constraint(equalTo: inputCard.leadingAnchor, constant: 20),
            sparkleName.trailingAnchor.constraint(equalTo: inputCard.trailingAnchor, constant: -20),
            sparkleName.heightAnchor.constraint(equalToConstant: 64),
            
            separatorLine.topAnchor.constraint(equalTo: sparkleName.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: inputCard.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: inputCard.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            sparkleClassification.topAnchor.constraint(equalTo: sparkleName.bottomAnchor),
            sparkleClassification.trailingAnchor.constraint(equalTo: inputCard.trailingAnchor, constant: -5),
            sparkleClassification.heightAnchor.constraint(equalToConstant: 64),
            
            categoryLabel.centerYAnchor.constraint(equalTo: sparkleClassification.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: inputCard.leadingAnchor, constant: 20),
            
            secondInputCard.heightAnchor.constraint(equalToConstant: 128),
            
            sparkleRepetition.topAnchor.constraint(equalTo: secondInputCard.topAnchor),
            sparkleRepetition.trailingAnchor.constraint(equalTo: secondInputCard.trailingAnchor, constant: -20),
            sparkleRepetition.heightAnchor.constraint(equalToConstant: 64),
            
            repetitionLabel.centerYAnchor.constraint(equalTo: sparkleRepetition.centerYAnchor),
            repetitionLabel.leadingAnchor.constraint(equalTo: secondInputCard.leadingAnchor, constant: 20),
            
            secondSeparatorLine.topAnchor.constraint(equalTo: sparkleRepetition.bottomAnchor),
            secondSeparatorLine.leadingAnchor.constraint(equalTo: secondInputCard.leadingAnchor, constant: 16),
            secondSeparatorLine.trailingAnchor.constraint(equalTo: secondInputCard.trailingAnchor, constant: -16),
            secondSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            sparkleReminder.topAnchor.constraint(equalTo: sparkleRepetition.bottomAnchor),
            sparkleReminder.trailingAnchor.constraint(equalTo: secondInputCard.trailingAnchor, constant: -5),
            sparkleReminder.heightAnchor.constraint(equalToConstant: 64),
            
            reminderLabel.centerYAnchor.constraint(equalTo: sparkleReminder.centerYAnchor),
            reminderLabel.leadingAnchor.constraint(equalTo: secondInputCard.leadingAnchor, constant: 20),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 345),
            saveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}

#Preview {
    SparkleSheet()
}
