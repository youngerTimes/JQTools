//
//  FileManger.m
//  Education
//
//  Created by ky_mini on 2019/1/25.
//  Copyright © 2019年 成都金翼致远. All rights reserved.
//

#import "JQFileManger.h"
static JQFileManger *center =nil;

@implementation JQFileManger
+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = (JQFileManger *)@"YKCenter"; //这是严格的单例模式书写
        center = [[JQFileManger alloc]init];
    });
    //防止子类使用
    NSString *classString = NSStringFromClass([self class]);
    if ([classString isEqualToString:@"FileManger"] == NO) {
        NSParameterAssert(nil);
    }
    return center;
}

-(instancetype)init{
    NSString *string = (NSString *)center;
    if ([string isKindOfClass:[NSString class]] && [string isEqualToString:@"FileManger"]) {
        self = [super init];
        if (self) {
        }
        return self;
    }else{
        return nil;
    }
}


+(Boolean)fileExists:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:path];
}

+(NSString *)filePathAppendFileNameByType:(File_Type)type DirectoryName:(NSString *)diect FileName:(NSString *)fileName{
     NSString *directory = Cover_DownFile(type);
    return  [[directory stringByAppendingPathComponent:diect] stringByAppendingPathComponent:fileName];
}

+(NSString *)contentURLWithType:(File_Type)type DirectoryName:(NSString *)dirName{
    NSString *directory = Cover_DownFile(type);
    NSString *fullFir;
    if (dirName!=nil) {
        fullFir = [dirName stringByAppendingPathComponent:dirName];
    }else{
        fullFir = directory;
    }
    return directory;
}

+(BOOL)createDirectoryWithType:(File_Type)type DirectoryName:(NSString *)dirName{
    
    NSString *fullFir = [JQFileManger contentURLWithType:type DirectoryName:dirName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:fullFir]) {
        return true;
    }else{
        BOOL status  = [manager createDirectoryAtPath:fullFir withIntermediateDirectories:YES attributes:nil error:nil];
        return status;
    }
}

+(NSArray *)enumeratorListAtType:(File_Type)type DirectoryName:(NSString *)dirName{
    NSArray *items;
    
    //文件不存在会先去创建文件
    BOOL status = [JQFileManger createDirectoryWithType:type DirectoryName:dirName];
    
    if (status){
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *fullFir = [JQFileManger contentURLWithType:type DirectoryName:dirName];
        items = [manager subpathsAtPath:fullFir];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",dirName];
        items = [items filteredArrayUsingPredicate:predicate];
    }
    
    return items;
}

@end
