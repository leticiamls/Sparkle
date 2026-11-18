//
//  ViewController.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 10/11/26.
//

import UIKit

class ViewController: UIViewController {
    
    private let remindersManager = ReminderIntegrationManager()
    
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
        config.image = UIImage(systemName: "plus")
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
    
    let yourSparklesLabel: UILabel = {
        let label = UILabel()
        label.text = "Seus Sparkles"
        label.textColor = .labelColor
        label.font = UIFont(name: "CormorantGaramond-SemiBold", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let sparkleList = SparkleListView()
    
    let dayPickerStackView = DayPickerStackView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        addButton.aplicarGradienteNoBotao()
        configurarLayout()
        loadGreetings()
        
        greetingsView.isUserInteractionEnabled = true
        greetingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userName)))
        
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
        view.addSubview(yourSparklesLabel)
        view.addSubview(addButton)
        view.addSubview(scrollView)
        scrollView.addSubview(sparkleList)
        
        NSLayoutConstraint.activate([
            greetingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            greetingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29),
            
            textDateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textDateView.topAnchor.constraint(equalTo: greetingsView.bottomAnchor),
            
            dayPickerStackView.topAnchor.constraint(equalTo: textDateView.bottomAnchor, constant: 35),
            dayPickerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            yourSparklesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            yourSparklesLabel.topAnchor.constraint(equalTo: dayPickerStackView.bottomAnchor, constant: 33),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29),
            
            addButton.widthAnchor.constraint(equalToConstant: 48),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            
            scrollView.topAnchor.constraint(equalTo: yourSparklesLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            sparkleList.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            sparkleList.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            sparkleList.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            sparkleList.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func loadGreetings() {
        let time = Calendar.current.component(.hour, from: Date())
        let greeting: String
        
        switch time {
        case 5..<12:
            greeting = "Bom Dia"
        case 12..<18:
            greeting = "Boa Tarde"
        default:
            greeting = "Boa Noite"
        }
        
        let name = UserDefaults.standard.string(forKey: "userName") ?? ""
        if name.isEmpty {
            greetingsView.text = "\(greeting)!"
        } else {
            greetingsView.text = "\(greeting), \(name)!"
        }
    }
    
    
    
    @objc private func userName() {
        let alert = UIAlertController(
            title: "Como podemos te chamar?",
            message: "Digite seu nome para personalizar sua tela inicial",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Seu nome"
            textField.text = UserDefaults.standard.string(forKey: "userName")
            textField.autocapitalizationType = .words
        }
        
        alert.addAction(UIAlertAction(title: "Salvar", style: .default) { [weak self] _ in
            if let nome = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces), !nome.isEmpty {
                UserDefaults.standard.set(nome, forKey: "userName")
                self?.loadGreetings()
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
}

#Preview {
    ViewController()
}
