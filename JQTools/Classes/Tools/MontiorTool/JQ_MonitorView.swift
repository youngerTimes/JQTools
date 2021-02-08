//
//  JQ_MonitorView.swift
//  JQTools
//
//  Created by 无故事王国 on 2021/2/7.
//

import UIKit

class JQ_MonitorView: UIView,JQNibView {

    @IBOutlet weak var CPUPercentL: UILabel!
    @IBOutlet weak var GPUPercentL: UILabel!
    @IBOutlet weak var memoryPercentL: UILabel!
    @IBOutlet weak var upStreamPercentL: UILabel!
    @IBOutlet weak var downStreamPercentL: UILabel!
    @IBOutlet weak var FPSL: UILabel!
    @IBOutlet weak var unInitNumL: UILabel!

    @IBOutlet weak var upStreamImg: UIImageView!
    @IBOutlet weak var downStreamImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        upStreamImg.image = Bundle.JQ_Bundle(icon: "jq_arrowUp")
        downStreamImg.image = Bundle.JQ_Bundle(icon: "jq_arrowDown")
    }
}
