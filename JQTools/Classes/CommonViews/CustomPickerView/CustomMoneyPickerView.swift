//
//  CustomMoneyPickerView.swift
//  mentor-teacher
//
//  Created by 杨锴 on 2020/2/26.
//  Copyright © 2020 memoo. All rights reserved.
//

import UIKit

//#if canImport(SnapKit)
//import SnapKit
//import UIKit
//
//public typealias MoneyFieldClouse = (NSInteger,NSInteger)->(Void)
//
//public class CustomMoneyPickerView: UIView {
//    
//    var centerView = UIView()
//    var pickerView = UIPickerView()
//    var cancelBtn = UIButton()
//    var completeBtn = UIButton()
//    var moneyFieldClouse:MoneyFieldClouse?
//    
//    var selectComponent_1 = 0
//    var selectComponent_2 = 0
//    
//    var moneys = [0,1,2,3,4,5,6,7,8,9]
//    var moneys_1 = [1,2,3,4,5,6,7,8,9,10]
//    var temp = [NSInteger]()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.frame = CGRect(x: 0, y: 0, width: JQ_ScreenW, height: JQ_ScreenH)
//        self.backgroundColor = UIColor(hexStr: "000000").withAlphaComponent(0.6)
//        
//        temp = Array(moneys_1)
//        centerView.backgroundColor = UIColor.white
//        centerView.layer.cornerRadius = 8
//        centerView.layer.masksToBounds = true
//        
//        cancelBtn.setTitle("取消", for: .normal)
//        cancelBtn.setTitleColor(UIColor(hexStr:"#9FA6AF"), for: .normal)
//        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        cancelBtn.addTarget(self, action: #selector(hiden), for: .touchUpInside)
//        
//        completeBtn.setTitle("确定", for: .normal)
//        completeBtn.setTitleColor(UIColor(hexStr:"#1FBC45"), for: .normal)
//        completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        completeBtn.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
//        
//        centerView.frame = CGRect(x: 0, y: jq_height, width: JQ_ScreenW, height: 325)
//        
//        addSubview(centerView)
//        centerView.addSubview(cancelBtn)
//        centerView.addSubview(completeBtn)
//        
//        cancelBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(20)
//            make.left.equalTo(20)
//            make.width.equalTo(35)
//            make.height.equalTo(20)
//        }
//        
//        completeBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(20)
//            make.right.equalTo(-20)
//            make.width.equalTo(35)
//            make.height.equalTo(20)
//        }
//        
//        pickerView.dataSource = self
//        pickerView.delegate = self
//        centerView.addSubview(pickerView)
//        changesSpearatorLine()
//        pickerView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-20)
//            make.top.equalToSuperview().offset(50)
//        }
//    }
//    
//     @objc public func hiden(){
//        UIView.animate(withDuration: 0.3, animations: {
//            self.centerView.frame = CGRect(x: 0, y: self.jq_height, width: JQ_ScreenW, height: 325)
//        }) { (complete) in
//            self.removeFromSuperview()
//        }
//    }
//    
//    public func show(vc:UIViewController,clouse:@escaping MoneyFieldClouse){
//        vc.view.addSubview(self)
//        moneyFieldClouse = clouse
//        UIView.animate(withDuration: 0.6, animations: {
//            self.centerView.frame = CGRect(x: 0, y: self.jq_height - 317, width: JQ_ScreenW, height: 325)
//        }) { (status) in
//            
//        }
//    }
//    
//    //    改变系统的横线
//    private func changesSpearatorLine(){
//        for view in pickerView.subviews {
//            if view.frame.size.height <= 1 {
//                view.backgroundColor = UIColor(hexStr: "E9E9E9")
//                view.frame.origin.x = view.frame.origin.x - 50
//                view.frame.size.width = JQ_ScreenW - 100
//            }
//        }
//    }
//    
//    //    MAKR: --Action
//    @objc func completeAction(){
//        hiden()
//        moneyFieldClouse?(moneys[selectComponent_1],temp[selectComponent_2])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension CustomMoneyPickerView:UIPickerViewDataSource{
//    public  func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//    
//    public  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 {
//            return moneys.count
//        }
//        if component == 1 {
//            return temp.count
//        }
//        return 0
//    }
//    
//    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 61
//    }
//    
//     public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let label = UILabel()
//        label.textAlignment = .center
//        if #available(iOS 8.2, *) {
//            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        } else {
//            // Fallback on earlier versions
//        }
//        label.textColor = UIColor(hexStr: "404040")
//        label.adjustsFontSizeToFitWidth = true
//        if component == 0{
//            label.text = "\(moneys[row]) k"
//        }
//        if component == 1{
//            label.text = "\(temp[row]) k"
//        }
//        
//        return label
//    }
//}
//
//extension CustomMoneyPickerView:UIPickerViewDelegate{
//    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if component == 0{
//            selectComponent_1 = row
//            let slice = moneys_1.suffix(from:row)
//            temp = Array(slice)
//        }
//        if component == 1{
//            selectComponent_2 = row
//        }
//        pickerView.reloadAllComponents()
//    }
//}
//
//#endif
