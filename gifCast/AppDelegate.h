//
//  AppDelegate.h
//  gifCast
//
//  Created by Paulius on 8/9/15.
//
//
#import <Cocoa/Cocoa.h>
@import Quartz;
@import WebKit;


@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusItem;

- (IBAction)prepareCaptureSessionSelect:(id)sender;
- (IBAction)prepareCaptureSessionFull:(id)sender;
- (IBAction)captureScreenStop:(id)sender;

- (IBAction)showAboutWindow:(id)sender;
- (IBAction)showSettingsWindow:(id)sender;

- (IBAction)closeApp:(id)sender;

@property (weak) IBOutlet NSMenuItem *captureMenuHolder;
@property (weak) IBOutlet NSMenuItem *stopCaptureMenuItem;

@property (weak) IBOutlet NSPanel *aboutWindow;

@property (weak) IBOutlet NSWindow *settingsWindow;

//aux
- (IBAction)linkDropboxAccount:(id)sender;
@property (weak) IBOutlet NSButton *linkDropboxAccountButton;

-(void) updateLinkStatus:(BOOL)status;


// viewer (save menu)
@property (weak) IBOutlet NSWindow *viewerWindow;
@property (weak) IBOutlet IKImageView *viewerImageView;
@property (weak) IBOutlet NSButton *saveToDropboxButton;
@property (weak) IBOutlet NSButton *saveLocallyButton;
//
- (IBAction)saveToDropboxAction:(id)sender;
- (IBAction)saveLocallyAction:(id)sender;
- (IBAction)viewerDiscardImage:(id)sender;
//
@property (weak) IBOutlet NSProgressIndicator *progressBar;
@property (weak) IBOutlet NSTextField *convertingLabel;

@end

