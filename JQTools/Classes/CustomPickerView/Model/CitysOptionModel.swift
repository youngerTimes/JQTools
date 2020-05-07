//
//  CitysOptionModel.swift
//  mentor-teacher
//
//  Created by 杨锴 on 2020/2/27.
//  Copyright © 2020 memoo. All rights reserved.
//

#if canImport(ObjectMapper)
import ObjectMapper

public class CitysOptionModel: JQModel {
    var object_id = 0
    var name = ""
    var level = 0
    var longitude = 0
    var latitude = 0
    var pid = 0
    var childs = [CitysOptionModel]()
    var crown = false
    
    public override func mapping(map: Map) {
        object_id <- map["object_id"]
        name <- map["name"]
        level <- map["level"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        pid <- map["pid"]
        childs <- map["childs"]
        crown <- map["crown"]
    }
}
#endif
