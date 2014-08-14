//
//  LEDocument.h
//  LacunaExpanse
//
//  Created by Mizar on 8/11/14.
//  Copyright (c) 2014 Mizar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LoadData.h"

@interface LEDocument : NSDocument {
    IBOutlet NSTextField *usernameFld; //
    IBOutlet NSTextField *passwordFld; //
	IBOutlet NSTextField *empireField;
	IBOutlet NSTextField *essentiaField;
    IBOutlet NSTextField *destructField;
	IBOutlet NSTextField *statusField;
	IBOutlet NSTextField *messagesField;
	IBOutlet NSTextField *rpcs;
	IBOutlet NSTextField *techLevelField;
    IBOutlet NSTextField *statusMessage;
//	IBOutlet NSTableView *planetTable;
    NSMutableArray *planetArray;  // was planetarray
    NSMutableArray *planetIdArray;
    NSDictionary *planets;
    NSString *username;       //
    NSString *password;       //
    NSString *serverURL;      //
    NSString *sessionid;      //
    NSString *essentia;       //
    NSString *messages;       //
    NSString *home_planet_id; //
    NSString *player_id;      //
    NSString *isolationist;   //
    NSString *empire_name;    //
    NSString *rpc_count;      //
    NSString *self_destruct;  //
    NSString *status_message; //
    NSString *tech_level;     //
    NSString *time;           //
}
- (IBAction)login:(id)sender;
- (void)setPlanets:(NSMutableArray *)a;

@end
