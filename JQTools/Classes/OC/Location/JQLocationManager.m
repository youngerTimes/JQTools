//
//  ViewController.m
//  MapDemo
//
//  Created by sp on 16/5/2.
//  Copyright © 2016年 宋平. All rights reserved.
//

#import "JQLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface JQLocationManager ()<CLLocationManagerDelegate>
//位置管理器
@property(nonatomic,strong)CLLocationManager *locMgr;
//位置编码
@property(nonatomic, strong)CLGeocoder *coder;
// 经度
@property (strong, nonatomic) NSString *longitude;
// 纬度
@property (strong, nonatomic) NSString *latitude;
// 城市
@property (strong, nonatomic) NSString *Citys;
@property (copy, nonatomic) locateBlk blk;


@end

@implementation JQLocationManager


#pragma mark-懒加载
- (CLLocationManager *)locMgr{
        if (!_locMgr ) {
            
            //1.创建位置管理器（定位用户的位置）
            self.locMgr=[[CLLocationManager alloc]init];
            //2.设置代理
            self.locMgr.delegate=self;
        }
        return _locMgr;
     }

// 位置编码
- (CLGeocoder *)coder{

    // _coder == nil
    if (!_coder) {
        
        self.coder = [[CLGeocoder alloc] init];
    }

    return _coder;
}

+ (JQLocationManager *)shareInstance {
    static JQLocationManager *p = nil ;//1.声明一个空的静态的单例对象
        static dispatch_once_t onceToken; //2.声明一个静态的gcd的单次任务
        dispatch_once(&onceToken, ^{ //3.执行gcd单次任务：对对象进行初始化
            if (p == nil) {
                p = [[JQLocationManager alloc]init];
            }
        });
      return p;
    
    
}

+ (void)startLocation:(locateBlk)blk{
    [self shareInstance].blk = blk;
    [[self shareInstance] creatLocationManager];
    
    
};



- (void)creatLocationManager{


    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        
        // iOS 8 之后添加 始终允许访问位置信息，请求允许在前后台都能获取用户位置的授权, 并在Info.Plist文件中配置Key ( Nslocationwheninuseusagedescription )
        [self.locMgr requestAlwaysAuthorization];
        
        //开始定位用户的位置
        [self.locMgr startUpdatingLocation];
        
        
        //每隔多少米定位一次（这里的设置为任何的移动）
        self.locMgr.distanceFilter = kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        self.locMgr.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
        
        
        
    }else
    {//不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
    }
    

}



#pragma mark-CLLocationManagerDelegate
/**
 *  当定位到用户的位置时，就会调用（调用的频率比较频繁）
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置，取出第一个位置
    CLLocation *loc =[locations firstObject];
    NSLog(@"%@",loc.timestamp);
    
    //位置坐标
    CLLocationCoordinate2D coordinate=loc.coordinate;
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,速度：%f",coordinate.longitude,coordinate.latitude,loc.altitude,loc.course,loc.speed);
    
    
    NSLog(@"定位到了");
   
    
    // 反编码
   
    [self.coder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        // 包含区，街道等信息的地标对象
        CLPlacemark *placemark = [placemarks firstObject];
        // 城市名称
        NSString *city = placemark.locality;
        // 街道名称
        NSString *street = placemark.thoroughfare;
        // 全称
        NSString *name = placemark.name;
        NSString *str = [NSString stringWithFormat:@"%@， %@， %@", name,city,street];
        NSLog(@"城市信息%@", str);
        
        self.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
        self.Citys = name;
        self.blk(self.longitude, self.latitude, self.Citys);

    }];
    
    
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    [self.locMgr stopUpdatingLocation];

}


// 定位错误的代理方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
         NSLog(@"无法获取位置信息");
    }
}




@end
