//
//  SparkleMenuPickerCell.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//
import UIKit

final class SparkleMenuPickerCell: UITableViewCell {
    static let identifier = "SparkleMenuPickerCell"
    var onOptionSelected: ((String) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = SparkleSheet.labelColor
        return label
    }()
    
    private lazy var selectionButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.baseForegroundColor = SparkleSheet.buttonLabelColor
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, selectionButton])
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
    
    func configure(title: String, options: [String], initialSelected: String) {
        titleLabel.text = title
        selectionButton.configuration?.title = initialSelected
        selectionButton.menu = UIMenu(
            children: options.map { option in
                UIAction(
                    title: option,
                    state: initialSelected == option ? .on : .off
                ) { [weak self] _ in
                    self?.onOptionSelected?(option)
                }
            }
        )
    }
}
