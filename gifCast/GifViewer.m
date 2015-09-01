//
//  GifViewer.m
//  gifCast
//
//  Created by Paulius on 8/23/15.
//
//

#import "GifViewer.h"
#pragma clang diagnostic ignored "-Wshadow-ivar"


@implementation GifViewer{

    NSWindow *window;
    NSImage *image;
    IKImageView *imageView;
    NSURL *tempFile;
    
    NSProgressIndicator* progressIndicator;
    NSTextField* convertingText;
    
  //  DropboxManager* dropboxManager;
    
    
}

- (id) initWithSettings:(NSWindow*)window viewerImage:(IKImageView*)imageView   progressBar:(NSProgressIndicator*)progressBar convertingTextField:(NSTextField*)convertingTextField {
    
    self = [super init];
    
//    self -> dropboxManager = dropboxManager;
    
    self -> imageView = imageView;
    self -> window = window;
    self -> convertingText = convertingTextField;
    self -> progressIndicator = progressBar;
    
    [self -> window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    
    
    [self -> imageView setWantsLayer: YES];
    [self -> imageView.layer setBackgroundColor: [NSColor whiteColor].CGColor];
  
    //OLD imageView implementation
//    [self -> imageView setImageScaling:NSImageScaleProportionallyUpOrDown];
//    [self -> imageView setAnimates:YES];
    
    //hide till image is ready
    [self -> imageView setHidden:YES];
    
    //reset progress bar & label
    [self -> progressIndicator setHidden:NO];
    [self -> convertingText setHidden:NO];
    
    
    [self -> progressIndicator setUsesThreadedAnimation:YES];
    [self -> progressIndicator setIndeterminate:YES];
    [self -> progressIndicator startAnimation:progressBar];
    
    return self;
}

-(void)showImage:(NSURL*)imageURL{
    
    [self -> imageView setHidden:NO];
    
    

    //-----+----+-----+------
    
    // EDIT: this is where we create the overlay now, but only if it doesn't
    //       already exists.
    // checks if a layer is already set
    if ([imageView overlayForType:IKOverlayTypeImage] == nil)
        [imageView setOverlay:[CALayer layer] forType:IKOverlayTypeImage];
    
    // remove the overlay animation
    [[imageView overlayForType:IKOverlayTypeImage] removeAllAnimations];
    
    // check if it's a gif

        // loads the image
        NSImage * image = [[NSImage alloc] initWithContentsOfFile:[imageURL path]];
        
        // get the image representations, and iterate through them
        NSArray * reps = [image representations];
        for (NSImageRep * rep in reps)
        {
            // find the bitmap representation
            if ([rep isKindOfClass:[NSBitmapImageRep class]] == YES)
            {
                // get the bitmap representation
                NSBitmapImageRep * bitmapRep = (NSBitmapImageRep *)rep;
                
                // get the number of frames
                int numFrame = [[bitmapRep valueForProperty:NSImageFrameCount] intValue];
                
                // create a value array which will contains the frames of the animation
                NSMutableArray * values = [NSMutableArray array];
                
                // loop through the frames (animationDuration is the duration of the whole animation)
                float animationDuration = 0.0f;
                for (int i = 0; i < numFrame; ++i)
                {
                    // set the current frame
                    [bitmapRep setProperty:NSImageCurrentFrame withValue:[NSNumber numberWithInt:i]];
                    
                    // this part is optional. For some reasons, the NSImage class often loads a GIF with
                    // frame times of 0, so the GIF plays extremely fast. So, we check the frame duration, and if it's
                    // less than a threshold value, we set it to a default value of 1/20 second.
                    if ([[bitmapRep valueForProperty:NSImageCurrentFrameDuration] floatValue] < 0.000001f)
                        [bitmapRep setProperty:NSImageCurrentFrameDuration withValue:[NSNumber numberWithFloat:1.0f / 20.0f]];
                    
                    // add the CGImageRef to this frame to the value array
                    [values addObject:(id)[bitmapRep CGImage]];
                    
                    // update the duration of the animation
                    animationDuration += [[bitmapRep valueForProperty:NSImageCurrentFrameDuration] floatValue];
                }
                
                // create and setup the animation (this is pretty straightforward)
                CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
                [animation setValues:values];
                [animation setCalculationMode:@"discrete"];
                [animation setDuration:animationDuration];
                [animation setRepeatCount:HUGE_VAL];
                
                // add the animation to the layer
                [[imageView overlayForType:IKOverlayTypeImage] addAnimation:animation forKey:@"contents"];
                
                // stops at the first valid representation
                break;
            }
        }
        
        // release the image
    
    
    // calls the super setImageWithURL method to handle standard images
    [imageView setImageWithURL:imageURL];
    [imageView zoomImageToFit: image];

    
    //----+---+---+--------+-
    
    //
    [progressIndicator setHidden:YES];
    [convertingText setHidden:YES];
}

//compress NSImage size
-(NSImage *)imageCompressedByFactor:(NSImage*)image factor:(float)factor{
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation]];
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:factor] forKey:NSImageCompressionFactor];
    NSData *compressedData = [imageRep representationUsingType:NSJPEGFileType properties:options];
    return [[NSImage alloc] initWithData:compressedData];
}

//called after viewer is closed and file is saved/uploaded/discarded
- (void)getResponseAfterCompletion:(void (^)(BOOL saveLocally))finishBlock{
    self.completeViewerSession = finishBlock;
}

-(void)saveToDropbox{
   
//    [dropboxManager saveFile:tempFile];
    // [self hideViewer:NO];
}
-(void)saveLocally{
    
    // create the save panel
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // set a new file name
    [panel setNameFieldStringValue:@"NewScreenCapture.gif"];
    
    // display the panel
    [panel beginWithCompletionHandler:^(NSInteger result) {
        
        if (result == NSFileHandlingPanelOKButton) {
            
            NSURL *saveURL = [panel URL];
            
            if ( [[NSFileManager defaultManager] isReadableFileAtPath:[tempFile path]] ){
                [[NSFileManager defaultManager] moveItemAtURL:tempFile toURL:saveURL error:nil];
                NSLog(@"@gif saved at : %@ ", [saveURL absoluteString]);
                
                //make sure to delete temp file, moveItemAtURL sometimes doesen't do that.
                if ( [[NSFileManager defaultManager] fileExistsAtPath:[tempFile path]] ){
                    NSLog(@"deleting temp file");
                    [[NSFileManager defaultManager] removeItemAtPath:[tempFile path] error:nil];  
                }
                [self hideViewer:YES]; //turn of viewer after saving file
            }
            else{
                NSLog(@"WTF couldn't find temp path %@", [tempFile path]);
            }
            
            
        }
        else{
            
            NSLog(@"Couldn't save file");
        }
        
    }];
    
}

- (void)hideViewer:(BOOL)local{
    
    [window orderOut:self];
    self.completeViewerSession(local);
}

-(void)discard{
    

  
    //reset states:
    [imageView setImageWithURL:nil];
    image = nil;
    
    [self hideViewer:NO];
}


@end
