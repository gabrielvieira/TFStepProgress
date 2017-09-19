//
//  StepProgress.swift
//  step
//
//  Created by Gabriel Tomaz on 28/08/17.
//  Copyright © 2017 Gabriel Tomaz. All rights reserved.
//

import UIKit

extension UIImage {
    
    public class func bundledImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            
            return UIImage(named: named, in: Bundle.init(for: TFStepProgress.classForCoder()), compatibleWith: nil)
        } // Replace MyBasePodClass with yours
        return image
    }
}

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
    
    public var currentIndex: Int {
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
        
        self.stepItems.first?.setActive(animationDuration: self.defaultAnimationDuration, firstAnimation: {}, completionHandler: {
             self.lockAnimation = false
        })
        self.stepItems.last?.hideRightBar()
    }
    
    public func setStep(direction: TFStepProgressDirection) {
        
        if lockAnimation { return }
        
        lockAnimation = true
        
        if direction == .next {
            
            _currentIndex += 1
            
            if _currentIndex == self.stepItems.count {
                _currentIndex = self.stepItems.count - 1
                self.lockAnimation = false
                return
            }
            
            let stepItem = self.stepItems[_currentIndex]
            let prev = self.stepItems[self._currentIndex - 1]
            
            if currentIndex == self.stepItems.count - 1 {
                
                stepItem.setActive(animationDuration: self.defaultAnimationDuration, firstAnimation: {}, completionHandler: {
                    stepItem.setComplete(animationDuration: self.defaultAnimationDuration, completionHandler: {
                        self.lockAnimation = false
                    })
                })
            }
            
            stepItem.setActive(animationDuration: self.defaultAnimationDuration, firstAnimation: {
                
                prev.setComplete(animationDuration: self.defaultAnimationDuration, completionHandler:  {})
            }, completionHandler: {
                self.lockAnimation = false
            })
            
        } else {
            let stepItem = self.stepItems[_currentIndex]
            
            if _currentIndex > 0 {
                
                stepItem.setDisabled(animationDuration: self.defaultAnimationDuration, completionHandler: { 
                    self.lockAnimation = false
                })
                
                _currentIndex -= 1
                
                let prev = self.stepItems[_currentIndex]
                prev.setActive(animationDuration: self.noneAnimationDuration, firstAnimation: {}, completionHandler: {
                    self.lockAnimation = false
                })
                
            }
            else{
                stepItem.setActive(animationDuration: self.noneAnimationDuration, firstAnimation: {}, completionHandler: {
                    self.lockAnimation = false
                })
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
            stepItem.setActive(animationDuration: self.noneAnimationDuration, firstAnimation: {}, completionHandler: {})
        }
    }
    
    public func clearAllSteps () {
        for num in 0...self.stepItems.count - 1 {
            let stepItem = self.stepItems[num]
            stepItem.setDisabled(animationDuration: self.noneAnimationDuration, completionHandler: {})
        }
    }
    

}
