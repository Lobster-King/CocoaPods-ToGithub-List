//
//  CTGFileManager.h
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/27.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTGFileManager : NSFileManager
+ (NSString *)ctg_file_findPodfileLocalPath:(NSString *)localPath;
+ (NSArray *)ctg_file_matchesCocoapodsLibriary:(NSString *)podfilePath;
+ (NSString *)ctg_file_taskFindCocoapodWithLibiraryName:(NSString *)libirayName;
@end
