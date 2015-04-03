//
//  TKUtilities.h
//  Stuff that helps me out, wrapped in a singleton.
//
//  Created by Timm Kandziora on 03.04.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKUtilities : NSObject

+ (id)sharedInstance;

- (BOOL)startsAtLogin;
- (void)setStartAtLoginEnabled:(BOOL)enabled;

@end
