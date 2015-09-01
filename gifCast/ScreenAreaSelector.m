//
//  ScreenAreaSelector.m
//  gifCast
//
//  Created by Paulius on 8/12/15.
//
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ScreenAreaSelector.h"
#import "SelectionRectangle.h"

@import AppKit;

@interface ScreenAreaSelector (private)

- (void)switchDirection;

@end



@implementation ScreenAreaSelector{
 
    SelectionRectangle* selector;

}

- (id)initSession:(NSURL*) file
{

    CGRect viewRect =  [[NSScreen mainScreen] frame];
    
    
    self = [super initWithContentRect:viewRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if ( self ) {
        //  [self setBackgroundColor:[NSColor blueColor]];
          [self makeKeyAndOrderFront:NSApp];
          [self setOpaque:NO]; // Needed so we can see through it when we have clear stuff on top
      //  [self setHasShadow:YES];
        //[self setLevel:NSFloatingWindowLevel]; // Let's make it sit on top of everything else
          [self setAlphaValue:0.2]; // It'll start out mostly transparent
        
        
        
        //create view
        
        
        selector = [[SelectionRectangle alloc]initSelector:viewRect];
        
        NSLog(@" viewRect: %@", NSStringFromRect(viewRect));
        
        
        [self.contentView addSubview:selector];
        // set any NSColor for filling, say white:
        [self makeFirstResponder:selector];
        
    }
    
    
    NSLog(@"init:ScreenAreaSelector");
    
    return self;
}
//----


- (void)getRecordingAreaRect: (BOOL)fullScreen :(void (^)(NSRect rect, CGDirectDisplayID displayId))finishBlock{

    NSLog(@"startSelection:ScreenAreaSelector");
    
    self.completeRecordingAreaSelection = finishBlock;
    
    if(fullScreen){
        
        self.completeRecordingAreaSelection( [[NSScreen mainScreen] frame], CGMainDisplayID() );
                                            
        return;
    }
    
    __block NSRect selectedRect;
    __block CGDirectDisplayID selectedDisplay;
    
    [selector getRectAfterSelection:^(NSRect rect, CGDirectDisplayID display) {
        
        selectedDisplay = display;
        selectedRect = rect;
        
        self.completeRecordingAreaSelection(selectedRect, selectedDisplay);
        [selector removeFromSuperview];
        
    }];
    
    
    

}



//--Mouse Events---



@end