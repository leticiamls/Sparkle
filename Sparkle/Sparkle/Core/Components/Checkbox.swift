//
//  Checkbox.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 13/11/26.
//
import UIKit

final class Checkbox: UIButton {

    var onToggle: ((Bool) -> Void)?

    var isChecked: Bool = false {
        didSet { isSelected = isChecked }
    }

    var checkedColor: UIColor = .clear {
        didSet { setNeedsUpdateConfiguration() }
    }

    var uncheckedColor: UIColor = .secondaryLabel {
        didSet { setNeedsUpdateConfiguration() }
    }

    var titleColor: UIColor = .label {
        didSet { setNeedsUpdateConfiguration() }
    }

    init(
        title: String? = nil,
        isChecked: Bool = false,
        checkedColor: UIColor = .checkboxColor,
        uncheckedColor: UIColor = .checkboxColor,
        titleColor: UIColor = .label
    ) {
        self.isChecked = isChecked
        self.checkedColor = checkedColor
        self.uncheckedColor = uncheckedColor
        self.titleColor = titleColor
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isSelected = isChecked
        setupConfiguration(title: title)
        setupAction()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConfiguration(title: currentTitle)
        setupAction()
    }

    private func setupConfiguration(title: String?) {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.imagePadding = 8
        config.contentInsets = .zero
        config.cornerStyle = .capsule
        self.configuration = config

        self.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var updatedConfig = button.configuration
            
            let symbolName = button.isSelected ? "checkmark.circle.fill" : "circle"
            let iconColor = button.isSelected ? self.checkedColor : self.uncheckedColor
            
            updatedConfig?.baseForegroundColor = self.titleColor
            updatedConfig?.image = UIImage(systemName: symbolName)?
                .withTintColor(iconColor, renderingMode: .alwaysOriginal)
            updatedConfig?.background.backgroundColor = .clear
            
            button.configuration = updatedConfig
        }
    }

    private func setupAction() {
        addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.isChecked.toggle()
            self.sendActions(for: .valueChanged)
            self.onToggle?(self.isChecked)
        }, for: .touchUpInside)
    }
}

#Preview {
    Checkbox()
}
