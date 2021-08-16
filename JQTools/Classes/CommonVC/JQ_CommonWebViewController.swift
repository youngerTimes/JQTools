//
//  CommonWebViewController.swift
//  Completely
//
//  Created by 无故事王国 on 2020/8/5.
//  Copyright © 2020 Mr. Hu. All rights reserved.
//

import UIKit
import WebKit

#if canImport(SnapKit)
/// 网页
public class JQ_CommonWebViewController: JQ_BaseVC {

    private var webView:WKWebView?
    private(set) var url = ""
    private(set) var htmlText = ""
    private var progressView = UIProgressView()
    private let jsCode = """
    var meta = document.createElement('meta');"
    "meta.name = 'viewport';"
    "meta.content = 'width=device-width, initial-scale=1.0,minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes';"
    "document.getElementsByTagName('head')[0].appendChild(meta);
"""
    
    public var tintColor = UIColor.blue
    
    public convenience init(url:String) {
        self.init()
        self.url = url
    }
    
    public convenience init(htmlText:String) {
        self.init()
        self.htmlText = htmlText.jq_wrapHtml()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        let userScript = WKUserScript(source: jsCode, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        let content = WKUserContentController()
        content.addUserScript(userScript)
        config.userContentController = content
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        view.addSubview(webView!)
        webView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        })
        
        if #available(iOS 11.0, *) {
            webView!.scrollView.contentInsetAdjustmentBehavior = .automatic
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        progressView.tintColor = tintColor
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(2 * JQ_RateW)
        }
        
        
        if !url.isEmpty {
            let urlRequest = URLRequest(url: URL(string: url)!)
            webView?.load(urlRequest)
        }else{
            webView?.loadHTMLString(htmlText, baseURL: nil)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let value = change![NSKeyValueChangeKey(rawValue: "new")] as! Double
        print(value)
        
        
        progressView.setProgress(Float(value), animated: true)
        if value == 1.0 {
            progressView.isHidden = true
        }else{
            progressView.isHidden = false
        }
    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

#endif
