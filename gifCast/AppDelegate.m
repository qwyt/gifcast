//
//  AppDelegate.m
//  gifCast
//
//  Created by Paulius on 8/9/15.
//
//

#import "AppDelegate.h"
#import "ScreenCaptureSession.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end



@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setTitle:@"My App"];
    [self.statusItem setHighlightMode:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//Application code:

//save menu

- (IBAction)saveFile:(id)sender {
    
    // create the save panel
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // set a new file name
    [panel setNameFieldStringValue:@"NewScreenCapture.mov"];
    
    // display the panel
    [panel beginWithCompletionHandler:^(NSInteger result) {
        
        if (result == NSFileHandlingPanelOKButton) {
            
            // create a file namaner and grab the save panel's returned URL
        //    NSFileManager *manager = [NSFileManager defaultManager];
            NSURL *saveURL = [panel URL];
            
            //assign it to file variable
            self.file = saveURL;
            
            ScreenCaptureSession* screenCaptureSession = [[ScreenCaptureSession alloc]init];

            [screenCaptureSession createScreenCaptureSession:(self.file)];
            [screenCaptureSession startRecording];
            
            [NSTimer scheduledTimerWithTimeInterval:2.0
                                             target:self
                                           selector:@selector(stopRecording:)
                                           userInfo:screenCaptureSession
                                            repeats:NO];

            
        }
    }];
}


-(void)stopRecording:(NSTimer*) timer{
    
    ScreenCaptureSession *session =  (ScreenCaptureSession*)[timer userInfo];
    [session stopRecording];
    
}

 // end doSaveAs

//screen capture

- (IBAction)captureScreen:(id)sender {
    
    [self saveFile:(sender)];

//    ScreenCaptureSession* screenCaptureSession = [[ScreenCaptureSession init]alloc];
    

}


@end
