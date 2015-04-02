//
//  AppDelegate.m
//  Cnvrt
//
//  Created by Timm Kandziora on 30.03.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) CNView *cnView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Information" action:@selector(showInfo:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Launch at Login" action:@selector(openAtLoginToggled:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit Cnvrt" action:@selector(quitApp:) keyEquivalent:@""];
    [menu setDelegate:self];
    
    self.cnView = [[CNView alloc] initWithFrame:NSMakeRect(0, 0, 30, 24)];
    self.cnView.menu = menu;
    
    [self.cnView makeMeVisible];
}

- (void)menuWillOpen:(NSMenu *)menu
{
    [self.cnView setHighlighted:YES];
}

- (void)menuDidClose:(NSMenu *)menu
{
    [self.cnView setHighlighted:NO];
}

- (void)showInfo:(id)sender
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"Information"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Cnvrt is a mac app by Timm Kandziora with the purpose of converting .RAF to .jpg via drag and drop."];
    
    [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:NULL contextInfo:nil];
}

- (BOOL)startAtLogin
{
    return [CNLaunchManager willStartAtLogin:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)openAtLoginToggled:(id)sender
{
    [self setStartAtLogin:![self startAtLogin]];
}

- (void)setStartAtLogin:(BOOL)enabled
{
    [self willChangeValueForKey:@"startAtLogin"];
    [CNLaunchManager setStartAtLogin:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]] enabled:enabled];
    [self didChangeValueForKey:@"startAtLogin"];
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)item
{
    if ([item action] == @selector(openAtLoginToggled:)) {
        if ([(NSMenuItem *)item respondsToSelector:@selector(setState:)]) {
            [(NSMenuItem *)item setState:[self startAtLogin]];
        }
    }
    
    return YES;
}

- (void)quitApp:(id)sender
{
    [NSApp terminate:self];
}

@end
