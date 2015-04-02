//
//  CNView.h
//  Cnvrt
//
//  Created by Timm Kandziora on 31.03.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CNImageView.h"

@interface CNView : NSView

@property BOOL shouldHighlightMe;
@property (strong, nonatomic) CNImageView *cnImageView;

@property (strong, nonatomic) NSMenu *menu;
@property (strong, nonatomic) NSStatusItem *statusItem;

- (void)makeMeVisible;
- (void)setHighlighted:(BOOL)highlighted;

@end
