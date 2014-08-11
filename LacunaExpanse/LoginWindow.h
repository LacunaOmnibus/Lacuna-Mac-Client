//
//  LoginWindow.h
//  LacunaExpanse
//
//  Created by Michael on 5/4/13.
//
//

#import <Cocoa/Cocoa.h>
#import "LoadData.h"

extern NSString * const LEColorKey;
extern NSString * const LESaveAccount;
extern NSString * const LEUsername1;
extern NSString * const LEPassword1;
extern NSString * const LEUsername2;
extern NSString * const LEPassword2;
extern NSString * const LEServer;
extern NSString * const LEServer1Name;
extern NSString * const LEServer2Name;
extern NSString * const LEServer1Description;
extern NSString * const LEServer2Description;
extern NSString * const LEServer1URL;
extern NSString * const LEServer2URL;

@interface LoginWindow : NSWindowController {
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSButton    *checkbox;
    IBOutlet NSButton    *server1check;
    IBOutlet NSButton    *server2check;
    IBOutlet NSTextField *username1;
    IBOutlet NSTextField *password1;
    IBOutlet NSTextField *username2;
    IBOutlet NSTextField *password2;
    IBOutlet NSTextField *server1name;
    IBOutlet NSTextField *server2name;
   	IBOutlet NSTextField *server1description;
   	IBOutlet NSTextField *server2description;
}

- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)saveAccountInfo:(id)sender;
- (IBAction)server1:(id)sender;
- (IBAction)server2:(id)sender;
- (IBAction)saveUsername1:(id)sender;
- (IBAction)savePassword1:(id)sender;
- (IBAction)saveUsername2:(id)sender;
- (IBAction)savePassword2:(id)sender;
- (IBAction)saveServer1Name:(id)sender;
- (IBAction)saveServer2Name:(id)sender;
- (IBAction)saveServer1Description:(id)sender;
- (IBAction)saveServer2Description:(id)sender;

+ (NSColor *)preferenceLEColorKey;
+ (BOOL)preferenceLESaveAccount;
+ (NSInteger)preferenceServer;
+ (NSString *)preferenceUsername1;
+ (NSString *)preferencePassword1;
+ (NSString *)preferenceUsername2;
+ (NSString *)preferencePassword2;
+ (NSString *)preferenceServer1Name;
+ (NSString *)preferenceServer2Name;
+ (NSString *)preferenceServer1Description;
+ (NSString *)preferenceServer2Description;

+ (void)setPreferenceLEColorKey:(NSColor *)color;
+ (void)setPreferenceLESaveAccount:(BOOL)saveAccount;
+ (void)setPreferenceLEServer:(NSInteger *)server;
+ (void)setPreferenceUsername1:(NSString *)username;
+ (void)setPreferencePassword1:(NSString *)username;
+ (void)setPreferenceUsername2:(NSString *)password;
+ (void)setPreferencePassword2:(NSString *)password;
+ (void)setPreferenceServer1Name:(NSString *)name;
+ (void)setPreferenceServer2Name:(NSString *)name;
+ (void)setPreferenceServer1Description:(NSString *)description;
+ (void)setPreferenceServer2Description:(NSString *)description;
+ (void)setPreferenceServer1URL:(NSString *)serverURL;
@end
