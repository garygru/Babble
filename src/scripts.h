//
//  scripts.h
//  Babble
//
//  Created by gary on 19.07.11.
//  Copyright 2011 Gary Grutzek. All rights reserved.
//

NSString *theMail =  @"tell application \"Mail\"\n set theMessage to make new outgoing message with properties {visible:true}\n ";

NSString *theAttachment =  @"tell theMessage\n make new attachment with properties{file name:\"";

NSString *theEnd =  @"\"} at after last paragraph\n end tell\n end tell \n";

//tell theMessage \n set content:\"-- \nsend to you by VoiceMail.\"\n end tell\n, 