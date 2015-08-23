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
@private
    AVCaptureSession *mSession;
    AVCaptureMovieFileOutput *mMovieFileOutput;
    NSTimer *mTimer;
    
    NSURL *destinationPath;
}


- (void)startRecording:(NSURL *)destPathOrig forRect:(NSRect)recordRect onFinish:(void (^)(NSURL* file))finishBlock
{
    self.completeVideoSession = finishBlock;
    
    NSLog((@"startRecording:ScreenCaptureSession"));
    
    //copy destPath, for whatever reason
    NSURL* destPath = [[NSURL alloc]initFileURLWithPath:[destPathOrig path]];
    
    destinationPath = destPath;
    
    
    
    // Create a capture session
    mSession = [[AVCaptureSession alloc] init];
    
    mSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    
    //select correct display TODO
    CGDirectDisplayID displayId = kCGDirectMainDisplay;
    
    AVCaptureScreenInput *input = [[AVCaptureScreenInput alloc] initWithDisplayID:displayId];
    
    [input setCropRect:recordRect];
    
    if (!input) {
        mSession = nil;
        return;
    }
    
    if ([mSession canAddInput:input])
        [mSession addInput:input];
    
    // Create a MovieFileOutput and add it to the session
    mMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([mSession canAddOutput:mMovieFileOutput])
        [mSession addOutput:mMovieFileOutput];
    
    [mSession startRunning];
    
    NSLog(@"Real mov record path: %@", destPath);
    
    // Delete any existing movie file first
    if ([[NSFileManager defaultManager] fileExistsAtPath:[destPath path]])
    {
        NSError *err;
        if (![[NSFileManager defaultManager] removeItemAtPath:[destPath path] error:&err])
        {
            NSLog(@"Error deleting existing movie %@",[err localizedDescription]);
        }
    }
    
    // Start recording to the destination movie file
    // The destination path is assumed to end with ".mov", for example, @"/users/master/desktop/capture.mov"
    // Set the recording delegate to self
    [mMovieFileOutput startRecordingToOutputFileURL:destPath recordingDelegate:self];

    
    
 //   mTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(stopRecording:) userInfo:nil repeats:NO];
}


/* Called when the user presses the 'Stop' button to stop a recording. */
- (void)stopRecording
{
    NSLog((@"stopRecording"));
    
    [mMovieFileOutput stopRecording];
    
    NSLog((@"completeVideoSession"));
    
    NSLog(@"destinationPath: %@", [destinationPath absoluteString]);
    
    
    
}

// AVCaptureFileOutputRecordingDelegate methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"Did finish recording to %@ due to error %@", [outputFileURL description], [error description]);
    
    // Stop running the session
    [mSession stopRunning];
    
    // Release the session
   // [mSession release];
    mSession = nil;
    
    self.completeVideoSession( outputFileURL );
}

@end
