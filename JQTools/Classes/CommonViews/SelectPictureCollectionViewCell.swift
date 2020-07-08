//
//  SelectPictureCollectionViewCell.swift
//  NirvanaCar
//
//  Created by 胡玳源 on 2020/4/27.
//  Copyright © 2020 Mr. Hu. All rights reserved.
//

import UIKit

class SelectPictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    
    var removeClick:((_ data:Any)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var data:Any!{
        didSet{
            removeBtn.isHidden = false
            if data is String{
                if (data as! String).contains("http"){
                    // MARK: -- 需要处理
//                    imageV.ky_setImage((data as! String), "")
                }else{
                    removeBtn.isHidden = true
                    imageV.image = UIImage(named: (data as! String))
                }
            }else{
                imageV.image = (data as! UIImage)
            }
        }
    }
    
    @IBAction func removeAction(_ sender: Any) {
        removeClick?(data as Any)
    }
}
