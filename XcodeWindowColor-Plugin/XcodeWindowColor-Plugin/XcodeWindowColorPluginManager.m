//
//  XcodeWindowColorPluginManager.m
//  XcodeWindowColor-Plugin
//
//  Created by 张磊 on 15/11/28.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import "XcodeWindowColorPluginManager.h"
#import <AppKit/AppKit.h>

@implementation XcodeWindowColorPluginManager

#pragma mark - 入口
+ (void)pluginDidLoad:(NSBundle *)bundle{
    [self shared];
}

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]){
        [self addNotification];
    }
    return self;
}

#pragma mark - 监听Xcode发出的通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickML) name:NSViewFrameDidChangeNotification object:nil];
}

// 给XcodeMenu添加Item
- (void)applicationDidFinishLaunching:(NSNotification *)noti{
    // 获取Xcode 第一排Menu
    NSMenu *appMenu = [NSApp menu];
    // 获取File
    NSMenuItem *fileMenuItem = [appMenu itemWithTitle:@"File"];
    
    NSMenuItem *separatorItem = [NSMenuItem separatorItem];
    [[fileMenuItem submenu] addItem:separatorItem];
    
    // 创建一个Item
    NSMenuItem *mlItem = [[NSMenuItem alloc] init];
    mlItem.action = @selector(clickML);
    mlItem.target = self;
    mlItem.title = @"ML";
    [[fileMenuItem submenu] addItem:mlItem];
}

- (void)checkXcodeNotification:(NSNotification *)noti{
    NSLog(@" ML : -- %@, %@", noti.name, noti.object);
}

- (void)clickML{
    [[[NSApp windows] firstObject] setBackgroundColor:[NSColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];
    
}

@end
