//
//  JQ_ContactTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/18.
//

import Foundation
//import Contacts
//
///// 通讯录操作
//public class JQ_ContactTool:NSObject{
//    public static let `default` = JQ_ContactTool()
//    public var canAccess = false
//    public var error:Error? = nil
//    private var clouse:(([CNContact])->Void)?
//
//    override init() {
//        super.init()
//        CNContactStore().requestAccess(for: .contacts) { (isRight, e) in
//            self.canAccess = isRight;self.error = e
//        }
//    }
//
//    /// 加载电话号码,邮箱,即时通讯
//    public func localizedValue(_ value:CNLabeledValue<CNPhoneNumber>)->(l:String,v:String)?{
//        let label = CNLabeledValue<NSString>.localizedString(forLabel: value.label ?? "")
//        let v = value.value.stringValue
//        return (label,v)
//    }
//
//    /// 加载纪念日
//    public func localizedDate(_ v:CNLabeledValue<NSDateComponents>,format:String = "YYYY-MM-dd HH:mm:ss")->(l:String,v:String)?{
//        let label = CNLabeledValue<NSString>.localizedString(forLabel: v.label ?? "")
//        //获取值
//        let dateComponents = v.value as DateComponents
//        let value = NSCalendar.current.date(from: dateComponents)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        return (label,dateFormatter.string(from: value!))
//    }
//
//    /// 加载纪念日
//    public func localizeIM(_ v:CNLabeledValue<CNInstantMessageAddress>)->(l:String,username:String,service:String)?{
//        let label = CNLabeledValue<NSString>.localizedString(forLabel: v.label ?? "")
//        let detail = v.value
//        let username = detail.value(forKey: CNInstantMessageAddressUsernameKey) ?? ""
//        let service = detail.value(forKey: CNInstantMessageAddressServiceKey) ?? ""
//        return (label,(username as! String),(service as! String))
//    }
//
//    /// 加载地址
//    public func localAddress(_ address:CNLabeledValue<CNPostalAddress>)->(l:String,contry:String,state:String,city:String,street:String,code:String)?{
//        let label = CNLabeledValue<NSString>.localizedString(forLabel: address.label ?? "")
//
//        let detail = address.value
//        let contry = detail.value(forKey: CNPostalAddressCountryKey) ?? ""
//        let state = detail.value(forKey: CNPostalAddressStateKey) ?? ""
//        let city = detail.value(forKey: CNPostalAddressCityKey) ?? ""
//        let street = detail.value(forKey: CNPostalAddressStreetKey) ?? ""
//        let code = detail.value(forKey: CNPostalAddressPostalCodeKey) ?? ""
//
//        return(label,(contry as! String),(state as! String),(city as! String),(street as! String),(code as! String))
//    }
//
//    /// 加载所有通讯录列表
//    public func loadAllList(clouse:@escaping ([CNContact])->Void){
//        self.clouse = clouse
//        var temp = Array<CNContact>()
//        //获取授权状态
//        let status = CNContactStore.authorizationStatus(for: .contacts)
//        //判断当前授权状态
//        guard status == .authorized else {
//            print("----通讯录未授权----");return
//        }
//
//        //创建通讯录对象
//        let store = CNContactStore()
//
//        //获取Fetch,并且指定要获取联系人中的什么属性
//        // 在iOS 13.x 上获取用户的通讯录数据时，不能获取 "备注" 信息，否则会系统会抛出异常，从而导致获取信息失败： CNContactNoteKey
//        let keys = [CNContactFamilyNameKey,CNContactGivenNameKey,CNContactNicknameKey,CNContactOrganizationNameKey,CNContactJobTitleKey,
//                    CNContactDepartmentNameKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactDatesKey,CNContactInstantMessageAddressesKey]
//
//        //创建请求对象
//        //需要传入一个(keysToFetch: [CNKeyDescriptor]) 包含CNKeyDescriptor类型的数组
//        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
//
//        //遍历所有联系人
//        do {
//            try store.enumerateContacts(with: request, usingBlock: {
//                (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
//                temp.append(contact)
//            })
//        } catch {
//            print(error)
//        }
//        self.clouse?(temp)
//    }
//
//    /// 添加一个联系人
//    /**
//     //创建CNMutableContact类型的实例
//     let contactToAdd = CNMutableContact()
//
//     //设置姓名
//     contactToAdd.familyName = "张"
//     contactToAdd.givenName = "飞"
//
//     //设置昵称
//     contactToAdd.nickname = "fly"
//
//     //设置头像
//     let image = UIImage(named: "fei")!
//     contactToAdd.imageData = UIImagePNGRepresentation(image)
//
//     //设置电话
//     let mobileNumber = CNPhoneNumber(stringValue: "1811111111")
//     let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile,
//     value: mobileNumber)
//
//     contactToAdd.phoneNumbers = [mobileValue]
//
//     //设置email
//     let email = CNLabeledValue(label: CNLabelHome, value: "XX@163.com" as NSString)
//     contactToAdd.emailAddresses = [email]
//     */
//    public func addContact(_ contactToAdd:CNMutableContact) -> Bool {
//        //创建通讯录对象
//        let store = CNContactStore()
//
//        //添加联系人请求
//        let saveRequest = CNSaveRequest()
//        saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
//
//        do {
//            //写入联系人
//            try store.execute(saveRequest)
//            return true
//        } catch {
//            return false
//        }
//    }
//
//    /// 修改联系人
//    public func editContact(_ contactToEdit:CNMutableContact)->Bool{
//        //创建通讯录对象
//        let store = CNContactStore()
//
//        let updateRequest = CNSaveRequest()
//        updateRequest.update(contactToEdit)
//        do {
//            //修改联系人
//            try store.execute(updateRequest)
//            return true
//        } catch {
//            return false
//        }
//    }
//
//    /// 删除联系人
//    public func deleteContact(_ contactToDel:CNMutableContact)->Bool{
//        //创建通讯录对象
//        let store = CNContactStore()
//
//        let updateRequest = CNSaveRequest()
//        updateRequest.delete(contactToDel)
//        do {
//            //修改联系人
//            try store.execute(updateRequest)
//            return true
//        } catch {
//            return false
//        }
//    }
//}
