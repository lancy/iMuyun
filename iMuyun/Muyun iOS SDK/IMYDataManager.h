//
//  IMYDataManager.h
//  iMuyun
//
//  Created by lancy on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMYDataManager : NSObject


+ (IMYDataManager *)shareManager;

@property (nonatomic, strong) NSArray *muyunContacts;
@property (nonatomic, strong) NSArray *favoriteContacts;

@property (nonatomic, strong) NSArray *recentCall;
@property (nonatomic, strong) NSArray *missedCall;


@end
