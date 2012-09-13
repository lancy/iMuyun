//
//  IMYViedoCallViewController.m
//  iMuyun
//
//  Created by lancy on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYVideoCallViewController.h"
#import "IMYAppDelegate.h"

@interface IMYVideoCallViewController ()

@property (nonatomic, strong) OTSession *session;
@property (nonatomic, strong) OTPublisher *publisher;
@property (nonatomic, strong) OTSubscriber *subscriber;
@property (nonatomic, strong) OTSubscriber *interpreterSubscriber;

@property (nonatomic, weak) NSString* apiKey;
@property (nonatomic, weak) NSString* token;
@property (nonatomic, weak) NSString* sessionId;

@property (nonatomic, strong) NSString* username;

@property NSInteger callTime;
@property NSInteger hiddenTime;

- (void)initSessionAndBeginConnecting;
- (void)initPublisherAndBeginPublish;
- (void)showAlert:(NSString*)string;
- (void)updateSubscriber;

- (void)updateUserInterface;
- (void)showAnswerButton:(BOOL)toggle;
- (void)showEndButton:(BOOL)toogle;

- (void)customUserInterface;


@end

@implementation IMYVideoCallViewController
@synthesize timerLabel = _timerLabel;


static double widgetHeight = 240;
static double widgetWidth = 320;
static double stateViewHeight = 100;

static NSString* const kApiKey = @"16937882";
static NSString* const kToken = @"devtoken";
static NSString* const kSessionId = @"1_MX4wfn4yMDEyLTA3LTE1IDA2OjMzOjQzLjEzMzU1OSswMDowMH4wLjY0MjU1Mjg1MjU2NH4";
static NSString* const kUserName = @"lancy";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // custom
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"Video Call Controller did load");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.apiKey = kApiKey;
    
    [self customUserInterface];
    
    self.callTime = 0;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
    
}

- (void)viewDidUnload
{
    NSLog(@"Video Call Controller did unload");
    [self setAcceptButton:nil];
    [self setRejectButton:nil];
    [self setAvatarImageView:nil];
    [self setStateLabel:nil];
    [self setEndButton:nil];
    [self setTargetVideoView:nil];
    [self setMyVideoView:nil];
    [self setInterpreterVideoView:nil];
    [self setStateView:nil];
    [self setTimerLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    IMYAppDelegate *delegate =  (IMYAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setIsInCall:YES];
    [self updateUserInterface];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    IMYAppDelegate *delegate =  (IMYAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setIsInCall:NO];

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark - rotate interface

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if ([self.session connectionCount] > 1 && interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    } else
        return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
            [self.targetVideoView setFrame:CGRectMake(0, 100, widgetWidth, widgetHeight)];
            [self.subscriber.view setFrame:CGRectMake(0, 0, widgetWidth, widgetHeight)];
            
            [self.interpreterVideoView setFrame:CGRectMake(widgetWidth / 2, widgetHeight + stateViewHeight, widgetWidth / 2, widgetHeight / 2)];
            
            [self.myVideoView setFrame:CGRectMake(0, 340, 160, 120)];
            [self.publisher.view setFrame:CGRectMake(0, 0, 160, 120)];

            
        } else
        {
            [self.targetVideoView setFrame:CGRectMake(200, 0, widgetWidth * 1.25, widgetHeight * 1.25)];
            [self.subscriber.view setFrame:CGRectMake(-60, 0, widgetWidth * 1.25, widgetHeight * 1.25)];
            
            [self.interpreterVideoView setFrame:CGRectMake(0, 0, 200, 150)];
            [self.interpreterSubscriber.view setFrame:CGRectMake(0, 0, 200, 150)];
            
            [self.myVideoView setFrame:CGRectMake(0, 150, 200, 150)];
            [self.publisher.view setFrame:CGRectMake(0, 0, 200, 150)];
        }
    }];
}


#pragma mark - UI methods

- (void)customUserInterface
{
    // add border corner and shadow
    self.myVideoView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.myVideoView.layer.masksToBounds= NO;
//    self.myVideoView.layer.cornerRadius= 5.0f;
    self.myVideoView.layer.borderWidth = 2.0f;
    
    self.myVideoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myVideoView.layer.shadowOffset = CGSizeMake(3, 3);
    self.myVideoView.layer.shadowOpacity = 0.5;
    self.myVideoView.layer.shadowRadius = 2.0;
    
    // add border corner and shadow
    self.interpreterVideoView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.interpreterVideoView.layer.masksToBounds= NO;
//    self.interpreterVideoView.layer.cornerRadius= 5.0f;
    self.interpreterVideoView.layer.borderWidth = 2.0f;
    
    self.interpreterVideoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.interpreterVideoView.layer.shadowOffset = CGSizeMake(3, 3);
    self.interpreterVideoView.layer.shadowOpacity = 0.5;
    self.interpreterVideoView.layer.shadowRadius = 2.0;
    
    // add border corner and shadow
    self.targetVideoView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.targetVideoView.layer.masksToBounds= NO;
//    self.targetVideoView.layer.cornerRadius= 5.0f;
    self.targetVideoView.layer.borderWidth = 2.0f;
    
    self.targetVideoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.targetVideoView.layer.shadowOffset = CGSizeMake(3, 3);
    self.targetVideoView.layer.shadowOpacity = 0.5;
    self.targetVideoView.layer.shadowRadius = 2.0;
}

- (void)updateUserInterface
{
    switch (self.videoCallState) {
        case IMYVideoCallStateNormal:
            [self showAnswerButton:NO];
            [self showEndButton:YES];
            self.hiddenTime = 0;
            [self.stateLabel setText:[NSString stringWithFormat:@"Comunication with %@", [self.targetContact valueForKey:@"name"]]];
            break;
        case IMYVideoCallStateCallIn:
            [self showAnswerButton:YES];
            [self showEndButton:NO];
            [self.stateLabel setText:[NSString stringWithFormat:@"%@ is calling you", [self.targetContact valueForKey:@"name"]]];
            break;
        case IMYVideoCallStateCallOut:
            [self showAnswerButton:NO];
            [self showEndButton:YES];
            [self.stateLabel setText:[NSString stringWithFormat:@"Calling %@", [self.targetContact valueForKey:@"name"]]];
            
            // request video call
            [[IMYHttpClient shareClient] requestVideoCallWithUsername:[[[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"] valueForKey:@"username"] callToUsername:[self.targetContact valueForKey:@"username"] delegate:self];

            break;
        default:
            break;
    }
    
}

- (void)showAnswerButton:(BOOL)toggle
{
    [self.acceptButton setHidden:!toggle];
    [self.rejectButton setHidden:!toggle];
}

- (void)showEndButton:(BOOL)toogle
{
    [self.endButton setHidden:!toogle];
}

- (IBAction)touchView:(id)sender {
    self.hiddenTime = 0;
    if (self.videoCallState == IMYVideoCallStateNormal && [self.endButton isHidden]) {
        [self setHiddenWithView:self.endButton toggle:NO animate:YES];
    }
}

- (IBAction)tapAceptButton:(id)toogle
{
    NSString *username = [[[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"] valueForKey:@"username"];
    [[IMYHttpClient shareClient] answerVideoCallWithUsername:username answerMessage:@"accept" delegate:self];
    self.videoCallState = IMYVideoCallStateNormal;
    [self updateUserInterface];

}


- (IBAction)tapRejectButton:(id)sender {
    NSString *username = [[[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"] valueForKey:@"username"];
    [[IMYHttpClient shareClient] answerVideoCallWithUsername:username answerMessage:@"reject" delegate:self];
    
    if ([self presentingViewController] != nil) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setFrame:CGRectMake(0, 480, 320, 460)];
        } completion:^(BOOL finished){
            [self.view removeFromSuperview];
        }];
    }

}

- (IBAction)tapEndButton:(id)sender {
//    [[IMYHttpClient shareClient] requestEndVideoCallWithUsername:self.username delegate:self];
    NSLog(@"User tap end button");
    [self.session disconnect];
    if ([self presentingViewController] != nil) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setFrame:CGRectMake(0, 480, 320, 460)];
        } completion:^(BOOL finished){
            [self.view removeFromSuperview];
        }];
    }

}

#pragma mark - http methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"Request finished, results: %@", result);
    if ([[result valueForKey:@"requestType"] isEqualToString:@"videoCall"]
        || [[result valueForKey:@"requestType"] isEqualToString:@"answerVideoCall"]) {
        if ([[result valueForKey:@"message"] isEqualToString:@"accept"]) {
            NSLog(@"Target accept video call.");
            self.sessionId = [result valueForKey:@"sessionId"];
            self.token = [result valueForKey:@"token"];
            self.username = [[[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"] valueForKey:@"username"];
//            self.username = [NSString stringWithFormat:@"%d", arc4random()];
            [self initSessionAndBeginConnecting];
        } else {
            NSLog(@"Target reject video call.");
        }
    }
    else if ([[result valueForKey:@"requestType"] isEqualToString:@"endVideoCall"])
    {
        if ([[result valueForKey:@"message"] isEqualToString:@"success"]) {
            NSLog(@"Request End video call success");
        }
        else
        {
            NSLog(@"Request End video call fail");
            
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Request failed, %@", error);
}

#pragma mark - timer
- (void)updateTimeLabel
{
    self.hiddenTime += 1;
    if (self.hiddenTime == 5 && self.videoCallState == IMYVideoCallStateNormal) {
        [self setHiddenWithView:self.endButton toggle:YES animate:YES];
    }
    
    if (self.subscriber != nil && self.interpreterSubscriber != nil) {
        self.callTime += 1;
        [self.timerLabel setText:[NSString stringWithFormat:@"%02d:%02d", self.callTime / 60, self.callTime % 60]];
    }

}


#pragma mark - Connecting methods
- (void)initSessionAndBeginConnecting
{
    NSLog(@"session begin conecting");
    self.session = [[OTSession alloc] initWithSessionId:self.sessionId delegate:self];
    [self.session connectWithApiKey:self.apiKey token:self.token];
}

- (void)sessionDidConnect:(OTSession *)session
{
    NSLog(@"session did connect");
    [self initPublisherAndBeginPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage = [NSString stringWithFormat:@"Session disconnected: (%@)", session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
//    [self showAlert:alertMessage];
}

- (void)initPublisherAndBeginPublish
{
    NSLog(@"publisher begin publish");
    self.publisher = [[OTPublisher alloc] initWithDelegate:self name:self.username];
    [self.session publish:self.publisher];
//    [self.publisher.view setFrame:CGRectMake(0, widgetHeight + stateViewHeight, widgetWidth / 2, widgetHeight / 2)];
//    [self.view addSubview:self.publisher.view];
    [self.publisher.view setFrame:CGRectMake(0, 0, widgetWidth / 2, widgetHeight / 2)];
    [self.myVideoView addSubview:self.publisher.view];
}

- (void)session:(OTSession *)session didReceiveStream:(OTStream *)stream
{
    NSLog(@"session didReceiveStream (%@)(%@)", stream.streamId, stream.name);
    
    if ([[stream name] isEqualToString:@"interpreter"]) {
        if (!self.interpreterSubscriber) {
            self.interpreterSubscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
        }
    } else if (![[stream name] isEqualToString:[self.publisher name]]) {
        if (!self.subscriber) {
            self.subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
        }
        self.videoCallState = IMYVideoCallStateNormal;
        [self updateUserInterface];

    }
}

- (void)subscriberDidConnectToStream:(OTSubscriber*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)", subscriber.stream.connection.connectionId);
    if ([subscriber isEqual:self.subscriber]) {
//        [subscriber.view setFrame:CGRectMake(0, stateViewHeight, widgetWidth, widgetHeight)];
//        [self.view addSubview:subscriber.view];
//        [self.view sendSubviewToBack:subscriber.view];
        [subscriber.view setFrame:CGRectMake(0, 0, widgetWidth, widgetHeight)];
        [self.targetVideoView addSubview:subscriber.view];
    } else {
//        [subscriber.view setFrame:CGRectMake(widgetWidth / 2, widgetHeight + stateViewHeight, widgetWidth / 2, widgetHeight / 2)];
//        [self.view addSubview:subscriber.view];
        [subscriber.view setFrame:CGRectMake(0, 0, widgetWidth / 2, widgetHeight / 2)];
        [self.interpreterVideoView addSubview:subscriber.view];
    }

}

- (void)session:(OTSession*)session didDropStream:(OTStream*)stream{
    NSLog(@"session didDropStream (%@)", stream.streamId);
    NSLog(@"_subscriber.stream.streamId (%@)", _subscriber.stream.streamId);
    if ([[stream name] isEqualToString:@"interpreter"]) {
        self.interpreterSubscriber = nil;
        
    } else if (![[stream name] isEqualToString:[self.publisher name]]) {
        self.subscriber = nil;
        [self tapEndButton:nil];
    }
}


#pragma mark - error methods

- (void)showAlert:(NSString*)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message from video session"
                                                    message:string
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)publisher:(OTPublisher*)publisher didFailWithError:(OTError*) error {
    NSLog(@"publisher didFailWithError %@", error);
//    [self showAlert:[NSString stringWithFormat:@"There was an error publishing."]];
}

- (void)subscriber:(OTSubscriber*)subscriber didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@", subscriber.stream.streamId, error);
//    [self showAlert:[NSString stringWithFormat:@"There was an error subscribing to stream %@", subscriber.stream.streamId]];
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
    NSLog(@"sessionDidFail");
//    [self showAlert:[NSString stringWithFormat:@"There was an error connecting to session %@", session.sessionId]];
}

- (void)setHiddenWithView:(UIView *)view toggle:(BOOL)toggle animate:(BOOL)animate {    
    if (toggle == YES) {
        [view setAlpha:1];
        [UIView animateWithDuration:0.5 animations:^{
            [view setAlpha:0];
        }completion:^(BOOL finish){
            [view setAlpha:1];
            [view setHidden:YES];
        }];
    } else {
            [view setHidden:NO];
    }

}



@end
