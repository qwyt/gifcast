//
//  SelectionView.h
//  gifCast
//
//  Created by Paulius on 9/2/15.
//
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

//one for each display
@interface SelectionView: NSView

@property (nonatomic, strong) NSWindow<NSWindowDelegate>  *window;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic) NSPoint startPoint;


-(id)initSelection:(NSRect)viewRect;

@end
