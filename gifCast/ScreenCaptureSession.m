//
//  ScreenCaptureSession.m
//  gifCast
//
//  Created by Paulius on 8/9/15.
//
//

#import "ScreenCaptureSession.h"
#import <AVFoundation/AVFoundation.h>



@implementation ScreenCaptureSession{

    CGDirectDisplayID           display;
    AVCaptureMovieFileOutput    *captureMovieFileOutput;
    NSMutableArray              *shadeWindows;
    NSURL *captureFile;
}

- (BOOL)createScreenCaptureSession :(NSURL*)file
{
    
    captureFile = file;
    
    /* Create a capture session. */
    self.captureSession = [[AVCaptureSession alloc] init];
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh])
    {
        /* Specifies capture settings suitable for high quality video and audio output. */
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    /* Add the main display as a capture input. */
    display = CGMainDisplayID();
    self.captureScreenInput = [[AVCaptureScreenInput alloc] initWithDisplayID:display];
    if ([self.captureSession canAddInput:self.captureScreenInput])
    {
        [self.captureSession addInput:self.captureScreenInput];
    }
    else
    {
        return NO;
    }
    
    /* Add a movie file output + delegate. */
    captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [captureMovieFileOutput setDelegate:self];
    if ([self.captureSession canAddOutput:captureMovieFileOutput])
    {
        [self.captureSession addOutput:captureMovieFileOutput];
    }
    else
    {
        return NO;
    }
    
    /* Register for notifications of errors during the capture session so we can display an alert. */
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureSessionRuntimeErrorDidOccur:) name:AVCaptureSessionRuntimeErrorNotification object:self.captureSession];
    
    return YES;
}

/* Called when the user presses the 'Start' button to start a recording. */
- (void)startRecording
{
    NSLog(@"Minimum Frame Duration: %f, Crop Rect: %@, Scale Factor: %f, Capture Mouse Clicks: %@, Capture Mouse Cursor: %@, Remove Duplicate Frames: %@",
          CMTimeGetSeconds([self.captureScreenInput minFrameDuration]),
          NSStringFromRect(NSRectFromCGRect([self.captureScreenInput cropRect])),
          [self.captureScreenInput scaleFactor],
          [self.captureScreenInput capturesMouseClicks] ? @"Yes" : @"No",
          [self.captureScreenInput capturesCursor] ? @"Yes" : @"No",
          [self.captureScreenInput removesDuplicateFrames] ? @"Yes" : @"No");
    

        /* Starts recording to a given URL. */
  //      [captureMovieFileOutput startRecordingToOutputFileURL:captureFile recordingDelegate:self];
}


/* Called when the user presses the 'Stop' button to stop a recording. */
- (void)stopRecording;
{
    NSLog((@"stopRecording"));
//    [captureMovieFileOutput stopRecording];
}

@end
