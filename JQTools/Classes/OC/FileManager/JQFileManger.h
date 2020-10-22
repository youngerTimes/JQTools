//
//  FileManger.h
//  Education
//
//  Created by ky_mini on 2019/1/25.
//  Copyright © 2019年 成都金翼致远. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//下载类型
typedef enum : NSUInteger {
    File_Document = 1,
    File_Cache = 2,
    File_LibraryPath = 3,
} File_Type;

static inline NSString *Cover_DownFile(File_Type type){
    NSString *str = @"";
    switch (type) {
        case File_Cache:
            str = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            break;
            case File_Document:
            str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            break;
            case File_LibraryPath:
            str = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
            break;
    }
    return str;
}


/**
 文件夹管理类
 */
@interface JQFileManger : NSObject
+(instancetype)share;


/**
 文件是否存在

 @param path 路径
 @return 状态
 */
+(Boolean)fileExists:(NSString *)path;

/**
 文件夹是否存在或可用

 @param type 文件类型
 @param dirName 文件夹昵称
 @return 返回可用状态
 */
+(BOOL)createDirectoryWithType:(File_Type)type DirectoryName:(NSString *)dirName;


/**
 枚举当前文件夹下的内容

 @param type 文件类型
 @param dirName 文件夹昵称
 @return 内容
 */
+(NSArray *)enumeratorListAtType:(File_Type)type DirectoryName:(NSString *)dirName;

/**
 拼接文件

 @param type 文件类型
 @param diect 文件夹昵称
 @param fileName 内容
 @return 内容
 */
+(NSString *)filePathAppendFileNameByType:(File_Type)type DirectoryName:(NSString *)diect FileName:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
