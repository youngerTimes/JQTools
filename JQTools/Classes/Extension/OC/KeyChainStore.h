//
//  KeyChainStore.h
//  XiaoLingEnglish
//
//  Created by apple on 2019/8/2.
//  Copyright © 2019 stitch. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainStore : NSObject

+ (void)save:(NSString*)service data:(id)data;
+ (id)load:(NSString*)service;
+ (void)deleteKeyData:(NSString*)service;

@end

NS_ASSUME_NONNULL_END
