//
//  YKCenter+StoreValue.m
//  yidao
//
//  Created by 杨锴 on 2017/6/10.
//  Copyright © 2017年 yvkd. All rights reserved.
//

#import "NSObject+StoreValue.h"

@implementation NSObject (StoreValue)
-(void)jq_storeValueWithKey:(NSString *)key{
    [[JQCenter share]jq_storeValue:self withKey:key];
}
+(id)jq_valueBykey:(NSString *)key{
    return  [[JQCenter share]jq_valueWithKey:key];
}
@end
