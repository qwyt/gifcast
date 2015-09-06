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
#import "AppDelegate.h"

// ----
// Used for communication between AppDelegate and SelectionRectangle
// owns SelectionRectangle
//
// TODO: merge class with SelectionRectangle
// ----

@import AppKit;

@interface ScreenAreaSelector (private)

- (void)switchDirection;

@end



@implementation ScreenAreaSelector{
 
    SelectionRectangle* selector;

}

- (id)initSession:(NSURL*) file fullScreen:(BOOL)fullScreen
{
    
    //selector is currently used for managing NSSwindows used for drawing selector, no need for fullscreen (ATM)
    if (!fullScreen) {
        selector = [[SelectionRectangle alloc] initSelectionRectangle];
    }
    return self;
}
//----


- (void)getRecordingAreaRect: (BOOL)fullScreen :(void (^)(NSRect rect, CGDirectDisplayID displayId))finishBlock{

    NSLog(@"startSelection:ScreenAreaSelector");
    
    self.completeRecordingAreaSelection = finishBlock;
    
    if(fullScreen){
        
        NSScreen* cScreen = [AppDelegate getCurrentMouseScreen];
        
        CGDirectDisplayID screenID = [[[cScreen deviceDescription] objectForKey:@"NSScreenNumber"] unsignedIntValue];
        
        NSLog(@"startSelection:fullScreen");
        self.completeRecordingAreaSelection( [cScreen frame], screenID );
                                            
        return;
    }
    
    __block NSRect selectedRect;
    __block CGDirectDisplayID selectedDisplay;
    
    NSLog(@"startSelection:getRectAfterSelection");
    [selector getRectAfterSelection:^(NSRect rect, CGDirectDisplayID display) {
        
        selectedDisplay = display;
        selectedRect = rect;
        
        self.completeRecordingAreaSelection(selectedRect, selectedDisplay);
       
        
    }];
    
    
    

}



//--Mouse Events---



@end