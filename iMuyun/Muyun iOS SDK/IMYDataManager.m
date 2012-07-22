//
//  IMYDataManager.m
//  iMuyun
//
//  Created by lancy on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYDataManager.h"
#import "IMYHttpClient.h"


@interface IMYDataManager()

@end;

@implementation IMYDataManager
@synthesize muyunContacts = _muyunContacts;
@synthesize favoriteContacts = _favoriteContacts;
@synthesize recentCall = _recentCall;
@synthesize missedCall = _missedCall;


+ (IMYDataManager *)shareManager
{
    static IMYDataManager *manager;          
    @synchronized(self) {
        if(!manager) {
            manager = [[IMYDataManager alloc] init];
        }   
    }
    return manager;
}

@end
