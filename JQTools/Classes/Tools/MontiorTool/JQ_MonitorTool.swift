//
//  JQ_MonitorTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2021/2/5.
//

import Foundation

private enum MonitorAdsorbEnum:Int{
    case left = 1
    case right = 2
}

/// 监视器
public class JQ_MonitorTool:NSObject{

    private lazy var monitorView:JQ_MonitorView = {
        let monitorV = JQ_MonitorView.jq_loadToolNibView()
        monitorV.frame = CGRect(x: 0, y:UIDevice.jq_safeEdges.top, width: showBallSize.width, height: showBallSize.height)
        monitorV.jq_cornerRadius = 5 * JQ_RateW
        monitorV.alpha = 0.6
        monitorV.isUserInteractionEnabled = true
        return monitorV
    }()

    public static let `default`:JQ_MonitorTool = {
        let center = JQ_MonitorTool()
        return center
    }()

    /// 小球的大小
    private var showBallSize = CGSize(width: 280 * JQ_RateW, height: 50 * JQ_RateW)

    /// 吸附方向
    private var monitorAdsorbEnum:MonitorAdsorbEnum = .left

    /// 手势拖动
    private var panGesture:UIPanGestureRecognizer!
    private var tapGesture:UITapGestureRecognizer!

    private var link: CADisplayLink?
    private var count: UInt = 0
    private var lastTime: TimeInterval = 0

    private var timer:Timer?

    //开始
    public func start(){
        //加载小球
        if let window = UIApplication.shared.keyWindow{
            window.addSubview(monitorView)
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(pangestureAction(_:)))
            monitorView.addGestureRecognizer(panGesture!)

            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
            monitorView.addGestureRecognizer(tapGesture!)

            unowned let weakSelf = self
            timer = Timer(timeInterval: 1.0, repeats: true) { (timer) in
                autoreleasepool{
                    weakSelf.monitorView.CPUPercentL.text = String(format: "%.1lf",JQ_cpuUsage()) + "%"
                    weakSelf.monitorView.memoryPercentL.text =  String(format: "%.1lf",JQ_report_memory().usage) + "M"
                }
            }
            RunLoop.current.add(timer!, forMode: .common)

            link = CADisplayLink(target: self, selector: #selector(tick(_:)))
            ///main runloop 添加到
            link?.add(to: RunLoop.main, forMode: .common)
        }
    }

    public func stop(){
        link?.invalidate()
        timer?.invalidate()
    }

    ///滴答滴答
    @objc fileprivate func tick(_ link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count = count + 1
        let delta = link.timestamp - lastTime
        if delta < 1 {
            return
        }
        lastTime = link.timestamp;
        let fps = Double(count) / delta
        count = 0
        monitorView.FPSL.text = String(format: "%.0lf", round(fps))
    }

    @objc private func tapAction(_ pan:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5) {
            self.monitorView.alpha = 1.0
        }

        //重新收回
        UIView.animate(withDuration: 0.3, delay: 5.0, options: .layoutSubviews) {
            self.monitorView.alpha = 0.6
        } completion: { (complete) in

        }
    }

    @objc private func pangestureAction(_ pan:UIPanGestureRecognizer){

        if pan == panGesture {
            let panPoint = pan.location(in: UIApplication.shared.keyWindow!)
            self.monitorView.alpha = 1.0
            switch pan.state {
                case .began,.changed:
                    monitorView.center = CGPoint(x: panPoint.x, y: panPoint.y)

                case .ended:
                    pan.setTranslation(CGPoint.zero, in: monitorView)
                    UIView.animate(withDuration: 0.5) {
                        //吸附左边
                        if self.monitorView.center.x < JQ_ScreenW / 2{
                            self.monitorAdsorbEnum = .left
                            self.monitorView.center.x = self.showBallSize.width / 2
                        }

                        //吸附右边
                        if self.monitorView.center.x >= JQ_ScreenW / 2 {
                            self.monitorAdsorbEnum = .right
                            self.monitorView.center.x = JQ_ScreenW - self.showBallSize.width/2
                        }

                        if self.monitorView.jq_y < UIDevice.jq_safeEdges.top{
                            self.monitorView.jq_y = UIDevice.jq_safeEdges.top
                        }

                        if self.monitorView.frame.maxY > JQ_ScreenH{
                            self.monitorView.jq_y = JQ_ScreenH - self.monitorView.jq_height - UIDevice.jq_safeEdges.bottom
                        }

                    } completion: { (complete) in
                        UIView.animate(withDuration: 0.5, delay: 3.0, options: .layoutSubviews) {
                            self.monitorView.alpha = 0.5
                        } completion: { (complete) in

                        }
                    }
                default:break
            }
        }
    }
}
