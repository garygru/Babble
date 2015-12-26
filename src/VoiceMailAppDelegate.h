//
//  VoiceMailAppDelegate.h
//  Babble
//
//  Created by gary on 17.07.11.
//  Copyright 2011 Gary Grutzek. All rights reserved.
//

NSString *const GGSelectedLanguage = @"SelectedLanguage";
NSString *const GGSelectedVoice = @"SelectedVoice";
NSString *const GGSpeechRate = @"SpeechRate";


#import <Cocoa/Cocoa.h>

@class SpeechSynth;

@interface VoiceMailAppDelegate : NSObject <NSApplicationDelegate, NSSpeechSynthesizerDelegate>
{
@private
    NSWindow *window;
    NSPopUpButton *bVoices;
    NSPopUpButton *bLanguages;
    NSButton *bSave;
    NSButton *bSay;
    NSTextField *text;
    NSProgressIndicator *progress;
    
    NSSlider *rateSlider;
    
    SpeechSynth *speech;
}

- (IBAction)save:(id)sender;
- (IBAction)say:(id)sender;
- (IBAction)mail:(id)sender;
- (IBAction)selectLanguage:(id)sender;
- (IBAction)selectVoice:(id)sender;
- (IBAction)setSpeechRate:(id)sender;

@property (assign) IBOutlet NSProgressIndicator *progress;
@property (assign) IBOutlet NSTextField *text;
@property (assign) IBOutlet NSButton *bSave;
@property (assign) IBOutlet NSButton *bSay;
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSPopUpButton *bVoices;
@property (assign) IBOutlet NSPopUpButton *bLanguages;
@property (assign) IBOutlet NSSlider *rateSlider;
@property (assign) SpeechSynth *speech;

@end
