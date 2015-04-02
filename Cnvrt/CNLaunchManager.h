//
//  CNLaunchManager.h
//  Cnvrt
//
//  Created by Timm Kandziora on 30.03.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNLaunchManager : NSObject

+ (BOOL)willStartAtLogin:(NSURL *)itemURL;
+ (void)setStartAtLogin:(NSURL *)itemURL enabled:(BOOL)enabled;

@end
