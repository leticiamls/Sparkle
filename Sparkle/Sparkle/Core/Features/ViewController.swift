//
//  ViewController.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 10/11/26.
//

import UIKit

struct SparkleModel: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var classification: String
    var reminder: Date
    var repetition: String
}

class ViewController: UIViewController {
    let greetingsView: UILabel = {
        let label = UILabel()
        label.text = "Bom dia, Kyle!"
        label.textColor = UIColor(red: 89/255.0, green: 61/255.0, blue: 96/255.0, alpha: 1.0)
        label.font = .systemFont(ofSize: 33, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "+"
        config.baseBackgroundColor = .clear
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let textDateView: UILabel = {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale.current
        
        let label = UILabel()
        label.text = formatter.string(from: currentDate)
        label.textColor = UIColor(red: 89/255.0, green: 61/255.0, blue: 96/255.0, alpha: 1.0)
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sparkleCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sparkleTitleView: UILabel = {
        let label = UILabel()
        label.text = "Pintar Unhas"
        label.textColor = .systemPink
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func aplicarGradiente() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let softPinkColor = UIColor(red: 255/255.0, green: 226/255.0, blue: 238/255.0, alpha: 1.0)
        let softPurple = UIColor(red: 249/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0)
        
        gradientLayer.colors = [
            softPinkColor.cgColor,
            softPurple.cgColor,
            UIColor.white.withAlphaComponent(1).cgColor,
            softPinkColor.cgColor,
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    func aplicarGradienteNoBotao() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = addButton.bounds
        
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
        
        gradientLayer.cornerRadius = 24
        
        addButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        aplicarGradiente()
        aplicarGradienteNoBotao()
        
        configurarLayout()
        addButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = addButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = addButton.bounds
        }
    }
    
    @objc func buttonClicked() {
        let sheet = AddSparkleSheetViewController()
        if let sheet = sheet.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(sheet, animated: true)
    }
    
    func configurarLayout() {
        view.addSubview(sparkleCardView)
        sparkleCardView.addSubview(sparkleTitleView)
        view.addSubview(greetingsView)
        view.addSubview(textDateView)
        view.addSubview(addButton)
        
        
        NSLayoutConstraint.activate([
            sparkleCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sparkleCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sparkleCardView.widthAnchor.constraint(equalToConstant: 345),
            sparkleCardView.heightAnchor.constraint(equalToConstant: 88),
            
            sparkleTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sparkleTitleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            greetingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            greetingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29),
            
            textDateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textDateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29),
            
            addButton.widthAnchor.constraint(equalToConstant: 48),
            addButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

#Preview {
    ViewController()
}
