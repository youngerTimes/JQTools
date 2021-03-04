//
//  JQ_FileCatalogVC.swift
//  JQTools
//
//  Created by 无故事王国 on 2021/3/4.
//

import UIKit

/// 沙盒目录
public class JQ_FileCatalogVC: UIViewController {

    var tableView:UITableView!
    var path:String = NSHomeDirectory()
    public var document = ""
    public var abstaticPath = ""

    var items = [String]()

    public override func viewDidLoad() {
        super.viewDidLoad()
        abstaticPath = path.appending("/\(document)")
        items = (FileManager.jq_shallowSearchAllFiles(folderPath:path)?.filter({!($0.hasPrefix("."))})) ?? []

        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        } else {
            tableView = UITableView(frame: CGRect.zero, style: .grouped)
        }
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        tableView.reloadData()
    }

    /// 打开文件
    /// - Parameters:
    ///   - filePath: 文件路径
    ///   - suffix: 后缀
    fileprivate func openFile(_ filePath:String,suffix:String){
        let documentVC = JQ_OpenFile()
        documentVC.datePathStr = URL(fileURLWithPath: filePath)
        documentVC.show()
    }
}

extension JQ_FileCatalogVC:UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //判断是否是文件夹
        if FileManager.jq_isDirectory(path: path.appending("/\(items[indexPath.row])")) {
            let vc = JQ_FileCatalogVC()
            vc.title = "\(items[indexPath.row])"
            vc.path = path.appending("/\(items[indexPath.row])")
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            openFile(path.appending("/\(items[indexPath.row])"), suffix: items[indexPath.row].components(separatedBy: ".").last!.lowercased())
        }
    }
}

extension JQ_FileCatalogVC:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "fileCatalog")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "fileCatalog")
            cell?.selectionStyle = .none
            cell?.selectionStyle = .none
            cell?.textLabel?.numberOfLines = 0
        }

      //获取后缀
//       let suffix = FileManager.jq_fileSuffixAtPath(path: items[indexPath.row])
//        switch suffix.lowercased() {
//            case "":cell?.imageView?.image = UIImage(named: "icon_document")
//            case "jpg","png","jpeg","gif":cell?.imageView?.image = UIImage(named: "icon_jpg")
//            case "txt","text":cell?.imageView?.image = UIImage(named: "icon_text")
//            case "doc","docx":cell?.imageView?.image = UIImage(named: "icon_world")
//            case "mp4","avi":cell?.imageView?.image = UIImage(named: "icon_movie")
//            case "excel":cell?.imageView?.image = UIImage(named: "icon_excel")
//            default:
//                //判断是否是文件夹
//                if FileManager.jq_isDirectory(path: path.appending("/\(items[indexPath.row])")) {
//                    cell?.imageView?.image = UIImage(named: "icon_document")
//                }else{
//                    cell?.imageView?.image = UIImage(named: "icon_other")
//                }
//        }
        cell?.textLabel?.text = items[indexPath.row]

        return cell!
    }
}
