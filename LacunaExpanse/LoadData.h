//
//  LoadData.h
//  LacunaExpanse
//
//  Created by Michael on 11/10/11.
//  Copyright (c) 2011 Michael. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const LEdataReceivedNotification;

@interface LoadData : NSObject{
    NSMutableData* responseData;
    NSString* responsetext;
}
- (void)get:(NSURL*)url;
- (void)post:(NSURL*)url data:(NSData*)data;

@end
