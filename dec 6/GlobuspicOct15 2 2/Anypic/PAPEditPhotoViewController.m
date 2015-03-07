//
//  PAPEditPhotoViewController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPEditPhotoViewController.h"
#import "PAPPhotoDetailsFooterView.h"
#import "PAPMsgViewController.h"
#import "PAPSettingsButtonItem.h"
#import "PAPMessageViewController.h"
#import "ViewController.h"
#import "TagPhotoViewController.h"
#import "UIImage+ResizeAdditions.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import  <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import "AppDelegate.h"

@interface PAPEditPhotoViewController (){
PAPMessageViewController   *directVC;
    UIButton *tagButton,*followers,*direct;
    UILabel *tagPeopleLabel;
    TagPhotoViewController *tagPhoto;
    UILabel * addLocationlbl,*tagLabel;
    UIImageView *photoImageView;
    CGRect footerRect;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITextField *commentTextField,* placetxt,* userPlace;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@property(nonatomic,strong) CLLocationManager * manager1;
@property(nonatomic,strong) NSString * Area;
@property(nonatomic)int fbToggle;
@property(nonatomic)int twitterToggle;
@property(nonatomic,strong)UISwitch * toggle;
@property(nonatomic,strong) UIView * follwerView,*tagView,* directView,*containerView,* placeview;
@property(nonatomic,strong)UIButton  *fbButton;
@property(nonatomic,strong)UIButton  *twitterButton;

@end

@implementation PAPEditPhotoViewController
@synthesize scrollView,manager1,Area,toggle,follwerView,directView,containerView,placeview,delegate;
@synthesize image;
@synthesize commentTextField,placetxt,userPlace;
@synthesize photoFile;
@synthesize thumbnailFile,tagView;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId,tagMutArray;

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"Memory warning on Edit");
}


#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.fbToggle=0;
    self.twitterToggle=0;
    //[self getlocation];
    
    self.directView=[[UIView alloc] init];
   // self.directView.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.directView];
      if(!follwerView)
    {
        self.follwerView=[[UIView alloc]init];
       // self.follwerView.backgroundColor=[UIColor redColor];
        [self.directView addSubview:follwerView];
    
        self.scrollView=[[UIScrollView alloc]init];
    self.scrollView.delegate = self;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
   [self.follwerView addSubview:scrollView];
    
    photoImageView = [[UIImageView alloc] init];
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
    
     footerRect = [PAPPhotoDetailsFooterView rectForView];
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            //footerRect.origin.y = photoImageView.frame.origin.y + photoImageView.frame.size.height;
        footerRect.origin.y=210.0f;
        }
        else{
            //footerRect.origin.y = photoImageView.frame.origin.y + photoImageView.frame.size.height;
            footerRect.origin.y=200.0f;
        }
        NSLog(@"footerrect %f",footerRect.origin.y);
    PAPPhotoDetailsFooterView *footerView = [[PAPPhotoDetailsFooterView alloc] initWithFrame:footerRect];
    self.commentTextField = footerView.commentField;
    self.commentTextField.delegate = self;
    [self.scrollView addSubview:footerView];
    [self.scrollView setContentSize:CGSizeMake(self.follwerView.bounds.size.width, 560)];
        
        tagView=[[UIView alloc]init];
        tagView.backgroundColor=[UIColor whiteColor];
        tagView.layer.cornerRadius=4.0f;
        [self.scrollView addSubview:tagView];
        
        tagButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
       
        [tagButton setImage:[UIImage imageNamed:@"tagpicNormal.png"] forState:UIControlStateNormal];
        [tagButton addTarget:self action:@selector(tagPeople:) forControlEvents:UIControlEventTouchUpInside];
        [tagView addSubview:tagButton];
        
        tagLabel =[[UILabel alloc]init];
        tagLabel.text=@" Tag  People";
        [tagLabel setTextColor:[UIColor blackColor]];
        [tagView addSubview:tagLabel];
        
        tagPeopleLabel=[[UILabel alloc]init];
        tagPeopleLabel.text=@" Tag  People";
        [tagPeopleLabel setTextColor:[UIColor blackColor]];
        [tagView addSubview:tagPeopleLabel];

        placeview=[[UIView alloc]init];
        placeview.backgroundColor=[UIColor whiteColor];
        placeview.layer.cornerRadius=4.0f;
        [self.scrollView addSubview:placeview];
        
        
         addLocationlbl=[[UILabel alloc]init ];
        addLocationlbl.text=@"Add your Location";
        [addLocationlbl setTextColor:[UIColor blackColor]];
        [placeview addSubview:addLocationlbl];
        
        
        
        toggle=[[UISwitch alloc]init ];
        [toggle addTarget:self action:@selector(locationdDisplay:) forControlEvents:UIControlEventValueChanged];
         toggle.onTintColor=[UIColor greenColor];
        [self.scrollView addSubview:toggle];
        
        self.fbButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.fbButton addTarget:self action:@selector(fbShareButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.fbButton setImage:[UIImage imageNamed:@"fbButtonNormal.png"] forState:UIControlStateNormal];
        [self.fbButton setImage:[UIImage imageNamed:@"fbButtonActive.png"] forState:UIControlStateSelected];
        
        [self.scrollView addSubview:self.fbButton];
        
        
        self.twitterButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.twitterButton addTarget:self action:@selector(twitterButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.twitterButton setImage:[UIImage imageNamed:@"twitterButtonNormal.png"] forState:UIControlStateNormal];
        [self.twitterButton setImage:[UIImage imageNamed:@"twitterButtonActive.png"] forState:UIControlStateSelected];
        
        [self.scrollView addSubview:self.twitterButton];

    }
    else{
    self.follwerView.hidden=NO;
    }
    
    if([UIScreen mainScreen].bounds.size.height>500)
    {
        self.directView.frame= CGRectMake(0,5, self.view.frame.size.width, self.view.frame.size.height-20);
        self.follwerView.frame=CGRectMake(0, 0, self.directView.bounds.size.width, self.directView.bounds.size.height);
        self.scrollView.frame= CGRectMake(0, 0, self.follwerView.bounds.size.width, self.follwerView.bounds.size.height);
        photoImageView.frame= CGRectMake(20.0f, 10.0f, 280.0f, 200.0f);
        
        tagView.frame= CGRectMake(10, 260, self.scrollView.bounds.size.width-20,50);
        tagButton.frame=CGRectMake(10, 5, 40, 40);
        tagLabel.frame= CGRectMake(55, 0,150 , 50);
        tagPeopleLabel.frame= CGRectMake(195, 0,150 , 50);
        placeview.frame= CGRectMake(10, 312, self.scrollView.bounds.size.width-20,50);
        addLocationlbl.frame= CGRectMake(20, 0,150 , 50);
        toggle.frame= CGRectMake(240, 315, 40, 20);
        self.fbButton.frame=CGRectMake(10, 360, 150, 50);
        self.twitterButton.frame=CGRectMake(161, 360, 150, 50);
    }
    else{
        self.directView.frame= CGRectMake(0,5, self.view.frame.size.width, self.view.frame.size.height-20);
        self.follwerView.frame=CGRectMake(0, 0, self.directView.bounds.size.width, self.directView.bounds.size.height);
        self.scrollView.frame= CGRectMake(0, 0, self.follwerView.bounds.size.width, self.follwerView.bounds.size.height);
        photoImageView.frame= CGRectMake(20.0f, 0.0f, 280.0f, 200.0f);
       
        tagView.frame= CGRectMake(10, 250, self.scrollView.bounds.size.width-20,50);
        tagButton.frame=CGRectMake(10, 5, 40, 40);
        tagLabel.frame= CGRectMake(55, 0,150 , 50);
        tagPeopleLabel.frame= CGRectMake(195, 0,150 , 50);
        placeview.frame= CGRectMake(10, 302, self.scrollView.bounds.size.width-20,50);
        addLocationlbl.frame= CGRectMake(20, 0,150 , 50);
        toggle.frame= CGRectMake(240, 305, 40, 20);
        self.fbButton.frame=CGRectMake(10, 353, 150, 50);
        self.twitterButton.frame=CGRectMake(161, 353, 150, 50);
        

    }
        
    UIButton * cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRectMake(10, 0, 60, 50);
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [cancel addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
     followers=[UIButton buttonWithType:UIButtonTypeCustom];
    followers.frame=CGRectMake(80, 0, 70, 50);
    [followers setTitle:@"Followers" forState:UIControlStateNormal];
    [followers setTitleColor:[UIColor colorWithRed:0.0/255.0 green:142.0/255.0 blue:218.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    followers.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [followers addTarget:self action:@selector(followersBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftBarBtn1 = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    UIBarButtonItem * leftBarBtn2 = [[UIBarButtonItem alloc] initWithCustomView:followers];
    
       self.navigationItem.leftBarButtonItems=@[leftBarBtn1,leftBarBtn2];
    
   direct=[UIButton buttonWithType:UIButtonTypeCustom];
    direct.frame=CGRectMake(140, 0, 50, 50);
    [direct setTitle:@"Direct" forState:UIControlStateNormal];
    direct.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [direct addTarget:self action:@selector(directBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * publish=[UIButton buttonWithType:UIButtonTypeCustom];
    publish.frame=CGRectMake(240, 0, 70, 50);
    [publish setTitle:@"Share" forState:UIControlStateNormal];
    publish.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [publish addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
     UIBarButtonItem * rightBarBtn1 =[[UIBarButtonItem alloc] initWithCustomView:direct];
     UIBarButtonItem * rightBarBtn2 =[[UIBarButtonItem alloc] initWithCustomView:publish];
    
    self.navigationItem.rightBarButtonItems=@[rightBarBtn2,rightBarBtn1];
    // self.navigationItem.leftBarButtonItems=@[leftBarBtn1,leftBarBtn2,rightBarBtn1,rightBarBtn2];

        [self shouldUploadImage:self.image];
}

-(void)locationdDisplay:(id)sender{
     if(toggle.on)
    {
        [self getlocation];
        self.placetxt=[[UITextField alloc]init];
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            self.placetxt.frame= CGRectMake(10, 363, self.view.bounds.size.width-20, 50);
        }
        else{
        self.placetxt.frame=CGRectMake(10, 353, self.view.bounds.size.width-20, 50);
        }
        placetxt.delegate=self;
        placetxt.backgroundColor=[UIColor whiteColor];
        placetxt.layer.cornerRadius=4.0f;
        [self.scrollView addSubview:placetxt];
        if (Area==nil) {
            [placetxt setEnabled:YES];
            placetxt.placeholder= @"      Name this Location";
        }
        else{
            [placetxt setEnabled:NO];
        }
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            self.fbButton.frame=CGRectMake(10, 413, 150, 50);
            self.twitterButton.frame=CGRectMake(161, 413, 150, 50);
        }
        else{
            self.fbButton.frame=CGRectMake(10, 403, 150, 50);
            self.twitterButton.frame=CGRectMake(161, 403, 150, 50);
        }
    }else{
        
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            self.placetxt.hidden=YES;
            self.fbButton.frame=CGRectMake(10, 360, 150, 50);
            self.twitterButton.frame=CGRectMake(161, 360, 150, 50);
        }
        else{
            self.placetxt.hidden=YES;
            self.fbButton.frame=CGRectMake(10, 353, 150, 50);
            self.twitterButton.frame=CGRectMake(161, 353, 150, 50);
        }

    }
}
-(void)fbShareButton:(UIButton *)button{
    if (self.fbToggle==0) {
        self.fbToggle=1;
        [self.fbButton setImage:[UIImage imageNamed:@"fbButtonActive.png"] forState:UIControlStateNormal];

    }else{
    
        self.fbToggle=0;
         [self.fbButton setImage:[UIImage imageNamed:@"fbButtonNormal.png"] forState:UIControlStateNormal];

    }

}
-(void)twitterButton:(UIButton *)button{
    if (self.twitterToggle==0) {
        self.twitterToggle=1;
       [self.twitterButton setImage:[UIImage imageNamed:@"twitterButtonActive.png"] forState:UIControlStateNormal];

    }else{
        
        self.twitterToggle=0;
        [self.twitterButton setImage:[UIImage imageNamed:@"twitterButtonNormal.png"] forState:UIControlStateNormal];

        
    }
}

-(void)tagPeople:(UIButton *)button{

    if (!tagPhoto) {
        tagPhoto=[[TagPhotoViewController alloc] init];
    }
    tagPhoto.delegate=self;
    tagPhoto.tagimage=self.image;
    
    [self.navigationController pushViewController:tagPhoto animated:YES];
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
    if(textField==placetxt||textField==commentTextField)
    {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	scrollView.frame = CGRectMake(scrollView.frame.origin.x, (scrollView.frame.origin.y-200 ), scrollView.frame.size.width, self.scrollView.frame.size.height);
        
	[UIView commitAnimations];
}

return YES;

}

-(void)sendDataToA:(NSArray *)taglistArray;
{
    
    tagMutArray=[[NSMutableArray alloc] init];
    [tagMutArray addObjectsFromArray:taglistArray];
    if (tagMutArray.count!=0) {
        [tagButton setImage:[UIImage imageNamed:@"tagpicSelected.png"] forState:UIControlStateNormal];
         tagPeopleLabel.frame=CGRectMake(170, 0,150 , 50);
        tagPeopleLabel.text=[NSString stringWithFormat:@"%lu people tagged",(unsigned long)tagMutArray.count];
    }
    NSLog(@"mutarray count %lu",(unsigned long)tagMutArray.count);

}


 -(void)sliderAction:(id)sender{
     NSLog(@"slider images");
     CGImageRef theCGImage;
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     CGContextRef context = CGBitmapContextCreate(nil, 30, 30, 8, 0, colorSpace,kCGBitmapByteOrder32Little );
     int x, y;
     
         // A gradient checkerboard, inside a rounded rect
     for (x = 5; x < 25; x+=2)
     {
         float b = (x - 5)/19.0*0.5+0.375;
         if (b > 0.75) b = 0.75;
         else if (b < 0.5) b = 0.5;
         
         for (y = 5; y < 25; y+=2)
         {
             float k = ((x ^ y) & 2) ? b : 1.0-b;
             CGContextSetRGBFillColor(context, k, k, k, k);
             CGContextFillRect(context, CGRectMake(x, y, 2, 2));
         }
     }
     
     CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
     CGContextMoveToPoint(context, 4, 15);
     CGContextAddArcToPoint(context, 4, 4, 15, 4, 4);
     CGContextAddArcToPoint(context, 26, 4, 26, 15, 4);
     CGContextAddArcToPoint(context, 26, 26, 15, 26, 4);
     CGContextAddArcToPoint(context, 4, 26, 4, 15, 4);
     CGContextClosePath(context);
     CGContextStrokePath(context);
 	theCGImage = CGBitmapContextCreateImage(context);
      self.image=[UIImage imageWithCGImage:theCGImage];
 }

//}
-(void)contrastAction:(id)sender{
    
}

#pragma mark - UITextFieldDelegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==commentTextField)
    {
    [self doneButtonAction:commentTextField];
    [commentTextField resignFirstResponder];
    }
        [placetxt resignFirstResponder];
    return YES;

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.commentTextField resignFirstResponder];  
}

-(void)brightnessControll:(id)sender{


}
#pragma mark - ()

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

//- (void)keyboardWillShow:(NSNotification *)note {
//    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGSize scrollViewContentSize = self.scrollView.bounds.size;
//    scrollViewContentSize.height += keyboardFrameEnd.size.height;
//    [self.scrollView setContentSize:scrollViewContentSize];
//    
//    CGPoint scrollViewContentOffset = self.scrollView.contentOffset;
//    // Align the bottom edge of the photo with the keyboard
//    scrollViewContentOffset.y = scrollViewContentOffset.y + keyboardFrameEnd.size.height*3.3f - [UIScreen mainScreen].bounds.size.height;
//    
//    [self.scrollView setContentOffset:scrollViewContentOffset animated:YES];
//}
//
//- (void)keyboardWillHide:(NSNotification *)note {
//   CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGSize scrollViewContentSize = self.scrollView.bounds.size;
//    scrollViewContentSize.height -= keyboardFrameEnd.size.height;
//    [UIView animateWithDuration:0.200f animations:^{
//        [self.scrollView setContentSize:scrollViewContentSize];
//    }];
//}

-(void)settingsButtonActions:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Publish To Timeline", nil), NSLocalizedString(@"Send Direct", nil), nil];
    
    [actionSheet showInView:self.view];

    
}
-(void)shareBtnClicked{
    
    if(self.follwerView.hidden==NO)
    {
        [self doneButtonAction:0];
    }
    else
    {
        if(directVC)
        {
            [directVC sendButtonClicked];
        }
    }
}


-(void)directMsg:(UIImage *)image{
    NSLog(@"fbid %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"fbid"]);
    NSString * fbid=[[NSUserDefaults standardUserDefaults]objectForKey:@"fbid"];
    NSString * toUsername;
    PFQuery * query=[PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"facebookId" equalTo:fbid];
    NSArray * arr=[query findObjects];
    for (int i=0; i<arr.count; i++) {
        PFObject * obj=[arr objectAtIndex:i];
        toUsername=obj[kPAPUserDisplayNameKey];
    }
   
    NSString * userid=[[PFUser currentUser]objectForKey:kPAPUserFacebookIDKey];
    NSString * fromname=[[PFUser currentUser]objectForKey:kPAPUserDisplayNameKey];
    
    PFObject *photo = [PFObject objectWithClassName:@"OneToOne"];
    [photo setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
    [photo setObject:fbid forKey:@"toUserFBID"];
    [photo setObject:userid forKey:@"fromUserFBID"];
    [photo setObject:toUsername forKey:@"toUserName"];
    [photo setObject:fromname forKey:@"fromUserName"];
    [photo setObject:photoFile forKey:kPAPPhotoPictureKey];
    [photo setObject:thumbnailFile forKey:kPAPPhotoThumbnailKey];
    
    
    // Create our Installation query
//    PFQuery *pushQuery = [PFInstallation query];
//    [pushQuery whereKey:@"facebookId" equalTo:fbid]; // Set channel
//    
//    
//    //     Send push notification to query
//    PFPush *push = [[PFPush alloc] init];
//    [push setQuery:pushQuery];
//    [push setMessage:@"sent photo "];
//    [push sendPushInBackground];
//
    
    
    
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
     [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonAction:(id)sender {
    
    if (self.fbToggle==1) {
        [self shareOnFacebook1];
    }
    
    
    NSDictionary *userInfo = [NSDictionary dictionary];
    NSString *trimmedComment = [self.commentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    trimmedComment,kPAPEditPhotoViewControllerUserInfoCommentKey,
                    nil];
    }
    //Place of photo teaken
    
    //      NSLog(@"image array count is %lu",(unsigned long)arrayOfImages.count);
    //
    
    // Make sure there were no errors creating the image files
    if (!self.photoFile || !self.thumbnailFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    // both files have finished uploading
    
    // create a photo object
    PFObject *photo = [PFObject objectWithClassName:kPAPPhotoClassKey];
    [photo setObject:[PFUser currentUser] forKey:kPAPPhotoUserKey];
    [photo setObject:self.photoFile forKey:kPAPPhotoPictureKey];
    [photo setObject:@"image" forKey:@"Type"];
    [photo setObject:self.thumbnailFile forKey:kPAPPhotoThumbnailKey];
    if(self.tagMutArray)
    {
        [photo setObject:self.tagMutArray forKey:@"TagList"];
    }
    
    if(Area!=nil)
    {
        //PFObject *comment = [PFObject objectWithClassName:kPAPActivityClassKey];
        [photo setObject:Area forKey:@"place"];
        // [photo saveEventually];
        //[[PAPCache sharedCache] incrementCommentCountForPhoto:photo];
        
    }
    else if(Area==nil){
        if(toggle.on)
        {
            Area=placetxt.text;
            [photo setObject:Area forKey:@"place"];
        }
        else{
//            [photo setObject:@"" forKey:@"place"];
        }
    }
    else{
    }
    
    // photos are public, but may only be modified by the user who uploaded them
    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    photo.ACL = photoACL;
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    // Save the Photo PFObject
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[PAPCache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
            
            // userInfo might contain any caption which might have been posted by the uploader
            if (userInfo) {
                NSString *commentText = [userInfo objectForKey:kPAPEditPhotoViewControllerUserInfoCommentKey];
                
                if (commentText && commentText.length != 0) {
                    // create and save photo caption
                    PFObject *comment = [PFObject objectWithClassName:kPAPActivityClassKey];
                    [comment setObject:kPAPActivityTypeComment forKey:kPAPActivityTypeKey];
                    [comment setObject:photo forKey:kPAPActivityPhotoKey];
                    [comment setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
                    [comment setObject:[PFUser currentUser] forKey:kPAPActivityToUserKey];
                    [comment setObject:commentText forKey:kPAPActivityContentKey];
                    
                    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                    [ACL setPublicReadAccess:YES];
                    comment.ACL = ACL;
                    
                    [comment saveEventually];
                    [[PAPCache sharedCache] incrementCommentCountForPhoto:photo];
                }
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:photo];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    if(self.twitterToggle==1){
        [self tweet];
    }
    else{
        [self.parentViewController dismissViewControllerAnimated:YES completion:^{
            [delegate callParentViewController];
        }];
        
    }
    //
}
- (void)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
-(void)shareOnFacebook{
    
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions",
                            @"user_photos",
                            nil];
    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    
    //imports an existing access token and opens a session with it.....
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error)
                        {
                            if(error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Problem connecting with Facebook" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                [alert show];
                            } else {
                                [self share];
                            }            
                        }];
        
                    }
-(void)share{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:self.image forKey:@"picture"];
   // FBRequest *request = [FBRequest requestWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST"];

     FBRequestConnection * con=[FBRequestConnection startForUploadPhoto:self.image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
          if(error)
          {
              NSLog(@"Error");
          }
     }];
    [con start];
}
*/



-(void)getlocation
{
    
    manager1=[[CLLocationManager alloc]init];
    manager1.delegate=self;
    manager1.desiredAccuracy=kCLLocationAccuracyBest;
    [manager1 startUpdatingLocation];
       NSLog(@"longitude %.7f",manager1.location.coordinate.longitude);
    NSLog(@"lattitude %.7f",manager1.location.coordinate.latitude);
    

    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation * curLocation=[locations objectAtIndex:0];
    [manager1 stopUpdatingLocation];
    
    
    CLGeocoder * coder=[[CLGeocoder alloc]init];
    [coder reverseGeocodeLocation:curLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error)
        {
            NSLog(@"Error in location finding %@",error);
        }
        else{
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//            NSLog(@"\nCurrent Location Detected\n");
//            NSLog(@"placemark %@",placemark);
            
            NSString*  Area1 = [[NSString alloc]initWithString:placemark.locality];
            
            NSString *Country = [[NSString alloc]initWithString:placemark.country];
            NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area1,Country];
            Area=[NSString stringWithFormat:@"%@, %@", Area1,Country];
//            NSLog(@"place in editphoto%@",CountryArea);
            placetxt.text=[NSString stringWithFormat:@"      %@",CountryArea];
           
        }
    }];
    
}

-(void)followersBtnClicked:(id)sender{
    directVC.view.hidden=YES;
[followers setTitleColor:[UIColor colorWithRed:0.0/255.0 green:142.0/255.0 blue:218.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [direct setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.follwerView.hidden=NO;
}

-(void)directBtnClicked:(id)sender{
    self.follwerView.hidden=YES;
    [direct setTitleColor:[UIColor colorWithRed:0.0/255.0 green:142.0/255.0 blue:218.0/255.0 alpha:1.0] forState:UIControlStateNormal];
     [followers setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if(!directVC)
    {
    directVC = [[PAPMessageViewController alloc] initWithImage:image];
        [self addChildViewController:directVC];
        self.directView.frame=CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
        [self.directView addSubview:directVC.view];
    }
    else{
        directVC.view.hidden=NO;
    }
//     directVC.delegate = self ;
}

#pragma mark ~share on twitter.
#pragma mark =================

- (void)tweet{
    if ([TWTweetComposeViewController canSendTweet]) {
        NSLog(@"I can send tweets.");
        
    } else {
        // Show Alert View When The Application Cannot Send Tweets
        NSString *message = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }
    
    TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
    
    // Settin The Initial Text
    [vc setInitialText:@"This tweet was sent using the new Twitter framework available in iOS 5."];
    //    UIImage *image1 = [UIImage imageNamed:@"4.png"];
    //[vc addImage:image1];
    [vc addImage:self.image];
    [self presentViewController:vc animated:YES completion:nil];
    vc.completionHandler = ^(TWTweetComposeViewControllerResult result){
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.parentViewController dismissViewControllerAnimated:YES completion:^{
                [delegate callParentViewController];
            }];
        }];
    };
    
    
    //    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark ~share on facebook.
#pragma mark =================
-(void)shareOnFacebook1{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //  appDelegate.delegate=self;
    
    if (!FBSession.activeSession.isOpen) {
        
        //        [self shareOnFacebook];
        
        [appDelegate openSessionWithLoginUI:self.image];
        
              [self  postImageToFB:self.image];
        
    }
    else{
        [self postImageToFB:self.image];
        
    }
    
    
}

#pragma mark - post to facebook

- (void) postImageToFB:(UIImage*)image1{
    
    
       UIImage *img1=image1;
    //UIImage *image1 = [UIImage imageNamed:@"globus.jpeg"];
    
    NSData* imageData = UIImageJPEGRepresentation(img1, 90);
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   imageData, @"source",nil];
    
//    NSLog(@"self.image is %@",image1);
//    
//    
//    NSLog(@"FBSession.activeSession.permissions is %@",FBSession.activeSession.permissions);
    [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         
         if (error == nil) {
             NSLog(@"Success");
           //  [[[UIAlertView alloc] initWithTitle:@"" message:@"Check your Facebook profile to see the photo"
                         //               delegate:self
                         //      cancelButtonTitle:@"OK!"
                          //     otherButtonTitles:nil] show];
         }
         else {
             NSLog(@"error is %@",error);
         }
         
     }];
    
}



@end
