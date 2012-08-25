//
//  IMYMuyunViewController.m
//  iMuyun
//
//  Created by Lancy on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYMuyunViewController.h"
#import "IMYInterpreterVideoCallViewController.h"

@interface IMYMuyunViewController ()

@property (nonatomic, strong) NSArray *languageArray;
@property BOOL isTargetLanguageButtonVisible;
@property BOOL isTappedTargetButton;
- (void)hideLanguagePicker:(BOOL) toggle;
- (void)moveTargetLanguageButtonVisible:(BOOL)toggle;

@end

@implementation IMYMuyunViewController
@synthesize languagePickerView = _languagePickerView;
@synthesize languageInputAccessoryView = _languageInputAccessoryView;
@synthesize myLanguageButton = _myLanguageButton;
@synthesize targetLanguageButton = _targetLanguageButton;

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
    
    self.languageArray = LANGUAGE_ARRAY;
}

- (void)viewDidUnload
{
    [self setLanguagePickerView:nil];
    [self setLanguageInputAccessoryView:nil];
    [self setMyLanguageButton:nil];
    [self setTargetLanguageButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [self setLanguageArray:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - language picker delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.languageArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.languageArray objectAtIndex:row];
}

#pragma mark - UI methods

- (void)hideLanguagePicker:(BOOL) toggle
{
    
    if (toggle) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            // outside the windows
            [self.languagePickerView setFrame:CGRectMake(0, frame.size.height + self.languageInputAccessoryView.frame.size.height, self.languagePickerView.frame.size.width, self.languagePickerView.frame.size.height)];
            
            [self.languageInputAccessoryView setFrame:CGRectMake(0, frame.size.height, self.languageInputAccessoryView.frame.size.width, self.languageInputAccessoryView.frame.size.height)];
        } completion:^(BOOL complete){
            [self.languagePickerView removeFromSuperview];
            [self.languageInputAccessoryView removeFromSuperview];
        }];
        
    } else {
        [self.view addSubview:self.languagePickerView];
        [self.view addSubview:self.languageInputAccessoryView];
        CGRect frame = self.view.frame;
        // outside the windows
        [self.languagePickerView setFrame:CGRectMake(0, frame.size.height + self.languageInputAccessoryView.frame.size.height, self.languagePickerView.frame.size.width, self.languagePickerView.frame.size.height)];
        
        [self.languageInputAccessoryView setFrame:CGRectMake(0, frame.size.height, self.languageInputAccessoryView.frame.size.width, self.languageInputAccessoryView.frame.size.height)];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.languagePickerView setFrame:CGRectMake(0, frame.size.height - self.languagePickerView.frame.size.height, self.languagePickerView.frame.size.width, self.languagePickerView.frame.size.height)];
            
            [self.languageInputAccessoryView setFrame:CGRectMake(0, frame.size.height - self.languagePickerView.frame.size.height - self.languageInputAccessoryView.frame.size.height, self.languageInputAccessoryView.frame.size.width, self.languageInputAccessoryView.frame.size.height)];
            
        }];
    }
}

- (void)moveTargetLanguageButtonVisible:(BOOL)toggle
{
#warning can't do that.
    self.isTargetLanguageButtonVisible = toggle;
    if (toggle) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view.layer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }];
         
    }
}

- (IBAction)tapLanguageDoneButton:(id)sender {
    [self hideLanguagePicker:YES];
//    if (self.isTargetLanguageButtonVisible) {
//        [self moveTargetLanguageButtonVisible:NO];
//    }
    UIButton *pickedButton;
    if ([self isTappedTargetButton]) {
        pickedButton = self.targetLanguageButton;
    } else {
        pickedButton = self.myLanguageButton;
    }
    NSString *language = [self.languageArray objectAtIndex:[self.languagePickerView selectedRowInComponent:0]];

    [pickedButton setTitle:language forState:UIControlStateNormal];
     
    
}

- (IBAction)tapLanguageButton:(id)sender {
    [self hideLanguagePicker:NO];
    if ([sender isEqual:self.targetLanguageButton]) {
//        [self moveTargetLanguageButtonVisible:YES];
        [self setIsTappedTargetButton:YES];
    } else {
        [self setIsTappedTargetButton:NO];
    }
}

- (IBAction)tapVideoCallButton:(id)sender {
    IMYInterpreterVideoCallViewController *interpreterVideoCallVC = [self.storyboard instantiateViewControllerWithIdentifier:@"interpreterVideoCallViewController"];
    
    [interpreterVideoCallVC setMyLanguage:self.myLanguageButton.titleLabel.text];
    [interpreterVideoCallVC setTargetLanguage:self.targetLanguageButton.titleLabel.text];
    [interpreterVideoCallVC setVideoCallState:IMYVideoCallStateCallOut];
    
    [self presentViewController:interpreterVideoCallVC animated:YES completion:nil];

}
@end
