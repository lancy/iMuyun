//
//  IMYViedoCallViewController.m
//  iMuyun
//
//  Created by lancy on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYVideoCallViewController.h"

@interface IMYVideoCallViewController ()

@property (nonatomic, strong) OTSession *session;
@property (nonatomic, strong) OTPublisher *publisher;
@property (nonatomic, strong) OTSubscriber *subscriber;
@property (nonatomic, strong) OTSubscriber *interpreterSubscriber;

@property (nonatomic, strong) NSString* apiKey;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* sessionId;

@property (nonatomic, strong) NSString* userName;

- (void)initSessionAndBeginConnecting;
- (void)initPublisherAndBeginPublish;
- (void)showAlert:(NSString*)string;
- (void)updateSubscriber;

- (void)updateUserInterface;
- (void)showAnswerButton:(BOOL)toggle;
- (void)showEndButton:(BOOL)toogle;


@end

@implementation IMYVideoCallViewController
@synthesize acceptButton = _aceptButton;
@synthesize rejectButton = _rejectButton;
@synthesize endButton = _endButton;
@synthesize portraitImageView = _portraitImageView;
@synthesize stateLabel = _stateLabel;
@synthesize session = _session;
@synthesize publisher = _publisher;
@synthesize subscriber = _subscriber;
@synthesize interpreterSubscriber = _interpreterSubscriber;
@synthesize apiKey = _apiKey;
@synthesize token = _token;
@synthesize sessionId = _sessionId;
@synthesize userName = _userName;
@synthesize targetContact = _targetContact; 
@synthesize videoCallState = _videoCallState;


static double widgetHeight = 240;
static double widgetWidth = 320;
static double stateViewHeight = 100;

static NSString* const kApiKey = @"16638031";
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self updateUserInterface];
    
        
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidUnload
{
    [self setAcceptButton:nil];
    [self setRejectButton:nil];
    [self setPortraitImageView:nil];
    [self setStateLabel:nil];
    [self setEndButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UI methods

- (void)updateUserInterface
{
    switch (self.videoCallState) {
        case IMYVideoCallStateNomal:
            [self showEndButton:NO];
            break;
        case IMYVideoCallStateCallIn:
            [self showAnswerButton:YES];
            [self showEndButton:NO];
            break;
        case IMYVideoCallStateCallOut:
            [self showAnswerButton:NO];
            [self showEndButton:YES];
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

- (IBAction)tapAceptButton:(id)sender {
    self.apiKey = kApiKey;
    self.token = kToken;
    self.sessionId = kSessionId;
    self.userName = [NSString stringWithFormat:@"%d", arc4random()];

    [self initSessionAndBeginConnecting];
}

- (IBAction)tapRejectButton:(id)sender {
}

- (IBAction)tapEndButton:(id)sender {
    [self.session disconnect];
    [self dismissModalViewControllerAnimated:YES];
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
    [self showAlert:alertMessage];
}

- (void)initPublisherAndBeginPublish
{
    NSLog(@"publisher begin publish");
    self.publisher = [[OTPublisher alloc] initWithDelegate:self name:self.userName];
    [self.session publish:self.publisher];
    [self.publisher.view setFrame:CGRectMake(0, widgetHeight + stateViewHeight, widgetWidth / 2, widgetHeight / 2)];
    [self.view addSubview:self.publisher.view];
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
    }
}

- (void)subscriberDidConnectToStream:(OTSubscriber*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)", subscriber.stream.connection.connectionId);
    if ([subscriber isEqual:self.subscriber]) {
        [subscriber.view setFrame:CGRectMake(0, stateViewHeight, widgetWidth, widgetHeight)];
        [self.view addSubview:subscriber.view];
        [self.view sendSubviewToBack:subscriber.view];
    } else {
        [subscriber.view setFrame:CGRectMake(widgetWidth / 2, widgetHeight + stateViewHeight, widgetWidth / 2, widgetHeight / 2)];
        [self.view addSubview:subscriber.view];
    }

}

- (void)session:(OTSession*)session didDropStream:(OTStream*)stream{
    NSLog(@"session didDropStream (%@)", stream.streamId);
    NSLog(@"_subscriber.stream.streamId (%@)", _subscriber.stream.streamId);
    if ([[stream name] isEqualToString:@"interpreter"]) {
        self.interpreterSubscriber = nil;
        
    } else if (![[stream name] isEqualToString:[self.publisher name]]) {
        self.subscriber = nil;
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
    [self showAlert:[NSString stringWithFormat:@"There was an error publishing."]];
}

- (void)subscriber:(OTSubscriber*)subscriber didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@", subscriber.stream.streamId, error);
    [self showAlert:[NSString stringWithFormat:@"There was an error subscribing to stream %@", subscriber.stream.streamId]];
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
    NSLog(@"sessionDidFail");
    [self showAlert:[NSString stringWithFormat:@"There was an error connecting to session %@", session.sessionId]];
}



@end
