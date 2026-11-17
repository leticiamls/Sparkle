//
//  DateTestViewController.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 17/11/26.
//

import UIKit

final class DateTestViewController: UIViewController {
    
    private let repository = SparkleRepository()
    private var memoryFallback: [SparkleModel] = []
    
    private var selectedDate: Date = Date() {
        didSet {
            datePicker.date = selectedDate
            updateDateLabel()
            reloadCardsForSelectedDate()
        }
    }
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Teste de Datas"
        label.textColor = .labelColor
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelColor
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "+"
        config.baseBackgroundColor = .rosaMedio
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let filterBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .buttonLabelColor
        picker.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.selectedDate = self.datePicker.date
        }, for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var prevDayButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "-1 dia"
        config.baseForegroundColor = .buttonLabelColor
        config.baseBackgroundColor = .softPinkColor
        config.buttonSize = .small
        let button = UIButton(configuration: config)
        button.addAction(UIAction { [weak self] _ in
            self?.changeDay(by: -1)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var todayButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Hoje"
        config.baseForegroundColor = .buttonLabelColor
        config.baseBackgroundColor = .softPinkColor
        config.buttonSize = .small
        let button = UIButton(configuration: config)
        button.addAction(UIAction { [weak self] _ in
            self?.selectedDate = Date()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var nextDayButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "+1 dia"
        config.baseForegroundColor = .buttonLabelColor
        config.baseBackgroundColor = .softPinkColor
        config.buttonSize = .small
        let button = UIButton(configuration: config)
        button.addAction(UIAction { [weak self] _ in
            self?.changeDay(by: 1)
        }, for: .touchUpInside)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let cardsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum Sparkle para este dia ✨"
        label.textColor = .labelColor.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aplicarGradiente()
        setupLayout()
        addButton.addTarget(self, action: #selector(openNewSparkleSheet), for: .touchUpInside)
        
        updateDateLabel()
        reloadCardsForSelectedDate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    // MARK: - Actions & Logic
    
    private func changeDay(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "pt_BR")
        subtitleDateLabel.text = formatter.string(from: selectedDate)
    }
    
    private func reloadCardsForSelectedDate() {
        // Remove os cards anteriores da pilha
        for arrangedSubview in cardsStackView.arrangedSubviews {
            cardsStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        // Busca todos no banco (ou fallback em memória) e filtra apenas os que devem aparecer no dia selecionado
        let saved = repository.fetchAll()
        let allSparkles = saved.isEmpty ? memoryFallback : saved
        let sparklesOfTheDay = allSparkles.filter { $0.shouldAppear(em: selectedDate) }
        
        if sparklesOfTheDay.isEmpty {
            cardsStackView.addArrangedSubview(emptyStateLabel)
            return
        }
        
        for sparkle in sparklesOfTheDay {
            let card = SparkleCardView()
            card.load(com: sparkle)
            
            card.loadState = { [weak self] isChecked in
                sparkle.isDone = isChecked
                self?.repository.save()
            }
            
            card.onDelete = { [weak self] in
                guard let self = self else { return }
                self.memoryFallback.removeAll { $0.id == sparkle.id }
                self.repository.delete(sparkle)
                self.reloadCardsForSelectedDate()
            }
            
            cardsStackView.addArrangedSubview(card)
        }
    }
    
    @objc private func openNewSparkleSheet() {
        let sheet = SparkleSheet()
        
        sheet.toSave = { [weak self] newSparkle in
            guard let self = self else { return }
            self.memoryFallback.append(newSparkle)
            self.repository.insert(newSparkle)
            self.reloadCardsForSelectedDate()
        }
        
        if let sheetController = sheet.sheetPresentationController {
            sheetController.detents = [.large()]
            sheetController.prefersGrabberVisible = true
        }
        present(sheet, animated: true)
    }
    
    // MARK: - Layout & Gradient
    
    private func aplicarGradiente() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.softPinkColor.cgColor,
            UIColor.softPurple.cgColor,
            UIColor.white.cgColor,
            UIColor.softPinkColor.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupLayout() {
        let shortcutsStack = UIStackView(arrangedSubviews: [prevDayButton, todayButton, nextDayButton])
        shortcutsStack.axis = .horizontal
        shortcutsStack.spacing = 6
        shortcutsStack.translatesAutoresizingMaskIntoConstraints = false
        
        filterBarView.addSubview(datePicker)
        filterBarView.addSubview(shortcutsStack)
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleDateLabel)
        view.addSubview(addButton)
        view.addSubview(filterBarView)
        view.addSubview(scrollView)
        scrollView.addSubview(cardsStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            subtitleDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 48),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            
            filterBarView.topAnchor.constraint(equalTo: subtitleDateLabel.bottomAnchor, constant: 16),
            filterBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            filterBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            filterBarView.heightAnchor.constraint(equalToConstant: 56),
            
            datePicker.leadingAnchor.constraint(equalTo: filterBarView.leadingAnchor, constant: 12),
            datePicker.centerYAnchor.constraint(equalTo: filterBarView.centerYAnchor),
            
            shortcutsStack.trailingAnchor.constraint(equalTo: filterBarView.trailingAnchor, constant: -12),
            shortcutsStack.centerYAnchor.constraint(equalTo: filterBarView.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: filterBarView.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cardsStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            cardsStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            cardsStackView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            cardsStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
}

#Preview {
    DateTestViewController()
}
