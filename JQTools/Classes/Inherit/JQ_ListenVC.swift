//
//  JQ_ListenVC.swift
//  JQTools
//
//  Created by 无故事王国 on 2021/2/5.
//

import UIKit

/// 监听控制器，
open class JQ_ListenVC: UIViewController {

    private var montiorTool = JQ_MonitorTool.default

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("--->消失:\(self.jq_identity)")
    }

    deinit {
        print("--->销毁:\(self.jq_identity)")
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        print("--->出现:\(self.jq_identity)")

    }
}
