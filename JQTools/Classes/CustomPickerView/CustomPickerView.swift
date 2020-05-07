//
//  CustomDatePickerView.swift
//  Midou
//
//  Created by 杨锴 on 2019/10/25.
//  Copyright © 2019 stitch. All rights reserved.
//


#if canImport(SnapKit)
import SnapKit
import UIKit

/// 自定义的选择器
class CustomPickerView: UIView {
    
    typealias CallbackSelect = (NSInteger,String)->Void
    
    var centerView = UIView()
    var pickerView = UIPickerView()
    var cancelBtn = UIButton()
    var completeBtn = UIButton()
    var callbackSelect:CallbackSelect?
    var selectcomponent:Int = 0
    var selectRow:Int = 0
    var items:Array<Any> = [["我是爸爸","我是妈妈","我是爷爷"]]{
        didSet{
            pickerView.reloadAllComponents()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: JQ_ScreenW, height: JQ_ScreenH)
        self.backgroundColor = UIColor(hexStr: "000000").withAlphaComponent(0.6)
        
        centerView.backgroundColor = UIColor.white
        centerView.layer.cornerRadius = 8 * JQ_RateW
        centerView.layer.masksToBounds = true
        
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor(hexStr:"#9FA6AF"), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.addTarget(self, action: #selector(hiden), for: .touchUpInside)
        
        completeBtn.setTitle("确定", for: .normal)
        completeBtn.setTitleColor(UIColor(hexStr:"#1FBC45"), for: .normal)
        completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        completeBtn.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
        
        centerView.frame = CGRect(x: 0, y: jq_height, width: JQ_ScreenW, height: 325 * JQ_RateW)
        
        addSubview(centerView)
        centerView.addSubview(cancelBtn)
        centerView.addSubview(completeBtn)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20 * JQ_RateW)
            make.left.equalTo(20 * JQ_RateW)
            make.width.equalTo(35 * JQ_RateW)
            make.height.equalTo(20 * JQ_RateW)
        }
        
        completeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20 * JQ_RateW)
            make.right.equalTo(-20 * JQ_RateW)
            make.width.equalTo(35 * JQ_RateW)
            make.height.equalTo(20 * JQ_RateW)
        }
        
        pickerView.dataSource = self
        pickerView.delegate = self
        centerView.addSubview(pickerView)
        changesSpearatorLine()
        pickerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20 * JQ_RateW)
            make.top.equalToSuperview().offset(50 * JQ_RateW)
        }
        
    }
    
   @objc func hiden(){
    UIView.animate(withDuration: 0.3, animations: {
        self.centerView.frame = CGRect(x: 0, y: self.jq_height, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
    
    func show(vc:UIViewController,callback:@escaping CallbackSelect){
        vc.view.addSubview(self)
        callbackSelect  = callback
    
        UIView.animate(withDuration: 0.6) {
            self.centerView.frame = CGRect(x: 0, y: self.jq_height - 317 * JQ_RateW, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }
    }
    
    //    改变系统的横线
    func changesSpearatorLine(){
        for view in pickerView.subviews {
            if view.frame.size.height <= 1 {
                view.backgroundColor = UIColor(hexStr: "E9E9E9")
                view.frame.origin.x = view.frame.origin.x - 50 * JQ_RateW
                view.frame.size.width = JQ_ScreenW - 100 * JQ_RateW
            }
        }
    }
    
    //    MAKR: --Action
    @objc func completeAction(){
        hiden()
        if items.count == 0 {
//            ShowError(errorStr: "数据发生错误")
            return
        }
        let item = items[selectcomponent]
        let str = (item as! Array<Any>)[selectRow]
        callbackSelect!(selectRow,str as! String)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomPickerView:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let item = items[component]
        return (item as AnyObject).count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 61 * JQ_RateW
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let item = items[component]
        let str = (item as! Array<Any>)[row]
        let label = UILabel()
        label.text = (str as! String)
        label.textAlignment = .center
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        } else {
            // Fallback on earlier versions
        }
        label.textColor = UIColor(hexStr: "404040")
        label.adjustsFontSizeToFitWidth = true
        return label
    }
}

extension CustomPickerView:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = row
        selectcomponent = component
    }
}
#endif
