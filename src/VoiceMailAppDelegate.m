//
//  VoiceMailAppDelegate.m
//  Babble
//
//  Created by gary on 17.07.11.
//  Copyright 2011 Gary Grutzek. All rights reserved.
//


#import "VoiceMailAppDelegate.h"
#import "SpeechSynth.h"
#include "scripts.h"

@implementation VoiceMailAppDelegate

@synthesize text;
@synthesize bSave;
@synthesize bSay;
@synthesize window;
@synthesize bVoices;
@synthesize bLanguages;
@synthesize rateSlider;
@synthesize speech;
@synthesize progress;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Register default Values
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setObject:[NSNumber numberWithInt:0] forKey:GGSelectedLanguage];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:GGSelectedVoice];
    [defaultValues setObject:[NSNumber numberWithInt:180] forKey:GGSpeechRate];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];	
    
    speech = [[SpeechSynth alloc]init];
    [[speech speechSynth] setDelegate:self];
   
    [progress setDisplayedWhenStopped:NO];
    [progress stopAnimation:nil];
    
    [bLanguages removeAllItems];
    [bLanguages addItemsWithTitles:[speech availableLanguages]];
    [bVoices removeAllItems];
    [bVoices addItemsWithTitles:[speech voicesByLanguage:[bLanguages titleOfSelectedItem]]];    
    //   
    NSInteger idx = [[NSUserDefaults standardUserDefaults]integerForKey:GGSelectedLanguage];
    if (idx < [[bLanguages itemArray]count])
        [bLanguages selectItemAtIndex:idx];
    
    [self selectLanguage:nil];
    
    idx = [[NSUserDefaults standardUserDefaults]integerForKey:GGSelectedVoice];
    if (idx < [[bVoices itemArray]count])
        [bVoices selectItemAtIndex:idx];
    
    [self selectVoice:nil];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (IBAction)say:(id)sender 
{
    if (![[speech speechSynth]isSpeaking]){
        [progress startAnimation:nil];
        [[speech speechSynth]startSpeakingString:[text stringValue]];
    }
    else{
        [progress stopAnimation:nil];
        [[speech speechSynth]stopSpeaking];
    }

}

- (IBAction)save:(id)sender 
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"aiff"]];
    [savePanel setNameFieldStringValue:@"voice"];
    
    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) 
     {
         if (result == NSOKButton) {
             NSURL *fileUrl = [savePanel URL];
             [progress startAnimation:nil];
             [[speech speechSynth] startSpeakingString:[text stringValue] toURL:fileUrl];
         }
     }];
}


- (IBAction)mail:(id)sender 
{
    NSDictionary *err = [[NSDictionary alloc]init];

    NSAppleScript *activateScript = [[NSAppleScript alloc]initWithSource:@"tell application \"Mail\"\n activate \n end tell \n"];
    [activateScript executeAndReturnError:&err];
    [activateScript release];
    
    NSString *tmpFile = [NSString stringWithString:[NSTemporaryDirectory() stringByAppendingString:@"tmpVoiceMail.aiff"]];
    [progress startAnimation:nil];
    [[speech speechSynth] startSpeakingString:[text stringValue] toURL:[NSURL URLWithString:tmpFile]];
    
    
    NSString *tmp = [theMail stringByAppendingString:theAttachment];
    tmp = [tmp stringByAppendingString:tmpFile];
    tmp = [tmp stringByAppendingString:theEnd];
	
    NSAppleScript *script = [[NSAppleScript alloc]initWithSource:tmp];
    
    [script executeAndReturnError:&err];  
    [script release];
    [err release];
}


- (IBAction)selectLanguage:(id)sender 
{
    [[speech speechSynth]stopSpeaking];
    [bVoices removeAllItems];
    [bVoices addItemsWithTitles:[speech voicesByLanguage:[bLanguages titleOfSelectedItem]]];
    [speech setVoice:[bVoices indexOfSelectedItem]];
    [self setSpeechRate:nil];
    
    [[NSUserDefaults standardUserDefaults]setInteger:[bLanguages indexOfSelectedItem] forKey:GGSelectedLanguage];
}

- (IBAction)selectVoice:(id)sender 
{
    [speech setVoice:[bVoices indexOfSelectedItem]];
    
    [[NSUserDefaults standardUserDefaults]setInteger:[bVoices indexOfSelectedItem] forKey:GGSelectedVoice];
}

- (IBAction)setSpeechRate:(id)sender
{
    [[speech speechSynth]setRate:[rateSlider floatValue]];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)complete
{
    [progress stopAnimation:nil];
}




@end
