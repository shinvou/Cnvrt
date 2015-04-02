//
//  CNImageView.m
//  Cnvrt
//
//  Created by Timm Kandziora on 31.03.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import "CNImageView.h"

@implementation CNImageView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
    }
    
    return self;
}

- (void)setImage:(NSImage *)image
{
    if ([image.name isEqualToString:@"menubar"] || [image.name isEqualToString:@"menubar_highlighted"]) {
        [super setImage:image];
    } else {
        // Don't allow the NSImageView to set the dropped image (there are probably better ways ...)
    }
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    
    if ([[pasteboard types] containsObject:NSFilenamesPboardType]) {
        NSArray *filePaths = [pasteboard propertyListForType:NSFilenamesPboardType];
        
        for (int i = 0; i < filePaths.count; i++) {
            NSString *currentFilePath = filePaths[i];
            
            if ([currentFilePath.pathExtension isEqualToString:@"RAF"]) {
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    [self convertImageFromPath:currentFilePath];
                });
            } else {
                NSLog(@"This is not a .RAF file.");
            }
        }
    }
    
    return YES;
}

- (void)convertImageFromPath:(NSString *)path
{
    NSString *pathWithoutExtension = [path stringByDeletingPathExtension];
    
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *fileHandle = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/sips";
    task.arguments = @[@"-s", @"format", @"jpeg", path, @"-o", [NSString stringWithFormat:@"%@.jpg", pathWithoutExtension]];
    task.standardOutput = pipe;
    [task launch];
    
    NSData *data = [fileHandle readDataToEndOfFile];
    [fileHandle closeFile];
    
    NSString *sipsOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog (@"sips said:\n%@", sipsOutput);
}

@end
