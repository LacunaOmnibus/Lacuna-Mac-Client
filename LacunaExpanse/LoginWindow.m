//
//  LoginWindow.m
//  LacunaExpanse
//
//  Created by Michael on 5/4/13.
//
//

#import "LoginWindow.h"

NSString * const LEColorKey    = @"LEColorKey";
NSString * const LESaveAccount = @"LESaveAccount";
NSString * const LEUsername1   = @"LEUsername1";
NSString * const LEPassword1   = @"LEPassword1";
NSString * const LEUsername2   = @"LEUsername2";
NSString * const LEPassword2   = @"LEPassword2";
NSString * const LEServer      = @"LEServer";
NSString * const LEServer1Name = @"LEServer1Name";
NSString * const LEServer2Name = @"LEServer2Name";
NSString * const LEServer1Description = @"LEServer1Description";
NSString * const LEServer2Description = @"LEServer2Description";
NSString * const LEServer1URL  = @"LEServer1URL";
NSString * const LEServer2URL  = @"LEServer2URL";

@implementation LoginWindow

- (id)init
{
    self = [super initWithWindowNibName:@"LoginPreferences"];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [colorWell setColor:       [LoginWindow preferenceLEColorKey]];
    [checkbox  setState:       [LoginWindow preferenceLESaveAccount]];
    NSInteger server = [LoginWindow preferenceServer];
    if ( server == 1 ) {
        [server1check setState:1];
        [server2check setState:0];
    }
    else {
        [server1check setState:0];
        [server2check setState:1];
    };
    [username1 setStringValue: [LoginWindow preferenceUsername1]];
    [password1 setStringValue: [LoginWindow preferencePassword1]];
    [username2 setStringValue: [LoginWindow preferenceUsername2]];
    [password2 setStringValue: [LoginWindow preferencePassword2]];
    [server1name setStringValue: [LoginWindow preferenceServer1Name]];
    [server1description setStringValue: [LoginWindow preferenceServer1Description]];
    [server2name setStringValue: [LoginWindow preferenceServer2Name]];
    [server2description setStringValue: [LoginWindow preferenceServer2Description]];
    
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
    NSString *input = [[[NSString alloc] initWithData:note.object encoding: NSASCIIStringEncoding] autorelease];
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
                        if ([ tag isEqualToString: @"name" ]) [LoginWindow setPreferenceServer1Name:value];
                        if ([ tag isEqualToString: @"description" ]) [LoginWindow setPreferenceServer1Description:value];
                        if ([ tag isEqualToString: @"uri" ]) [LoginWindow setPreferenceServer1URL:value];
                        [scanner scanString:@"\"" intoString:NULL];  // remove ending quote
                    }
                }
            }
        }
        else
            break;
    }
    
    [scanner release];
	scanner = nil;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (IBAction)server1:(id)sender
{
    NSInteger server = 1;
    [LoginWindow setPreferenceLEServer:server];
    [server2check setState:0];
}

- (IBAction)server2:(id)sender
{
    NSInteger server = 2;
    [LoginWindow setPreferenceLEServer:server];
    [server1check setState:0];
}

- (IBAction)changeBackgroundColor:(id)sender
{
    NSColor *color = [colorWell color];
    [LoginWindow setPreferenceLEColorKey:color];
}

- (IBAction)saveAccountInfo:(id)sender
{
    NSInteger state = [checkbox state];
    [LoginWindow setPreferenceLESaveAccount:state];
}

- (IBAction)saveUsername1:(id)sender
{
    NSString *name = [username1 stringValue];
    [LoginWindow setPreferenceUsername1:name];
}

- (IBAction)savePassword1:(id)sender
{
    NSString *word = [password1 stringValue];
    [LoginWindow setPreferencePassword1:word];
}

- (IBAction)saveUsername2:(id)sender
{
    NSString *name = [username2 stringValue];
    [LoginWindow setPreferenceUsername2:name];
}

- (IBAction)savePassword2:(id)sender
{
    NSString *word = [password2 stringValue];
    [LoginWindow setPreferencePassword2:word];
}

- (IBAction)saveServer1Name:(id)sender
{
    NSString *name = [server1name stringValue];
    [LoginWindow setPreferenceServer1Name:name];
}

- (IBAction)saveServer2Name:(id)sender
{
    NSString *name = [server2name stringValue];
    [LoginWindow setPreferenceServer2Name:name];
}

- (IBAction)saveServer1Description:(id)sender
{
    NSString *description = [server1description stringValue];
    [LoginWindow setPreferenceServer1Description:description];
}

- (IBAction)saveServer2Description:(id)sender
{
    NSString *description = [server2description stringValue];
    [LoginWindow setPreferenceServer2Description:description];
}

+ (NSColor *)preferenceLEColorKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData = [defaults objectForKey:LEColorKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

+ (BOOL)preferenceLESaveAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:LESaveAccount];
}

+ (NSInteger)preferenceServer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:LEServer];
}

+ (NSString *)preferenceUsername1;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:LEUsername1];
}

+ (NSString *)preferencePassword1;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:LEPassword1];
}

+ (NSString *)preferenceUsername2;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:LEUsername2];
}

+ (NSString *)preferencePassword2;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:LEPassword2];
}

+ (NSString *)preferenceServer1Name;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:LEServer1Name];
}

+ (NSString *)preferenceServer2Name;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:LEServer2Name];
}

+ (NSString *)preferenceServer1Description;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:LEServer1Description];
}

+ (NSString *)preferenceServer2Description;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:LEServer2Description];
}

+ (void)setPreferenceLEColorKey:(NSColor *)color
{
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:LEColorKey];
}

+ (void)setPreferenceLESaveAccount:(BOOL)saveAccount
{
    [[NSUserDefaults standardUserDefaults] setBool:saveAccount forKey:LESaveAccount];
}

+ (void)setPreferenceLEServer:(NSInteger *)server
{
    [[NSUserDefaults standardUserDefaults] setInteger:server forKey:LEServer];
}

+ (void)setPreferenceUsername1:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:LEUsername1];
}

+ (void)setPreferencePassword1:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:LEPassword1];
}

+ (void)setPreferenceUsername2:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:LEUsername2];
}

+ (void)setPreferencePassword2:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:LEPassword2];
}

+ (void)setPreferenceServer1Name:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:LEServer1Name];
}

+ (void)setPreferenceServer2Name:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:LEServer2Name];
}

+ (void)setPreferenceServer1Description:(NSString *)description
{
    [[NSUserDefaults standardUserDefaults] setObject:description forKey:LEServer1Description];
}

+ (void)setPreferenceServer2Description:(NSString *)description
{
    [[NSUserDefaults standardUserDefaults] setObject:description forKey:LEServer2Description];
}

+ (void)setPreferenceServer1URL:(NSString *)serverURL
{
    [[NSUserDefaults standardUserDefaults] setObject:serverURL forKey:LEServer1URL];
}

@end
