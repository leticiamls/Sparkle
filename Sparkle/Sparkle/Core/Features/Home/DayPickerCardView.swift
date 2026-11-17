//
//  DayPickerView.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 17/11/26.
//

import UIKit

class DayPickerCardView: UIView {
    var date: Date = Date()
    
    var onTap: ((Date) -> Void)?
    
    private let dayPickerCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let weekDayLabel: UILabel = {
        let label = UILabel()
        label.text = "Seg"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .labelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.font = .systemFont(ofSize: 21)
        label.textColor = .labelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCard() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 18
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dayPickerCard)
        dayStack.addArrangedSubview(weekDayLabel)
        dayStack.addArrangedSubview(dayNumberLabel)
        dayPickerCard.addSubview(dayStack)
        
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 45),
            heightAnchor.constraint(equalToConstant: 72),
            
            dayPickerCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            dayPickerCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayPickerCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayPickerCard.topAnchor.constraint(equalTo: topAnchor),
            
            dayStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tap)
    }
    
    func configure(date: Date, isSelected: Bool) {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        self.date = date
        
        formatter.dateFormat = "EEE"
        weekDayLabel.text = formatter.string(from: date).replacingOccurrences(of: ".", with: "").capitalized
        
        formatter.dateFormat = "d"
        dayNumberLabel.text = formatter.string(from: date)
        
        if isSelected == true {
            dayPickerCard.backgroundColor = .rosaMedio
            dayNumberLabel.textColor = .white
            weekDayLabel.textColor = .white
        } else {
            dayPickerCard.backgroundColor = .white
            dayNumberLabel.textColor = .labelColor
            weekDayLabel.textColor = .labelColor
        }
    }
    
    @objc func cardTapped() {
        onTap?(date)
    }
}

#Preview {
    DayPickerCardView()
}
