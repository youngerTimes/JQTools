//
//  JQAddressModel.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/17.
//

import Foundation

#if canImport(ObjectMapper)
import ObjectMapper
public class JQ_AddressModel:JQModel{
    var adcode = ""
    var center = ""
    var citycode = ""
    var districts: [JQ_AddressModel]? = nil
    var level = ""
    var name = ""
    var pingYin = ""
    var hot = false
    var village = ""
    
    public override func mapping(map: Map) {
        hot <- map["hot"]
        adcode <- map["adcode"]
        center <- map["center"]
        citycode <- map["citycode"]
        districts <- map["districts"]
        level <- map["level"]
        name <- map["name"]
        pingYin <- map["pingYin"]
    }
}
#endif
