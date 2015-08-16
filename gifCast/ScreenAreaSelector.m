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


- (void)getRecordingAreaRect:(void (^)(NSRect rect))finishBlock{

    NSLog(@"startSelection:ScreenAreaSelector");
    
    self.completeRecordingAreaSelection = finishBlock;
    
    __block NSRect selectedRect;
    
    [selector getRectAfterSelection:^(NSRect rect) {
                
        selectedRect = rect;
        
        self.completeRecordingAreaSelection(selectedRect);
        [selector removeFromSuperview];
        
    }];
    
    
    

}

-(void)stopSelection{
    
    
}

//--Mouse Events---



@end