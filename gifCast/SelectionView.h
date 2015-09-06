//
//  SelectionView.h
//  gifCast
//
//  Created by Paulius on 9/2/15.
//
// ----
// Used for defined the selected view, one for each screen.
// ----

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "SelectionRectangle.h"

@class SelectionRectangle;

//one for each display
@interface SelectionView: NSView

@property (nonatomic, strong) NSWindow<NSWindowDelegate>  *window;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic) NSPoint startPoint;


-(id)initSelectionView:(NSScreen*)screen parent:(SelectionRectangle*)parent;
-(void)remove;

@end
