//
//  WeChatOptView.swift
//  Midou
//
//  Created by 杨锴 on 2019/12/17.
//  Copyright © 2019 stitch. All rights reserved.
//

import UIKit

enum WeChatShareType {
    case Fri
    case Com
    case Qq
    case Cancel
}

typealias ShareToFriClouse = (WeChatShareType)->()

class WeChatOptView: UIView,JQNibView {
    @IBOutlet weak var contentView: UIView!
    var shareToFriClouse:ShareToFriClouse?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func shareToFriendAction(_ sender: Any) {
        shareToFriClouse?(WeChatShareType.Fri)
    }
    
    @IBAction func shareToCommunityAction(_ sender: Any) {
        shareToFriClouse?(WeChatShareType.Com)
    }

    @IBAction func shareToQQAction(_ sender: Any) {
        shareToFriClouse?(WeChatShareType.Qq)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        shareToFriClouse?(WeChatShareType.Cancel)
    }
}
