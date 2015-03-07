//
//  SendMsgViewController.m
//  Anypic
//
//  Created by Sumit Ghosh on 13/09/14.
//
//

#import "SendMsgViewController.h"
#import "PAPPhotoDetailsFooterView.h"
#import "PAPMsgViewController.h"
#import "PAPSettingsButtonItem.h"
#import "PAPMessageViewController.h"
#import "ViewController.h"
#import "UIImage+ResizeAdditions.h"

@interface SendMsgViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@property (nonatomic,strong) UITextView * caption;
@end

@implementation SendMsgViewController
@synthesize scrollView;
@synthesize image;
@synthesize commentTextField,caption;
@synthesize photoFile;
@synthesize thumbnailFile;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
- (id)initWithImage:(UIImage *)aImage {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (!aImage) {
            return nil;
        }
        
        self.image = aImage;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.delegate = self;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    //self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    // self.view = self.scrollView;
    [self.view addSubview:scrollView];
      [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 480)];
    
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 230.0f)];
    [photoImageView setBackgroundColor:[UIColor blackColor]];
    [photoImageView setImage:self.image];
    [photoImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    
    CALayer *layer = photoImageView.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = 3.0f;
    layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    layer.shadowOpacity = 0.5f;
    layer.shouldRasterize = YES;
    
    [self.scrollView addSubview:photoImageView];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(sendButtonClicked:)];
    
    
    caption =[[UITextView alloc]initWithFrame:CGRectMake(20, 260, 280, 35)];
    caption.layer.cornerRadius=4.0f;
    caption.delegate=self;
    caption.backgroundColor=[UIColor whiteColor];
    caption.text=@"Write a caption here..";
    caption.pagingEnabled=YES;
    [self.scrollView addSubview:caption];
    
    [self shouldUploadImage:self.image];
 }

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n" ]) {
        [caption resignFirstResponder];
    }    return YES ;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [caption resignFirstResponder];
    return  YES ;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if(textView==caption)
    {   caption.text=@"";
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        scrollView.frame = CGRectMake(scrollView.frame.origin.x, (scrollView.frame.origin.y-100 ), scrollView.frame.size.width, self.scrollView.frame.size.height);
        
        [UIView commitAnimations];
    }

    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
    if([UIScreen mainScreen].bounds.size.height>500)
    {
        scrollView.frame=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    }
    else{
        scrollView.frame=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height+20);
    }
	[UIView commitAnimations];
    [textView resignFirstResponder];
    

    return  YES;
}



- (BOOL)shouldUploadImage:(UIImage *)anImage {
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}
/*
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [commentTextField resignFirstResponder];
    return  YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
    if([UIScreen mainScreen].bounds.size.height>500)
    {
        scrollView.frame=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    }
    else{
        scrollView.frame=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height+20);
    }
	[UIView commitAnimations];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField==commentTextField)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        scrollView.frame = CGRectMake(scrollView.frame.origin.x, (scrollView.frame.origin.y-240 ), scrollView.frame.size.width, self.scrollView.frame.size.height);
        
        [UIView commitAnimations];
    }
    if(commentTextField!=nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"msg"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    return YES;
}*/

- (void)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendButtonClicked:(id)sender{
    NSString * fb=[[NSUserDefaults standardUserDefaults]objectForKey:@"fbid"];
    NSLog(@"fbid sendbutton %@",fb);
    if(![fb isEqualToString:@"0"])
    {
        [self directMsg:self.image];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"fbid"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)directMsg:(UIImage *)image{
    NSLog(@"fbid %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"fbid"]);
    NSString * fbid=[[NSUserDefaults standardUserDefaults]objectForKey:@"fbid"];
   
    PFQuery * query=[PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"facebookId" equalTo:fbid];
    
//    NSArray *arr ;
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
      NSString * toUsername;
          NSArray *arr = [query findObjects] ;
          
    

    for (int i=0; i<arr.count; i++) {
        PFObject * obj=[arr objectAtIndex:i];
        toUsername=obj[kPAPUserDisplayNameKey];
    }
    
    
    //added by me .
    
    PFQuery * query1=[PFQuery queryWithClassName:@"_User"];
    NSString *getId=[[NSUserDefaults standardUserDefaults]objectForKey:@"toUser"];
    
    [query whereKey:@"facebookId" equalTo:getId];
    NSArray * arr1=[query findObjects];
    PFObject * obj ;
    for (int i=0; i<arr1.count; i++) {
        obj=[arr1 objectAtIndex:i];
//        NSLog(@"obj is %@",obj);
    }
    ////
    
    NSString * userid=[[PFUser currentUser]objectForKey:kPAPUserFacebookIDKey];
    NSString * fromname=[[PFUser currentUser]objectForKey:kPAPUserDisplayNameKey];
    
    PFObject *photo = [PFObject objectWithClassName:@"OneToOne"];
    [photo setObject:@"image" forKey:@"Type"];
    [photo setObject:obj forKey:@"toUser"];
    [photo setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
    [photo setObject:fbid forKey:@"toUserFBID"];
    [photo setObject:userid forKey:@"fromUserFBID"];
    [photo setObject:toUsername forKey:@"toUserName"];
    [photo setObject:fromname forKey:@"fromUserName"];
    [photo setObject:photoFile forKey:kPAPPhotoPictureKey];
    [photo setObject:thumbnailFile forKey:kPAPPhotoThumbnailKey];
    if(caption!=nil)
    { NSString * cmntstr=caption.text;
        [photo setObject:cmntstr forKey:@"Message"];
    }
   
    
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"facebookId" equalTo:fbid]; // Set channel
        
    // photos are public, but may only be modified by the user who uploaded them
    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    photo.ACL = photoACL;
    // Save the Photo PFObject
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[PAPCache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
            
            // userInfo might contain any caption which might have been posted by the uploader
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:photo];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        
    }];
    //}
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"fbid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
 });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
