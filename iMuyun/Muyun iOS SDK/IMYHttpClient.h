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
- (void)requestLoginWithUsername:(NSString *) username password:(NSString*) password delegate:(id)delegate;

@end
