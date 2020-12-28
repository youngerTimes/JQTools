//
//  Bundle+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/19.
//

import Foundation

/*
 //根目录下的资源
 let mainBundle  = Bundle(for: JQTool.self)
 let path = mainBundle.path(forResource: "JQToolsRes", ofType: "bundle")
 let jqToolsBundle = Bundle(path: path!)
 let filePath = jqToolsBundle?.path(forResource: "citysCode", ofType: "txt")

 do {
 let content = try String(contentsOfFile: filePath!)
 print(content)
 } catch  {

 }

 //Media.xcassets下的资源
 _ = UIImage(named: "ty_qrcode_bg", in: jqToolsBundle, compatibleWith: .none)

 //获取目录下 XXXX.bundle资源
 let a = jqToolsBundle?.path(forResource: "Icon", ofType: "bundle")
 let bundle1 = Bundle(path: a!)
 let b = UIImage(named: "addImg", in: bundle1, compatibleWith: .none)
 */

public extension Bundle{
    static var jqBundle:Bundle?{
        get{
            let mainBundle  = Bundle(for: JQTool.self)
            let path = mainBundle.path(forResource: "JQToolsRes", ofType: "bundle")
            let jqToolsBundle = Bundle(path: path!)
            return jqToolsBundle
        }
    }

    /// 加载JQTools中 JQTools中的数据根目录下的数据
    static func JQ_Bundle(resource:String,type:String)->String?{
        let filePath = jqBundle?.path(forResource: resource, ofType: type)
        do {
            let content = try String(contentsOfFile: filePath!)
            return content
        } catch  {
            return nil
        }
    }

    /// 加载Media.xcassets中的文件
    /// - Parameter icon: 图片名称
    /// - Returns: 返回图片
    static func JQ_Bundle(icon:String)->UIImage?{
        return UIImage(named: icon, in: jqBundle, compatibleWith: .none)
    }

    /// 加载JQTools 中XXX.bundle
    /// - Parameters:
    ///   - bundleName: bundle名称
    ///   - resource: 数据名称
    ///   - type: 数据后缀
    /// - Returns: 返回Bundle
    static func JQ_Bundle(bundleName:String,resource:String,type:String)->Bundle?{
        let a = jqBundle?.path(forResource: bundleName, ofType: "bundle")
        if a != nil {
            return Bundle(path: a!)
        }else{
            return nil
        }
    }
}
