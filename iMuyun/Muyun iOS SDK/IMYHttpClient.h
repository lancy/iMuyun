//
//  IMYHttpClient.h
//  iMuyun
//
//  Created by lancy on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "IMYHttpRequestDelegate.h"

@interface IMYHttpClient : NSObject

//@property (nonatomic, weak) id<IMYHttpRequestDelegate> delegate;


+ (IMYHttpClient *)shareClient;

//api


@end
