//
//  CustomDatePickerView.swift
//  Midou
//
//  Created by 杨锴 on 2019/10/25.
//  Copyright © 2019 stitch. All rights reserved.
//


//#if canImport(SnapKit)
//import SnapKit
//import UIKit
//
///// 自定义的选择器
//public class CustomPickerView: UIView {
//    
//    public typealias CallbackSelect = (NSInteger,String)->Void
//    
//    private var centerView = UIView()
//    private var pickerView = UIPickerView()
//    private var cancelBtn = UIButton()
//    private var completeBtn = UIButton()
//    public var callbackSelect:CallbackSelect?
//    public var selectcomponent:Int = 0
//    public var selectRow:Int = 0
//    public var items:Array<Any> = [["我是爸爸","我是妈妈","我是爷爷"]]{
//        didSet{
//            pickerView.reloadAllComponents()
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.frame = CGRect(x: 0, y: 0, width: JQ_ScreenW, height: JQ_ScreenH)
//        self.backgroundColor = UIColor(hexStr: "000000").withAlphaComponent(0.6)
//        
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
//   @objc public func hiden(){
//    callbackSelect?(-1,"")
//    UIView.animate(withDuration: 0.3, animations: {
//        self.centerView.frame = CGRect(x: 0, y: self.jq_height, width: JQ_ScreenW, height: 325)
//        }) { (complete) in
//            self.removeFromSuperview()
//        }
//    }
//    
//    
//    /// 显示
//    /// - Parameters:
//    ///   - vc: 在那个控制展示
//    ///   - callback: 返回index -1 时，是点击了取消，不需要去响应
//    public func show(vc:UIViewController,callback:@escaping CallbackSelect){
//        vc.view.addSubview(self)
//        callbackSelect  = callback
//    
//        UIView.animate(withDuration: 0.6) {
//            self.centerView.frame = CGRect(x: 0, y: self.jq_height - 317, width: JQ_ScreenW, height: 325)
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
//    @objc private func completeAction(){
//        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.centerView.frame = CGRect(x: 0, y: self.jq_height, width: JQ_ScreenW, height: 325)
//            }) { (complete) in
//                self.removeFromSuperview()
//            }
//        
//        if items.count == 0 {
////            ShowError(errorStr: "数据发生错误")
//            return
//        }
//        let item = items[selectcomponent]
//        let str = (item as! Array<Any>)[selectRow]
//        if selectRow != -1{
//            callbackSelect!(selectRow,str as! String)
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension CustomPickerView:UIPickerViewDataSource{
//    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return items.count
//    }
//    
//    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        let item = items[component]
//        return (item as AnyObject).count
//    }
//    
//    public  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 61
//    }
//    
//    public  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let item = items[component]
//        let str = (item as! Array<Any>)[row]
//        let label = UILabel()
//        label.text = (str as! String)
//        label.textAlignment = .center
//        if #available(iOS 8.2, *) {
//            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        } else {
//            // Fallback on earlier versions
//        }
//        label.textColor = UIColor(hexStr: "404040")
//        label.adjustsFontSizeToFitWidth = true
//        
//        pickerView.subviews[1].backgroundColor = UIColor.gray.withAlphaComponent(0.5)
//        pickerView.subviews[2].backgroundColor = UIColor.gray.withAlphaComponent(0.5)
//        return label
//    }
//}
//
//extension CustomPickerView:UIPickerViewDelegate{
//    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectRow = row
//        selectcomponent = component
//    }
//}
//#endif
