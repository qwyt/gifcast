//
//  ScreenCaptureSession.h
//  gifCast
//
//  Created by Paulius on 8/9/15.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^CompleteVideoSession)(NSURL* file);

@interface ScreenCaptureSession : NSObject <AVCaptureFileOutputRecordingDelegate> 

@property (copy, nonatomic) CompleteVideoSession completeVideoSession;


- (void)startRecording:(NSURL *)destPathOrig forDisplay:(CGDirectDisplayID)displayId forRect:(NSRect)recordRect onFinish:(void (^)(NSURL* file))finishBlock;

- (void)stopRecording;



@end
