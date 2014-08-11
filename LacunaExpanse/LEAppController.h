//
//  LEAppController.h
//  LacunaExpanse
//
//  Created by Michael on 9/30/11.
//  Copyright 2011. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LoadData.h"
#import "LoginWindow.h"  // same as @class LoginWindow;

@interface LEAppController : NSObject {
    LoginWindow  *loginWindow;
	IBOutlet NSTextField *empireField;
	IBOutlet NSTextField *essentiaField;
    IBOutlet NSTextField *destructField;
	IBOutlet NSTextField *statusField;
	IBOutlet NSTextField *messagesField;
	IBOutlet NSTextField *rpcs;
	IBOutlet NSTextField *techLevelField;
	IBOutlet NSTableView *planetTable;
    NSString *username;
    NSString *password;
    NSString *serverURL;
    NSString *sessionid;
    NSString *essentia;
    NSString *messages;
    NSString *home_planet_id;
    NSString *player_id;
    NSString *isolationist;
    NSString *empire_name;
    NSDictionary *planets;
    NSArray *planetidarray;
    NSArray *planetarray;
    NSString *rpc_count;
    NSString *self_destruct;
    NSString *status_message;
    NSString *tech_level;
    NSString *time;
}
- (IBAction)showLoginWindow:(id)sender;
- (IBAction)server2:(id)sender;

@end
