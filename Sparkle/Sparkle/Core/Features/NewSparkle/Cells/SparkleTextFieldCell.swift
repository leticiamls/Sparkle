//
//  SparkleTextFieldCell.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//
import UIKit

final class SparkleTextFieldCell: UITableViewCell {
    static let identifier = "SparkleTextFieldCell"
    var onTextChanged: ((String) -> Void)?
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Nome"
        tf.font = .systemFont(ofSize: 16)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }
}
