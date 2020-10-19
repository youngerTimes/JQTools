//
//  Bundle+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/19.
//

import Foundation

//        var a = Bundle(for: JQTool.self).path(forResource: "Icon", ofType: "bundle")
//        let jqToolBundle = Bundle(path: a!)
//        let image = UIImage(named: "ty_qrcode_bg", in: jqToolBundle, compatibleWith: .none)
//        print(image)
//
//
//        let mainBundle  = Bundle(for: JQTool.self)
//        let path = mainBundle.path(forResource: "JQToolsRes", ofType: "bundle")
//        let jqToolsBundle = Bundle(path: path!)
//        let filePath = jqToolsBundle?.path(forResource: "citysCode", ofType: "txt")
//
//        do {
//            let content = try String(contentsOfFile: filePath!)
//            print(content)
//        } catch  {
//
//        }


//        let a = Bundle(for: JQTool.self)
//        let image = UIImage(named: "ty_qrcode_line", in: a, compatibleWith: .none)
//        let imageView = UIImageView(image: image)
//        view.addSubview(imageView)
//        imageView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }

extension Bundle{
    /// 加载JQTools中 JQTools中的数据目录下的数据
    static func JQ_Bundle(resource:String,type:String)->String?{
        let mainBundle  = Bundle(for: JQTool.self)
        let path = mainBundle.path(forResource: "JQToolsRes", ofType: "bundle")
        let jqToolsBundle = Bundle(path: path!)
        let filePath = jqToolsBundle?.path(forResource: resource, ofType: type)
        do {
            let content = try String(contentsOfFile: filePath!)
            return content
        } catch  {
            return nil
        }
    }

    /// 加载JQTools 中XXX.bundle
    /// - Parameters:
    ///   - bundleName: bundle名称
    ///   - resource: 数据名称
    ///   - type: 数据后缀
    /// - Returns: 返回Bundle
    static func JQ_Bundle(bundleName:String,resource:String,type:String)->Bundle?{
        let a = Bundle(for: JQTool.self).path(forResource: bundleName, ofType: "bundle")
        if a != nil {
            return Bundle(path: a!)
        }
        return nil
    }
}
