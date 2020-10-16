//
//  WKWebView+JQExtension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/16.
//

import WebKit

public extension WKWebView{
    ///获取HTML中的所有图片，写在 didFinishNavigation 【部分一】
    /**
     func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
         let url  = navigationAction.request.url
         if url?.scheme == "image-preview-index"{
             let browser = SDPhotoBrowser()
             browser.imageCount = htmlImgsUrl!.count
             let last = url?.absoluteString.split(separator: ":").last
             let index = Int("\(last!)") ?? 0
             print(index)
             browser.currentImageIndex = index
             browser.delegate = self
             browser.show()
         }
         decisionHandler(WKNavigationActionPolicy.allow)
     }

     */
    func jq_htmlImgTag(resultForImg:@escaping ([String],[UIImageView])->(Void)){

        var imgsUrl:Array<String> = []
        var imgs:Array<UIImageView> = []

        //获取所有图片的标签
        let getAllImgsTag = """
            function getImages(){\
                var imgs = document.getElementsByTagName('img');\
                 var imgScr = '';\
                 for(var i=0;i<imgs.length;i++){\
                 if (i == 0){ \
                 imgScr = imgs[i].src; \
                 } else {\
                 imgScr = imgScr +'***'+ imgs[i].src;\
                 } \
                 };\
                 return imgScr;\
                 };
            """
        self.evaluateJavaScript(getAllImgsTag, completionHandler: nil)

        self.evaluateJavaScript("getImages()") { (result, error) in
            if((error) != nil){return}
            if (result != nil){
                let res = result as! String
                imgsUrl = Array(res.components(separatedBy: "***"))
                for img in imgsUrl{
                    let imageView = UIImageView()
//                    imageView.setImage(img, nil)
                    imageView.jq_imageFromURL(img, placeholder: UIImage(named: "")!)
                    imgs.append(imageView)
                }
               resultForImg(imgsUrl,imgs)
            }
        }

        let imgClick = """
         function registerImageClickAction(){\
         var imgs = document.getElementsByTagName('img');\
         for(var i=0;i<imgs.length;i++){\
         imgs[i].customIndex = i;\
         imgs[i].onclick=function(){\
         window.location.href='image-preview-index:'+this.customIndex;\
            }\
         }\
         }
"""
        self.evaluateJavaScript(imgClick, completionHandler: nil)
        self.evaluateJavaScript("registerImageClickAction()", completionHandler: nil)
    }
}
