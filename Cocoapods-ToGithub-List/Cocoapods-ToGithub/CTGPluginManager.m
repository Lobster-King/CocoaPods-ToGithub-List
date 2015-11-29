//
//  CTGPluginManager.m
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/25.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import "CTGPluginManager.h"

@interface CTGPluginManager ()
@property (strong,nonatomic) NSURL *documentUrl;

@end

@implementation CTGPluginManager

- (instancetype)initWithDocumentURL:(NSURL *)documentURL withPodfilePath:(NSString *)podfilePath{
    if (self = [super init]) {
        _documentUrl = documentURL;
        _podfilePath = podfilePath;
    }
    return self;
}

@end
