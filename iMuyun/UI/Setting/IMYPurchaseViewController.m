//
//  IMYPurchaseViewController.m
//  iMuyun
//
//  Created by Lancy on 13/9/12.
//

#import "IMYPurchaseViewController.h"
#import "IAPHandler.h"

@interface IMYPurchaseViewController ()
- (void)registIapObservers;
@end

@implementation IMYPurchaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Purchase";
    [self registIapObservers];
    [IAPHandler initECPurchaseWithHandler];
    //iap产品编号集合，这里你需要替换为你自己的iap列表
    NSArray *productIds = [NSArray arrayWithObjects:@"com.imuyun.item1",
                           @"com.imuyun.item2", nil];
    //从AppStore上获取产品信息
    [[ECPurchase shared]requestProductData:productIds];
}

- (void)viewWillUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return products_ ? [products_ count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType =  UITableViewCellAccessoryNone;
    } else {
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
    }
    SKProduct *product = [products_ objectAtIndex:indexPath.row];
    //产品名称
    UILabel *localizedTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 20)];
    localizedTitle.text = product.localizedTitle;
    //产品价格
    UILabel *localizedPrice = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 20)];
    localizedPrice.text = product.localizedPrice;
    //购买按钮
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buyButton.tag = indexPath.row;
    buyButton.frame = CGRectMake(250, 10, 50, 20);
    [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:localizedTitle];
    [cell.contentView addSubview:localizedPrice];
    [cell.contentView addSubview:buyButton];
    return cell;
}

- (void)getedProds:(NSNotification*)notification
{
    NSLog(@"通过NSNotificationCenter收到信息：%@,", [notification object]);
}


- (void)buy:(UIButton*)sender
{
    SKProduct *product = [products_ objectAtIndex:sender.tag];
    NSLog(@"购买商品：%@", product.productIdentifier);
    [[ECPurchase shared]addPaymentWithProduct:product];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//接收从app store抓取回来的产品，显示在表格上
-(void) receivedProducts:(NSNotification*)notification
{
    products_ = [[NSArray alloc]initWithArray:[notification object]];
    NSLog(@"Products = %@", products_);
    
    if (!products_ || [products_ count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"IPA Demo" message:@"获取不到产品列表，请确定已经在itunes connect注册了产品，并且配置无误！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
        [alert show];
    }
    
    [self.tableView reloadData];
}

// 注册IapHander的监听器，并不是所有监听器都需要注册，
// 这里可以根据业务需求和收据认证模式有选择的注册需要
- (void)registIapObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(receivedProducts:)
                                                name:IAPDidReceivedProducts
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(failedTransaction:)
                                                name:IAPDidFailedTransaction
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(restoreTransaction:)
                                                name:IAPDidRestoreTransaction
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(completeTransaction:)
                                                name:IAPDidCompleteTransaction object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(completeTransactionAndVerifySucceed:)
                                                name:IAPDidCompleteTransactionAndVerifySucceed
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(completeTransactionAndVerifyFailed:)
                                                name:IAPDidCompleteTransactionAndVerifyFailed
                                              object:nil];
}

-(void)showAlertWithMsg:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"IAP反馈"
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
}

-(void) failedTransaction:(NSNotification*)notification
{
    [self showAlertWithMsg:[NSString stringWithFormat:@"交易取消(%@)",[notification name]]];
}

-(void) restoreTransaction:(NSNotification*)notification
{
    [self showAlertWithMsg:[NSString stringWithFormat:@"交易恢复(%@)",[notification name]]];
}

-(void )completeTransaction:(NSNotification*)notification
{
    [self showAlertWithMsg:[NSString stringWithFormat:@"交易成功(%@)",[notification name]]];
}

-(void) completeTransactionAndVerifySucceed:(NSNotification*)notification
{
    NSString *proIdentifier = [notification object];
    [self showAlertWithMsg:[NSString stringWithFormat:@"交易成功，产品编号：%@",proIdentifier]];
}

-(void) completeTransactionAndVerifyFailed:(NSNotification*)notification
{
    NSString *proIdentifier = [notification object];
    [self showAlertWithMsg:[NSString stringWithFormat:@"产品%@交易失败",proIdentifier]];
}

@end
