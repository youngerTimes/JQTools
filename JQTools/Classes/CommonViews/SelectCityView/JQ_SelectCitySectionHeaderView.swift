//
//  JQ_SelectCitySectionHeaderView.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/17.
//

import UIKit

#if canImport(SnapKit)
public class JQ_SelectCitySectionHeaderView: UITableViewHeaderFooterView {

    var indexL = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(hexStr: "F5F5F5")
        indexL.textColor = UIColor(hexStr: "999999")
        indexL.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        self.contentView.addSubview(indexL)
        indexL.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
#endif
