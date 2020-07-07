//
//  Ys_OpenFile.swift
//  ElevatorChain
//
//  Created by apple on 2019/1/29.
//  Copyright © 2019 stitch. All rights reserved.
//

import UIKit
//#import <QuickLook/QuickLook.h>
import QuickLook

class JQ_OpenFile: NSObject,QLPreviewControllerDelegate,QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return datePathStr! as NSURL
    }
    
    var datePathStr:URL!
    
     func show(){
        let myQlPreVC = QLPreviewController()
        myQlPreVC.delegate = self
        myQlPreVC.dataSource = self
        myQlPreVC.currentPreviewItemIndex = 0
        
        JQ_currentNavigationController().present(myQlPreVC, animated: true, completion: nil)
    }
}
