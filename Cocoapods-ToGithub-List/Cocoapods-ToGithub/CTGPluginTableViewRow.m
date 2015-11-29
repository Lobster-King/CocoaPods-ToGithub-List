//
//  CTGPluginWindowCell.m
//  Cocoapods-ToGithub
//
//  Created by 张磊 on 15/11/27.
//  Copyright © 2015年 MakeZL. All rights reserved.
//

#import "CTGPluginTableViewRow.h"

@interface CTGPluginTableViewRow ()
@property (weak,nonatomic) NSButton *btn;
@end

@implementation CTGPluginTableViewRow

- (void)drawBackgroundInRect:(NSRect)dirtyRect{
    NSTableRowView *cellView = [self viewAtColumn:0];
    cellView.backgroundColor = [NSColor redColor];
    
    if (!self.btn) {
        NSButton *btn = [[NSButton alloc] init];
        btn.target = self;
        btn.action = @selector(jumpToGithub);
        [self addSubview:_btn = btn];
        btn.frame = cellView.frame;
    }
    [self.btn setTitle:self.library.libraryName];
    
    NSRectFill([cellView bounds]);
}

- (void)jumpToGithub{
    if ([self.delegate respondsToSelector:@selector(pluginTableViewButtonDidSelectedLibray:)]) {
        [self.delegate pluginTableViewButtonDidSelectedLibray:self.library];
    }
}

@end
