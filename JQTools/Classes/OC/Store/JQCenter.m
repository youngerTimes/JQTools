//
//  YKCenter.m
//  yidao
//
//  Created by 杨锴 on 2017/6/10.
//  Copyright © 2017年 yvkd. All rights reserved.
//

#import "JQCenter.h"
#import "FastCoder.h"
static JQCenter *center =nil;

@implementation JQCenter
+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = (JQCenter *)@"YKCenter"; //这是严格的单例模式书写
        center = [[JQCenter alloc]init];
    });
    //防止子类使用
    NSString *classString = NSStringFromClass([self class]);
    if ([classString isEqualToString:@"YKCenter"] == NO) {
        NSParameterAssert(nil);
    }
    return center;
}
-(instancetype)init{
    NSString *string = (NSString *)center;
    if ([string isKindOfClass:[NSString class]] && [string isEqualToString:@"YKCenter"]) {
        self = [super init];
        if (self) {
        }
        return self;
    }else{
        return nil;
    }
}
-(void)jq_storeValue:(id)value withKey:(NSString *)key{
    NSParameterAssert(value); //如果为空，将会报错。
    NSParameterAssert(key);
    NSData *data= [FastCoder dataWithRootObject:value];//FastCoder 的内容
    if (data) {
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
    }
}
-(id)jq_valueWithKey:(NSString *)key{
    NSParameterAssert(key);
    NSData *data = [[NSUserDefaults standardUserDefaults]valueForKey:key];
    return [FastCoder objectWithData:data];
}
@end
