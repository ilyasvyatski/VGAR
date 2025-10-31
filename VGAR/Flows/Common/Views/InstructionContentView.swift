//
//  InstructionView.swift
//  VGAR
//
//  configd by Ilya Svyatski on 02.12.2024.
//

import Foundation
import UIKit

protocol InstructionContentViewDelegate: AnyObject {
    func didTapLink(_ type: InstructionContentView.InstructionLinkType)
}

class InstructionContentView: UIView {
    enum InstructionLinkType {
        case supportService
        case examplePhotos
    }
    
    weak var delegate: InstructionContentViewDelegate?

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initConstraints()
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
        initConstraints()
        configureContent()
    }
    
    private func initUI() {
        addSubview(stackView)
    }
    
    private func initConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureContent() {
        stackView.addArrangedSubview(
            configLabel(text: "1. Найдите изображения с отметкой AR.")
        )
        
        stackView.addArrangedSubview(configLinkLabel())
        
        stackView.addArrangedSubview(
            configLabel(
                text: "3. Фото оживет в режиме дополненной реальности (если оно не распознано, переместите фокус камеры)."
            )
        )
        
        stackView.addArrangedSubview(UIView())
        
        stackView.addArrangedSubview(
            configTextIconView(
               text: "Информация с подсказкой представлена иконкой «!»",
               iconName: "exclamationmark.circle"
           )
        )
        
        stackView.addArrangedSubview(
            configTextIconView(
                text: "Для выхода из камеры, нажмите иконку «←»",
                iconName: "arrow.left.circle"
            )
        )
    }
    
    private func configLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = Colors.lightGray
        label.numberOfLines = 0
        return label
    }
    
    private func configLinkLabel() -> UILabel {
        let parts = [
            NSAttributedString.TextPart(
                text: "2. Наведите камеру на фото (если у Вас нет доступа к книге, обратитесь в ",
                attributes: [
                    .font(.systemFont(ofSize: 16, weight: .regular)),
                    .foregroundColor(Colors.lightGray),
                    .lineSpacing(4)
                ]
            ),
            NSAttributedString.TextPart(
                text: "службу поддержки",
                attributes: [
                    .font(.systemFont(ofSize: 16, weight: .medium)),
                    .foregroundColor(.systemBlue),
                    .underlineStyle(.single),
                    .lineSpacing(4)
                ]
            ),
            NSAttributedString.TextPart(
                text: " или воспользуйтесь примерами ",
                attributes: [
                    .font(.systemFont(ofSize: 16, weight: .regular)),
                    .foregroundColor(Colors.lightGray),
                    .lineSpacing(4)
                ]
            ),
            NSAttributedString.TextPart(
                text: "по ссылке",
                attributes: [
                    .font(.systemFont(ofSize: 16, weight: .medium)),
                    .foregroundColor(.systemBlue),
                    .underlineStyle(.single),
                    .lineSpacing(4)
                ]
            ),
            NSAttributedString.TextPart(
                text: ").",
                attributes: [
                    .font(.systemFont(ofSize: 16, weight: .regular)),
                    .foregroundColor(Colors.lightGray),
                    .lineSpacing(4)
                ]
            )
        ]
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = NSAttributedString.configureAttributedString(parts: parts)
        label.isUserInteractionEnabled = true
        
        label.addTappable(text: "службу поддержки") { [weak self] in
            self?.delegate?.didTapLink(.supportService)
        }
        
        label.addTappable(text: "по ссылке") { [weak self] in
            self?.delegate?.didTapLink(.examplePhotos)
        }
        
        return label
    }
    
    private func configTextIconView(text: String, iconName: String) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 48
        stack.distribution = .equalSpacing
        stack.alignment = .center
    
        let label = configLabel(text: text)
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: iconName)?.withTintColor(Colors.lightGray, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
        iconView.snp.makeConstraints { $0.size.equalTo(40) }
        
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(iconView)
        
        return stack
    }
}
