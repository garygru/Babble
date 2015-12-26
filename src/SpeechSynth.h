//
//  SpeechSynth.h
//  Babble
//
//  Created by Gary Grutzek on 29.07.11.
//  Copyright 2011 Gary Grutzek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeechSynth : NSObject
{
@private
    NSSpeechSynthesizer *speechSynth;
    NSMutableArray *voiceList;
    NSMutableArray *voiceNames;
    NSMutableArray *languages;
    NSMutableDictionary *langIDs;
}

- (NSArray*) availableVoices;
- (NSArray*) availableLanguages;
- (NSArray*) voicesByLanguage:(NSString *)language;
- (void) setVoice:(NSInteger)voiceIndex;

@property (assign) NSSpeechSynthesizer *speechSynth;


@end
