//
//  SelectionRectangle.m
//  gifCast
//
//  Created by Paulius on 8/16/15.
//
//

#import "SelectionRectangle.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionView.h"

@implementation SelectionRectangle{
    
    NSColor* backgroundColor;
    NSRect currentRect;
    CGDirectDisplayID currentDisplay;
    NSMutableArray* selectionViews;
    
    //currently selected view
    SelectionView* currentView;
}


- (id)initSelector{
    
    self = [super init];

    for( NSScreen *display in [NSScreen screens ]){
        
        SelectionView selView = Selection
        
    }
    
    //create a selectionView for each display
    
    return self;
}

- (void)getRectAfterSelection:(void (^)(NSRect rect, CGDirectDisplayID display))finishBlock{
    self.completeRectSelection = finishBlock;
}


- (void)drawRect:(NSRect)dirtyRect {
  //  [super drawRect:dirtyRect];
    
    // Get Quartz Crap ( TODO figure out how to do this on a higher level)
    
    NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext currentContext];
    CGContextRef context = (CGContextRef) [nsGraphicsContext graphicsPort];
    
    // Drawing code
    [backgroundColor setFill];
    CGContextFillRect(context, currentView.bounds);

    
   // clear the background in the given rectangle
    
  //  currentRect = NSMakeRect(500.0, 333.0, 222.0, 444.0);
    
  //  CGRect holeRectIntersection = CGRectIntersection( currentRect, self.bounds );
    [[NSColor clearColor] setFill];
    

    
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextFillRect(context, currentRect);
    
  //  NSLog(@" HHH : %@", NSStringFromRect( holeRectIntersection) );
    
}

#pragma mark Mouse Events

- (void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"mouseDown:SelectionRectangle");
    
    currentView.startPoint = [currentView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    NSScreen *screen = [[theEvent window] screen];
        
    NSNumber* screenID = [ [screen deviceDescription] objectForKey:@"NSScreenNumber"];
    CGDirectDisplayID currentDisplay = [screenID unsignedIntValue];
    
    // create and configure shape layer
    
    currentView.shapeLayer = [CAShapeLayer layer];
    currentView.shapeLayer.lineWidth = 1.0;
    currentView.shapeLayer.strokeColor = [[NSColor blackColor] CGColor];
    currentView.shapeLayer.fillColor = [[NSColor clearColor] CGColor];
    currentView.shapeLayer.lineDashPattern = @[@10, @5];
    [currentView.layer addSublayer:currentView.shapeLayer];
    
    // create animation for the layer
    
    CABasicAnimation *dashAnimation;
    dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:@0.0f];
    [dashAnimation setToValue:@15.0f];
    [dashAnimation setDuration:0.75f];
    [dashAnimation setRepeatCount:HUGE_VALF];
    [currentView.shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
    
    //set currentRect origin
    currentRect = NSMakeRect(theEvent.locationInWindow.x, theEvent.locationInWindow.x, 0, 0);
    
}

- (void)mouseDragged:(NSEvent *)theEvent
{
 //    NSLog(@"mouseDragged:SelectionRectangle");
    
    
    NSPoint point = [currentView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    // create path for the shape layer
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, currentView.startPoint.x, currentView.startPoint.y);
    CGPathAddLineToPoint(path, NULL, currentView.startPoint.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x, currentView.startPoint.y);
    CGPathCloseSubpath(path);
    
    // set the shape layer's path
    
    currentView.shapeLayer.path = path;
    
    CGPathRelease(path);
    
    // save current rect for cutout thing
  //  currentRect = NSMakeRect(currentRect.origin.x, currentRect.origin.y, theEvent.locationInWindow.x,  theEvent.locationInWindow.y);
    
    currentRect =  CGPathGetBoundingBox([currentView.shapeLayer path]);
    
    [currentView setNeedsDisplay:YES];
     //   [self dr]
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"mouseUp:SelectionRectangle");
    
    [currentView.shapeLayer removeFromSuperlayer];
    currentView.shapeLayer = nil;
    
    NSRect resultRect = currentRect;
    currentRect = NSMakeRect(0,0,0,0);
    
    [currentView setNeedsDisplay:YES];
    
    currentView.completeRectSelection(resultRect, currentDisplay);
}


@end

