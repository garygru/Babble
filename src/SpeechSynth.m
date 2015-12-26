//
//  SpeechSynth.m
//  Babble
//
//  Created by Gary Grutzek on 29.07.11.
//  Copyright 2011 Gary Grutzek. All rights reserved.
//

#import "SpeechSynth.h"

@implementation SpeechSynth

@synthesize speechSynth;

- (id)init
{
    self = [super init];
    if (self) {
        speechSynth = [[NSSpeechSynthesizer alloc]init];
        voiceList = [[NSMutableArray alloc]init];
        voiceNames = [[NSMutableArray alloc]init];
        languages = [[NSMutableArray alloc]init];
        langIDs = [[NSMutableDictionary alloc]init];
    }
    return self;
}


- (NSArray*) availableVoices
{
    return voiceList;
}

- (NSArray*) availableLanguages
{
    NSMutableArray *languageIDs = [[NSMutableArray alloc]init];        

    NSLocale *curLocale =  [NSLocale currentLocale];
    
    for (id voice in [NSSpeechSynthesizer availableVoices])
    {     
        NSDictionary *dict = [NSSpeechSynthesizer attributesForVoice:voice];
        [languageIDs addObject:(NSString *)[dict objectForKey:NSVoiceLocaleIdentifier]];
        [languages addObject:[curLocale displayNameForKey:NSLocaleIdentifier 
                                                    value:[dict objectForKey:NSVoiceLocaleIdentifier]]];
    }
    NSSet *uniqueIDs = [NSSet setWithArray:languageIDs];
    NSSet *uniqueElements = [NSSet setWithArray:languages];
    
    [languageIDs removeAllObjects];
    [languages removeAllObjects];
    [languageIDs release];
    
    for (id element in uniqueElements) {
        [languages addObject:element];
    }
    for (id element in uniqueIDs) {
        [langIDs setObject:element forKey:[curLocale displayNameForKey:NSLocaleIdentifier value:element]];
    }
	
    return languages;
}

- (NSArray*) voicesByLanguage:(NSString *)language
{
    [voiceNames removeAllObjects];
    [voiceList removeAllObjects];
    for (id voice in [NSSpeechSynthesizer availableVoices])
    {     
        NSDictionary *dict = [NSSpeechSynthesizer attributesForVoice:voice];
        if ([[dict objectForKey:NSVoiceLocaleIdentifier] isEqualToString:[langIDs objectForKey:language]])
        {
            [voiceList addObject:dict];   
            [voiceNames addObject:[dict objectForKey:NSVoiceName]];
        }
    }
    return voiceNames;
}

- (void) setVoice:(NSInteger)voiceIndex
{
    [speechSynth setVoice:[[voiceList objectAtIndex:voiceIndex] objectForKey:NSVoiceIdentifier]];
}

-(void)dealloc
{
    [langIDs release];
    [voiceList release];
    [voiceNames release];
    [languages release];
    [speechSynth release];
    
    [super dealloc];
}

@end
