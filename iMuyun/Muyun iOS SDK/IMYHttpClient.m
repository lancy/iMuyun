//
//  IMYHttpClient.m
//  iMuyun
//
//  Created by lancy on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYHttpClient.h"
#import "ASIDownloadCache.h"

@implementation IMYHttpClient
//@synthesize delegate = _delegate;
 
// http://222.200.181.42/
// http://omegaga.net:8000/

static NSString* const kHost = @"http://222.200.181.42/";
static NSString* const kLogin = @"login/";
static NSString* const kContacts = @"contacts/";
static NSString* const kFavoriteContacts = @"favoriteContacts/";
static NSString* const kRecents = @"recents/";
static NSString* const kMissed = @"missed/";
static NSString* const kVideoCallTo = @"videoCallTo/";
static NSString* const kAnswerVideoCall = @"answerVideoCall/";
static NSString* const kEndVideoCall = @"endVideoCall/";

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
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"myToken"] forKey:@"pushToken"];
    [request startAsynchronous];
}

- (void)requestContactsWithUsername:(NSString *)username delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kContacts]]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}

- (void)requestFavoriteContactsWithUsername:(NSString *)username delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kFavoriteContacts]]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];    
}

- (void)requestRecentsWithUsername:(NSString *)username delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kRecents]]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}

- (void)requestMissedWithUsername:(NSString *)username delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kMissed]]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}



- (void)requestVideoCallWithUsername:(NSString *) username callToUsername:(NSString *) callToUsername delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kVideoCallTo]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:callToUsername forKey:@"callToUserName"];
    [request startAsynchronous];
}
- (void)answerVideoCallWithUsername:(NSString *) username answerMessage:(NSString *) message delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kAnswerVideoCall]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:message forKey:@"message"];
    [request startAsynchronous];
}
- (void)requestEndVideoCallWithUsername:(NSString *) username delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kEndVideoCall]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}



@end
