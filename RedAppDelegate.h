//
//  RedAppDelegate.h
//  Red
//
//  Created by Tom Stamm on 2/18/11.
//  Copyright 2011 Tom Stamm. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RedAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction) colorChanged:(id)sender;
- (IBAction) sliderChanged:(id)sender;
- (IBAction) terminate:(id)sender;

@end
