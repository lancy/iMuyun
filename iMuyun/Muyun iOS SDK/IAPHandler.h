//
//  IAPHandler.h
//  iMuyun
//
//  Created by Lancy on 13/9/12.
//
//

#define IAPDidReceivedProducts                      @"IAPDidReceivedProducts"
#define IAPDidFailedTransaction                     @"IAPDidFailedTransaction"
#define IAPDidRestoreTransaction                    @"IAPDidRestoreTransaction"
#define IAPDidCompleteTransaction                   @"IAPDidCompleteTransaction"
#define IAPDidCompleteTransactionAndVerifySucceed   @"IAPDidCompleteTransactionAndVerifySucceed"
#define IAPDidCompleteTransactionAndVerifyFailed    @"IAPDidCompleteTransactionAndVerifyFailed"
#import <Foundation/Foundation.h>
#import "ECPurchase.h"

@interface IAPHandler : NSObject<ECPurchaseTransactionDelegate, ECPurchaseProductDelegate>

+ (void)initECPurchaseWithHandler;
@end