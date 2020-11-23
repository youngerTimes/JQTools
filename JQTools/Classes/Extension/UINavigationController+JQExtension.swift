//
//  UINavigationController+JQExtension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/11/19.
//

import UIKit

public extension UINavigationController{

    func jq_presentPush(vc:UIViewController){
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        UIApplication.shared.keyWindow?.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
    }
    
    func jq_dismissPop(){
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        UIApplication.shared.keyWindow?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}
