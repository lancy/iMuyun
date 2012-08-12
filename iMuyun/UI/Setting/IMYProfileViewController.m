//
//  IMYProfileViewController.m
//  iMuyun
//
//  Created by Lancy on 12/8/12.
//
//

#import "IMYProfileViewController.h"
#import "UIImageView+WebCache.h"

@interface IMYProfileViewController ()

@property (nonatomic, strong) NSMutableDictionary *myInfo;
@property BOOL newMedia;

- (void)initMyProfile;

@end

@implementation IMYProfileViewController
@synthesize photoImageView;
@synthesize nameTextField;
@synthesize companyTextField;
@synthesize languageTextField;

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
    [self initMyProfile];
}

- (void)viewDidUnload
{
    [self setPhotoImageView:nil];
    [self setNameTextField:nil];
    [self setCompanyTextField:nil];
    [self setLanguageTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [self setMyInfo:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView delegate
// use static table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancle" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UI Methods

- (void)initMyProfile
{
    NSDictionary *myInfo = [[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"];
    [self.nameTextField setText:[myInfo valueForKey:@"name"]];
    [self.companyTextField setText:[myInfo valueForKey:@"company"]];
    [self.languageTextField setText:[myInfo valueForKey:@"language"]];
    
    [self.photoImageView setImageWithURL:[NSURL URLWithString:[myInfo valueForKey:@"portraitUrl"]] placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    self.myInfo = [myInfo mutableCopy];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Tap take photo");
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker =
                [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType =
                UIImagePickerControllerSourceTypeCamera;
                [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
                imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
                imagePicker.allowsEditing = YES;
                [self presentModalViewController:imagePicker
                                        animated:YES];
                self.newMedia = YES;
            }
            break;
        case 1:
            NSLog(@"Tap choose existing");
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                UIImagePickerController *imagePicker =
                [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType =
                UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                          (NSString *) kUTTypeImage,
                                          nil];
                imagePicker.allowsEditing = YES;
                [self presentModalViewController:imagePicker animated:YES];
                self.newMedia = NO;
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)textfieldDidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)nameTextFieldEditingDidEnd:(id)sender {
    [self.myInfo setValue:self.nameTextField.text forKey:@"name"];
    [[IMYHttpClient shareClient] requestUpdateMyInfoWithUsername:[self.myInfo valueForKey:@"username"] myInfo:self.myInfo delegate:self];
    [[NSUserDefaults standardUserDefaults] setValue:self.myInfo forKey:@"myInfo"];
}
- (IBAction)companyTextFieldEditingDidEnd:(id)sender {
    [self.myInfo setValue:self.companyTextField.text forKey:@"company"];
    [[IMYHttpClient shareClient] requestUpdateMyInfoWithUsername:[self.myInfo valueForKey:@"company"]  myInfo:self.myInfo delegate:self];
    [[NSUserDefaults standardUserDefaults] setValue:self.myInfo forKey:@"myInfo"];
}

#pragma mark - image picker controller delegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerEditedImage];
        
        [self.photoImageView setImage:image];
        
        [[IMYHttpClient shareClient] requestUploadPortraitWithUsername:[self.myInfo valueForKey:@"username"] portraitImage:image delegate:self];
//        if (self.newMedia)
//            UIImageWriteToSavedPhotosAlbum(image,
//                                           self,
//                                           @selector(image:finishedSavingWithError:contextInfo:),
//                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
}
//-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle: @"Save failed"
//                              message: @"Failed to save image"\
//                              delegate: nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//    }
//}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - HTTP methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"Request finished, results: %@", results);
    if ([[results valueForKey:@"requestType"] isEqualToString:@"uploadPortrait"] ) {
        if ([[results valueForKey:@"message"] isEqualToString:@"success"]) {
            NSLog(@"Upload portrait success");
            [self.myInfo setValue:[results valueForKey:@"portraitUrl"] forKey:@"portraitUrl"];
            
        } else {
            NSLog(@"Upload portrait fail");
        }
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Request Failed, %@", error);
}




@end
