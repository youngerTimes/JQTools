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
    public var object_id = 0
    public var name = ""
    public var level = 0
    public var longitude = 0
    public var latitude = 0
    public var pid = 0
    public var childs = [CitysOptionModel]()
    public var crown = false
    
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
