//
//  CustomSwitch.swift
//  YounetProject
//
//  Created by 김세아 on 1/20/24.
//

// 사용하실 때 UIButton에 Custom Class -> CustomSwitch로 지정 부탁드립니다.
// 크기는 Figma 기준 width = 42, height = 28 입니다.

import UIKit

protocol SwieeftSwitchButtonDelegate: AnyObject {
    func isOnValueChange(isOn: Bool)
}

class CustomSwitch: UIButton {
    typealias SwitchColor = (bar: UIColor, circle: UIColor)
    
    private var barView: UIView!
    private var circleView: UIView!
    private var subCircleView: UIView!
    private var subBarView: UIView!

    var isOn: Bool = false {
        didSet {
            self.changeState()
        }
    }
    
    // on 상태의 스위치 색상
    var onColor: SwitchColor = (#colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) {
        didSet {
            if isOn { 
                self.barView.backgroundColor = self.onColor.bar
                self.circleView.backgroundColor = self.onColor.circle
                self.subBarView.backgroundColor = self.onColor.circle
            }
        }
    }
    
    // off 상태의 스위치 색상
    var offColor: SwitchColor = (#colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) {
        didSet {
            if isOn == false {
                self.barView.backgroundColor = self.offColor.bar
                self.circleView.backgroundColor = self.offColor.circle
                self.subCircleView.layer.borderColor = #colorLiteral(red: 0.5882353187, green: 0.5882353187, blue: 0.5882353187, alpha: 1)
            }
        }
    }
    
    // 스위치가 이동하는 애니메이션 시간
    var animationDuration: TimeInterval = 0.25
    
    // 스위치 isOn 값 변경 시 애니메이션 여부
    private var isAnimated: Bool = false
    
    // barView의 상, 하단 마진 값
    var barViewTopBottomMargin: CGFloat = 2
    
    weak var delegate: SwieeftSwitchButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buttonInit(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.buttonInit(frame: frame)
    }
    
    private func buttonInit(frame: CGRect) {
        
        let barViewHeight = frame.height - (barViewTopBottomMargin * 2)
        
        barView = UIView(frame: CGRect(x: 0, y: barViewTopBottomMargin, width: frame.width, height: barViewHeight))
        barView.backgroundColor = self.offColor.bar
        barView.layer.masksToBounds = true
        barView.layer.cornerRadius = barViewHeight / 2
        
        self.addSubview(barView)
        
        let circleViewLength = barViewHeight - (barViewTopBottomMargin * 2)
        circleView = UIView(frame: CGRect(x: barViewTopBottomMargin, y: barViewTopBottomMargin * 2, width: circleViewLength, height: circleViewLength))
        circleView.backgroundColor = self.offColor.circle
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = circleViewLength / 2
        
        self.addSubview(circleView)
        
        subCircleView = UIView(frame: CGRect(x: circleViewLength + (barViewTopBottomMargin * 3.5), y: (barViewHeight / 2) - 2, width: 8, height: 8))
        subCircleView.layer.borderWidth = 0.3
        subCircleView.layer.borderColor = #colorLiteral(red: 0.5882353187, green: 0.5882353187, blue: 0.5882353187, alpha: 1)
        subCircleView.layer.masksToBounds = true
        subCircleView.layer.cornerRadius = 4
        
        self.addSubview(subCircleView)
        
        subBarView = UIView(frame: CGRect(x: barViewTopBottomMargin + (circleViewLength / 2), y: (barViewHeight / 2) - 3, width: 0.8, height: 10))
        subBarView.backgroundColor = self.onColor.circle
        subBarView.layer.masksToBounds = true
        
        self.addSubview(subBarView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setOn(on: !self.isOn, animated: true)
    }
    
    func setOn(on: Bool, animated: Bool) {
        self.isAnimated = animated
        self.isOn = on
    }
    
    private func changeState() {
        
        var circleCenter: CGFloat = 0
        var barViewColor: UIColor = .clear
        var circleViewColor: UIColor = .clear

        if self.isOn {
            circleCenter = self.frame.width - (self.circleView.frame.width / 2) - barViewTopBottomMargin
            barViewColor = self.onColor.bar
            circleViewColor = self.onColor.circle
            subCircleView.fadeOut(0.25, onCompletion: nil)
            subBarView.fadeIn(0.25, onCompletion: nil)
        } else {
            circleCenter = (self.circleView.frame.width / 2) + barViewTopBottomMargin
            barViewColor = self.offColor.bar
            circleViewColor = self.offColor.circle
            subCircleView.fadeIn(0.25, onCompletion: nil)
            subBarView.fadeOut(0.25, onCompletion: nil)
        }
        
        let duration = self.isAnimated ? self.animationDuration : 0
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            
            self.circleView.center.x = circleCenter
            self.barView.backgroundColor = barViewColor
            self.circleView.backgroundColor = circleViewColor
            
        }) { [weak self] _ in
            guard let self = self else { return }
            
            self.delegate?.isOnValueChange(isOn: self.isOn)
            self.isAnimated = false
        }
    }
}
