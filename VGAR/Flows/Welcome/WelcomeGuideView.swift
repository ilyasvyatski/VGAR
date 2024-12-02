//
//  WelcomeGuideView.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import Foundation
import UIKit
import SnapKit

final class WelcomeGuideView: UIView {
    
    let model: WelcomeGuideModel?
    
    private lazy var headerView: UILabel = {
        let header = UILabel()
        header.text = "Добро пожаловать!"
        header.numberOfLines = 1
        header.font = .systemFont(ofSize: 34, weight: .bold)
        header.contentMode = .left
        header.textColor = Colors.lightGray
        return header
    }()
    
    private lazy var instructionView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var fourthTextView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var fifthTextView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(_ data: WelcomeGuideModel) {
        model = data
        super.init(frame: UIScreen.main.bounds)
        initUI()
        initConstraints()
    }
    
    override init(frame: CGRect) {
        model = nil
        super.init(frame: frame)
        initUI()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        model = nil
        super.init(coder: coder)
        initUI()
        initConstraints()
    }
    
    private func initUI() {
        addSubview(headerView)
        addSubview(instructionView)
        
        //instructionView.addSubviews(fourthTextView, fifthTextView)
        
        fourthTextView = makeTextBlockView(from: (model?.textBlocks[3])!)
        fifthTextView = makeTextBlockView(from: (model?.textBlocks[4])!)

        initConstraints()
    }
    
    private func initConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        instructionView.snp.makeConstraints { make in
            make.top.equalTo(headerView).offset(45)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        var previousView: UIView?
        
        if let blocks = model?.textBlocks {
            for (index, dataBlock) in blocks.enumerated() {
                if index == 3 {
                    break
                } else {
                    let view = makeTextBlockView(from: dataBlock)
                    instructionView.addSubview(view)
                    
                    view.snp.makeConstraints { make in
                        if index == 0 {
                            make.top.equalToSuperview()
                        } else {
                            make.top.equalTo(previousView!.snp.bottom)
                        }
                        make.trailing.leading.equalToSuperview()
                    }
                    previousView = view
                }
            }
        }
        
        instructionView.addSubview(fifthTextView)
        instructionView.addSubview(fourthTextView)
        
        fourthTextView.snp.makeConstraints { make in
            make.bottom.equalTo(fifthTextView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        fifthTextView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.bottom.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func makeTextBlockView(from block: WelcomeGuideTextBlock) -> UIView {
        let view = UIView()
        
        let textView = UITextView()
        textView.text = block.imageName != nil ? block.description : "\(block.id). \(block.description)"
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .clear
        textView.contentMode = .left
        
        textView.attributedText = NSAttributedString.makeHyperLink(
            for: [DataStrings.supportServiceLink, DataStrings.examplePhotosLink],
            in: textView.text,
            as: ["службу поддержки", "по ссылке"]
        )
        
//        textView.attributedText = NSAttributedString.makeHyperLink(
//            for: DataStrings.supportServiceLink,
//            in: textView.text,
//            as: "службу поддержки"
//        )
//
//        textView.attributedText = NSAttributedString.makeHyperLink(
//            for: DataStrings.examplePhotosLink,
//            in: textView.text,
//            as: "по ссылке"
//        )
        
        
        textView.textColor = Colors.lightGray
        textView.font = .boldSystemFont(ofSize: 17)
        textView.tintColor = .link
        
        view.addSubview(textView)
        
        if let imageName = block.imageName {
            let image = UIImage(systemName: imageName)?.withTintColor(Colors.lightGray, renderingMode: .alwaysOriginal)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)
        
            textView.snp.makeConstraints { make in
                make.leading.centerY.equalToSuperview()
            }
            
            imageView.snp.makeConstraints { make in
                make.size.equalTo(50)
                make.leading.equalTo(textView.snp.trailing).offset(20)
                make.trailing.centerY.equalToSuperview()
            }
        } else {
            textView.snp.makeConstraints { make in
                make.top.bottom.leading.trailing.equalToSuperview()
            }
        }
        return view
    }
}
