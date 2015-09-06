//
//  SelectionView.m
//  gifCast
//
//  Created by Paulius on 9/2/15.
//
// ----
// Used for defined the selected view, one for each screen.
// only the container
// ----

#import "SelectionView.h"
#import "AppDelegate.h"

@implementation SelectionView{
    
    NSColor* backgroundColor;
    NSWindow* parentWindow;
    NSRect currentRect;
    SelectionRectangle* parent;

}

-(id)initSelectionView:(NSScreen*)screen parent:(SelectionRectangle*)parent{
    
    //----
    //Set up parent NSWindow:
    
    CGRect viewRect =  [screen frame];
    
    self -> parent = parent;
    
    parentWindow = [[NSWindow alloc] initWithContentRect:viewRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO screen:screen];
    
    //  [self setBackgroundColor:[NSColor blueColor]];
    [parentWindow makeKeyAndOrderFront:NSApp];
    [parentWindow setOpaque:NO]; // Needed so we can see through it when we have clear stuff on top
    //  [self setHasShadow:YES];
    //[self setLevel:NSFloatingWindowLevel]; // Let's make it sit on top of everything else
    [parentWindow setAlphaValue:0.2]; // It'll start out mostly transparent
        
    //create view
    self = [super initWithFrame:viewRect];
        
    [self setWantsLayer:YES];
        
    backgroundColor = [NSColor blueColor];
    
    NSLog(@" viewRect: %@", NSStringFromRect(viewRect));
        
        
    [parentWindow.contentView addSubview:self];
    
    [parentWindow makeFirstResponder:self];
    
    NSLog(@"init:SelectionView.h");


    
    //
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    //  [super drawRect:dirtyRect];
    
    // Get Quartz Crap ( TODO figure out how to do this on a higher level)
    
    NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext currentContext];
    CGContextRef context = (CGContextRef) [nsGraphicsContext graphicsPort];
    
    // Drawing code
    [backgroundColor setFill];
    CGContextFillRect(context, self.bounds);
    
    
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
    
    self.startPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    //   NSScreen *screen = [[theEvent window] screen];
    
    //   NSNumber* screenID = [ [screen deviceDescription] objectForKey:@"NSScreenNumber"];
    //   CGDirectDisplayID currentDisplay = [screenID unsignedIntValue];
    
    // create and configure shape layer
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.lineWidth = 1.0;
    self.shapeLayer.strokeColor = [[NSColor blackColor] CGColor];
    self.shapeLayer.fillColor = [[NSColor clearColor] CGColor];
    self.shapeLayer.lineDashPattern = @[@10, @5];
    [self.layer addSublayer:self.shapeLayer];
    
    // create animation for the layer
    
    CABasicAnimation *dashAnimation;
    dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:@0.0f];
    [dashAnimation setToValue:@15.0f];
    [dashAnimation setDuration:0.75f];
    [dashAnimation setRepeatCount:HUGE_VALF];
    [self.shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
    
    //set currentRect origin
    currentRect = NSMakeRect(theEvent.locationInWindow.x, theEvent.locationInWindow.x, 0, 0);
    
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    //    NSLog(@"mouseDragged:SelectionRectangle");
    
    
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    // create path for the shape layer
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.startPoint.x, self.startPoint.y);
    CGPathAddLineToPoint(path, NULL, self.startPoint.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x, self.startPoint.y);
    CGPathCloseSubpath(path);
    
    // set the shape layer's path
    
    self.shapeLayer.path = path;
    
    CGPathRelease(path);
    
    // save current rect for cutout thing
    //  currentRect = NSMakeRect(currentRect.origin.x, currentRect.origin.y, theEvent.locationInWindow.x,  theEvent.locationInWindow.y);
    
    currentRect =  CGPathGetBoundingBox([self.shapeLayer path]);
    
    [self setNeedsDisplay:YES];
    //   [self dr]
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"mouseUp:SelectionRectangle");
    
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    NSRect resultRect = currentRect;
    currentRect = NSMakeRect(0,0,0,0);
    
    [self setNeedsDisplay:YES];
    
    NSScreen* screen = [AppDelegate getCurrentMouseScreen];
    
    [parent completeSelection:self resultRect:resultRect currentDisplay:screen];
}

-(void)remove{
    
    [self removeFromSuperview];
}

@end
