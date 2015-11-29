//
//  CTGPluginManager.h
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/25.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#ifdef DEBUG
#   define MLLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define MLLog(fmt, ...)
#endif

#import <Foundation/Foundation.h>

@interface CTGPluginManager : NSObject
@property (strong,nonatomic) NSString *podfilePath;
- (instancetype)initWithDocumentURL:(NSURL *)documentURL withPodfilePath:(NSString *)podfilePath;
@end
