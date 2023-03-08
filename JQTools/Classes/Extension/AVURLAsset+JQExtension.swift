//
//  AVURLAsset+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//
import AVKit

public extension AVURLAsset{
    @available(*,deprecated,message: "废弃:使用JQBase")
    ///获取视频截图(网络)
    func jq_GetVedioPicture(_ image: ((_ vedioImage:UIImage)->Void)?) {
        DispatchQueue.global().async {
            //生成视频截图
            let generator = AVAssetImageGenerator(asset: self)
            generator.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(0.0,preferredTimescale: 600)
            var actualTime:CMTime = CMTimeMake(value: 0,timescale: 0)
            do {
                let imageRef:CGImage = try generator.copyCGImage(at: time, actualTime: &actualTime)
                let frameImg = UIImage(cgImage: imageRef)
                DispatchQueue.main.async(execute: {
                    if (image) != nil {
                        image!(frameImg)
                    }
                })
            }catch {
                print(error)
            }
        }
    }
}
