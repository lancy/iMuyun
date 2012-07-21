//
//  IMYHttpClient.m
//  iMuyun
//
//  Created by lancy on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYHttpClient.h"

@implementation IMYHttpClient
//@synthesize delegate = _delegate;

static NSString* const kHost = @"http://omegaga.net/bc";
static NSString* const kLogin = @"/login.php";

+ (IMYHttpClient *)shareClient
{
    static IMYHttpClient *client;          
    @synchronized(self) {
        if(!client) {
            client = [[IMYHttpClient alloc] init];
        }   
    }
    return client;
}

- (void)requestLoginWithUsername:(NSString *) username password:(NSString*) password delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingString:kLogin]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request startAsynchronous];
}

@end
