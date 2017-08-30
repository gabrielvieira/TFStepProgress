//
//  StepItemView.swift
//  step
//
//  Created by Gabriel Tomaz on 28/08/17.
//  Copyright © 2017 Gabriel Tomaz. All rights reserved.
//

import UIKit

public struct TFStepItemColorConfig {
    
    var leftBarColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    var rightBarColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    var circleColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    var disabledColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
    
    public init(){}
    
    public init(leftBarColor: UIColor, rightBarColor: UIColor, circleColor: UIColor, disabledColor: UIColor) {
        
        self.leftBarColor = leftBarColor
        self.rightBarColor = rightBarColor
        self.circleColor = circleColor
        self.disabledColor = disabledColor
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

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var leftLineView: UIView!
    @IBOutlet private weak var rightLineView: UIView!
   
    private var leftBarColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    private var rightBarColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    private var disabledColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
    private var circleColor = UIColor(red:0.00, green:0.56, blue:0.83, alpha:1.0)
    private var circleBorder: CGFloat = 2.0
    
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
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        self.circleView.layer.borderWidth = circleBorder
        addSubview(view)
        setDisabled(animationDuration: 0) {}
    }
    
    fileprivate func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // MARK: - Config
    func configure(config: TFStepItemConfig) {
        
        self.leftBarColor = config.colorConfig.leftBarColor
        self.rightBarColor = config.colorConfig.rightBarColor
        self.circleColor = config.colorConfig.circleColor
        self.disabledColor = config.colorConfig.disabledColor
        self.setTitle(config.title)
        self.setNumber(config.number)
    }
    
    private func setActive(animationDuration: Double, completionHandler:@escaping () -> ()) {
        
        let leftAnimate = UIView(frame: self.leftLineView.frame)
        leftAnimate.frame.size.width = 0
        leftAnimate.backgroundColor = self.leftBarColor
        if !self.leftLineView.isHidden { self.addSubview(leftAnimate) }
        
        UIView.animate(withDuration: animationDuration, animations: {
            leftAnimate.frame.size.width = self.leftLineView.frame.width
        }, completion: { (finished: Bool) in
            
            self.leftLineView.backgroundColor = self.leftBarColor
            leftAnimate.removeFromSuperview()
            
            UIView.animate(withDuration: animationDuration, animations: {
                
                self.circleView.backgroundColor = self.circleColor
                self.circleView.layer.borderColor = self.circleColor.cgColor
                self.titleLabel.textColor = self.circleColor
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
    
    private func setDisabled(animationDuration: Double, completionHandler:@escaping () -> ()) {
        
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
    
    private func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    private func setNumber(_ number: Int) {
        self.numberLabel.text = "\(number)"
    }
    
    // MARK: - Public metods
    func setState(animationDuration: Double, state: Bool, completionHandler: (()->())? ) {
        
        if state {
            setActive(animationDuration: animationDuration, completionHandler: { 
                completionHandler?()
            })
        } else {
            self.setDisabled(animationDuration: animationDuration, completionHandler: { 
                completionHandler?()
            })
        }
    }
    
    func hideLeftBar() {
        self.leftLineView.isHidden = true
    }
    
    func hideRightBar() {
        self.rightLineView.isHidden = true
    }
    
}
