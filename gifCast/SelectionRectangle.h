//
//  SelectionRectangle.h
//  gifCast
//
//  Created by Paulius on 8/16/15.
//
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "SelectionView.h"

typedef void (^CompleteRectSelection)(NSRect rect, CGDirectDisplayID display);

@class SelectionView;

@interface SelectionRectangle : NSObject


// Completion Handler for rect selection, is executed after you select rect:

@property (copy, nonatomic) CompleteRectSelection completeRectSelection;

- (id)initSelectionRectangle;

- (void)getRectAfterSelection:(void (^)(NSRect rect, CGDirectDisplayID display))finishBlock;

-(void)completeSelection:(SelectionView*)selView resultRect:(NSRect)resultRect currentDisplay:(NSScreen*)currentDisplay;

@end
