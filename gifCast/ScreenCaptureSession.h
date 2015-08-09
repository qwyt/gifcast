//
//  ScreenCaptureSession.h
//  gifCast
//
//  Created by Paulius on 8/9/15.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ScreenCaptureSession : NSObject <AVCaptureFileOutputRecordingDelegate> 


@property (strong) AVCaptureSession *captureSession;
@property (strong) AVCaptureScreenInput *captureScreenInput;

- (void)startRecording;
- (void)stopRecording;


- (BOOL)createScreenCaptureSession:(NSURL *)file;

@end
