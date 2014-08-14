//
//  LoadData.m
//  LacunaExpanse
//
//  Created by Michael on 11/10/11.
//

#import "LoadData.h"

NSString * const LEdataReceivedNotification = @"LEdataReceived";

@implementation LoadData

- (void) get:(NSURL*)url {
    NSLog(@"Get url = %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void) post:(NSURL*)url data:(NSData*)data {
	NSMutableURLRequest*	request;
    NSLog(@"Post url = %@", url);
    request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [request setHTTPMethod:@"POST"];
	[request setHTTPBody:data];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
//	[request release];
}

//- (void) dealloc {
//    if (responseData) [responseData release];
//    [super dealloc];
//}

// NSURLConnection delegate functions //

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[responseData setLength:0];
//    [connection release];
    NSLog(@"URL Connection Error");
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSLog(@"URL Connection Did Finish Loading");
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:LEdataReceivedNotification object:responseData];
}

@end
