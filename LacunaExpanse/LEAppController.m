//
//  LEAppController.m
//  LacunaExpanse
//
//  Created by Michael on 9/30/11.
//  Copyright 2011. All rights reserved.
//

#import "LEAppController.h"

@implementation LEAppController

+ (void)initialize
{
    // Create a dictionary
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    // Archive the color object
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor blueColor]];
    // Put defaults in the dictionary
    [defaultValues setObject:colorAsData forKey:LEColorKey];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:LESaveAccount];
    [defaultValues setObject:[NSNumber numberWithInt:1] forKey:LEServer];
    [defaultValues setObject:@"" forKey:LEUsername1];
    [defaultValues setObject:@"" forKey:LEPassword1];
    [defaultValues setObject:@"" forKey:LEUsername2];
    [defaultValues setObject:@"" forKey:LEPassword2];
    [defaultValues setObject:@"US1" forKey:LEServer1Name];
    [defaultValues setObject:@"PT"  forKey:LEServer2Name];
    [defaultValues setObject:@"Long term empire building" forKey:LEServer1Description];
    [defaultValues setObject:@"Server testing" forKey:LEServer2Description];
    [defaultValues setObject:@"https://us1.lacunaexpanse.com/" forKey:LEServer1URL];
    [defaultValues setObject:@"https://pt.lacunaexpanse.com/" forKey:LEServer2URL];
    // Register the dictionary of defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
}

-(void)awakeFromNib
{
}

- (IBAction)showLoginWindow:(id)sender
{
    if (!loginWindow) {
        loginWindow = [[ LoginWindow alloc] init];
    }
    [loginWindow showWindow:self];
}

- (IBAction)server2:(id)sender
//OSX-player-aid
//Public Key:
//08a9f03e-25be-496e-b3cf-4fc68e09e83a
//Private Key:
//87167b88-6db4-4d54-864c-7f9b0b45a387
{
    NSInteger server = [LoginWindow preferenceServer];
    if ( server == 1 ) {
        username = [LoginWindow preferenceUsername1];
        password = [LoginWindow preferencePassword1];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        serverURL = [defaults stringForKey:LEServer1URL];
    }
    else
    {
        username = [LoginWindow preferenceUsername2];
        password = [LoginWindow preferencePassword2];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        serverURL = [defaults stringForKey:LEServer2URL];
    };
    NSString *apikey = @"87167b88-6db4-4d54-864c-7f9b0b45a387";
    NSArray *login = [NSArray arrayWithObjects: username, password, apikey, nil];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"2.0", @"jsonrpc", @"1", @"id", @"login", @"method",
                                    login, @"params",nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *resultAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"login jsonData as string:\n%@", resultAsString);
    NSString *string = [serverURL stringByAppendingString:@"empire"];
    NSURL *url = [NSURL URLWithString: string];
    [[LoadData alloc] post:url data:jsonData];
//------------------------------
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(receivedLogin:)
               name:LEdataReceivedNotification
             object:nil];
}

- (void)receivedLogin:(NSNotification *)note
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    NSError* error = nil;
    NSDictionary* json = nil;
    if (note.object) {
         json = [NSJSONSerialization
                JSONObjectWithData:note.object
                options:NSJSONReadingAllowFragments
                error:&error];
        if (json) {
            NSDictionary* result = [json objectForKey:@"result"];
            if (result) {
                sessionid = [result objectForKey:@"session_id"];
                NSDictionary* status = [result objectForKey:@"status"];
                if ( status ) {
                    NSDictionary* empire = [status objectForKey:@"empire"];
                    if ( empire ) {
                        NSLog(@"Empire: %@", empire);
                        essentia       = [empire objectForKey:@"essentia"];
                        [essentiaField setStringValue:essentia];
                        messages       = [empire objectForKey:@"has_new_messages"];
                        [messagesField setStringValue:messages];
                        home_planet_id = [empire objectForKey:@"home_planet_id"];
                        player_id      = [empire objectForKey:@"id"];
                        isolationist   = [empire objectForKey:@"is_isolationist"];
                        if (isolationist) {
                            [statusField setStringValue:@"Isolationist"];
                        } else {
                            [statusField setStringValue:@"Expansionist"];
                        }
                        empire_name    = [empire objectForKey:@"name"];
                        [empireField setStringValue:empire_name];
                        [planets dealloc];
                        planets        = [[NSDictionary alloc] initWithDictionary:[empire objectForKey:@"planets"]];
                        [planetarray dealloc];
                        planetarray    = [[NSArray alloc] initWithArray:[planets allValues]];
                        planetidarray    = [[NSArray alloc] initWithArray:[planets keysSortedByValueUsingSelector: @selector(compare:)]];
                        int planetcount = [planetarray count];
                        NSLog(@"Number of Planets: %d", planetcount);
                        NSLog(@"Planets: %@", planetarray);
                        [planetTable reloadData];
                        rpc_count      = [empire objectForKey:@"rpc_count"];
                        [rpcs setStringValue:rpc_count];
                        self_destruct  = [empire objectForKey:@"self_destruct_active"];
                        if ( [self_destruct compare:@"0"] ) {
                            [destructField setStringValue:@"Self Destruct"];
                        }
                        status_message = [empire objectForKey:@"status_message"];
                        tech_level     = [empire objectForKey:@"tech_level"];
                        [techLevelField setStringValue:tech_level];
                    };
                    NSDictionary* server = [status objectForKey:@"server"];
                    if ( server ) {
                        time           = [server objectForKey:@"time"];
                    };
                };
            };
        };
    }
    if (error) {
        [[NSAlert alertWithError:error] runModal];
    }
/*
    empire =     {  essentia = 0;  "has_new_messages" = 2; "home_planet_id" = 1580;
        id = 1026;  "is_isolationist" = 1;  "latest_message_id" = 1719579;
        name = mizar;
        planets =         {
            1580 = "Kajam 2";
        };
        "rpc_count" = 4;  "self_destruct_active" = 0;
        "self_destruct_date" = "19 01 2013 22:27:55 +0000";
        "status_message" = "Making Lacuna a better Expanse.";
        "tech_level" = 0;
    };
    server =     {
        "rpc_limit" = 5000;
        "star_map_size" =         {
            x = ( "-500", 500 );
            y = ( "-500", 500 );
        };
        time = "23 04 2013 03:03:28 +0000";
        version = "3.0888";
    };
*/
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)planetTable
{
    int planetcount = [planetidarray count];
    NSLog(@"*Number of Planets: %d", planetcount);
	return (NSInteger)planetcount;
}

- (id)tableView:(NSTableView *)planetTable
    objectValueForTableColumn:(NSTableColumn *)planetColumn
           row:(NSInteger)planetRow
{
    int rownumber = (long)planetRow;
    NSString *planetid = [planetidarray objectAtIndex:rownumber];
    NSString *planetname = [planets objectForKey:planetid];
    
    return planetname;
}

@end


