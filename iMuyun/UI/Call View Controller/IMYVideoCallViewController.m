//
//  IMYViedoCallViewController.m
//  iMuyun
//
//  Created by lancy on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYViedoCallViewController.h"

@interface IMYViedoCallViewController ()

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


@end

@implementation IMYViedoCallViewController
@synthesize nameTextField = _nameTextField;
@synthesize session = _session;
@synthesize publisher = _publisher;
@synthesize subscriber = _subscriber;
@synthesize interpreterSubscriber = _interpreterSubscriber;
@synthesize apiKey = _apiKey;
@synthesize token = _token;
@synthesize sessionId = _sessionId;
@synthesize userName = _userName;


static double widgetHeight = 240;
static double widgetWidth = 320;

static NSString* const kApiKey = @"16638031";
static NSString* const kToken = @"devtoken";
static NSString* const kSessionId = @"1_MX4wfn4yMDEyLTA3LTE1IDA2OjMzOjQzLjEzMzU1OSswMDowMH4wLjY0MjU1Mjg1MjU2NH4";
static NSString* const kUserName = @"lancy";



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
    
    self.apiKey = kApiKey;
    self.token = kToken;
    self.sessionId = kSessionId;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [self.publisher.view setFrame:CGRectMake(0, widgetHeight, widgetWidth / 2, widgetHeight / 2)];
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
        [subscriber.view setFrame:CGRectMake(0, 0, widgetWidth, widgetHeight)];
        [self.view addSubview:subscriber.view];
        [self.view sendSubviewToBack:subscriber.view];
    } else {
        [subscriber.view setFrame:CGRectMake(widgetWidth / 2, widgetHeight, widgetWidth / 2, widgetHeight / 2)];
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

- (IBAction)pressEnd:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)pressConnectButton:(id)sender {
    self.userName = self.nameTextField.text;
    [self initSessionAndBeginConnecting];
}

- (IBAction)pressDropButton:(id)sender {
    [self.session disconnect];
}
@end
