//
//  CTGPlugin.m
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/25.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import "CTGPlugin.h"
#import "CTGPluginWindowController.h"
#import "CTGFileManager.h"
#import <AppKit/AppKit.h>

static Class IDEWorkspaceWindowControllerClass;

@interface CTGPlugin ()
@property (strong,nonatomic) id ideWorkspaceWindow;
@property (strong,nonatomic) CTGPluginWindowController *showViewController;
@end

@implementation CTGPlugin

#pragma mark - 插件入口函数
+ (void)pluginDidLoad:(NSBundle *)plugin {
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

#pragma mark - 监听Xcode发出的通知
- (instancetype)init{
    if (self = [super init]) {
        IDEWorkspaceWindowControllerClass = NSClassFromString(@"IDEWorkspaceWindowController");
        [self addNotification];
    }
    return self;
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWindownUpdate:) name:NSWindowDidUpdateNotification object:nil];
}

#pragma mark - 初始化Item
- (void)applicationDidFinishLaunching:(NSNotification *)noti{
    NSMenuItem *appItem = [[NSApp menu] itemWithTitle:@"File"];

    [[appItem submenu] addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"CocoaPods-Github-List";
    item.target = self;
    item.action = @selector(jumpGithubListVc);
    [[appItem submenu] addItem:item];
}

#pragma mark - 创建控制器
- (void)jumpGithubListVc{
    if (![self activeDocument]) {
        return;
    }
    
    NSString *PodfilePath = [CTGFileManager ctg_file_findPodfileLocalPath:[[self activeDocument] path]];
    if (![PodfilePath length]){
        return ;
    }
    
    self.manager = [[CTGPluginManager alloc] initWithDocumentURL:[self activeDocument] withPodfilePath:PodfilePath];
    self.showViewController = [[CTGPluginWindowController alloc] initWithWindowNibName:NSStringFromClass([CTGPluginWindowController class])];
    [self.showViewController showWindow:self.showViewController];
}

#pragma mark - 获取到当前项目的URL
- (NSURL *)activeDocument
{
    NSArray *windows = [IDEWorkspaceWindowControllerClass valueForKey:@"workspaceWindowControllers"];
    for (id workspaceWindowController in windows)
    {
        if ([workspaceWindowController valueForKey:@"workspaceWindow"] == self.ideWorkspaceWindow || windows.count == 1)
        {
            id document = [[workspaceWindowController valueForKey:@"editorArea"] valueForKey:@"primaryEditorDocument"];
            return [document fileURL];
        }
    }
    
    return nil;
}

#pragma mark - 获取到当前项目的Window
- (void)applicationWindownUpdate:(NSNotification *)noti{
    id window = [noti object];
    if ([window isKindOfClass:[NSWindow class]] && [window isMainWindow])
    {
        self.ideWorkspaceWindow = window;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
