//
//  SparkleStartDateCell.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//
import UIKit

final class SparkleStartDate: UITableViewCell {
    static let identifier = "SparkleStartDate"
    var onDateChanged: ((Date) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Data de início"
        label.font = .systemFont(ofSize: 16)
        label.textColor = SparkleSheet.labelColor
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.onDateChanged?(self.datePicker.date)
        }, for: .valueChanged)
        return picker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, datePicker])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
