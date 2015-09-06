//
//  SelectionRectangle.m
//  gifCast
//
//  Created by Paulius on 8/16/15.
//
// ----
// Used for defineing the selection rectangle and background, drawn on each SelectionView
// owns selectionsView(s) and draws on them.
// ----

#import "SelectionRectangle.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionView.h"

@implementation SelectionRectangle{
    
    NSColor* backgroundColor;
    NSMutableArray* selectionViews;
    
    //currently selected view
    SelectionView* currentView;
}


- (id)initSelectionRectangle{
    
    self = [super init];

    selectionViews = [[NSMutableArray alloc]init];
    
    //create a selectionView for each display
    for( NSScreen *screen in [NSScreen screens ]){
        
        NSLog(@"init: screen id:    %d", [[[screen deviceDescription] objectForKey:@"NSScreenNumber"] unsignedIntValue]);
        
        SelectionView *selView = [[SelectionView alloc]initSelectionView:screen parent:self];
        
        [selectionViews addObject:selView];
    }
    
    
    return self;
}

- (void)getRectAfterSelection:(void (^)(NSRect rect, CGDirectDisplayID display))finishBlock{
    self.completeRectSelection = finishBlock;
}




-(void)completeSelection:(SelectionView*)selView resultRect:(NSRect)resultRect currentDisplay:(NSScreen*)currentDisplay{
    
    CGDirectDisplayID screenID = [[[currentDisplay deviceDescription] objectForKey:@"NSScreenNumber"] unsignedIntValue];
    
    NSLog(@"Screen id: %d", screenID);
    
    self.completeRectSelection(resultRect, screenID);
    for(SelectionView* selView in selectionViews){
        
         [selView remove];
    }
}


@end

