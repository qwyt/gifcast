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
    NSImageView *imageView;
    NSURL *tempFile;
    
    NSProgressIndicator* progressIndicator;
    NSTextField* convertingText;
    
  //  DropboxManager* dropboxManager;
    
    
}

- (id) initWithSettings:(NSWindow*)window viewerImage:(NSImageView*)imageView   progressBar:(NSProgressIndicator*)progressBar convertingTextField:(NSTextField*)convertingTextField {
    
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
    
    [self -> imageView setImageScaling:NSImageScaleProportionallyUpOrDown];
    [self -> imageView setAnimates:YES];
    
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

-(void)showImage:(NSImage*)image{
    
    [self -> imageView setHidden:NO];
    
    self -> tempFile = tempFile;

    
    [self -> imageView setImage:image];
    [self -> imageView setAnimates:YES];
    
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
    [imageView setImage:nil];
    image = nil;
    
    [self hideViewer:NO];
}


@end
