//
//  IMYInterpreterVideoCallViewController.h
//  iMuyun
//
//  Created by Lancy on 7/8/12.
//
//

#import <UIKit/UIKit.h>
#import <Opentok/Opentok.h>
#import "IMYHttpClient.h"
#import "IMYVideoCallViewController.h"
//
//typedef enum{
//    IMYVideoCallStateNormal,
//    IMYVideoCallStateCallOut,
//    IMYVideoCallStateCallIn
//} IMYVideoCallState;


@interface IMYInterpreterVideoCallViewController : UIViewController<ASIHTTPRequestDelegate, OTSessionDelegate, OTPublisherDelegate, OTSubscriberDelegate>

// video call target
@property (strong, nonatomic) NSString* myLanguage;
@property (strong, nonatomic) NSString* targetLanguage;

@property IMYVideoCallState videoCallState;

//UI
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *stateView;

@property (weak, nonatomic) IBOutlet UIView *myVideoView;
@property (weak, nonatomic) IBOutlet UIView *interpreterVideoView;


- (IBAction)tapEndButton:(id)sender;


@end
