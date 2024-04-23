//
//  JQ_SelectCityVC.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/17.
//

import UIKit

#if canImport(QMUIKit) && canImport(SnapKit) && canImport(AMapLocationKit) && canImport(AMapSearchKit)
import QMUIKit
import SnapKit

var localAddressArr: [JQ_AddressModel]?
var addressIndexDic: [String:[JQ_AddressModel]]?
var addressCharacterArr: [String]?
var addressHotArr: [String]?
var addressAllCityArray: [JQ_AddressModel]?

public class JQ_SelectCityVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var topH: NSLayoutConstraint!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var headerV: UIView!
    
    @IBOutlet weak var searchTF: QMUITextField!
    @IBOutlet weak var cityL: UILabel!
    //    @IBOutlet weak var detailAddressL: UILabel!
    var allCityArray = Array<JQ_AddressModel>()
    var addressArr = Array<JQ_AddressModel>()
    var indexArr = Array<String>()
    var indexDic = Dictionary<String,[JQ_AddressModel]>()
    var locationModel: JQ_AddressModel?
    var characterArr = Array<String>()
    var searchArr = Array<JQ_AddressModel>()
    var hotArr = Array<JQ_AddressModel>()
    
    var refreshAddress: ((_ address: JQ_AddressModel)->Void)?
    
    var hightText = ""
    
    var currentLocation: CLLocationCoordinate2D?
    var currentJQ_AddressModel: JQ_AddressModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topH.constant = JQ_NavBarHeight+9
        self.searchView.jq_cornerRadius = 8
        self.cityL.jq_cornerRadius = 4
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 104, height: 40)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionV.collectionViewLayout = layout
        collectionV.isUserInteractionEnabled = true
        
        tableView.rowHeight = 50
        tableView.register(JQ_SelectCitySectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.sectionIndexBackgroundColor = UIColor.white.withAlphaComponent(0)
        tableView.sectionIndexColor = UIColor(hexStr: "0E1823")
        self.addressArr = localAddressArr!
        if addressIndexDic!["hot"] != nil{
            if addressCharacterArr!.contains("hot"){
                let index = NSMutableArray(array: addressCharacterArr!).index(of: "hot")
                addressCharacterArr?.remove(at: index)
            }
            self.hotArr = addressIndexDic!["hot"]!
        }
        self.characterArr = addressCharacterArr!
        self.indexDic = addressIndexDic!
        self.allCityArray = addressAllCityArray!
        weak var weakSelf = self
        weak var weakSearchTf = self.searchTF
        searchTF.rx.controlEvent(.editingChanged).subscribe(onNext: { () in
            weakSelf!.searchArr.removeAll()
            weakSelf!.hightText = ""
            if ((weakSearchTf!.text?.count)! > 0) {
                if weakSearchTf!.text!.jq_isValidateChinese() {
                    var allArr = NSMutableArray(array: weakSelf!.allCityArray)
                    allArr = NSMutableArray(array: allArr.qmui_filter({ (model) -> Bool in
                        return (model as! JQ_AddressModel).name.contains(weakSearchTf!.text!)
                    }))
                    for model in allArr {
                        weakSelf!.searchArr.append(model as! JQ_AddressModel)
                    }
                    weakSelf!.hightText = weakSearchTf!.text!
                }else {
                    for model in self.allCityArray {
                        if model.pingYin.lowercased().hasPrefix(weakSearchTf!.text!) {
                            weakSelf!.searchArr.append(model)
                        }
                    }
                }
            }
            weakSelf!.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        if self.currentJQ_AddressModel != nil {
            //            self.detailAddressL.text = self.currentJQ_AddressModel!.village
            self.cityL.text = self.currentJQ_AddressModel!.name
            let arr = self.currentJQ_AddressModel!.center.components(separatedBy: ",")
            self.currentLocation = CLLocationCoordinate2D(latitude: (arr[1] as NSString).doubleValue, longitude: (arr[0] as NSString).doubleValue)
        }else {
            weak var wSelf = self
            JQ_LocationManager.shareManager.ky_singleLocation { (location, regeocode, error) in
                if error == nil {
                    wSelf?.cityL.text = regeocode!.city
                }
            }
        }
        collectionV.layoutIfNeeded()
        headerV.frame = CGRect(x: 0, y: 0, width: JQ_ScreenW, height: 94+collectionV.contentSize.height)
        tableView.tableHeaderView = headerV
    }
    
    
    @IBAction func nowCity(_ sender: Any) {
        if self.currentLocation != nil || self.currentJQ_AddressModel != nil {
            let model = JQ_AddressModel(JSON: ["name":self.cityL.text!])
            //                model?.village = self.detailAddressL.text ?? ""
            model?.center = "\(self.currentLocation!.longitude),\(self.currentLocation!.latitude)"
            model?.name = self.cityL.text!
            if self.refreshAddress != nil {
                self.refreshAddress!(model!)
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            JQ_ShowText(textStr: "正在定位中")
        }
    }
    
    @IBAction func cancleAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if ((self.searchTF.text?.count)! == 0) {
            if self.characterArr.count > 0 {
                return self.characterArr.count
            }else {
                return 0
            }
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((self.searchTF.text?.count)! == 0) {
            return self.indexDic[self.characterArr[section]]!.count
        }else {
            return self.searchArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectCityTableViewCell
        cell.cityNameL.text = ""
        cell.cityNameL.attributedText = nil
        if ((self.searchTF.text?.count)! == 0) {
            cell.cityNameL.text = self.indexDic[self.characterArr[indexPath.section]]![indexPath.row].name
        }else {
            if self.hightText.count > 0 {
                let arrStr = NSMutableAttributedString(string: self.searchArr[indexPath.row].name, attributes: [.font:UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium), .foregroundColor:UIColor(hexStr: "0E1823")])
                let location = (self.searchArr[indexPath.row].name as NSString).range(of: self.hightText).location
                if location != NSNotFound {
                    arrStr.addAttribute(.foregroundColor, value: UIColor(hexStr: "0E1823"), range: NSRange(location: location, length: self.hightText.count))
                    cell.cityNameL.attributedText = arrStr
                }else {
                    cell.cityNameL.text = self.searchArr[indexPath.row].name
                }
            }else {
                cell.cityNameL.text = self.searchArr[indexPath.row].name
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! JQ_SelectCitySectionHeaderView
        if ((self.searchTF.text?.count)! == 0) {
            view.indexL.text = self.characterArr[section]
        }else {
            view.indexL.text = "搜索结果"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if ((self.searchTF.text?.count)! == 0) {
            return 24
        }else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.refreshAddress != nil {
            if ((self.searchTF.text?.count)! == 0) {
                self.refreshAddress!(self.indexDic[self.characterArr[indexPath.section]]![indexPath.row])
            }else {
                self.refreshAddress!(self.searchArr[indexPath.row])
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if ((self.searchTF.text?.count)! == 0) {
            return self.characterArr
        }else {
            return nil
        }
    }
}

extension JQ_SelectCityVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotCell", for: indexPath) as! HotCityCollectionViewCell
        cell.hotCityL.text = hotArr[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        refreshAddress?(hotArr[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}


class SelectCityTableViewCell: UITableViewCell {
    @IBOutlet weak var cityNameL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class HotCityCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var hotCityL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
#endif
