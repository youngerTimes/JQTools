//
//  JQ_FileTools.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/7/10.
//

import Foundation

enum JQ_FileType {
    case document
    case cache
    case lib
}

public class JQ_FileTool: NSObject {
    static let `default` = JQ_FileTool()
    private var type:JQ_FileType = .document
    private let manager = FileManager.default
    private(set) var documentUrl:URL?
    private(set) var cacheUrl:URL?
    private(set) var libraryUrl:URL?
    
    public override init() {
        super.init()
        documentUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        cacheUrl = manager.urls(for: .cachesDirectory, in: .userDomainMask).first
        libraryUrl = manager.urls(for: .libraryDirectory, in: .userDomainMask).first
    }
    
    ///对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
    func shallowPath(type:JQ_FileType,hasLink:Bool = false,url:String = "")->([Any]?){
        var finalUrl = ""
        switch type {
            case .cache:
                finalUrl = cacheUrl!.absoluteString
            case .document:
                finalUrl = documentUrl!.absoluteString
            case .lib:
                finalUrl = documentUrl!.absoluteString
        }
        
        finalUrl.append(contentsOf: url)
        let Url = URL(string: finalUrl)
        do {
            
            //包含路径
            if hasLink {
                return try manager.contentsOfDirectory(at: Url!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            }else{
                return try manager.contentsOfDirectory(atPath: Url!.absoluteString)
            }
        } catch _ {
            return nil
        }
    }
}
