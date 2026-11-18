//
//  Untitled.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 17/11/26.
//

import UIKit

class MonthViewController: UIViewController {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "calendarPink")
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        calendar.calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "pt_BR")
        
        calendar.tintColor = UIColor(red: 197/255.0, green: 107/255.0, blue: 146/255.0, alpha: 1.0)
        
        return calendar
    }()
    
    let textDateView: UILabel = {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale.current
        
        let label = UILabel()
        label.text = formatter.string(from: currentDate)
        label.textColor = UIColor(red: 89/255.0, green: 61/255.0, blue: 96/255.0, alpha: 1.0)
        label.font = UIFont(name: "CormorantGaramond-SemiBold", size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleView: UILabel = {
        let label = UILabel()
        label.text = "Calendário"
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
    
    let sparkleList = SparkleListView()
    
    let dayPickerStackView = DayPickerStackView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        configurarLayout()
        
        calendarView.delegate = self
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
    }
    
    func configurarLayout() {
        view.aplicarGradiente()
        view.addSubview(textDateView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 2. Adiciona os elementos na ContentView
        contentView.addSubview(titleView)
        contentView.addSubview(cardView)
        contentView.addSubview(sparkleList)
        cardView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            // --- Constraints da ScrollView ---
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // --- Constraints da ContentView ---
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            // Trava a largura para impedir scroll horizontal
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // --- Constraints dos Elementos Internos ---
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 29),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            textDateView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 29),
            textDateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            cardView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            calendarView.topAnchor.constraint(equalTo: cardView.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            calendarView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            calendarView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            
            sparkleList.topAnchor.constraint(equalTo: textDateView.bottomAnchor),
            sparkleList.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sparkleList.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Define o final do scroll
            sparkleList.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
}

extension MonthViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
}

extension MonthViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        guard let selectedDate = dateComponents?.date else { return }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale.current
        textDateView.text = formatter.string(from: selectedDate)
        
        sparkleList.loadSavedSparkles(para: selectedDate)
    }
}

#Preview {
    MonthViewController()
}
