//
//  ViewController.h
//  MapDemo
//
//  Created by sp on 16/5/2.
//  Copyright © 2016年 宋平. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^locateBlk)(NSString *longitude, NSString *latitude, NSString *city);

@interface JQLocationManager : NSObject
//定位
+ (void)startLocation:(locateBlk)blk;
@end

