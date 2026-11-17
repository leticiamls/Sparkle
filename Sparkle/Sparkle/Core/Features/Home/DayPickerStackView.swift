import UIKit

class DayPickerStackView: UIView {
    var selectedDate: Date = Date()
    var onDateSelected: ((Date) -> Void)?
    
    private var weekOffset: Int = 0
    
    // Guardamos os 7 cards de cada uma das 3 semanas (Anterior, Atual e Próxima)
    private var prevCards: [DayPickerCardView] = []
    private var currentCards: [DayPickerCardView] = []
    private var nextCards: [DayPickerCardView] = []
    
    // Largura de 1 semana (7 cards de 45 + 6 espaços de 6 = 351) + 16 de espaço entre semanas
    private let pageOffset: CGFloat = 351 + 16
    
    // Container que segura as 3 semanas lado a lado e desliza com o dedo
    private let carouselContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let prevWeekStack = DayPickerStackView.makeWeekStack()
    private let currentWeekStack = DayPickerStackView.makeWeekStack()
    private let nextWeekStack = DayPickerStackView.makeWeekStack()
    
    private static func makeWeekStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCard()
        setupDays()
        setupSwipeGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCard() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false // Permite ver a pontinha das outras semanas ao arrastar
        
        addSubview(carouselContainer)
        carouselContainer.addSubview(prevWeekStack)
        carouselContainer.addSubview(currentWeekStack)
        carouselContainer.addSubview(nextWeekStack)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 351),
            heightAnchor.constraint(equalToConstant: 72),
            
            carouselContainer.topAnchor.constraint(equalTo: topAnchor),
            carouselContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            carouselContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Semana atual no centro
            currentWeekStack.centerXAnchor.constraint(equalTo: carouselContainer.centerXAnchor),
            currentWeekStack.centerYAnchor.constraint(equalTo: carouselContainer.centerYAnchor),
            
            // Semana anterior colada à esquerda
            prevWeekStack.centerXAnchor.constraint(equalTo: carouselContainer.centerXAnchor, constant: -pageOffset),
            prevWeekStack.centerYAnchor.constraint(equalTo: carouselContainer.centerYAnchor),
            
            // Próxima semana colada à direita
            nextWeekStack.centerXAnchor.constraint(equalTo: carouselContainer.centerXAnchor, constant: pageOffset),
            nextWeekStack.centerYAnchor.constraint(equalTo: carouselContainer.centerYAnchor)
        ])
    }
    
    func setupDays() {
        prevCards = populateStack(prevWeekStack)
        currentCards = populateStack(currentWeekStack)
        nextCards = populateStack(nextWeekStack)
        updateAllWeeks()
    }
    
    private func populateStack(_ stack: UIStackView) -> [DayPickerCardView] {
        var list: [DayPickerCardView] = []
        for _ in 0...6 {
            let card = DayPickerCardView()
            card.onTap = { [weak self] clickedDate in
                self?.selectDate(clickedDate)
            }
            list.append(card)
            stack.addArrangedSubview(card)
        }
        return list
    }
    
    func updateAllWeeks() {
        updateWeek(cards: prevCards, offset: weekOffset - 1)
        updateWeek(cards: currentCards, offset: weekOffset)
        updateWeek(cards: nextCards, offset: weekOffset + 1)
    }
    
    private func updateWeek(cards: [DayPickerCardView], offset: Int) {
        let calendar = Calendar.current
        let today = Date()
        
        let weekday = calendar.component(.weekday, from: today)
        guard let currentWeekSunday = calendar.date(byAdding: .day, value: -(weekday - 1), to: today),
              let targetSunday = calendar.date(byAdding: .day, value: offset * 7, to: currentWeekSunday) else { return }
        
        for (index, card) in cards.enumerated() {
            guard let dayDate = calendar.date(byAdding: .day, value: index, to: targetSunday) else { continue }
            let isSelected = calendar.isDate(dayDate, inSameDayAs: selectedDate)
            card.configure(date: dayDate, isSelected: isSelected)
        }
    }
    
    private func setupSwipeGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .changed:
            // Move as 3 semanas juntas acompanhando o dedo
            carouselContainer.transform = CGAffineTransform(translationX: translation.x, y: 0)
            
        case .ended, .cancelled:
            if abs(translation.x) > 60 {
                let goingNextWeek = translation.x < 0
                let targetX = goingNextWeek ? -pageOffset : pageOffset
                
                // Encaixa suavemente a semana vizinha no centro
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    self.carouselContainer.transform = CGAffineTransform(translationX: targetX, y: 0)
                }, completion: { _ in
                    // Atualiza os números e reposiciona no zero sem ninguém perceber!
                    self.weekOffset += goingNextWeek ? 1 : -1
                    self.updateAllWeeks()
                    self.carouselContainer.transform = .identity
                })
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.carouselContainer.transform = .identity
                }
            }
            
        default:
            break
        }
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        updateAllWeeks()
        onDateSelected?(date)
    }
}

#Preview {
    DayPickerStackView()
}
