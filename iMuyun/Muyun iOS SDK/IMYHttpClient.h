//
//  IMYHttpClient.h
//  iMuyun
//
//  Created by lancy on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface IMYHttpClient : NSObject





+ (IMYHttpClient *)shareClient;

//api
- (void)requestLoginWithUsername:(NSString *)username password:(NSString*) password delegate:(id)delegate;
- (void)requestContactsWithUsername:(NSString *)username delegate:(id)delegate;
//- (void)requestFavoriteContactsWithUsername:(NSString *)username delegate:(id)delegate;
- (void)requestRecentsWithUsername:(NSString *)username delegate:(id)delegate;
//- (void)requestMissedWithUsername:(NSString *)username delegate:(id)delegate;

- (void)requestVideoCallWithUsername:(NSString *)username callToUsername:(NSString *)callToUsername delegate:(id)delegate;
- (void)answerVideoCallWithUsername:(NSString *)username answerMessage:(NSString *)message delegate:(id)delegate;
- (void)requestEndVideoCallWithUsername:(NSString *)username delegate:(id)delegate;

- (void)requestAddFavoriteWithUsername:(NSString *)username favoriteUsername:(NSString *)favoriteUsername delegate:(id)delegate;
- (void)requestDeleteRecentWithUsername:(NSString *)username recentUid:(NSString *)recentUid delegate:(id)delegate;
- (void)requestClearRecentsWithUsername:(NSString *)username delegate:(id)delegate;
- (void)requestUpdateMyInfoWithUsername:(NSString *)username myInfo:(NSDictionary *)myInfo delegate:(id)delegate;


@end
