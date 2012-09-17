
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
 
//static NSString* const kHost = @"http://222.200.181.42/";
//static NSString* const kHost = @"http://omegaga.net:8000/";
//static NSString* const kHost = @"http://omegaga.net/muyunvideo/";
static NSString* const kHost = @"http://imuyun.com/muyunvideo/";
static NSString* const kLogin = @"login/";
static NSString* const kRegister = @"register/";
static NSString* const kUserInfo = @"userInfo/";
static NSString* const kContacts = @"contacts/";
static NSString* const kUpdateNote = @"updateNote/";
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
static NSString* const kSendFeedBack = @"sendFeedBack/";
static NSString* const kUserBalance = @"userBalance/";
static NSString* const kAddBalance = @"addBalance/";


+ (IMYHttpClient *)shareClient
{
    static IMYHttpClient *client;          
    @synchronized(self) {
        if(!client) {
            client = [[IMYHttpClient alloc] init];
            [ASIHTTPRequest setDefaultTimeOutSeconds:5];
        }   
    }
    return client;
}

- (void)requestLoginWithUsername:(NSString *) username password:(NSString*) password delegate:(id)delegate
{
    NSLog(@"Begin request login with username: %@ and push token: %@", username, [[NSUserDefaults standardUserDefaults] valueForKey:@"myToken"]);
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

- (void)requestUpdateNoteWithUsername:(NSString *)username targetUsername:(NSString *)targetUsername note:(NSString *)note delegate:(id)delegate;
{
    NSLog(@"Begin request update note with username: %@, target usernmae: %@ and note: %@", username, targetUsername, note);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kUpdateNote]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:targetUsername forKey:@"targetUsername"];
    [request setPostValue:note forKey:@"note"];
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
    NSError *error = nil;
    NSData *jsonInfo = [NSJSONSerialization dataWithJSONObject:myInfo  options:kNilOptions error:&error];
    NSString *str = [[NSString alloc] initWithData:jsonInfo
                                             encoding:NSUTF8StringEncoding];
    [request setPostValue:str forKey:@"myInfo"];
    [request startAsynchronous];
}

- (void)requestRegisterWithUsername:(NSString *)username password:(NSString *)password language:(NSString *)language delegate:(id)delegate
{
    NSLog(@"Begin request register with username: %@, password: %@ and language: %@", username, password, language);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kRegister]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:language forKey:@"language"];
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
    [request setPostValue:username forKey:@"username"];
    NSData *imageDate = UIImagePNGRepresentation(avatarImage);
    [request setData:imageDate withFileName:@"avatar.png" andContentType:@"image/png" forKey:@"avatar"];
    [request startAsynchronous];
}

- (void)requestSendFeedBackWithUsername:(NSString *)username message:(NSString *)message deleagte:(id)delegate
{
    NSLog(@"begin send feedback with username: %@, message: %@", username, message);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kSendFeedBack]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:message forKey:@"message"];
    [request startAsynchronous];
    
}

- (void)requestUserBalanceWithUsername:(NSString *)username delegate:(id)delegate
{
    NSLog(@"begin request user balance with username: %@", username);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kUserBalance]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request startAsynchronous];
}

- (void)requestaddBalanceWithUsername:(NSString *)username addBalance:(NSString *)addBalance delegate:(id)delegate
{
    NSLog(@"begin request add balance with username: %@, balance: %@", username, addBalance);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[kHost stringByAppendingFormat:kAddBalance]]];
    [request setDelegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:addBalance forKey:@"addBalance"];
    [request startAsynchronous];
}

- (NSData*)toJSON
{NSError* error =nil;
    id result =[NSJSONSerialization dataWithJSONObject:self
                                               options:kNilOptions error:&error];
    if(error !=nil)
    return nil;
    return result;    
}

@end
