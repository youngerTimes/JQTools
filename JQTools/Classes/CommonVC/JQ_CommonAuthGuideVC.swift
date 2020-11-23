//
//  JQ_CommonAuthGuideVC.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/11/17.
//

import UIKit

/// 权限引导页:第一次运行APP需先加载此页
class JQ_CommonAuthGuideVC: UIViewController {

    var authGuide = [JQ_AuthorizesTool.JQ_PermissionsType]()
    var authDesc = [String]()
    var authImg = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    /// 初始化方法
    /// - Parameters:
    ///   - auths: 权限列表
    ///   - authDesc: 权限描述内容
    ///   - authImg: 权限展示图片
    convenience init(auths:[JQ_AuthorizesTool.JQ_PermissionsType],authDesc:[String],authImg:[String]) {
        self.init()
        authGuide = auths
        self.authDesc = authDesc
        self.authImg = authImg

        if auths.count != authDesc.count || auths.count != authImg.count {
            fatalError("保持权限请求项和描述说明与图片数组相同")
        }

    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/**

 {
     lat = "24.34678027";
     lng = "102.5467238";
     orgName = "";
     pagenum = 15;
     pagestart = 1;
 }

 {
     lat = "24.19863929";
     lng = "102.93521303";
     orgName = "";
     pagenum = 15;
     pagestart = 1;
 }

 */
