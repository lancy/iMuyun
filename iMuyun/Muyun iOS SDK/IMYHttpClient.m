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

static NSString* const kHost = @"http://omegaga.net:8000/";
static NSString* const kLogin = @"login/";
static NSString* const kContacts = @"contacts/";
static NSString* const kFavoriteContacts = @"favoriteContacts/";
static NSString* const kRecents = @"recents/";
static NSString* const kMissed = @"missed/";
static NSString* const kVideoCallTo = @"videoCallTo/";
static NSString* const kAnswerVideoCall = @"answerVideoCall/";
static NSString* const kEndVideoCall = @"endVideoCall/";
static NSString* const kAddFavorite = @"addFavorite/";
static NSString* const kDeleteRecent = @"deleteRecent/";
static NSString* const kClearRecent = @"clearRecent/";
static NSString* const kUpdateMyInfo = @"updateMyInfo/";

+ (IMYHttpClient *)shareClient
{
    static IMYHttpClient *client;          
    @synchronized(self) {
        if(!client) {
            client = [[IMYHttpClient alloc] init];
            [ASIHTTPRequest setDefaultTimeOutSeconds:20];
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
    [request setPostValue:callToUsername forKey:@"callToUsername"];
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

- (void)requestAddFavoriteWithUsername:(NSString *)username favoriteUsername:(NSString *)favoriteUsername delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kAddFavorite]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:favoriteUsername forKey:@"favoriteUsername"];
    [request startAsynchronous];
}

- (void)requestDeleteRecentWithUsername:(NSString *)username recentUID:(NSString *)recentUid delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kDeleteRecent]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:recentUid forKey:@"recentUid"];
    [request startAsynchronous];
}

- (void)requestClearRecentsWithUsername:(NSString *)username delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kClearRecent]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}

- (void)requestUpdateMyInfoWithUsername:(NSString *)username myInfo:(NSDictionary *)myInfo delegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kUpdateMyInfo]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:myInfo forKey:@"myInfo"];
    [request startAsynchronous];
}


@end
