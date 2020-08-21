//
//  JQ_SQLiteTool.swift
//  RealmDemo
//
//  Created by 无故事王国 on 2020/8/21.
//  Copyright © 2020 成都金翼致远科技有限公司. All rights reserved.
//

#if canImport(FMDB)
import FMDB
import Foundation

//https://www.hangge.com/blog/cache/detail_2316.html
public class JQ_SQLiteTool: NSObject {
    
    public static let `default`:JQ_SQLiteTool = {
        let center = JQ_SQLiteTool()
        return center
    }()
    
    // 数据库名称
    private let dbName = "test.db"
    
    // 数据库地址
    public lazy var dbURL: URL = {
        // 根据传入的数据库名称拼接数据库的路径
        let fileURL = URL(string: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).last!)!.appendingPathComponent(dbName)
        print("数据库地址：", fileURL)
        return fileURL
    }()
    
    // FMDatabase对象（用于对数据库进行操作）
    public lazy var db: FMDatabase = {
        let database = FMDatabase(url: dbURL)
        return database
    }()
    
    // FMDatabaseQueue对象（用于多线程事务处理）
    public lazy var dbQueue: FMDatabaseQueue? = {
        // 根据路径返回数据库
        let databaseQueue = FMDatabaseQueue(url: dbURL)
        return databaseQueue
    }()
    
    
    ///插入：建议使用映射
    public func exec(_ sql:String,_ args:[Any]){
        if db.open() {
            dbQueue?.inTransaction({ (db, rollback) in
                do{
                    try db.executeUpdate(sql, values: args)
                    db.close()
                }catch{
                    rollback.pointee = true
                    db.close()
                }
            })
        }
    }
    
    //查询：建议使用映射
    public func query(_ sql:String,args:[Any])->FMResultSet?{
        if db.open(){
            return db.executeQuery(sql, withArgumentsIn:args)
        }
        return nil
    }
}

/**
 class User: SQLModel {
 var id:Int = -1
 var name:String = ""
 var age:Int = -1
 
 // 返回主键名
 override func primaryKey() -> String {
 return "uid"
 }
 
 // 返回忽略的键值
 override func ignoredKeys() -> [String] {
 return ["age"]
 }
 }
 
 
 //新增数据
 let user = User()
 user.name = "测试用户\(i)"
 user.age = 100
 user.save()
 
 //修改数据
 let user = User()
 user.id = 2
 user.name = "hangge.com"
 user.age = 0
 user.save()
 
 //删除数据
 let user = User()
 user.id = 2
 user.delete()
 
 // 删除User表所有的数据
 User.remove()
 
 // 根据指定条件删除User表的数据
 User.remove(filter: "id > 5 and age < 107")
 
 //获取记录数
 let count = User.count()
 print("记录数：\(count)")
 
 / 获取所有数据
 let users = User.rows()
 
 // 遍历输出结果
 for user in users {
 print(user.id, user.name, user.age)
 }
 
 
 // 根据条件获取数据
 let users = User.rows(filter: "id > 5 and age < 107", order: "age desc", limit: 3)
 
 // 遍历输出结果
 for user in users {
 print(user.id, user.name, user.age)
 }
 
 
 // 通过sql获取数据
 let users = User.rowsFor(sql: "select * from User limit 3")
 
 // 遍历输出结果
 for user in users {
 print(user.id, user.name, user.age)
 }
 
 */

public protocol JQ_SQLModelProtocol {}
// 数据库模型（一张表对应一个模型）
@objcMembers
public class SQLModel: NSObject,JQ_SQLModelProtocol {
    
    // 模型对应的表名（直接使用对应模型类名字）
    internal var table = ""
    
    // 记录每个模式对应的数据表是否已经创建完毕了
    private static var verified = [String:Bool]()
    
    // 初始化方法
    required override init() {
        super.init()
        // 自动初始化表名
        self.table = type(of: self).table
        // 自动建对应的数据库表
        let verified = SQLModel.verified[self.table]
        if verified == nil || !verified! {
            let db = JQ_SQLiteTool.default.db
            var sql = "CREATE TABLE IF NOT EXISTS \(table) ("
            // Columns
            let cols = values()
            var first = true
            for col in cols {
                if first {
                    first = false
                    sql += getColumnSQL(column:col)
                } else {
                    sql += ", " + getColumnSQL(column: col)
                }
            }
            // Close query
            sql += ")"
            if db.open() {
                if db.executeUpdate(sql, withArgumentsIn:[]) {
                    SQLModel.verified[table] = true
                    print("\(table) 表自动创建成功")
                }
            }
        }
    }
    
    // 返回主键字段名（如果模型主键不是id，则需要覆盖这个方法）
    func primaryKey() -> String {
        return "id"
    }
    
    // 忽略的属性（模型中不需要与数据库表进行映射的字段可以在这里发返回）
    func ignoredKeys() -> [String] {
        return []
    }
    
    // 静态方法返回表名
    static var table:String {
        // 直接返回类名字
        return "\(classForCoder())"
    }
    
    // 删除指定数据（可附带条件）
    @discardableResult
    class func remove(filter: String = "") -> Bool {
        let db = JQ_SQLiteTool.default.db
        var sql = "DELETE FROM \(table)"
        if !filter.isEmpty {
            // 添加删除条件
            sql += " WHERE \(filter)"
        }
        if db.open() {
            return db.executeUpdate(sql, withArgumentsIn:[])
        } else {
            return false
        }
    }
    
    // 获取数量（可附带条件）
    class func count(filter: String = "") -> Int {
        let db = JQ_SQLiteTool.default.db
        var sql = "SELECT COUNT(*) AS count FROM \(table)"
        if !filter.isEmpty {
            // 添加查询条件
            sql += " WHERE \(filter)"
        }
        if let res = db.executeQuery(sql, withArgumentsIn: []) {
            if res.next() {
                return Int(res.int(forColumn: "count"))
            } else {
                return 0
            }
        }
        return 0
    }
    
    // 保存当前对象数据
    // * 如果模型主键为空或者使用该主键查不到数据则新增
    // * 否则的话则更新
    @discardableResult
    func save() -> Bool{
        let key = primaryKey()
        let data = values()
        var insert = true
        let db = JQ_SQLiteTool.default.db
        
        if let rid = data[key] {
            var val = "\(rid)"
            if rid is String {
                val = "'\(rid)'"
            }
            let sql = "SELECT COUNT(*) AS count FROM \(table) "
                + "WHERE \(primaryKey())=\(val)"
            if db.open() {
                if let res = db.executeQuery(sql, withArgumentsIn: []) {
                    if res.next() {
                        insert = res.int(forColumn: "count") == 0
                    }
                }
            }
            
        }
        
        let (sql, params) = getSQL(data:data, forInsert:insert)
        // 执行SQL语句
        
        if db.open() {
            return db.executeUpdate(sql, withArgumentsIn: params ?? [])
        } else {
            return false
        }
    }
    
    // 删除当天对象数据
    @discardableResult
    func delete() -> Bool{
        let key = primaryKey()
        let data = values()
        let db = JQ_SQLiteTool.default.db
        if let rid = data[key] {
            if db.open() {
                let sql = "DELETE FROM \(table) WHERE \(primaryKey())=\(rid)"
                return db.executeUpdate(sql, withArgumentsIn: [])
            }
        }
        return false
    }
    
    // 通过反射获取对象所有有的属性和属性值
    internal func values() -> [String:Any] {
        var res = [String:Any]()
        let obj = Mirror(reflecting:self)
        processMirror(obj: obj, results: &res)
        getValues(obj: obj.superclassMirror, results: &res)
        return res
    }
    
    // 供上方方法（获取对象所有有的属性和属性值）调用
    private func getValues(obj: Mirror?, results: inout [String:Any]) {
        guard let obj = obj else { return }
        processMirror(obj: obj, results: &results)
        getValues(obj: obj.superclassMirror, results: &results)
    }
    
    // 供上方方法（获取对象所有有的属性和属性值）调用
    private func processMirror(obj: Mirror, results: inout [String: Any]) {
        for (_, attr) in obj.children.enumerated() {
            if let name = attr.label {
                // 忽略 table 和 db 这两个属性
                if name == "table" || name == "db" {
                    continue
                }
                // 忽略人为指定的属性
                if ignoredKeys().contains(name) ||
                    name.hasSuffix(".storage") {
                    continue
                }
                results[name] = unwrap(attr.value)
            }
        }
    }
    
    //将可选类型（Optional）拆包
    func unwrap(_ any:Any) -> Any {
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
        
        if mi.children.count == 0 { return any }
        let (_, some) = mi.children.first!
        return some
    }
    
    // 返回新增或者修改的SQL语句
    private func getSQL(data:[String:Any], forInsert:Bool = true)
        -> (String, [Any]?) {
            var sql = ""
            var params:[Any]? = nil
            if forInsert {
                sql = "INSERT INTO \(table)("
            } else {
                sql = "UPDATE \(table) SET "
            }
            let pkey = primaryKey()
            var wsql = ""
            var rid:Any?
            var first = true
            for (key, val) in data {
                // 处理主键
                if pkey == key {
                    if forInsert {
                        if val is Int && (val as! Int) == -1 {
                            continue
                        }
                    } else {
                        wsql += " WHERE " + key + " = ?"
                        rid = val
                        continue
                    }
                }
                // 设置参数
                if first && params == nil {
                    params = [AnyObject]()
                }
                if forInsert {
                    sql += first ? "\(key)" : ", \(key)"
                    wsql += first ? " VALUES (?" : ", ?"
                    params!.append(val)
                } else {
                    sql += first ? "\(key) = ?" : ", \(key) = ?"
                    params!.append(val)
                }
                first = false
            }
            // 生成最终的SQL
            if forInsert {
                sql += ")" + wsql + ")"
            } else if params != nil && !wsql.isEmpty {
                sql += wsql
                params!.append(rid!)
            }
            return (sql, params)
    }
    
    // 返回建表时每个字段的sql语句
    private func getColumnSQL(column:(key: String, value: Any)) -> String {
        let key = column.key
        let val = column.value
        var sql = "'\(key)' "
        if val is Int {
            // 如果是Int型
            sql += "INTEGER"
            if key == primaryKey() {
                sql += " PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE"
            } else {
                sql += " DEFAULT \(val)"
            }
        } else {
            // 如果是其它类型
            if val is Float || val is Double {
                sql += "REAL DEFAULT \(val)"
            } else if val is Bool {
                sql += "BOOLEAN DEFAULT " + ((val as! Bool) ? "1" : "0")
            } else if val is Date {
                sql += "DATE"
            } else if val is NSData {
                sql += "BLOB"
            } else {
                // Default to text
                sql += "TEXT"
            }
            if key == primaryKey() {
                sql += " PRIMARY KEY NOT NULL UNIQUE"
            }
        }
        return sql
    }
}

public extension JQ_SQLModelProtocol where Self: SQLModel {
    // 根据完成的sql返回数据结果
    static func rowsFor(sql: String = "") -> [Self] {
        var result = [Self]()
        let tmp = self.init()
        let data = tmp.values()
        let db = JQ_SQLiteTool.default.db
        let fsql = sql.isEmpty ? "SELECT * FROM \(table)" : sql
        if let res = db.executeQuery(fsql, withArgumentsIn: []){
            // 遍历输出结果
            while res.next() {
                let t = self.init()
                for (key, _) in data {
                    if let val = res.object(forColumn: key) {
                        t.setValue(val, forKey:key)
                    }
                }
                result.append(t)
            }
        }else{
            print("查询失败")
        }
        return result
    }
    
    // 根据指定条件和排序算法返回数据结果
    static func rows(filter: String = "", order: String = "",
                     limit: Int = 0) -> [Self] {
        var sql = "SELECT * FROM \(table)"
        if !filter.isEmpty {
            sql += " WHERE \(filter)"
        }
        if !order.isEmpty {
            sql += " ORDER BY \(order)"
        }
        if limit > 0 {
            sql += " LIMIT 0, \(limit)"
        }
        return self.rowsFor(sql:sql)
    }
}
#endif
