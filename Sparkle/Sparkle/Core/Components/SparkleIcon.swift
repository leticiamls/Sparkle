//
//  SparkleIcon.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 13/11/26.
//
import UIKit

class SparkleIcon: UIView {
    
    let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurarIcone()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func defineColor(para classification: String) {
            switch classification {
            case "Cabelo":
                backgroundColor = .iconPurpleBg
                iconImageView.tintColor = .iconPurple
                iconImageView.image = UIImage(systemName: "comb.fill")
            case "Unhas":
                backgroundColor = .iconBlueBg
                iconImageView.tintColor = .iconBlue
                iconImageView.image = UIImage(systemName: "hands.sparkles.fill")
            case "Pele":
                backgroundColor = .iconYellowBg
                iconImageView.tintColor = .iconYellow
                iconImageView.image = UIImage(systemName: "star.fill")
            default:
                backgroundColor = .iconPurpleBg
                iconImageView.tintColor = .iconPurple
                iconImageView.image = UIImage(systemName: "comb.fill")
            }
        }
    
    func configurarIcone() {
        layer.cornerRadius = 14
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 48),
            heightAnchor.constraint(equalToConstant: 48),
            
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        defineColor(para: "Cabelo")
    }
}
