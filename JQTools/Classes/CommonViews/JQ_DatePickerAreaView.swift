//
//  JQ_DatePickerAreaView.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/14.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)

public class JQ_DatePickerAreaView: UIView,JQNibView{
    
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var toolView: UIView!
    
    @IBOutlet weak var startDatePickerView: UIPickerView!
    
    @IBOutlet weak var endDatePickerView: UIPickerView!
    
    let currentYear = Date().jq_nowYear()
    
    public typealias DateTimeReturn = ((_ startTimeStr:String, _ startTime:Int,_ endTimeStr:String, _ endTime:Int)->Void)
    
    private var updateTime: DateTimeReturn?
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        startDatePickerView.delegate = self
        startDatePickerView.dataSource = self
        
        endDatePickerView.delegate = self
        endDatePickerView.dataSource = self
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        let tap = UITapGestureRecognizer()
        weak var weakSelf = self
        tap.rx.event.subscribe(onNext: { (tap) in
            if !weakSelf!.centerView.frame.contains(tap.location(in: weakSelf!)) {
                weakSelf!.dismiss()
            }
        }).disposed(by: JQ_disposeBag)
        self.addGestureRecognizer(tap)
    }
    
    public func show(update: DateTimeReturn?) {
        if update != nil {
            self.updateTime = update
        }
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.frame = CGRect(x: 0, y: 0, width: JQ_ScreenW, height: JQ_ScreenH)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.centerView.backgroundColor = UIColor.white
        unowned let weakSelf = self
        
        
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf.centerView.transform = CGAffineTransform(translationX: 0, y: -266 * JQ_RateW + (jq_isDiffPhone ? 53*JQ_RateW : 0))
        }) { (value) in
            weakSelf.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        }
    }
    
    func dismiss() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.centerView.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (value) in
            weakSelf?.removeFromSuperview()
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        if self.updateTime != nil {
            
            let startYear = startDatePickerView.selectedRow(inComponent: 0) + currentYear
            let startMonth = startDatePickerView.selectedRow(inComponent: 1) + 1
            let startDay = startDatePickerView.selectedRow(inComponent: 2) + 1
            let startDateStr = "\(startYear)-\(startMonth)-\(startDay)"
            let startInterval = Date.jq_StringToTimeInterval("\(startDateStr)", "YYYY-MM-dd")
            
            let endYear = endDatePickerView.selectedRow(inComponent: 0) + currentYear
            let endMonth = endDatePickerView.selectedRow(inComponent: 1) + 1
            let endDay = endDatePickerView.selectedRow(inComponent: 2) + 1
            let endDateStr = "\(endYear)-\(endMonth)-\(endDay)"
            let endInterval = Date.jq_StringToTimeInterval("\(endDateStr)", "YYYY-MM-dd")
            
            self.updateTime!(startDateStr,Int(startInterval * 1000),endDateStr,Int(endInterval * 1000))
        }
        self.dismiss()
    }
    
}

extension JQ_DatePickerAreaView:UIPickerViewDelegate{
    
}

extension JQ_DatePickerAreaView:UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {return 50}
        
        if component == 1 {return 12}
        
        if component == 2{
            let year = pickerView.selectedRow(inComponent: 0) + currentYear
            let month = pickerView.selectedRow(inComponent: 1) + 1
            return Date.jq_getDays(year, month)
        }
        
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36 * JQ_RateW
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if  component == 0{
            if endDatePickerView.selectedRow(inComponent: 0) < startDatePickerView.selectedRow(inComponent: 0){
                endDatePickerView.selectRow(startDatePickerView.selectedRow(inComponent: 0), inComponent: 0, animated: true)
            }
        }
        
        if component == 1 {
            let yearVaild = endDatePickerView.selectedRow(inComponent: 0) == startDatePickerView.selectedRow(inComponent: 0)
            let monthVaild = endDatePickerView.selectedRow(inComponent: 1) < startDatePickerView.selectedRow(inComponent: 1)
            
            if yearVaild && monthVaild {
                endDatePickerView.selectRow(startDatePickerView.selectedRow(inComponent: 1), inComponent: 1, animated: true)
            }
        }
        
        if component == 2{
            let yearVaild = endDatePickerView.selectedRow(inComponent: 0) == startDatePickerView.selectedRow(inComponent: 0)
            let monthVaild = endDatePickerView.selectedRow(inComponent: 1) == startDatePickerView.selectedRow(inComponent: 1)
            let dayVaild = endDatePickerView.selectedRow(inComponent: 2) < startDatePickerView.selectedRow(inComponent: 2)
            
            if yearVaild && monthVaild && dayVaild {
                endDatePickerView.selectRow(startDatePickerView.selectedRow(inComponent: 2), inComponent: 2, animated: true)
            }
        }
        pickerView.reloadAllComponents()
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(hexStr: "333333")
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        
        if component == 0 {
            label.text = "\(currentYear + row)"
        }
        
        if component == 1{
            label.text = String(format: "%02ld", row + 1)
        }
        
        if component == 2{
            label.text = String(format: "%02ld", row + 1)
        }
        return label
    }
    
}
#endif
