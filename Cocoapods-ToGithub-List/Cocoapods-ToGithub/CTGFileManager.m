//
//  CTGFileManager.m
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/27.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import "CTGFileManager.h"

@implementation CTGFileManager

static NSString *CTGFileName = @"Podfile";
static NSString *CTGPattern = @"^pod.*'(.*)'\\s*,.*$";
static CTGFileManager *mgr = nil;

#pragma mark - 递归遍历有没有Podfile文件
+ (NSString *)ctg_file_findPodfileLocalPath:(NSString *)path{
    if (!mgr) {
        mgr = [CTGFileManager defaultManager];
    }
    
    if ([path isEqualToString:@"/"]) return @"";
    
    BOOL fileExists = [mgr fileExistsAtPath:path];
    if (!fileExists) return nil;
    
    NSString *descPath = [path stringByDeletingLastPathComponent];
    NSString *filePath = [descPath stringByAppendingPathComponent:CTGFileName];
    if (![mgr fileExistsAtPath:filePath]) {
        return [self ctg_file_findPodfileLocalPath:descPath];
    }
    return filePath;
}

#pragma mark - 正则遍历librarys
+ (NSArray *)ctg_file_matchesCocoapodsLibriary:(NSString *)podfilePath{
    if (!podfilePath) return nil;
    
    NSString *podfileContent = [[NSString alloc] initWithContentsOfFile:podfilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *podfileLines = [podfileContent componentsSeparatedByString:@"\n"];
    NSMutableArray *libriarys = [NSMutableArray array];
    for (NSString *podfileLineStr in podfileLines) {
        if ([podfileLineStr length] == 0) {
            continue;
        }
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:CTGPattern options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSArray *matches = [regex matchesInString:podfileLineStr options:NSMatchingReportProgress range:NSMakeRange(0, podfileLineStr.length)];
        
        if (matches) {
            for (NSTextCheckingResult *match in matches) {
                // 提示: 第0个,是原来的字符串,所以要从第一个开始
                for (int i = 1; i < match.numberOfRanges; ++i) {
                    NSString *libName = [podfileLineStr substringWithRange:[match rangeAtIndex:i]];
                    [libriarys addObject:libName];
                }
            }
        }
    }
    return libriarys;
}

#pragma mark - 递归遍历Pod search podfilePath
+ (NSString *)ctg_file_taskFindCocoapodWithLibiraryName:(NSString *)libirayName{
    if (![libirayName length]) return nil;
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/xcrun";
    task.arguments = @[@"pod", @"search", libirayName];
    task.standardOutput = [NSPipe pipe];
    NSFileHandle *file = [task.standardOutput fileHandleForReading];
    
    [task launch];
    
    // For some reason [task waitUntilExit]; does not return sometimes. Therefore this rather hackish solution:
    int count = 0;
    while (task.isRunning && (count < 10))
    {
        [NSThread sleepForTimeInterval:0.1];
        count++;
    }
    
    NSString *output = [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSArray *libs = [output componentsSeparatedByString:@"->"];

    return libs.count > 1 ? libs[1] : @"";
}
@end
