//
//  SelectionRectangle.h
//  gifCast
//
//  Created by Paulius on 8/16/15.
//
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

typedef void (^CompleteRectSelection)(NSRect rect);

@interface SelectionRectangle : NSView

@property (nonatomic) NSPoint startPoint;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

- (id)initSelector:(NSRect)viewRect;


// Completion Handler for rect selection, is executed after you select rect:

@property (copy, nonatomic) CompleteRectSelection completeRectSelection;

- (void)getRectAfterSelection:(void (^)(NSRect rect))finishBlock;

@end
