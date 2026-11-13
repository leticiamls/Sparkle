//
//  Teste.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 13/11/26.
//
import UIKit

enum Type: String, CaseIterable, Identifiable {
    case cabelo, unhas, pele
    var id: Self { self }
}

class ContentViewController: UITableViewController {
    
    private var selectedType: Type = .cabelo
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TypeCell.self, forCellReuseIdentifier: "TypeCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TextFieldCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            
            let textField = UITextField(frame: CGRect(x: 20, y: 0, width: 300, height: 44))
            textField.placeholder = "Nome"
            
            cell.contentView.addSubview(textField)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as! TypeCell
            
            cell.configure(initialSelectedType: selectedType)
            cell.onTypeSelected = { [weak self] type in
                self?.selectedType = type
                print(type)
            }
            return cell
        }
    }
}

final class TypeCell: UITableViewCell {

    var onTypeSelected: ((Type) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Categoria"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    private lazy var selectionButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.baseForegroundColor = .secondaryLabel
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, selectionButton]
        )

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.leadingAnchor
            ),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.trailingAnchor
            ),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(initialSelectedType: Type) {
        selectionButton.configuration?.title = initialSelectedType.rawValue.capitalized
        selectionButton.menu = UIMenu(
            children: Type.allCases.map { type in
                UIAction(
                    title: type.rawValue.capitalized,
                    state: initialSelectedType == type ? .on : .off
                ) { [weak self] _ in
                    self?.onTypeSelected?(type)
                }
            }
        )
    }
}

#Preview {
    ContentViewController()
}

