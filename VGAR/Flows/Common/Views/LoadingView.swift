//
//  LoadingView.swift
//  VGAR
//
//  Created by Ilya Svyatski on 29.10.2025.
//

import UIKit
import SnapKit
import Lottie

class LoadingView: UIView {
    
    private lazy var bluredView: UIView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var lottieView: LottieAnimationView = {
        let view = LottieAnimationView(name: "LoadingAnimation")
        view.contentMode = .scaleAspectFit
        let fillKeypath = AnimationKeypath(keypath:  "**.Fill 1.Color")
        let provider = ColorValueProvider(UIColor.black.lottieColorValue)
        view.setValueProvider(provider, keypath: fillKeypath)
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        isHidden = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(bluredView)
        bluredView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(lottieView)
        lottieView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    func startAnimating() {
        superview?.isUserInteractionEnabled = false
        isHidden = false
        lottieView.play(LottiePlaybackMode.PlaybackMode.fromProgress(1, toProgress: 0, loopMode: .loop))
    }
    
    func stopAnimating() {
        superview?.isUserInteractionEnabled = true
        lottieView.stop()
        isHidden = true
    }
}
