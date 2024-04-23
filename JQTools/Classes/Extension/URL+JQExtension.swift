//
//  URL+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/21.
//

import MobileCoreServices
import AVFoundation
public extension URL{
    
    ///根据后缀获取对应的Mime-Type
    var jq_mimeType:String{
        get{
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,pathExtension as NSString,nil)?.takeRetainedValue() {
                if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                    .takeRetainedValue() {
                    return mimetype as String
                }
            }
            //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
            return "application/octet-stream"
        }
    }

    ///获取URL的参数
    var jq_params : [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }

	static func jq_getVideoSize(by url: URL?) -> CGSize {
		var size: CGSize = .zero
		guard let url = url else {
			return size
		}
		let asset = AVAsset(url: url)
		let tracks = asset.tracks(withMediaType: AVMediaType.video)
		guard let track = tracks.first else {
			return size
		}

		let t = track.preferredTransform
		size = CGSize(width: track.naturalSize.height, height: track.naturalSize.width)

		if t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0 {
			size = CGSize(width: track.naturalSize.height, height: track.naturalSize.width)
		} else if t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0 {
				// PortraitUpsideDown
			size = CGSize(width: track.naturalSize.height, height: track.naturalSize.width)
		} else if t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0 {
				// LandscapeRight
			size = CGSize(width: track.naturalSize.width, height: track.naturalSize.height)
		}else if t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0 {
				// LandscapeLeft
			size = CGSize(width: track.naturalSize.width, height: track.naturalSize.height)
		}
		return size
	}

	static func wm_getFileSize(_ url:URL) -> Double {
		if let fileData:Data = try? Data.init(contentsOf: url) {
			let size = Double(fileData.count) / (1024.00 * 1024.00)
			return size
		}
		return 0.00
	}

	static func jq_splitVideoFileUrlFps(splitFileUrl: URL, fps: Float, splitCompleteClosure: @escaping (Bool, [UIImage]) -> Void) {

		var splitImages = [UIImage]()
		let optDict = NSDictionary(object: NSNumber(value: false), forKey: AVURLAssetPreferPreciseDurationAndTimingKey as NSCopying)
		let urlAsset = AVURLAsset(url: splitFileUrl, options: optDict as? [String: Any])

		let cmTime = urlAsset.duration
		let durationSeconds: Float64 = CMTimeGetSeconds(cmTime) //视频总秒数

		var times = [NSValue]()
		let totalFrames: Float64 = durationSeconds * Float64(fps) //获取视频的总帧数
		var timeFrame: CMTime

		for i in 0...Int(totalFrames) {
			timeFrame = CMTimeMake(value: Int64(i), timescale: Int32(fps)) //第i帧， 帧率
			let timeValue = NSValue(time: timeFrame)

			times.append(timeValue)
		}

		let imgGenerator = AVAssetImageGenerator(asset: urlAsset)
		imgGenerator.requestedTimeToleranceBefore = CMTime.zero //防止时间出现偏差
		imgGenerator.requestedTimeToleranceAfter = CMTime.zero
		imgGenerator.appliesPreferredTrackTransform = true //不知道是什么属性，不写true视频帧图方向不对

		let timesCount = times.count

			//获取每一帧的图片
		imgGenerator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, image, actualTime, result, error) in

				//times有多少次body就循环多少次。。。

			var isSuccess = false
			switch (result) {
				case AVAssetImageGenerator.Result.cancelled:
					print("cancelled------")

				case AVAssetImageGenerator.Result.failed:
					print("failed++++++")

				case AVAssetImageGenerator.Result.succeeded:
					let framImg = UIImage(cgImage: image!)
					splitImages.append(framImg)

					if (Int(requestedTime.value) == (timesCount - 1)) { //最后一帧时 回调赋值
						isSuccess = true
						splitCompleteClosure(isSuccess, splitImages)
						print("completed")
					}
				default:break
			}
		}
	}
}
