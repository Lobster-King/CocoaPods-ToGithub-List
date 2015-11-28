//
//  CTGPlugin.h
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/25.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTGPluginManager.h"

@interface CTGPlugin : NSObject
+ (instancetype)shared;
@property (strong,nonatomic) CTGPluginManager *manager;
@end
