//
//  ScreenAreaSelector.h
//  gifCast
//
//  Created by Paulius on 8/12/15.
//
//
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef void (^CompleteRecordingAreaSelection)(NSRect rect);



@interface ScreenAreaSelector: NSWindow  <NSWindowDelegate> 
{

}

@property (nonatomic) NSPoint startPoint;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

- (id)initSession:(NSURL*) file;

// Completion Handler for rect selection, is executed after you select rect:

@property (copy, nonatomic) CompleteRecordingAreaSelection completeRecordingAreaSelection;

- (void)getRecordingAreaRect:(void (^)(NSRect rect))finishBlock;


@end


