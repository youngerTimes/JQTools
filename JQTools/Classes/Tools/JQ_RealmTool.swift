//
//  RealmTool.swift
//  RealmDemo
//
//  Created by 无故事王国 on 2020/8/20.
//  Copyright © 2020 成都金翼致远科技有限公司. All rights reserved.
//

import Foundation

#if canImport(RealmSwift)

//https://www.hangge.com/blog/cache/detail_891.html
/// RealmTool数据库
public class JQ_RealmTool:NSObject{
    public static let `default` = JQ_RealmTool()
    public private(set) var dbVersion:UInt64 = 0
    public private(set) var dbName:String!
    public private(set) var realm:Realm?
    
    let docPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).last!
    
    override init() {super.init()}
    
    /// 配置
    public func config(dbName:String = "defaultDB.realm",dbVersion:UInt64,memoryId:String? = nil,syncConfig:SyncConfiguration? = nil,encrypt:Bool = false,readOnly:Bool = false){
        
        var key:Data?
        if encrypt{
            key = Data(count: 64)
            _ = key!.withUnsafeMutableBytes { bytes in
                SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
            }
        }
        
        self.dbVersion = dbVersion
        self.dbName = dbName
        let dbPath = docPath.appending("/\(dbName)")
        
        let config = Realm.Configuration(fileURL: URL(string: dbPath), inMemoryIdentifier: memoryId, syncConfiguration: syncConfig, encryptionKey: key, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
    }
    
    /// 打开数据库
    public func open(_ clouse:((Realm)->Void)?){
        if realm != nil {
            print("Realm 数据库打开成功【已拥有】")
            clouse?(realm!)
        }else{
            unowned let weakSelf = self
            Realm.asyncOpen { (r, e) in
                if e != nil{
                    print("Realm 数据库配置失败：\(e!.localizedDescription)");return
                }
                if r != nil{
                    print("Realm 数据库打开成功【新建】")
                    weakSelf.realm = r;clouse?(r!)
                }
            }
        }
    }
    
    public func insert(_ objs:[Object]){
        realm?.beginWrite()
        try! realm?.write {
            realm?.add(objs)
        }
    }
    
    
    public func insert<Element: Object>(_ type:Element.Type,value:Dictionary<String,Any>){
        realm?.beginWrite()
        try! realm?.write {
            realm?.create(type, value: value, update: .modified)
        }
    }
    
    public func query<Element: Object>(_ type: Element.Type) -> Results<Element> {
        return (realm?.objects(type))!
    }
    
    public func delete(_ object: Object){
        realm?.delete(object)
    }
    
    public func deleteAll(){
        realm?.deleteAll()
    }
}
#endif
