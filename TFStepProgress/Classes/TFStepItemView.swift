//
//  StepItemView.swift
//  step
//
//  Created by Gabriel Tomaz on 28/08/17.
//  Copyright © 2017 Gabriel Tomaz. All rights reserved.
//

import UIKit
//166 206 57
public struct TFStepItemColorConfig {
    
    var leftBarColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    var rightBarColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    var enableColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    var completeColor = UIColor(red:0.65, green:0.81, blue:0.22, alpha:1.0)
    var disabledColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
    
    public init(){}
    
    public init(leftBarColor: UIColor, rightBarColor: UIColor, enableColor: UIColor, disabledColor: UIColor,completeColor: UIColor) {
        
        self.leftBarColor = leftBarColor
        self.rightBarColor = rightBarColor
        self.enableColor = enableColor
        self.disabledColor = disabledColor
        self.completeColor = completeColor
    }
}

public struct TFStepItemConfig {
    
    var colorConfig = TFStepItemColorConfig()
    var title: String = ""
    var number: Int = 0
    
    public init(colorConfig: TFStepItemColorConfig, title: String?, number: Int) {
        self.colorConfig = colorConfig
        self.title = title ?? ""
        self.number = number
    }
}

class TFStepItemView: UIView {

    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var leftLineView: UIView!
    @IBOutlet private weak var rightLineView: UIView!
   
    private var leftBarColor = UIColor(red:0.65, green:0.81, blue:0.22, alpha:1.0)
    private var rightBarColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    private var enableColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    private var completeColor = UIColor(red:0.65, green:0.81, blue:0.22, alpha:1.0)
    private var disabledColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
    private var circleBorder: CGFloat = 2.0
    private var fontSize:CGFloat = 1.0
    
    public var titleHeight : CGFloat {
        get {
            return self.titleLabel.frame.height
        }
    }
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        self.circleView.layer.borderWidth = circleBorder
        addSubview(view)
        setDisabled(animationDuration: 0) {}
        self.checkIcon.image = UIImage(readerImageNamed: "check_icon")
        self.checkIcon.isHidden = true
        self.numberLabel.isHidden = false
    }
    
    fileprivate func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // MARK: - Config
    func configure(config: TFStepItemConfig, fontSize:CGFloat) {
        
        self.leftBarColor = config.colorConfig.leftBarColor
        self.rightBarColor = config.colorConfig.rightBarColor
        self.enableColor = config.colorConfig.enableColor
        self.disabledColor = config.colorConfig.disabledColor
        self.setTitle(config.title)
        self.setNumber(config.number)
        self.fontSize = fontSize
        self.titleLabel.font = self.titleLabel.font.withSize(fontSize)
    }
    
    func setActive(animationDuration: Double, firstAnimation:@escaping () -> (), completionHandler:@escaping () -> ()) {
        
        self.checkIcon.isHidden = true
        self.numberLabel.isHidden = false
        let leftAnimate = UIView(frame: self.leftLineView.frame)
        leftAnimate.frame.size.width = 0
        leftAnimate.backgroundColor = self.leftBarColor
        if !self.leftLineView.isHidden { self.addSubview(leftAnimate) }
        
        UIView.animate(withDuration: animationDuration, animations: {
            leftAnimate.frame.size.width = self.leftLineView.frame.width
        }, completion: { (finished: Bool) in
            firstAnimation()
            self.leftLineView.backgroundColor = self.leftBarColor
            leftAnimate.removeFromSuperview()
            
            UIView.animate(withDuration: animationDuration, animations: {
                
                self.circleView.backgroundColor = self.enableColor
                self.circleView.layer.borderColor = self.enableColor.cgColor
                self.titleLabel.textColor = self.enableColor
                self.numberLabel.textColor = .white
                
            }, completion: { (finished: Bool) in
                
                let rightAnimate = UIView(frame: self.rightLineView.frame)
                rightAnimate.frame.size.width = 0
                rightAnimate.backgroundColor = self.rightBarColor
                if !self.rightLineView.isHidden { self.addSubview(rightAnimate) }
                
                UIView.animate(withDuration: animationDuration, animations: {
                    rightAnimate.frame.size.width = self.rightLineView.frame.width
                }, completion: { (finished: Bool) in
                    
                    self.rightLineView.backgroundColor = self.rightBarColor
                    rightAnimate.removeFromSuperview()
                    completionHandler()
                })
            })
        })
        
    }
    
    func setDisabled(animationDuration: Double, completionHandler:@escaping () -> ()) {
        
        self.checkIcon.isHidden = true
        self.numberLabel.isHidden = false
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.circleView.backgroundColor = .white
            self.circleView.layer.borderColor = self.disabledColor.cgColor
            self.numberLabel.textColor = self.disabledColor
            self.titleLabel.textColor = self.disabledColor
            self.leftLineView.backgroundColor = self.disabledColor
            self.rightLineView.backgroundColor = self.disabledColor
        }, completion: { (finished: Bool) in
            completionHandler()
        })
    }
    
    func setComplete(animationDuration: Double, completionHandler:@escaping () -> ()) {
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.circleView.backgroundColor = self.completeColor
            self.circleView.layer.borderColor = self.completeColor.cgColor
            self.numberLabel.textColor = self.completeColor
            self.titleLabel.textColor = self.completeColor
            self.leftLineView.backgroundColor = self.completeColor
            self.rightLineView.backgroundColor = self.completeColor
            self.checkIcon.isHidden = false
            self.numberLabel.isHidden = true
        }, completion: { (finished: Bool) in
            completionHandler()
        })
    }
    
    private func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    private func setNumber(_ number: Int) {
        self.numberLabel.text = "\(number)"
    }
    
    func hideLeftBar() {
        self.leftLineView.isHidden = true
    }
    
    func hideRightBar() {
        self.rightLineView.isHidden = true
    }
    
}
