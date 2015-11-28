//
//  CTGPluginWindowController.m
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/27.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import "CTGPluginWindowController.h"
#import "CTGPluginManager.h"
#import "CTGFileManager.h"
#import "CTGPlugin.h"
#import "CTGLibrary.h"
#import "CTGPluginTableViewRow.h"

@interface CTGPluginWindowController () <
    NSTableViewDataSource,
    NSTableViewDelegate,
    CTGPluginTableViewRowDelegate
>
@property (strong,nonatomic) CTGPluginManager *mgr;
@property (strong,nonatomic) NSMutableArray *librarys;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *msgTextField;
@end

@implementation CTGPluginWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.mgr = [[CTGPlugin shared] manager];
    self.librarys = [NSMutableArray array];
    self.msgTextField.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *libriarys = [CTGFileManager ctg_file_matchesCocoapodsLibriary:self.mgr.podfilePath];
        for (NSString *libraryName in libriarys) {
            CTGLibrary *library = [[CTGLibrary alloc] initLibraryWithLibraryName:libraryName];
            [self.librarys addObject:library];
            MLLog(@"%@", library);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.msgTextField.hidden = YES;
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.librarys.count;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)rowIndex {
    CTGPluginTableViewRow *rowView = [[CTGPluginTableViewRow alloc] init];
    rowView.delegate = self;
    rowView.library = [self.librarys objectAtIndex:rowIndex];
    return rowView;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 50;
}

#pragma mark - <CTGPluginTableViewRowDelegate>
- (void)pluginTableViewButtonDidSelectedLibray:(CTGLibrary *)library{
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[library.libraryHomePageUrl]];
    MLLog(@"library.libraryHomePageUrl == %@",library.libraryHomePageUrl);
    [task waitUntilExit];
    if (![task isRunning]) {
        int status = [task terminationStatus];
        if (status != 0 ) {
            NSModalResponse res = [self showMessage:[NSString stringWithFormat:@"Cloud not open %@. It might be a bug. Please report it. Thanks.", library.libraryName]];
            if (res == NSAlertFirstButtonReturn) {
                [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"https://github.com/MakeZL"]];
            }
        }
    }
}

- (NSModalResponse)showMessage:(NSString *)message {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText: message];
    [alert setAlertStyle:NSWarningAlertStyle];
    return [alert runModal];
}

@end
