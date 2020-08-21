//
//  BannerCell.swift
//  YKTools
//
//  Created by 杨锴 on 2019/6/14.
//  Copyright © 2019 younger_times. All rights reserved.
//

import UIKit

public class BannerCell: UICollectionViewCell {
    
    var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
        label.center = contentView.center
        label.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
