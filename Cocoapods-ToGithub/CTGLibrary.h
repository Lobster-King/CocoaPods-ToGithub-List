//
//  CTGLibrary.h
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/27.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTGLibrary : NSObject

- (instancetype)initLibraryWithLibraryName:(NSString *)libraryName;

@property (copy,nonatomic,readonly) NSString *libraryName;
@property (copy,nonatomic,readonly) NSString *libraryRemarks;
@property (copy,nonatomic,readonly) NSString *libraryHomePageUrl;
@property (copy,nonatomic,readonly) NSString *libraryVersions;
@end
