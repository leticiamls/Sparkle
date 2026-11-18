//
//  UIView.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 16/11/26.
//
import UIKit

extension UIView {
    func aplicarGradiente() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds // 'self' representa a view atual
        
        let softPinkColor = UIColor(red: 255/255.0, green: 226/255.0, blue: 238/255.0, alpha: 1.0)
        let softPurple = UIColor(red: 249/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0)
        
        gradientLayer.colors = [
            softPinkColor.cgColor,
            softPurple.cgColor,
            UIColor.white.withAlphaComponent(1).cgColor,
            softPinkColor.cgColor,
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIButton {
    func aplicarGradienteNoBotao() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
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
        
        gradientLayer.cornerRadius = 24
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
