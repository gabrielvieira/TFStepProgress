//
//  Extension.swift
//  Pods
//
//  Created by BTG-Mobile on 19/09/17.
//
//

import Foundation
import UIKit

internal extension Bundle {
    class func frameworkBundle() -> Bundle {
        return Bundle(for: TFStepProgress.self)
    }
}

internal extension UIImage {
    
    convenience init?(readerImageNamed: String) {
        self.init(named: readerImageNamed, in: Bundle.frameworkBundle(), compatibleWith: nil)
    }
}
