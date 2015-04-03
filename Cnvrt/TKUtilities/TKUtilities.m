//
//  TKUtilities.m
//  Stuff that helps me out, wrapped in a singleton.
//
//  Created by Timm Kandziora on 03.04.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import "TKUtilities.h"

@implementation TKUtilities

+ (id)sharedInstance
{
    static TKUtilities *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (BOOL)startsAtLogin
{
    Boolean isInLoginItems;
    CFURLRef applicationURL = (__bridge CFTypeRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    LSSharedFileListRef loginItemsList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (loginItemsList) {
        CFArrayRef loginItems = LSSharedFileListCopySnapshot(loginItemsList, 0);
        
        CFIndex i, c = CFArrayGetCount(loginItems);
        
        for (i = 0; i < c; i++) {
            CFURLRef itemURL = NULL;
            LSSharedFileListItemRef item = (LSSharedFileListItemRef)CFArrayGetValueAtIndex(loginItems, i);
            
            OSStatus error = LSSharedFileListItemResolve(item, 0, &itemURL, NULL);
            
            if (error == noErr) {
                isInLoginItems = CFEqual(itemURL, applicationURL);
                CFRelease(itemURL);
                
                if (isInLoginItems) {
                    break;
                }
            }
        }
    }
    
    CFRelease(loginItemsList);
    
    return (BOOL)isInLoginItems;
}

- (void)setStartAtLoginEnabled:(BOOL)enabled
{
    LSSharedFileListItemRef itemFromList = NULL;
    CFURLRef applicationURL = (__bridge CFTypeRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    LSSharedFileListRef loginItemsList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (loginItemsList) {
        CFArrayRef loginItems = LSSharedFileListCopySnapshot(loginItemsList, 0);
        
        CFIndex i, c = CFArrayGetCount(loginItems);
        
        for (i = 0; i < c; i++) {
            CFURLRef itemURL = NULL;
            LSSharedFileListItemRef item = (LSSharedFileListItemRef)CFArrayGetValueAtIndex(loginItems, i);
            
            OSStatus error = LSSharedFileListItemResolve(item, 0, &itemURL, NULL);
            
            if (error == noErr) {
                Boolean isInLoginItems = CFEqual(itemURL, applicationURL);
                CFRelease(itemURL);
                
                if (isInLoginItems) {
                    itemFromList = item;
                    break;
                }
            }
        }
                
        if (enabled && !itemFromList) {
            LSSharedFileListInsertItemURL(loginItemsList, kLSSharedFileListItemLast, NULL, NULL, applicationURL, NULL, NULL);
        } else if (!enabled && itemFromList) {
            LSSharedFileListItemRemove(loginItemsList, itemFromList);
        }
    }
    
    CFRelease(loginItemsList);
}

@end
