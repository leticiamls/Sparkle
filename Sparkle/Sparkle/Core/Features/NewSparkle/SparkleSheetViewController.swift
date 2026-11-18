//
//  SparkleSheet.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 11/11/26.
//
import UIKit

// MARK: - SparkleSheet
class SparkleSheet: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var toSave: ((SparkleModel) -> Void)?
    
    private var typedName: String = "" {
        didSet {
            let sparkleHasName = !typedName.trimmingCharacters(in: .whitespaces).isEmpty
            saveButton.isEnabled = sparkleHasName
            saveButton.alpha = sparkleHasName ? 1.0 : 0.5
        }
    }
    private var selectedCategory: SparkleCategory = .cabelo
    private var selectedRepetition: SparkleRepetition = .diariamente
    private var selectedStartDate: Date = Date()
    private var selectedReminder: SparkleReminder = .desativado
    
    static let labelColor = UIColor(red: 89/255.0, green: 61/255.0, blue: 96/255.0, alpha: 1.0)
    static let buttonLabelColor = UIColor(red: 163/255.0, green: 76/255.0, blue: 117/255.0, alpha: 1.0)
    
    let sheetTitle: UILabel = {
        let label = UILabel()
        label.text = "Novo Sparkle"
        label.font = UIFont(name: "CormorantGaramond-SemiBold", size: 33)
        label.textColor = labelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.isScrollEnabled = false
        table.rowHeight = 64
        table.dataSource = self
        table.delegate = self
        table.register(SparkleTextFieldCell.self, forCellReuseIdentifier: SparkleTextFieldCell.identifier)
        table.register(SparkleMenuPickerCell.self, forCellReuseIdentifier: SparkleMenuPickerCell.identifier)
        table.register(SparkleStartDate.self, forCellReuseIdentifier: SparkleStartDate.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let saveButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Salvar"
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 26
        button.clipsToBounds = true
        button.isEnabled = false
        button.alpha = 0.5
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
        let cleanName = typedName.trimmingCharacters(in: .whitespaces)
        guard !cleanName.isEmpty else { return }
        let newSparkle = SparkleModel(
            name: typedName,
            classification: selectedCategory.rawValue,
            reminder: selectedReminder.rawValue,
            repetition: selectedRepetition.rawValue,
            startDate: selectedStartDate
        )
        print("Sparkle Salvo com sucesso!")
        toSave?(newSparkle)
        dismiss(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        2 // Duas caixas agrupadas (insetGrouped)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2 // Nome e Categoria
        case 1: return 3 // Repetição, Data de Início e Lembrete
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SparkleTextFieldCell.identifier,
                for: indexPath
            ) as! SparkleTextFieldCell
            cell.onTextChanged = { [weak self] text in
                self?.typedName = text
            }
            return cell
            
        case (0, 1):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SparkleMenuPickerCell.identifier,
                for: indexPath
            ) as! SparkleMenuPickerCell
            cell.configure(
                title: "Categoria",
                options: SparkleCategory.allCases.map { $0.rawValue },
                initialSelected: selectedCategory.rawValue
            )
            cell.onOptionSelected = { [weak self] selected in
                if let category = SparkleCategory(rawValue: selected) {
                    self?.selectedCategory = category
                }
            }
            return cell
            
        case (1, 0):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SparkleMenuPickerCell.identifier,
                for: indexPath
            ) as! SparkleMenuPickerCell
            cell.configure(
                title: "Repetição",
                options: SparkleRepetition.allCases.map { $0.rawValue },
                initialSelected: selectedRepetition.rawValue
            )
            cell.onOptionSelected = { [weak self] selected in
                if let repetition = SparkleRepetition(rawValue: selected) {
                    self?.selectedRepetition = repetition
                }
            }
            return cell
            
        case (1, 1):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SparkleStartDate.identifier,
                for: indexPath
            ) as! SparkleStartDate
            cell.onDateChanged = { [weak self] date in
                self?.selectedStartDate = date
            }
            return cell
            
        default: // case (1, 2) - Lembrete como Menu Picker
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SparkleMenuPickerCell.identifier,
                for: indexPath
            ) as! SparkleMenuPickerCell
            cell.configure(
                title: "Lembrete",
                options: SparkleReminder.allCases.map { $0.rawValue },
                initialSelected: selectedReminder.rawValue
            )
            cell.onOptionSelected = { [weak self] selected in
                if let reminder = SparkleReminder(rawValue: selected) {
                    self?.selectedReminder = reminder
                }
            }
            return cell
        }
    }
    
    // MARK: - Gradientes e Layout
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
        view.addSubview(tableView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            sheetTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            sheetTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            
            tableView.topAnchor.constraint(equalTo: sheetTitle.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            
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
