//
//  IMYDataManager.m
//  iMuyun
//
//  Created by lancy on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYDataManager.h"

@implementation IMYDataManager

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
