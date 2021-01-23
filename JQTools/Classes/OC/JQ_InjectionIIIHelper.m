//
//  InjectionIIIHelper.m
//  JQTools_Test
//
//  Created by 无故事王国 on 2020/8/26.
//  Copyright © 2020 杨锴. All rights reserved.
//

#import "JQ_InjectionIIIHelper.h"
#import <objc/runtime.h>

@implementation JQ_InjectionIIIHelper
#if DEBUG
/**
 InjectionIII 热部署会调用的一个方法，
 runtime给VC绑定上之后，每次部署完就重新viewDidLoad
 */
void injected (id self, SEL _cmd) {
    //重新加载view
    [self loadView];
    [self viewDidLoad];
    [self viewWillLayoutSubviews];
    [self viewWillAppear:NO];
}

+ (void)load{
#if DEBUG
    //注册项目启动监听
    __block id observer =
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        //更改bundlePath
        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSSwiftUISupport.bundle"] load];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    
    //给UIViewController 注册injected 方法
    class_addMethod([UIViewController class], NSSelectorFromString(@"injected"), (IMP)injected, "v@:");
#endif
}
#endif
@end
