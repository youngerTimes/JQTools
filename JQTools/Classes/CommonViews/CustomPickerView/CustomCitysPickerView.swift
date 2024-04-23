//
//  CustomCitysPickerView.swift
//  mentor-teacher
//
//  Created by 杨锴 on 2020/3/3.
//  Copyright © 2020 memoo. All rights reserved.
//

import UIKit

#if canImport(ObjectMapper)

public typealias CustomCitysClouse = (CitysOptionModel,CitysOptionModel,CitysOptionModel)->(Void)

public enum CistysPickerType{
    case PC
    case PCC
}

public class CustomCitysPickerView: UIView {
    private var centerView = UIView()
    private var pickerView = UIPickerView()
    private var completeBtn = UIButton()
    private var cancelBtn = UIButton()
    var customCitysClouse:CustomCitysClouse?
    private var citysModel = [CitysOptionModel]()
    private var provinceComponent = 0
    private var cityComponent = 0
    private var countryCompontent = 0
    private var provinceModel:CitysOptionModel?
    private var cityModel:CitysOptionModel?
    private var countryModel:CitysOptionModel?
    public var cityType:CistysPickerType = .PCC
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        do {
            let mainBundle  = Bundle(for: type(of: self))
            let path = mainBundle.path(forResource: "JQToolsRes", ofType: "bundle")
            let jqToolsBundle = Bundle(path: path!)
            let filePath = jqToolsBundle?.path(forResource: "citysCode", ofType: "txt")
            let str = try String(contentsOf: URL(fileURLWithPath: filePath!))
            citysModel = Array<CitysOptionModel>(JSONString: str)!
        } catch  {
            JQ_ShowError(errorStr: "城市列表加载失败")
        }
        
        
        self.frame = CGRect(x: 0, y: 0, width: JQ_ScreenW, height: JQ_ScreenH)
        self.backgroundColor = UIColor(hexStr: "000000").withAlphaComponent(0.6)
        
        centerView.backgroundColor = UIColor.white
        centerView.layer.cornerRadius = 8
        centerView.layer.masksToBounds = true
        
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor(hexStr:"#9FA6AF"), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.addTarget(self, action: #selector(hiden), for: .touchUpInside)
        
        completeBtn.setTitle("确定", for: .normal)
        completeBtn.setTitleColor(UIColor(hexStr:"#1FBC45"), for: .normal)
        completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        completeBtn.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
        
        centerView.frame = CGRect(x: 0, y: jq_height, width: JQ_ScreenW, height: 325)
        
        addSubview(centerView)
        centerView.addSubview(cancelBtn)
        centerView.addSubview(completeBtn)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.width.equalTo(35)
            make.height.equalTo(20)
        }
        
        completeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.right.equalTo(-20)
            make.width.equalTo(35)
            make.height.equalTo(20)
        }
        
        pickerView.dataSource = self
        pickerView.delegate = self
        centerView.addSubview(pickerView)
        changesSpearatorLine()
        pickerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(50)
        }
    }
    
    @objc func hiden(){
        UIView.animate(withDuration: 0.3, animations: {
            self.centerView.frame = CGRect(x: 0, y: self.jq_height, width: JQ_ScreenW, height: 325)
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
    
    public func show(vc:UIViewController,selectComponent:NSInteger = 0,callback:@escaping CustomCitysClouse){
        vc.view.addSubview(self)
        customCitysClouse  = callback
        provinceComponent = selectComponent
        self.pickerView.selectRow(selectComponent, inComponent: 0, animated: false)
        self.pickerView.selectRow(0, inComponent: 1, animated: false)
        self.pickerView.reloadAllComponents()
        UIView.animate(withDuration: 0.6, animations: {
            self.centerView.frame = CGRect(x: 0, y: self.jq_height - 317, width: JQ_ScreenW, height: 325)
        }) { (status) in
            
        }
    }
    
    //    改变系统的横线
    func changesSpearatorLine(){
        for view in pickerView.subviews {
            if view.frame.size.height <= 1 {
                view.backgroundColor = UIColor(hexStr: "E9E9E9")
                view.frame.origin.x = view.frame.origin.x - 50
                view.frame.size.width = JQ_ScreenW - 100
            }
        }
    }
    
    //    MAKR: --Action
    @objc func completeAction(){
        hiden()
        
        let provinceModel = citysModel[provinceComponent]
        let cityModel = citysModel[provinceComponent].childs[cityComponent]
        let countryModel = citysModel[provinceComponent].childs[cityComponent].childs[countryCompontent]
        
        customCitysClouse?(provinceModel,cityModel,countryModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCitysPickerView:UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if cityType == .PC{
            return 2
        }
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return citysModel.count
        }
        if component == 1 {
            return citysModel[provinceComponent].childs.count
        }
        if component == 2 {
            return citysModel[provinceComponent].childs[cityComponent].childs.count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 61
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(hexStr: "404040")
        label.adjustsFontSizeToFitWidth = true
        
        if component == 0 {
            let model = citysModel[row]
            label.text = model.name
        }
        if component == 1 {
            let model = citysModel[provinceComponent].childs[row]
            label.text = model.name
        }
        if component == 2 {
            let model = citysModel[provinceComponent].childs[cityComponent].childs[row]
            label.text = model.name
        }
        return label
    }
}

extension CustomCitysPickerView:UIPickerViewDelegate{
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            provinceComponent = row
        }
        
        if component == 1{
            cityComponent = row
        }
        
        if component == 2{
            countryCompontent = row
        }
        pickerView.reloadAllComponents()
    }
}
#endif
