//
//  IMYDataManager.h
//  iMuyun
//
//  Created by lancy on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface IMYDataManager : NSObject <ASIHTTPRequestDelegate>


+ (IMYDataManager *)shareManager;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSMutableDictionary *myInfo;

@property (nonatomic, strong) NSMutableArray *muyunContacts;
@property (nonatomic, strong) NSMutableArray *favoriteContacts;

@property (nonatomic, strong) NSMutableArray *recentCall;
@property (nonatomic, strong) NSMutableArray *missedCall;

- (void)reloadMyInfoWithCompletionBlock:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (void)reloadContacts;
- (void)reloadRecents;

@end
