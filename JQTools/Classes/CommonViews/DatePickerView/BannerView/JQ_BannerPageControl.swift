//
//  BannerPageControl.swift
//  YKTools
//
//  Created by 杨锴 on 2019/6/19.
//  Copyright © 2019 younger_times. All rights reserved.
//

import UIKit

public class JQ_BannerPageControl: UIPageControl {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews() 
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: JQ_ScreenW/2, height: frame.size.height)
        
        var center = self.center
        center.x = (self.superview?.center.x)!
        self.center = center
        
        for (index,_) in self.subviews.enumerated(){
            
            let dot = self.subviews[index]
            if index == self.currentPage{
                dot.frame = CGRect(x: Int(dot.jq_x), y: Int(dot.frame.origin.y), width: 7, height: 7)
            }else{
                dot.frame = CGRect(x: Int(dot.jq_x), y: Int(dot.frame.origin.y), width: 7, height: 7)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
