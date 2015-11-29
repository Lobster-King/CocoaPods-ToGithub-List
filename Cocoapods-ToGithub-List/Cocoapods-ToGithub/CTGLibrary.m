//
//  CTGLibrary.m
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/27.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import "CTGLibrary.h"
#import "CTGFileManager.h"

static NSString *CTGHomePagePrefix = @"- Homepage: ";
static NSString *CTGSourcePrefix = @"- Source: ";

@interface CTGLibrary ()
@property (copy,nonatomic) NSString *content;
@end

@implementation CTGLibrary

- (instancetype)initLibraryWithLibraryName:(NSString *)libraryName{
    if (self = [super init]) {
        _libraryName = libraryName;
        _content = [CTGFileManager ctg_file_taskFindCocoapodWithLibiraryName:libraryName];
        
        _libraryHomePageUrl = [self getHomePageUrl];
    }
    return self;
}

#pragma mark - 字符串操作截取HomePageUrl
- (NSString *)getHomePageUrl{
    NSRange startRange = [self.content rangeOfString:CTGHomePagePrefix];
    if (startRange.location == NSNotFound) return @"";
    NSRange endRange = [self.content rangeOfString:CTGSourcePrefix];
    if (endRange.location == NSNotFound) return @"";
    
    NSString *homePageUrl = [self.content substringWithRange:NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length)];
    return [homePageUrl stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<CTGLibrary _libraryName is %@, homePageUrl is %@>", _libraryName, _libraryHomePageUrl];
}

@end
