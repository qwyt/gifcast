//
//  AppDelegate.m
//  gifCast
//
//  Created by Paulius on 8/9/15.
//
//

#import "AppDelegate.h"
#import "ScreenCaptureSession.h"
#import "ScreenAreaSelector.h"
#import "GifConverter.h"
#import "GifViewer.h"

@interface AppDelegate (){
    
    ScreenAreaSelector* screenAreaSelector;
    
    NSMenuItem *captureMenuItem;
    
  //  DropboxManager* dropboxManager;
    
    ScreenCaptureSession *captureSession;

    GifViewer *viewer;
}


@property (weak) IBOutlet NSWindow *window;
@end



@implementation AppDelegate{
    
    BOOL capturing;
    
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setTitle:@"My App"];
    [self.statusItem setHighlightMode:YES];
    
    
    [self.aboutWindow setHidesOnDeactivate:YES];
    [self.aboutWindow orderOut:self];
    
    [self.settingsWindow orderOut:self];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//Application code:


- (IBAction)showAboutWindow:(id)sender{
    
    [self.aboutWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)showSettingsWindow:(id)sender {
    
    [self.settingsWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    
}



- (IBAction)closeApp:(id)sender {
    
    [NSApp terminate:self];
}

//wrapper to call captureScreen
- (IBAction)prepareCaptureSessionSelect:(id)sender {

    [self prepareCaptureSessionGeneric:sender:NO];
}

- (IBAction)prepareCaptureSessionFull:(id)sender {
        
    [self prepareCaptureSessionGeneric:sender:YES];
}

-(void)prepareCaptureSessionGeneric:(id)sender :(BOOL)fullScreen{
    

    if( captureMenuItem == nil)
        captureMenuItem = (NSMenuItem*) sender; //save button

    
    [self captureScreenPrepare];
    
    //create temp file
    
//    NSString* tempDir = NSTemporaryDirectory();
//    NSURL* tempFile = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"file:/%@%@", tempDir, @"tempfile.mov"]];
//     NSURL* tempFile = [[NSURL alloc]initWithString:@"/Users/paulius/temp/tempfile.mov"];
    
    
    //just save in supporting files, because temp dir thing always gets fucked up.. after some time (wtf...)
    NSString *tempFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tempFile.mov"];
    
    [self captureScreen:[[NSURL alloc]initFileURLWithPath:tempFile] fullScreen:fullScreen];
    
}




 // end doSaveAs

//screen capture


//called to stop screan capture after session has been created
- (IBAction)captureScreenStop:(id)sender {

    capturing = NO;
    
    //if recording alreayd started stop it & open viewer
    if (captureSession != nil){
        
        NSLog(@"captureScreenStop:SESSION");
        
        [captureSession stopRecording];
        
        //gif viewer
        viewer = [[GifViewer alloc] initWithSettings:self.viewerWindow viewerImage:self.viewerImageView  progressBar:self.progressBar convertingTextField:self.convertingLabel];

        NSLog(@"Created viewer");
        
        [viewer getResponseAfterCompletion:^(BOOL saveLocally){
            
            NSLog(@"Exited viewer");
            
            
        }];
    }
    //otherwise just reset menu item
    else{
        NSLog(@"captureScreenStop:Reset");
        [self captureScreenReset];
    }
    
}


//called to disabled menuItem while save dialog is opened
- (void)captureScreenPrepare{
    
    [captureMenuItem setEnabled:NO];
}

//called to create a capture session after an url is know
- (void)captureScreen:(NSURL*)saveURL fullScreen:(BOOL)fullScreen{
    
    capturing = YES;
    
    screenAreaSelector =  [[ScreenAreaSelector alloc]initSession:saveURL];
    
    //enable stopRecordingMenu + set up actions
    [self.stopCaptureMenuItem setHidden:NO];
    [self.stopCaptureMenuItem setEnabled:YES];
    [self.stopCaptureMenuItem setAction:@selector(captureScreenStop:)];
    [self.stopCaptureMenuItem setTitle:@"Stop"];
    
    [self.captureMenuHolder setEnabled:NO];
    
    //wait untill recording rect is selected then start recording
    [screenAreaSelector getRecordingAreaRect:fullScreen :^(NSRect rect) {
        
        NSLog(@"WWWWWW -   WWWWW   _  WWWWWW %@", NSStringFromRect(rect));
        [screenAreaSelector close];
        
        captureSession = [[ScreenCaptureSession alloc]init];
        
        
        //create a recording session, procces file on completion
        [captureSession startRecording:saveURL forRect:rect onFinish:^(NSURL *file) {
            
            NSLog(@"@video recorded, saved at : %@ ", [file absoluteString]);
            
            //CONVERT TO GIF
            
            if ( [[NSFileManager defaultManager] isReadableFileAtPath:[file absoluteString]] ){
                NSLog(@"Missing temp mov file!!!");
            }
            else{
                
                 NSLog(@"temp mov file found at: %@", [file absoluteString]);
            }
            
            GifConverter *converter = [[GifConverter alloc]init];
            
            
            //Convert file async, wait till conversion is finished then call viewer.showImage
            dispatch_queue_t queue = dispatch_queue_create("com.gifCast.gifCast", NULL);
            dispatch_async(queue, ^{
                [converter convert:file :^(NSURL *gifPath) {
                    [viewer showImage:gifPath];
                }];
            });
            
//            NSURL *gifPath = [converter convert:file];
            
            //viewer is already opened, after proccesing is finished show corect image.
            
            
            
     
            
            
            
            //----
            
            [self captureScreenReset]; //reset menu to original state after recording is finished
        }];
    }];
}

//called to reset menuItem to original state
- (void)captureScreenReset{
    
    capturing = NO;
    
    [self.captureMenuHolder setEnabled:YES];
    
    [self.stopCaptureMenuItem setEnabled:NO];
    [self.stopCaptureMenuItem setHidden:YES];
    
}

//aux

- (IBAction)linkDropboxAccount:(id)sender {
    
/*    if (!dropboxManager){
        
        dropboxManager = [[DropboxManager alloc]initSession:self];
    }
    
    [dropboxManager linkDropboxAcc:sender];
  */
}



//update dropbox link status
-(void) updateLinkStatus:(BOOL)status{

 //   [self.linkDropboxAccountButton setTitle: [NSString stringWithFormat:@"Dropbox Connected: %@", status ? @"YES" : @"NO"]];
}
- (IBAction)saveToDropboxAction:(id)sender {
    [viewer saveToDropbox];
}

- (IBAction)saveLocallyAction:(id)sender {
    [viewer saveLocally];
}

- (IBAction)viewerDiscardImage:(id)sender{
    [viewer discard];
}
@end
