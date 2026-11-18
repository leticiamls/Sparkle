//
//  ViewController.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 10/11/26.
//

import UIKit

class ViewController: UIViewController {
    var sparkles: [SparkleModel] = []
    
    let greetingsView: UILabel = {
        let label = UILabel()
        label.text = "Bom dia, Kyle!"
        label.textColor = UIColor(red: 89/255.0, green: 61/255.0, blue: 96/255.0, alpha: 1.0)
        label.font = UIFont(name: "CormorantGaramond-SemiBold", size: 33)
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
    
    let sparkleList = SparkleListView()
    
    let dayPickerStackView = DayPickerStackView()
    
    
    let sparkleTitleView: UILabel = {
        let label = UILabel()
        label.text = "Pintar Unhas"
        label.textColor = .systemPink
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        addButton.aplicarGradienteNoBotao()
        for family in UIFont.familyNames {
            print("Família: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("==> Nome interno para o código: \(name)")
            }
        }
        
        configurarLayout()
        addButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        dayPickerStackView.onDateSelected = { [weak self] selectedDate in
            self?.sparkleList.loadSavedSparkles(para: selectedDate)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = addButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = addButton.bounds
        }
    }
    
    @objc func buttonClicked() {
        let sheet = SparkleSheet()
        
        sheet.toSave = { [weak self] newSparkle in
            self?.sparkleList.addSparkle(newSparkle)
        }
        
        if let sheet = sheet.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(sheet, animated: true)
    }
    
    func configurarLayout() {
        view.aplicarGradiente()
        view.addSubview(greetingsView)
        view.addSubview(textDateView)
        view.addSubview(dayPickerStackView)
        view.addSubview(addButton)
        view.addSubview(sparkleList)
        
        
        
        NSLayoutConstraint.activate([
            greetingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            greetingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29),
            
            textDateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textDateView.topAnchor.constraint(equalTo: greetingsView.bottomAnchor, constant: 4),
            
            dayPickerStackView.topAnchor.constraint(equalTo: textDateView.bottomAnchor, constant: 35),
            dayPickerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29),
            
            addButton.widthAnchor.constraint(equalToConstant: 48),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            
            sparkleList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sparkleList.topAnchor.constraint(equalTo: dayPickerStackView.bottomAnchor, constant: 30),
        ])
    }
}

#Preview {
    ViewController()
}
