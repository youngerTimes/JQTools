//
//  NSObject+NetworkStream.h
//  JQTools
//
//  Created by 无故事王国 on 2021/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NetworkStream)
+ (void )initCheck;

/// 获取流量总量
+ (long long )getGprsWifiFlowIOBytes;

/// 获取流量总流量
+ (long long )getGprsWifiFlowOBytes;

/// 获取流量下行流量
+ (long long )getNetWorkIBytesPerSecond;

/// 获取流量上行流量
+ (long long )getNetWorkOBytesPerSecond;

+ (long long )getNetWorkBytesPerSecond;
+ (NSString *)convertStringWithbyte:(long)bytes;
@end

NS_ASSUME_NONNULL_END
