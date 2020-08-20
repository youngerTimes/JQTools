//
//  JQ_LocationManager.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/17.
//

import UIKit

#if canImport(AMapLocationKit) && canImport(AMapSearchKit)
import AMapLocationKit
import AMapSearchKit

public typealias KYLocationManagerLocationComplete = ((_ location: CLLocationCoordinate2D?, _ regeocode: AMapLocationReGeocode?, _ error: Error?)->Void)
public typealias KYLocationManagerSearchComplete = ((_ location: CLLocationCoordinate2D?, _ regecode: AMapLocationReGeocode?, _ error: Error?)->Void)

public enum KYLocationError: Error {
    case locationError
    case otherError
    
    var localizedDescription: String {
        let desc = self == .locationError ? "locationError" : "otherError"
        return "\(self): \(desc)"
    }
    
}

public class JQ_LocationTool:NSObject,AMapSearchDelegate{
    public static let shareManager = JQ_LocationManager()
    public var complete: KYLocationManagerLocationComplete?
    public var search: KYLocationManagerSearchComplete?
    
    var completeArr = Array<KYLocationManagerLocationComplete>()
    
    public  var dataTuple: (location:CLLocationCoordinate2D?, regeocode: AMapLocationReGeocode, error:Error?)?
    
    public  lazy var locationManager: AMapLocationManager = {
        let manager = AMapLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.locatingWithReGeocode = true
        return manager
    }()
    
    let maxReLocationCount = 3
    
    var currentLocationCount = 0
    
    public  lazy var searchManager: AMapSearchAPI = {
        let manager = AMapSearchAPI()
        manager?.delegate = self
        manager?.timeout = 10
        return manager!
    }()
    
    public func ky_singleLocation(complete: @escaping KYLocationManagerLocationComplete) {
        
        if !JQTool.JudgeLoationService() {
            return
        }
        self.completeArr.append(complete)
        if self.complete != nil {
            return
        }else {
            self.complete = complete
        }
        currentLocationCount = 0
        singleLocation()
    }
    
    public func singleLocation() {
        currentLocationCount += 1
        self.locationManager.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            if error != nil {
                for complet in self.completeArr {
                    complet(nil, nil, error!)
                }
                self.complete = nil
                self.completeArr.removeAll()
            }else {
                if regeocode != nil {
                    let requst = AMapGeocodeSearchRequest()
                    requst.address = regeocode!.city
                    requst.city = regeocode!.citycode
                    self.dataTuple = ((location?.coordinate, regeocode, error) as! (location: CLLocationCoordinate2D?, regeocode: AMapLocationReGeocode, error: Error?))
                    self.searchManager.aMapGeocodeSearch(requst)
                }else {
                    if self.currentLocationCount == 3 {
                        KYTool.ky_showText(textStr: "暂时无法定位到当前地址")
                        self.locationError()
                    }else {
                        self.singleLocation()
                    }
                }
            }
        }
    }
    
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.count > 0 {
            self.dataTuple!.regeocode.adcode = response.geocodes[0].adcode
            self.complete = nil
            for complet in self.completeArr {
                complet(self.dataTuple!.location, self.dataTuple!.regeocode, self.dataTuple?.error)
            }
            self.completeArr.removeAll()
        }
        self.searchManager.cancelAllRequests()
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        locationError()
    }
    
    func locationError() {
        for complet in self.completeArr {
            complet(nil, nil, KYLocationError.locationError)
        }
        self.complete = nil
        self.completeArr.removeAll()
    }
}
#endif
