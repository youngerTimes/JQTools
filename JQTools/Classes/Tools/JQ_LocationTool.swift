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


// 参考来源：
// http://blog.woodbunny.com/post-68.html
// https://www.jianshu.com/p/347e4dc3d05a
// 圆周率
// let pi = 3.14159265358979324;
// let pi = M_PI;
let pi = Double.pi
let xpi: Double = pi * 3000.0 / 180.0

// 地球的平均半径
let r = 6371004
let a: Double = 6378245.0
//
let e: Double = 0.00669342162296594323



//WGS-84：是国际标准，GPS坐标（Google Earth使用、或者GPS模块）
//GCJ-02：中国坐标偏移标准，Google Map、高德、腾讯使用
//BD-09： 百度坐标偏移标准，Baidu Map使用
public class LocationUtil
{
    // 坐标转换 标准坐标系-> 中国坐标系
    //          WGS-84 --> GCJ-02
    // wgsLocation:     标准坐标
    public static func transformWGSToGCJ(wgsLocation:CLLocationCoordinate2D)->CLLocationCoordinate2D
    {
    var adjustLocation  = CLLocationCoordinate2D()
    var adjustLatitude  = transformLatitudeWith(x: wgsLocation.longitude - 105.0,
                                                y:wgsLocation.latitude - 35.0);
    var adjustLongitude = transformLongitudeWith(x: wgsLocation.longitude - 105.0,
                                                 y:wgsLocation.latitude - 35.0);
    let radLatitude     = wgsLocation.latitude / 180.0 * pi;
    var magic           = sin(radLatitude);
    magic               = 1 - e * magic * magic;
    let sqrtMagic       = sqrt(magic);
    adjustLatitude      = (adjustLatitude * 180.0) / ((a * (1 - e)) / (magic * sqrtMagic) * pi);
    adjustLongitude     = (adjustLongitude * 180.0) / (a / sqrtMagic * cos(radLatitude) * pi);

    adjustLocation.latitude     = wgsLocation.latitude + adjustLatitude;
    adjustLocation.longitude    = wgsLocation.longitude + adjustLongitude;
    return adjustLocation;
    }

    // 纬度转换
    //
    public static  func transformLatitudeWith(x: Double,
                                              y: Double ) -> Double
    {
    var lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y ;
    lat += 0.2 * sqrt(fabs(x));

    lat += (20.0 * sin(6.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi)) * 2.0 / 3.0;
    lat += (40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi)) * 2.0 / 3.0;
    lat += (320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
    }

    // 经度转换
    //
    public static func transformLongitudeWith(x: Double,
                                              y: Double )-> Double
    {
    var lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y ;
    lon +=  0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi)) * 2.0 / 3.0;
    lon += (40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi)) * 2.0 / 3.0;
    lon += (300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
    }

    // 坐标转换 中国坐标系 -> 百度坐标系
    //          GCJ-02 --> BD-09
    // location:     中国标准坐标
    public static func transformGCJToBaidu(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D
    {
    let z = sqrt(location.longitude * location.longitude + location.latitude * location.latitude)
    + 0.00002 * sqrt(location.latitude * pi);
    let t = atan2(location.latitude, location.longitude) + 0.000003 * cos(location.longitude * pi);
    var geoPoint        = CLLocationCoordinate2D();
    geoPoint.latitude   = (z * sin(t) + 0.006);
    geoPoint.longitude  = (z * cos(t) + 0.0065);
    return geoPoint;
    }

    // 坐标转换 百度坐标系 -> 中国坐标系
    //          BD-09 --> GCJ-02
    // location:     百度坐标

    //
    public static func transformBaiduToGCJ(location: CLLocationCoordinate2D)-> CLLocationCoordinate2D
    {
    let x       = location.longitude - 0.0065;
    let y       = location.latitude - 0.006;
    let z       = sqrt(x * x + y * y) - 0.00002 * sin(y * xpi);
    let t       = atan2(y, x) - 0.000003 * cos(x *  xpi);
    var geoPoint = CLLocationCoordinate2D();
    geoPoint.latitude  = z * sin(t);
    geoPoint.longitude = z * cos(t);
    return geoPoint;
    }

    // 坐标转换 中国坐标系-> 标准坐标系
    //          GCJ-02 --> WGS-84
    // wgsLocation:     中国坐标
    public static func transformGCJToWGS(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D
    {
    let threshold       = 0.00001;
    // The boundary
    var minLat          = location.latitude - 0.5;
    var maxLat          = location.latitude + 0.5;
    var minLng          = location.longitude - 0.5;
    var maxLng          = location.longitude + 0.5;

    var delta           = 1.0;
    let maxIteration    = 30;
    // Binary search
    while(true)
    {
    let leftBottom  = transformWGSToGCJ(wgsLocation: CLLocationCoordinate2D(latitude: minLat,
                                                                            longitude: minLng));
    let rightBottom = transformWGSToGCJ(wgsLocation: CLLocationCoordinate2D(latitude: minLat,
                                                                            longitude : maxLng));
    let leftUp      = transformWGSToGCJ(wgsLocation: CLLocationCoordinate2D(latitude: maxLat,
                                                                            longitude: minLng));
    let midPoint    = transformWGSToGCJ(wgsLocation: CLLocationCoordinate2D(latitude: ((minLat + maxLat) / 2),
                                                                            longitude: ((minLng + maxLng) / 2)));
    delta = fabs(midPoint.latitude - location.latitude) + fabs(midPoint.longitude - location.longitude);

    if(maxIteration <= 1 || delta <= threshold)
    {
    return CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2);

    }

    if(isContains(target: location, point1: leftBottom, point2: midPoint))
    {
    maxLat = (minLat + maxLat) / 2;
    maxLng = (minLng + maxLng) / 2;
    }
    else if(isContains(target: location, point1: rightBottom, point2: midPoint))
    {
    maxLat = (minLat + maxLat) / 2;
    minLng = (minLng + maxLng) / 2;
    }
    else if(isContains(target: location, point1: leftUp, point2: midPoint))
    {
    minLat = (minLat + maxLat) / 2;
    maxLng = (minLng + maxLng) / 2;
    }
    else
    {
    minLat = (minLat + maxLat) / 2;
    minLng = (minLng + maxLng) / 2;
    }
    }

    }

    //WGS-84 --> BD-09
    public static func transformFromWGSToBaidu(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D
    {
    let gcjLocation = transformWGSToGCJ(wgsLocation: location);
    let bdLocation = transformGCJToBaidu(location: gcjLocation)
    return bdLocation;
    }

    //BD-09 --> WGS-84
    public static func transformFromBaiduToWGS(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D
    {
    let gcjLocation = transformBaiduToGCJ(location: location);
    let wgsLocation = transformGCJToWGS(location: gcjLocation);
    return wgsLocation;
    }

    //判断点是否在p1和p2之间
    //point: 点
    //point1:    点1
    //point2:    点2
    public static func isContains(target:CLLocationCoordinate2D ,
                                  point1:CLLocationCoordinate2D,
                                  point2: CLLocationCoordinate2D ) -> Bool
    {
    let latitudeIn = target.latitude >= min(point1.latitude, point2.latitude) && target.latitude <= max(point1.latitude, point2.latitude);
    let longitudeIn = target.longitude >= min(point1.longitude,point2.longitude) && target.longitude <= max(point1.longitude, point2.longitude);

    return latitudeIn && longitudeIn;
    }


    //判断坐标是否在中国大陆
    public static func isLocationOutOfChina(location:CLLocationCoordinate2D) -> Bool
    {
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271){
        return true;
    }else{
        return false;
    }
    }

    // 获取两点之间的距离(米)
    public static func distanceBeteen(point1Latitude    : Double,
                                      point1Longitude   : Double,
                                      point2Latitude    : Double,
                                      point2Longitude   : Double )->Double{
        let dd          = pi / 180;
        let x1          = point1Latitude * dd;
        let x2          = point2Latitude * dd;
        let y1          = point1Longitude * dd;
        let y2          = point2Longitude * dd;

        let t = 2 - 2 * cos(x1) * cos(x2) * cos(y1 - y2) - 2 * sin(x1) * sin(x2);
        let distance = Double(2) * Double(r) * asin(sqrt(t) / 2);
        return   distance;

    }

    // 获取两点之间的距离 (米)
    public static func distanceBeteen(point1:CLLocationCoordinate2D,
                                      point2:CLLocationCoordinate2D ) -> Double{
        let distance = distanceBeteen(point1Latitude: point1.latitude,
                                      point1Longitude: point1.longitude,
                                      point2Latitude: point2.latitude,
                                      point2Longitude: point2.longitude);
        return distance;
    }

    /// Google Polyline 多段线路编解码 【压缩】
    struct Polyline{
        private static func encodeCoordinate(_ coordinate: Double) -> String {
            var coord = Int(round(coordinate * 1e5))
            coord <<= 1
            if coord < 0 {
                coord = ~coord
            }
            var encodedString = ""

            while coord >= 0x20 {
                let value = (0x20 | (coord & 0x1f)) + 63
                encodedString.append(Character(UnicodeScalar(value)!))
                coord >>= 5
            }
            coord += 63
            encodedString.append(Character(UnicodeScalar(coord)!))
            return encodedString
        }
        /// 编码
        public static func encodePolyline(_ coordinates:[(latitude: Double, longitude: Double)])->String{
            var encodedPolyline = ""
            var previousLatitude = 0.0
            var previousLongitude = 0.0

            for coordinate in coordinates {
                let latitudeChange = coordinate.latitude - previousLatitude
                let longitudeChange = coordinate.longitude - previousLongitude

                encodedPolyline += Polyline.encodeCoordinate(latitudeChange)
                encodedPolyline += Polyline.encodeCoordinate(longitudeChange)

                previousLatitude = coordinate.latitude
                previousLongitude = coordinate.longitude
            }
            return encodedPolyline
        }


        private static func decodeCoordinate(from encodedString: inout String) -> Double {
            var coordinate = 0
            var shift = 0
            var result = 0
            var continueDecoding = true

            while continueDecoding && !encodedString.isEmpty {
                let character = encodedString.removeFirst().unicodeScalars.first!.value - 63
                result = Int(character) & 0x1F
                coordinate |= (result << shift)
                shift += 5
                continueDecoding = (character >= 0x20)
            }

            if (coordinate & 1) != 0 {
                coordinate = ~(coordinate >> 1)
            } else {
                coordinate >>= 1
            }

            return Double(coordinate) * 1e-5
        }

        /// 解码一条多段线
        public static func decodePolyline(_ encodedString: String) -> [(latitude: Double, longitude: Double)] {
            var encodedString = encodedString
            var coordinates: [(latitude: Double, longitude: Double)] = []
            var latitude = 0.0
            var longitude = 0.0

            while !encodedString.isEmpty {
                let latitudeChange = decodeCoordinate(from: &encodedString)
                let longitudeChange = decodeCoordinate(from: &encodedString)

                latitude += latitudeChange
                longitude += longitudeChange

                coordinates.append((latitude: latitude, longitude: longitude))
            }

            return coordinates
        }
    }
}
