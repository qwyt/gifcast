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

@interface AppDelegate (){
    
    ScreenAreaSelector* screenAreaSelector;
    
    NSMenuItem *captureMenuItem;
    
    ScreenCaptureSession *captureSession;
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
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//Application code:

//save menu

- (IBAction)saveFile:(id)sender {
    
    
    [self captureScreenPrepare];
    
    // create the save panel
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // set a new file name
    [panel setNameFieldStringValue:@"NewScreenCapture.mov"];
    
    // display the panel
    [panel beginWithCompletionHandler:^(NSInteger result) {
        
        
        if (result == NSFileHandlingPanelOKButton) {
            
            NSURL *saveURL = [panel URL];
            
     
            [self captureScreen:saveURL];
    
        
            
        }
        else{
            
            [self captureScreenReset];
        }
    
    }];
}



 // end doSaveAs

//screen capture

//called to open save dialog
- (IBAction)captureScreenSaveDialog:(id)sender {
    
    if( captureMenuItem == nil)
        captureMenuItem = (NSMenuItem*) sender; //save button
    
    
    [self saveFile:(sender)];
        

}

//called to stop screan capture after session has been created
- (IBAction)captureScreenStop:(id)sender {

    capturing = NO;
    
    //if recording alreayd started stop it & procced
    if (captureSession != nil){
        
        NSLog(@"captureScreenStop:SESSION");
        
        [captureSession stopRecording];
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
- (void)captureScreen:(NSURL*)saveURL{
    
    capturing = YES;
    
    screenAreaSelector =  [[ScreenAreaSelector alloc]initSession:saveURL];
    
    [captureMenuItem setEnabled:YES];
    [captureMenuItem setAction:@selector(captureScreenStop:)];
    [captureMenuItem setTitle:@"Stop"];
    
    //wait untill recording rect is selected then start recording
    [screenAreaSelector getRecordingAreaRect:^(NSRect rect) {
        
        NSLog(@"WWWWWW -   WWWWW   _  WWWWWW %@", NSStringFromRect(rect));
        [screenAreaSelector close];
        
        captureSession = [[ScreenCaptureSession alloc]init];
        
        
        //create a recording session, procces file on completion
        [captureSession startRecording:saveURL forRect:rect onFinish:^(NSURL *file) {
            
            NSLog(@"@video recorded, saved at : %@ ", [file absoluteString]);
        }];
        
        //[captureSession startRecording:saveURL forRect:rect]
        
    }];
}

//called to reset menuItem to original state
- (void)captureScreenReset{
    
    capturing = NO;
    
    [captureMenuItem setEnabled:YES];
    [captureMenuItem setAction:@selector(captureScreenSaveDialog:)];
    [captureMenuItem setTitle:@"Capture"];
    
}



@end
