//
//  LEDocument.m
//  LacunaExpanse
//
//  Created by Mizar on 8/11/14.
//  Copyright (c) 2014 Mizar. All rights reserved.
//

#import "LEDocument.h"

@implementation LEDocument

- (id)init
{
    self = [super init];
    if (self) {
        planetArray =[[NSMutableArray alloc] init];
        planetIdArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setPlanets:(NSMutableArray *)a
{
    if ( a == planetArray ) return;
}

- (IBAction)login:(id)sender
//OSX-player-aid
//Public Key:
//08a9f03e-25be-496e-b3cf-4fc68e09e83a
//Private Key:
//87167b88-6db4-4d54-864c-7f9b0b45a387
{
//    NSInteger server = [LoginWindow preferenceServer];
//    NSLog(@"Server: %ld", (long)server);
    username = [usernameFld stringValue];
    NSLog(@"Username: %@", username);
    password = [passwordFld stringValue];
    NSLog(@"Password: %@", password);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ( server == 1 ) {
//        serverURL = [defaults stringForKey:LEServer1URL];
//    }
//    else
//    {
//        serverURL = [defaults stringForKey:LEServer2URL];
//    };
    NSLog(@"Server URL: %@", serverURL);
    NSString *apikey = @"87167b88-6db4-4d54-864c-7f9b0b45a387";
    NSArray *login = [NSArray arrayWithObjects: username, password, apikey, nil];
    NSLog(@"Login: %@", login);
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"2.0", @"jsonrpc", @"1", @"id", @"login", @"method",
                                    login, @"params",nil];
    NSLog(@"jsonDictionary: %@", jsonDictionary);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *resultAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"login jsonData as string:\n%@", resultAsString);
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
    NSLog(@"received Login");
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    NSError* error = nil;
    NSDictionary* json = nil;
    if (note.object) {
        NSLog(@"object okay");
        json = [NSJSONSerialization
                JSONObjectWithData:note.object
                options:NSJSONReadingAllowFragments
                error:&error];
        NSLog(@"json %@",json);
        if (json) {
            NSLog(@"json okay");
            NSDictionary* errordict = [json objectForKey:@"error"];
            if (errordict) {
                empire_name    = [errordict objectForKey:@"data"];
                [empireField setStringValue:empire_name];
                status_message = [errordict objectForKey:@"message"];
                [statusField setStringValue:status_message];
            }
            NSDictionary* result = [json objectForKey:@"result"];
            if (result) {
                NSLog(@"result okay");
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
                        if ( [isolationist compare:0] ) {
                            [statusField setStringValue:@"Expansionist"];
                        } else {
                            [statusField setStringValue:@"Isolationist"];
                        }
                        
                        empire_name    = [empire objectForKey:@"name"];
                        [empireField setStringValue:empire_name];
                        
                        planets        = [[NSDictionary alloc] initWithDictionary:[empire objectForKey:@"planets"]];
                        planetArray    = [[NSMutableArray alloc] initWithArray:[planets allValues]];
                        planetIdArray    = [[NSMutableArray alloc] initWithArray:[planets keysSortedByValueUsingSelector: @selector(compare:)]];
                        long planetcount = [planetArray count];
                        NSLog(@"Number of Planets: %ld", planetcount);
                        //NSLog(@"Planets: %@", planetArray);
//                        [planetTable reloadData];
                        
                        rpc_count      = [empire objectForKey:@"rpc_count"];
                        [rpcs setStringValue:rpc_count];
                        
                        self_destruct  = [empire objectForKey:@"self_destruct_active"];
                        if ( [self_destruct compare:0] ) {
                            [destructField setStringValue:@""];
                        } else {
                            [destructField setStringValue:@"Self Destruct"];
                        }
                        
                        status_message = [empire objectForKey:@"status_message"];
                        [statusMessage setStringValue:status_message];
                        
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

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"LEDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.lacunaexpanse.com/servers.json"];
    [[LoadData alloc] get:url];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(receivedServerList:)
               name:LEdataReceivedNotification
             object:nil];
}

- (void)receivedServerList:(NSNotification *)note
{
    NSString *input = [[NSString alloc] initWithData:note.object encoding: NSASCIIStringEncoding];
    NSLog(@"String: %@", input);
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:input];
    //	[scanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];// already default
	
    NSString *tag = [NSString string];
    NSString *value = [NSString string];
	while (YES)
	{
        if ([scanner scanString:@"[" intoString:NULL])  { }
        else if ([scanner scanString:@"]" intoString:NULL])  { }
        else if ([scanner scanString:@"{" intoString:NULL])  { }
        else if ([scanner scanString:@"}" intoString:NULL])  { }
        else if ([scanner scanString:@"," intoString:NULL])  { }
        else if ([scanner scanString:@"\"" intoString:NULL])  // starting quote
        {
            [scanner scanUpToString:@"\"" intoString:&tag];  // identifier
            [scanner scanString:@"\"" intoString:NULL];  // remove ending quote
            if ([scanner scanString:@":" intoString:NULL])  // colon seperator
            {
                if ([scanner scanString:@"\"" intoString:NULL]) // starting quote
                {
                    if ([scanner scanUpToString:@"\"" intoString:&value])  // value
                    {
//                        if ([ tag isEqualToString: @"name" ]) [LoginWindow setPreferenceServer1Name:value];
//                        if ([ tag isEqualToString: @"description" ]) [LoginWindow setPreferenceServer1Description:value];
//                        if ([ tag isEqualToString: @"uri" ]) [LoginWindow setPreferenceServer1URL:value];
                        if ([ tag isEqualToString: @"uri" ]) serverURL = value;
                        [scanner scanString:@"\"" intoString:NULL];  // remove ending quote
                    }
                }
            }
        }
        else
            break;
    }
    
	scanner = nil;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

@end
