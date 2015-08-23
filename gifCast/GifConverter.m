//
//  GifConverter.m
//  gifCast
//
//  Created by Paulius on 8/17/15.
//
//

#import "GifConverter.h"

@implementation GifConverter{
    
    NSURL* tempFile;
    NSTask *task;
}

-(void)convert : (NSURL*)file :(void (^)(NSURL* tempFile))finishBlock{
//   /Users/paulius/proj/gifCast/gifCast/ffmpeg/ffmpeg
    //make sure that we have ffmpeg
    
    self.completeConversionSession = finishBlock;
    
    task = [[NSTask alloc]init];
    
    NSString *execPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ffmpeg"];
    
    [task setLaunchPath:execPath];

    
    //d
    //construct
    NSString *origin = [NSString stringWithFormat:@"%@", [file absoluteString]];
    NSString *target = [[file absoluteString] stringByReplacingOccurrencesOfString:@".mov" withString:@".gif"];
    
 //  NSString *target = [NSString stringWithFormat:@"%@.%@", [file absoluteString], @"gif"];
    
 
 /*   [task setArguments:@[ @"-ss 45",
                            @"-t 2",
                            origin,
                            @"-vf scale=300:-1:sws_dither=ed",
                            target]];
  */
    
 //   -ss 45 -t 2 -i big_buck_bunny_1080p_h264.mov -vf scale=300:-1:sws_dither=ed -y bbb-error-diffusal.gif
    
    [task setArguments:@[
                  //       @"-ss",
                  //        @"45",
                  //        @"-t",
                  //        @"-2",
                          @"-i",
                          origin,
                //          @"-vf",
               //           @"scale=900:-1:sws_dither=ed",
                          @"-y",
                          target]];
    
  NSLog(@" ffmpeg running with args: %@", [task arguments]);
    
    [task launch];
    
 /*   while (YES) {
        if( task.isRunning){
            [NSThread sleepForTimeInterval:0.1f];
            NSLog(@"Still running");
        }
        else{
            break;
        }
    }
  */
    
    tempFile = [[NSURL alloc]initWithString:target];

    [self finishConversion];
}

- (void)finishConversion{
    
    while (task.isRunning) {
        [NSThread sleepForTimeInterval:0.1f];
        NSLog(@"Still running");

    }
    
    self.completeConversionSession(tempFile);
}


@end
