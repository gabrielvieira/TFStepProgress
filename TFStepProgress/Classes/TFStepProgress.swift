//
//  StepProgress.swift
//  step
//
//  Created by Gabriel Tomaz on 28/08/17.
//  Copyright © 2017 Gabriel Tomaz. All rights reserved.
//

import UIKit

public enum TFStepProgressDirection {
    case next
    case back
}

public class TFStepProgress: UIView {

    private var stepItems: [TFStepItemView] = []
    private var _currentIndex = 0
    private var lockAnimation:Bool = false
    private var defaultAnimationDuration = 0.5
    private var noneAnimationDuration = 0.0
    
    var currentIndex: Int {
        return _currentIndex
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //TODO DEIXAR BONITO
    public func setupItems(items: [TFStepItemConfig]) {
        
        for (index,item) in items.enumerated() {
            
            let xPos = 0 + CGFloat(index) * (self.frame.width / CGFloat(items.count) )
            let step = TFStepItemView(frame: CGRect(x: xPos, y: 0, width: self.frame.width / CGFloat(items.count), height: self.frame.height))
            step.configure(config: item)
            self.stepItems.append(step)
            self.addSubview(step)
        }
        self.stepItems.first?.hideLeftBar()
        self.lockAnimation = true
        self.stepItems.first?.setState(animationDuration: self.defaultAnimationDuration, state:true) {
            self.lockAnimation = false
        }
        
        self.stepItems.last?.hideRightBar()
    }
    
    public func setStep(direction: TFStepProgressDirection) {
        
        if lockAnimation { return }
        
        lockAnimation = true
        
        
        if direction == .next {
            
            _currentIndex += 1
            if _currentIndex == self.stepItems.count {
                _currentIndex = self.stepItems.count - 1
            }
            
            let stepItem = self.stepItems[_currentIndex]
            stepItem.setState(animationDuration: self.defaultAnimationDuration, state: true, completionHandler: {
                self.lockAnimation = false
            })
            
        } else {
            let stepItem = self.stepItems[_currentIndex]
            
            if _currentIndex > 0 {
                stepItem.setState(animationDuration: self.defaultAnimationDuration, state: false, completionHandler: {
                    self.lockAnimation = false
                })
                _currentIndex -= 1
            }
            
            if _currentIndex < 0 {
                _currentIndex = 0
            }
            
            if _currentIndex == 0 {
                self.lockAnimation = false
            }
        }
    }
    
    public func setStep(index: Int) {
        
        if index < 0 || index > self.stepItems.count - 1 {
            return
        }
        
        self.clearAllSteps()
        
        for num in 0...index {
            let stepItem = self.stepItems[num]
            stepItem.setState(animationDuration: self.noneAnimationDuration, state: true, completionHandler: nil)
        }
    }
    
    public func clearAllSteps () {
        for num in 0...self.stepItems.count - 1 {
            let stepItem = self.stepItems[num]
            stepItem.setState(animationDuration: self.noneAnimationDuration, state: false, completionHandler: nil)
        }
    }
    

}
