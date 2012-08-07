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

- (void)reloadMyInfoWithCompletionBlock:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
{
    [[IMYHttpClient shareClient] requestUserInfoWithUsername:self.username delegate:self];
}

- (void)reloadContacts
{
    [[IMYHttpClient shareClient] requestContactsWithUsername:self.username delegate:self];
}

- (void)reloadRecents
{
    [[IMYHttpClient shareClient] requestRecentsWithUsername:self.username delegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"Request finished, results: %@", results);
    if ([[results valueForKey:@"requestType"] isEqualToString:@"contacts"] ) {
        if (![self.muyunContacts isEqualToArray:[results valueForKey:@"contacts"]]) {
            NSLog(@"Results are different, will write to userdefaults buffer muyunContacts.");
            [[NSUserDefaults standardUserDefaults] setValue:[results valueForKey:@"contacts"] forKey:@"muyunContacts"];
            NSLog(@"Did write to user defaults buffer muyunContacts.");
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}


@end
