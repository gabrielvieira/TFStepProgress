//
//  ViewController.swift
//  TFStepProgress
//
//  Created by gabrielvieira on 08/29/2017.
//  Copyright (c) 2017 gabrielvieira. All rights reserved.
//

import UIKit
import TFStepProgress

class ViewController: UIViewController {

    var step: TFStepProgress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.step = TFStepProgress(frame: CGRect(x: 0, y: 100, width: view.frame.width * 0.75, height: view.frame.height * 0.2))
        self.step?.center.x = self.view.center.x
        self.step?.setupItems(items: ["Solicitação", "Assinar Termos", "Confirmação", "Conclusão"])
        self.view.addSubview(self.step!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

