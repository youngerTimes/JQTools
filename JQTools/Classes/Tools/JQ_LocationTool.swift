//
//  JQ_LocationManager.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/17.
//

import UIKit
import CoreLocation
import MapKit


public enum JQ_MapNavigationType {
    case BaiduMap //百度地图
    case Amap //高德地图
    case GoogleMap //谷歌地图
    case qqMap //qq地图

    static let allValues = [BaiduMap,Amap,GoogleMap,qqMap]

    public var raw:String{
        get{
            switch self {
                case .BaiduMap:
                    return "百度地图"
                case .Amap:
                    return "高德地图"
                case .GoogleMap:
                    return "Google地图"
                case .qqMap:
                    return "QQ地图"
            }
        }
    }
    public var URL:String{
        get{
            switch self {
                case .BaiduMap:
                    return "baidumap://"
                case .Amap:
                    return "iosamap://"
                case .GoogleMap:
                    return "comgooglemaps://"
                case .qqMap:
                    return "qqmap://"
            }
        }
    }
}

/*

 配置:LSApplicationQueriesSchemes
 各种地图的 Scheme：
 百度地图：baidumap
 高德地图：iosamap
 谷歌地图：comgooglemaps
 腾讯地图：qqmap
 */
public class JQ_MapNavigationTool{

    static var manager:CLLocationManager?;

    //查询已安装的地图
    public static func mapList()->[JQ_MapNavigationType]{
        var canOpenMapUrl = [JQ_MapNavigationType]()
        for mapEnum in JQ_MapNavigationType.allValues{
            if UIApplication.shared.canOpenURL(URL(string: mapEnum.URL)!) {
                canOpenMapUrl.append(mapEnum)
            }
        }
        return canOpenMapUrl
    }

    /// 使用系统自带的弹框进行导航
    /// - Parameters:
    ///   - coor: 经纬度
    ///   - distanceName: 终点名称
    ///   - scheme: 回跳至APP所需scheme
    public static func startNav(_ coor:CLLocationCoordinate2D,distanceName:String,scheme:String){
        let alertVC = UIAlertController(title: "导航", message: "请选择导航方式", preferredStyle: .actionSheet)
        for mapItem in JQ_MapNavigationTool.mapList() {
            let alert = UIAlertAction(title: mapItem.raw, style: .default) { (_) in
                JQ_MapNavigationTool.plaformMap(mapItem, scheme: scheme, coor: coor, distanceName: distanceName)
            }
            alertVC.addAction(alert)
        }

        let appleMap = UIAlertAction(title: "Apple地图", style: .default) { (_) in
            JQ_MapNavigationTool.navMap(coor, distanceName: distanceName)
        }

        alertVC.addAction(appleMap)
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        JQ_currentViewController().present(alertVC, animated: true, completion: nil)
    }

    /// 原生地图导航
    /// - Parameters:
    ///   - coor: 经纬度
    ///   - distanceName: 终点名称
    public static func navMap(_ coor:CLLocationCoordinate2D,distanceName:String){
        let currentLoc = MKMapItem.forCurrentLocation()
        let distanceLoc = MKMapItem(placemark: MKPlacemark(coordinate: coor,addressDictionary: nil))
        distanceLoc.name = distanceName

        let launchOpt = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                         MKLaunchOptionsShowsTrafficKey:true
        ] as [String : Any]

        MKMapItem.openMaps(with: [currentLoc,distanceLoc], launchOptions: launchOpt)
    }


				/// 百度地图坐标转换：GCJ-02 坐标系转 BD-09
				public static func bdEncrypt(ggLng: Double, ggLat: Double) -> (Double,Double) {
								let X_PI = Double.pi * 3000.0 / 180.0
								let x = ggLng
								let y = ggLat
								let z = sqrt(x * x + y * y) + 0.00002 * sin(y * X_PI)
								let theta = atan2(y, x) + 0.000003 * cos(x * X_PI)
								let bdLng = z * cos(theta) + 0.0065
								let bdLat = z * sin(theta) + 0.006
								return (bdLat,bdLng)
				}

    

    public static func plaformMap(_ type:JQ_MapNavigationType,scheme:String,coor:CLLocationCoordinate2D,distanceName:String){

        var url = ""
        switch type {
            case .BaiduMap:
                url = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(coor.latitude),\(coor.longitude)|name=\(distanceName)&mode=driving&coord_type=gcj02"
            case .Amap:
                url = "iosamap://path?sourceApplication=导航&backScheme=\(scheme)&lat=\(coor.latitude)&lon=\(coor.longitude)&dev=0&style=2"
            case .GoogleMap:
                url = "comgooglemaps://?x-source=导航&x-success=\(scheme)&saddr=&daddr=\(coor.latitude),\(coor.longitude)&directionsmode=driving"
            case .qqMap:
                url = "qqmap://map/routeplan?from=我的位置&type=drive&tocoord=\(coor.latitude),\(coor.longitude)&to=\(distanceName)&coord_type=1&policy=0"
        }
        UIApplication.shared.open(URL(string: url.jq_urlEncoded())!, options: [:]) { (status) in
            if !status{
//                JQ_ShowError(errorStr: "导航失败,请选择其他导航APP")
            }
        }
    }
}

public class JQ_LocationTool:NSObject,CLLocationManagerDelegate{

    public typealias JQLocationLocationClouse = (CLLocation)->Void
    public typealias JQLocationHeadingClouse = (CLHeading,Double)->Void
    public typealias JQLocationErrorClouse = (Error)->Void

    public var manager:CLLocationManager!

    private var currentType = 0

    public private(set) var currentLocation:CLLocation?

    public var locationClouse:JQLocationLocationClouse?
    public var headingClouse:JQLocationHeadingClouse?
    public var errorClouse:JQLocationErrorClouse?

    private static var _sharedInstance: JQ_LocationTool?

    public class func instance() -> JQ_LocationTool {
           guard let instance = _sharedInstance else {
               _sharedInstance = JQ_LocationTool()
               return _sharedInstance!
           }
           return instance
       }
    private override init() {
        super.init()
    }

    public func startLocation(_ locationClouse:@escaping JQLocationLocationClouse,errorClouse:@escaping JQLocationErrorClouse){
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        manager.delegate = self
        currentType = 0
        self.locationClouse = locationClouse
        self.errorClouse = errorClouse

        var currentStatus:CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            currentStatus = manager.authorizationStatus
        } else {
            currentStatus = CLLocationManager.authorizationStatus()
        }
        switch currentStatus {
            case .authorizedAlways,.authorizedWhenInUse:
                manager.startUpdatingLocation()
            case .restricted,.denied:
                JQ_AuthorizesTool.default.openURL(.location)
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            default:break
        }
    }

    public func geocoder(_ location:CLLocation,completeClouse:@escaping CLGeocodeCompletionHandler){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: completeClouse)
    }

    public func stopLocation(){
        manager.stopUpdatingLocation()
    }

    public func stopHeading(){
        manager.stopUpdatingHeading()
    }

    public func destroy(){
        JQ_LocationTool._sharedInstance = nil
    }

    public func startHeading(_ headingClouse:@escaping JQLocationHeadingClouse,errorClouse:@escaping JQLocationErrorClouse){
        currentType = 1
        self.headingClouse = headingClouse
        self.errorClouse = errorClouse

        var currentStatus:CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            currentStatus = manager.authorizationStatus
        } else {
            currentStatus = CLLocationManager.authorizationStatus()
        }
        switch currentStatus {
            case .authorizedAlways,.authorizedWhenInUse:
                if CLLocationManager.headingAvailable() {
                    manager.startUpdatingHeading()
                }
            case .restricted,.denied:
                JQ_AuthorizesTool.default.openURL(.location)
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            default:break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation = nil
        errorClouse?(error)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let angle = newHeading.magneticHeading/180.0*Double.pi
        headingClouse?(newHeading,angle)
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        var currentStatus:CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            currentStatus = manager.authorizationStatus
        } else {
            currentStatus = CLLocationManager.authorizationStatus()
        }
        switch currentStatus {
            case .authorizedAlways,.authorizedWhenInUse:
                manager.startUpdatingLocation()
            case .restricted,.denied:
                JQ_AuthorizesTool.default.openURL(.location)
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            default:break
        }
    }

    public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {

    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.filter({$0.coordinate.latitude > 0 && $0.coordinate.longitude > 0}).last{
            currentLocation = location
            locationClouse?(location)
        }
    }
}
