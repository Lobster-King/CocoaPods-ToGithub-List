//
//  CTGPluginWindowCell.h
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/27.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CTGLibrary.h"

@protocol CTGPluginTableViewRowDelegate <NSObject>
- (void)pluginTableViewButtonDidSelectedLibray:(CTGLibrary *)library;
@end

@interface CTGPluginTableViewRow : NSTableRowView
@property (weak,nonatomic) id <CTGPluginTableViewRowDelegate>delegate;
@property (strong,nonatomic) CTGLibrary *library;
@end
