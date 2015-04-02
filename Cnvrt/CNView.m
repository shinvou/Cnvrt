//
//  CNView.m
//  Cnvrt
//
//  Created by Timm Kandziora on 31.03.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import "CNView.h"

@implementation CNView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (self.shouldHighlightMe) {
        [[NSColor selectedMenuItemColor] setFill];
        NSRectFill(dirtyRect);
    } else {
        [[NSColor clearColor] setFill];
        NSRectFill(dirtyRect);
    }
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.cnImageView = [[CNImageView alloc] initWithFrame:frame];
        [self.cnImageView setImage:[NSImage imageNamed:@"menubar.tiff"]];
        [self addSubview:self.cnImageView];
    }
    
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self.statusItem popUpStatusItemMenu:self.menu];
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    [self.statusItem popUpStatusItemMenu:self.menu];
}

- (void)makeMeVisible
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:30];
    [self.statusItem setView:self];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.shouldHighlightMe = YES;
        [self setNeedsDisplay:YES];
        [self.cnImageView setImage:[NSImage imageNamed:@"menubar_highlighted.tiff"]];
    } else {
        self.shouldHighlightMe = NO;
        [self setNeedsDisplay:YES];
        [self.cnImageView setImage:[NSImage imageNamed:@"menubar.tiff"]];
    }
}

@end
