//
//  MyBWWalkthroughViewController.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 26/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit
import BWWalkthrough

protocol CompoStateDelegate {
    func compoStateOpened() -> Void
    func compoStateClosed() -> Void
}




class MyBWWalkthroughViewController: BWWalkthroughViewController {
    
    
    
    var compoStateListener : CompoStateDelegate?
    
    @IBOutlet weak var compo_top: UIImageView!
    @IBOutlet weak var compo_bottom: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        openCompo()
    }
    
    
    
    
    
    func openCompo(){
        let originalTransformCompoTop = self.compo_top.transform
        let scaledTransformCompoTop = originalTransformCompoTop.scaledBy(x: 1.0, y: 1.0)
        let scaledAndTranslatedTransformCompoTop = scaledTransformCompoTop.translatedBy(x: 0.0, y: -compo_top.frame.size.height)
        
        
        let originalTransformCompoBottom = self.compo_bottom.transform
        let scaledTransformCompoBottom = originalTransformCompoBottom.scaledBy(x: 1.0, y: 1.0)
        let scaledAndTranslatedTransformCompoBottom = scaledTransformCompoBottom.translatedBy(x: 0.0, y: compo_bottom.frame.size.height)
        

        UIView.animate(withDuration: 1.0 , delay:2.0, animations: {
            self.compo_top.transform = scaledAndTranslatedTransformCompoTop
             self.compo_bottom.transform = scaledAndTranslatedTransformCompoBottom
        }, completion: { (finished: Bool) in
            self.compoStateListener?.compoStateOpened()
        })
    }
    
    
    
    
    
    
    func closeCompo(){
        print("CErramos compo")
        let originalTransformCompoTop = self.compo_top.transform
        let scaledTransformCompoTop = originalTransformCompoTop.scaledBy(x: 1.0, y: 1.0)
        let scaledAndTranslatedTransformCompoTop = scaledTransformCompoTop.translatedBy(x: 0.0, y: compo_top.frame.size.height)
        
        
        let originalTransformCompoBottom = self.compo_bottom.transform
        let scaledTransformCompoBottom = originalTransformCompoBottom.scaledBy(x: 1.0, y: 1.0)
        let scaledAndTranslatedTransformCompoBottom = scaledTransformCompoBottom.translatedBy(x: 0.0, y: -compo_bottom.frame.size.height)
        
        
        UIView.animate(withDuration: 1.0, animations: {
            self.compo_top.transform = scaledAndTranslatedTransformCompoTop
            self.compo_bottom.transform = scaledAndTranslatedTransformCompoBottom
        }, completion: { (finished: Bool) in
            self.compoStateListener?.compoStateClosed()
        })
    }
    

    

}
