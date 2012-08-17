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
//static NSString* const kHost = @"http://omegaga.net:8000/";
static NSString* const kLogin = @"login/";
static NSString* const kRegister = @"register/";
static NSString* const kUserInfo = @"userInfo/";
static NSString* const kContacts = @"contacts/";
static NSString* const kFavoriteContacts = @"favoriteContacts/";
static NSString* const kRecents = @"recents/";
static NSString* const kMissed = @"missed/";
static NSString* const kVideoCallTo = @"videoCallTo/";
static NSString* const kAnswerVideoCall = @"answerVideoCall/";
static NSString* const kEndVideoCall = @"endVideoCall/";
static NSString* const kAddFavorite = @"setFavorite/";
static NSString* const kDeleteRecent = @"deleteRecent/";
static NSString* const kClearRecent = @"clearRecent/";
static NSString* const kUpdateMyInfo = @"updateMyInfo/";
static NSString* const kInterpreterVideoCall = @"interpreterVideoCallTo/";
static NSString* const kUploadAvatar = @"uploadAvatar/";
static NSString* const kAddContact = @"addContact/";

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
    NSLog(@"Begin request login with username: %@ password: %@ and push token: %@", username, password, [[NSUserDefaults standardUserDefaults] valueForKey:@"myToken"]);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingString:kLogin]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"myToken"] forKey:@"pushToken"];
    [request startAsynchronous];
}

- (void)requestUserInfoWithUsername:(NSString *)username delegate:(id)delegate
{
    NSLog(@"Begin request userInfo with username: %@", username);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingString:kUserInfo]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}

- (void)requestAddContactWithUsername:(NSString *)username targetUsername:(NSString *)targetUsername delegate:(id)delegate
{
    NSLog(@"Begin request add contact with username: %@ and target usernmae: %@", username, targetUsername);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kAddContact]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:targetUsername forKey:@"targetUsername"];
    [request startAsynchronous];
    
}



- (void)requestContactsWithUsername:(NSString *)username delegate:(id)delegate
{
    NSLog(@"Begin request contacts with username: %@", username);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kContacts]]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}


- (void)requestRecentsWithUsername:(NSString *)username delegate:(id)delegate
{
    NSLog(@"Begin request recents with username: %@", username);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kRecents]]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}


- (void)requestVideoCallWithUsername:(NSString *) username callToUsername:(NSString *) callToUsername delegate:(id)delegate
{
    NSLog(@"Begin request video call with username: %@ to another usernmae: %@", username, callToUsername);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kVideoCallTo]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:callToUsername forKey:@"callToUsername"];
    [request startAsynchronous];
}
- (void)answerVideoCallWithUsername:(NSString *) username answerMessage:(NSString *) message delegate:(id)delegate
{
    NSLog(@"Begin answer video with username: %@ and message: %@", username, message);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kAnswerVideoCall]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:message forKey:@"message"];
    [request startAsynchronous];

}
- (void)requestEndVideoCallWithUsername:(NSString *) username delegate:(id)delegate
{
    NSLog(@"begin request end video call with username: %@", username);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kEndVideoCall]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}


- (void)requestSetFavoriteWithUsername:(NSString *)username favoriteUsername:(NSString *)favoriteUsername toggle:(NSString *)toggle delegate:(id)delegate
{
    NSLog(@"Begin request set favorite with username: %@, favorite usernmae: %@ and toggle: %@", username, favoriteUsername, toggle);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kAddFavorite]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:favoriteUsername forKey:@"favoriteUsername"];
    [request setPostValue:toggle forKey:@"toggle"];
    [request startAsynchronous];
}

- (void)requestDeleteRecentWithUsername:(NSString *)username recentUid:(NSString *)recentUid delegate:(id)delegate
{
    NSLog(@"Begin request delete recent with username: %@ and recentUid: %@", username, recentUid);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kDeleteRecent]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:recentUid forKey:@"recentUid"];
    [request startAsynchronous];
}

- (void)requestClearRecentsWithUsername:(NSString *)username delegate:(id)delegate
{
    NSLog(@"Begin request clear recents with username: %@", username);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kClearRecent]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}

- (void)requestUpdateMyInfoWithUsername:(NSString *)username myInfo:(NSDictionary *)myInfo delegate:(id)delegate
{
    NSLog(@"Begin request update my info with username: %@ and my info: %@", username, myInfo);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kUpdateMyInfo]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:myInfo forKey:@"myInfo"];
    [request startAsynchronous];
}

- (void)requestRegisterWithUsername:(NSString *)username password:(NSString *)password delegate:(id)delegate
{
    NSLog(@"Begin request register with username: %@ and password: %@", username, password);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kRegister]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request startAsynchronous];

}

- (void)requestInterpreterVideoCallWithUsername:(NSString *)username myLanguage:(NSString *)myLanguage targetLanguage:(NSString *)targetLanguage delegate:(id)delegate
{
    NSLog(@"begin request interpreter video call with username: %@, my language: %@, target language: %@", username, myLanguage, targetLanguage);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kInterpreterVideoCall]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:myLanguage forKey:@"myLanguage"];
    [request setPostValue:targetLanguage forKey:@"targetLanguage"];
    [request startAsynchronous];
}

- (void)requestUploadAvatarWithUsername:(NSString *)username avatarImage:(UIImage *)avatarImage delegate:(id)delegate
{
    NSLog(@"begin request upload avatar with username: %@", username);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kUploadAvatar]]];
    [request setDelegate:delegate];
    NSData *imageDate = UIImagePNGRepresentation(avatarImage);
    [request setData:imageDate withFileName:@"avatar.png" andContentType:@"image/png" forKey:@"avatar"];
    [request startAsynchronous];
}


@end
