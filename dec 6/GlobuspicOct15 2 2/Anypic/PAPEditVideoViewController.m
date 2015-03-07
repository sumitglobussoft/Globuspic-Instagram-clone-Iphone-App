//
//  PAPEditVideoViewController.m
//  Anypic
//
//  Created by Sumit on 02/09/14.
//
//

#import "PAPEditVideoViewController.h"
#import "PAPPhotoDetailsFooterView.h"
#import "PAPMessageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "TagPhotoViewController.h"
#import "PAPMessageViewController.h"
#import <Twitter/Twitter.h>

@interface PAPEditVideoViewController ()
{
    PAPMessageViewController   *directVC;
    MPMoviePlayerViewController* theMovie;
    NSURL *videoURl;
    UIButton *tagButton,*followers;
    UILabel *tagPeopleLabel, * tagLabel,*addLocationlbl;
    UIBarButtonItem * rightBarBtn1;
    TagPhotoViewController *phototag;
}

@property (nonatomic, strong) UIButton * direct;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITextField *commentTextField,* placetxt,* userPlace;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;

@property(nonatomic,strong) CLLocationManager * manager1;
@property(nonatomic,strong) NSString * Area;

@property(nonatomic,strong)UISwitch * toggle;
@property(nonatomic,strong) UIView * follwerView,* directView,*containerView,* tagView,* placeview;
@property(nonatomic)int fbToggle;
@property(nonatomic)int twitterToggle;

@property(nonatomic,strong)UIButton  *fbButton;
@property(nonatomic,strong)UIButton  *twitterButton;


//@property(nonatomic,strong)
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@end

@implementation PAPEditVideoViewController

@synthesize scrollView,videoFile;
@synthesize manager1,Area,toggle,follwerView,directView,containerView,tagView;
@synthesize image, placeview;
@synthesize photoFile;
@synthesize thumbnailFile,thumbnailImage;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId,array;
@synthesize commentTextField,placetxt,userPlace;

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    if(!follwerView)
    {
        self.follwerView=[[UIView alloc]init ];
        [self.view addSubview:follwerView];
        
        //self.scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        self.scrollView=[[UIScrollView alloc]init];
        
       // self.scrollView.backgroundColor=[UIColor redColor];
        self.scrollView.delegate = self;
        [self.follwerView addSubview:self.scrollView];
        CGRect footerRect = [PAPPhotoDetailsFooterView rectForView];
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            //footerRect.origin.y = photoImageView.frame.origin.y + photoImageView.frame.size.height;
            footerRect.origin.y=209.0f;
        }
        else{
        
        footerRect.origin.y = 203;
        }
        PAPPhotoDetailsFooterView *footerView = [[PAPPhotoDetailsFooterView alloc] initWithFrame:footerRect];
        self.commentTextField = footerView.commentField;
        self.commentTextField.delegate = self;
        [self.scrollView addSubview:footerView];
        [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height*1.1)];
        
            //tag People Design
        /*tagView=[[UIView alloc]init];
                
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
        [tagView addSubview:tagPeopleLabel];*/
//        tagPeopleLabel.hidden=YES;

            //Add location View design
        placeview=[[UIView alloc]init];
        placeview.backgroundColor=[UIColor whiteColor];
        placeview.layer.cornerRadius=4.0f;
        [self.scrollView addSubview:placeview];
        
        addLocationlbl=[[UILabel alloc]init];
        addLocationlbl.text=@"Add your Location";
        [addLocationlbl setTextColor:[UIColor blackColor]];
        [placeview addSubview:addLocationlbl];
        
        
        toggle=[[UISwitch alloc]init];
        [toggle addTarget:self action:@selector(locationdDisplay:) forControlEvents:UIControlEventValueChanged];
        toggle.onTintColor=[UIColor greenColor];
        [self.scrollView addSubview:toggle];
        
        
            //FBButton and twitter button View
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
        self.follwerView.frame= CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        self.scrollView.frame= CGRectMake(0.0, 0.0, self.follwerView.bounds.size.width, self.follwerView.bounds.size.height);
        //tagView.frame= CGRectMake(10, 250, self.scrollView.bounds.size.width-20,50);
        //tagButton.frame=CGRectMake(10, 5, 40, 40);
       // tagLabel.frame= CGRectMake(55, 0,150 , 50);
        //tagPeopleLabel.frame= CGRectMake(195, 0,150 , 50);
        placeview.frame= CGRectMake(10, 252, self.scrollView.bounds.size.width-20,50);
        addLocationlbl.frame= CGRectMake(20, 0,150 , 50);
        toggle.frame= CGRectMake(240, 262, 40, 20);
        self.fbButton.frame=CGRectMake(10, 302, 150, 50);
        self.twitterButton.frame=CGRectMake(161, 302, 150, 50);
    }
    else{
        self.follwerView.frame= CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        self.scrollView.frame= CGRectMake(0.0, 0.0, self.follwerView.bounds.size.width, self.follwerView.bounds.size.height);
        //tagView.frame= CGRectMake(10, 250, self.scrollView.bounds.size.width-20,50);
        //tagButton.frame=CGRectMake(10, 5, 40, 40);
       // tagLabel.frame= CGRectMake(55, 0,150 , 50);
       // tagPeopleLabel.frame= CGRectMake(195, 0,150 , 50);
        placeview.frame= CGRectMake(10, 252, self.scrollView.bounds.size.width-20,50);
        addLocationlbl.frame= CGRectMake(20, 0,150 , 50);
        toggle.frame= CGRectMake(240, 253, 40, 20);
         self.fbButton.frame=CGRectMake(10, 302, 150, 50);
        self.twitterButton.frame=CGRectMake(161, 302, 150, 50);

    }
    
    
#pragma mark -
#pragma UIBarButtonItemDesign 
    UIButton * cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRectMake(10, 0, 60, 50);
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [cancel addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    followers=[UIButton buttonWithType:UIButtonTypeCustom];
    followers.frame=CGRectMake(80, 0, 70, 50);
    [followers setTitle:@"Followers" forState:UIControlStateNormal];
    [followers setTitleColor:[UIColor colorWithRed:0.0/255.0 green:142.0/255.0 blue:218/255.0 alpha:1.0] forState:UIControlStateNormal];
    followers.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [followers addTarget:self action:@selector(followersBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftBarBtn1 = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    UIBarButtonItem * leftBarBtn2 = [[UIBarButtonItem alloc] initWithCustomView:followers];

    self.navigationItem.leftBarButtonItems=@[leftBarBtn1,leftBarBtn2];
    
    self.direct=[UIButton buttonWithType:UIButtonTypeCustom];
    self.direct.frame=CGRectMake(140, 0, 50, 50);
    [self.direct setTitle:@"Direct" forState:UIControlStateNormal];
    self.direct.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [self.direct addTarget:self action:@selector(directBttnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * publish=[UIButton buttonWithType:UIButtonTypeCustom];
    publish.frame=CGRectMake(240, 0, 70, 50);
    [publish setTitle:@"Share" forState:UIControlStateNormal];
    publish.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [publish addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
     rightBarBtn1 =[[UIBarButtonItem alloc] initWithCustomView:self.direct];
    UIBarButtonItem * rightBarBtn2 =[[UIBarButtonItem alloc] initWithCustomView:publish];
    
    self.navigationItem.rightBarButtonItems=@[rightBarBtn2,rightBarBtn1];

    [self shouldUploadVideo:self.urlstr];

   // NSLog(@"Video Url -==- %@",self.urlstr);
  
}
-(void)directBttnClicked:(UIButton *)button{
    follwerView.hidden=YES;
    [self.direct setTitleColor:[UIColor colorWithRed:0.0/255.0 green:142.0/255.0 blue:218/255.0 alpha:1.0] forState:UIControlStateNormal];
    [followers setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

//    self.direct.titleLabel.textColor=[UIColor blueColor];
    rightBarBtn1.tintColor=[UIColor blueColor];
    if(!directVC)
    {
        directVC = [[PAPMessageViewController alloc] initWithImage:self.thumbnail];
        directVC.videoFile=self.videoFile;
        directVC.videoUrl=self.urlstr;
        directVC.view.frame=CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
        [self addChildViewController:directVC];
        [self.view addSubview:directVC.view];
    }
    else{
        directVC.view.hidden=NO;
    }

}


-(void)cancelButtonAction:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)tagPeople:(UIButton *)button{

   
    
}

-(void)locationdDisplay:(id)sender{
    if(toggle.on)
    {
        [self getlocation];
        self.placetxt=[[UITextField alloc]init ];
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            self.placetxt.frame= CGRectMake(10, 303, self.view.bounds.size.width-20, 50);
        }
        else{
            self.placetxt.frame= CGRectMake(10, 303, self.view.bounds.size.width-20, 50);
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
            placetxt.text=[NSString stringWithFormat:@"  %@",Area];
        }
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            self.fbButton.frame=CGRectMake(10, 383, 150, 50);
            self.twitterButton.frame=CGRectMake(161, 383, 150, 50);
        }
        else{
            self.fbButton.frame=CGRectMake(10, 353, 150, 50);
            self.twitterButton.frame=CGRectMake(161, 353, 150, 50);
        }
    
         //self.fbButton.frame=CGRectMake(0, 400, 160, 50);
         //self.twitterButton.frame=CGRectMake(160, 400, 160, 50);
//        [self.scrollView  setContentOffset:CGPointMake(0, 450)];

    }else{
        //self.placetxt.hidden=YES;
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            self.placetxt.hidden=YES;
            self.fbButton.frame=CGRectMake(10, 313, 150, 50);
            self.twitterButton.frame=CGRectMake(161, 313, 150, 50);
        }
        else{
            self.placetxt.hidden=YES;
            self.fbButton.frame=CGRectMake(10, 303, 150, 50);
            self.twitterButton.frame=CGRectMake(161, 303, 150, 50);
        }

      //  self.fbButton.frame=CGRectMake(0, 350, 160, 50);
      //  self.twitterButton.frame=CGRectMake(160, 350, 160, 50);

        
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
        scrollView.frame=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
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
        scrollView.frame = CGRectMake(scrollView.frame.origin.x, (scrollView.frame.origin.y-180 ), scrollView.frame.size.width, self.scrollView.frame.size.height);
        
        [UIView commitAnimations];
    }
    
    return YES;
    
}
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

-(void)getlocation
{
    if (!manager1) {
        manager1=[[CLLocationManager alloc]init];
        manager1.delegate=self;
        manager1.desiredAccuracy=kCLLocationAccuracyBest;
        [manager1 startUpdatingLocation];
    }
   
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
     [followers setTitleColor:[UIColor colorWithRed:0.0/255.0 green:142.0/255.0 blue:218/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.direct setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    self.follwerView.hidden=NO;
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
    
    
//    // Create our Installation query
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

#pragma mark - ()

-(void)shouldPlayVideo{
   // You can download the data for the video through the SDK, or you can use the URL of the video stored on Parse.
    
    PFQuery *query = [PFQuery queryWithClassName:kPAPPhotoClassKey];
    
    [query whereKey:@"Type" equalTo:@"Video"];
    
   // [query whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
    
    [query orderByDescending:@"createdAt"];
    
    NSArray *ary = [query findObjects];
    
    NSLog(@"ary is %@",ary);
    
    for (int i=0; i<1; i++) {

        PFObject *obj = [ary objectAtIndex:0];
        
        PFFile *theFile = obj[@"image"];
        
        NSLog(@"%@",theFile.url);
        
  }
}

-(void )screenshotOfVideo{
  
    
    UIImage *image1  = [UIImage imageNamed:@"play_btn.png"]; //foreground image
    
    CGSize newSize = self.thumbnailImage.size;
    UIGraphicsBeginImageContext( newSize );
    
        // Use existing opacity as is
    [self.thumbnailImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
        // Apply supplied opacity if applicable
    [image1 drawInRect:CGRectMake(newSize.width/2-20,newSize.height/2-20,60,60) blendMode:kCGBlendModeNormal alpha:0.8];
    
    self.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        //    self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
}


-(BOOL)shouldUploadVideo:(NSURL *)anVideo{
    //- (BOOL)shouldUploadImage:(UIImage *)anImage {
    
    NSData *videoData = [NSData dataWithContentsOfURL:anVideo];
    @try {
        self.videoFile = [PFFile fileWithName:@"myFile.Mov" data:videoData];
        
        [self.videoFile saveInBackground];
        if (!videoFile) {
            return NO;
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception %@",exception);
    }
   
    
//}
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    [self.videoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.videoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
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
    
    // Make sure there were no errors creating the image files
    if (!self.videoFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    
    NSData *imgData= UIImageJPEGRepresentation(self.thumbnail,0.0);
    PFFile *file=[PFFile fileWithData:imgData];

    // both files have finished uploading
    
    // create a photo object
    
    PFObject *photo = [PFObject objectWithClassName:kPAPPhotoClassKey];
    [photo setObject:[PFUser currentUser] forKey:kPAPPhotoUserKey];
     [photo setObject:file forKey:@"thumbnail"];
       [photo setObject:self.videoFile forKey:kPAPPhotoPictureKey];
//    videoURl=[NSURL URLWithString:self.videoFile.url];
    [photo setObject:@"Video" forKey:@"Type"];
    
    
    
    
      if(Area!=nil)
    {
        //PFObject *comment = [PFObject objectWithClassName:kPAPActivityClassKey];
        [photo setObject:Area forKey:@"place"];
        
    }
    else if(Area==nil){
        if(toggle.on)
        {
            Area=placetxt.text;
            [photo setObject:Area forKey:@"place"];
        }
        else{
            
        }
    }
    else{
    }

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
        
        if (self.twitterToggle==1) {
       PFFile *file = photo[kPAPPhotoPictureKey];
          videoURl= [NSURL URLWithString:file.url]      ;
        
            [self tweet ];
        }
        else {
        
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    
    
    
    // Dismiss this screen
//   [self.parentViewController dismissViewControllerAnimated:YES completion:nil];

}

-(void)shareOnFacebook1{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //  appDelegate.delegate=self;
    
    if (!FBSession.activeSession.isOpen) {
        
            //        [self shareOnFacebook];
        
        [appDelegate openSessionWithLoginUI:self.image];
        
        [self  postVideoToFB];
        
    }
    else{
        [self postVideoToFB];
        
    }
    
    
}

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
    [vc setInitialText:@"This tweet"];
        //     [vc addURL:videoURl];
    [vc addURL:videoURl];
    
    [self presentViewController:vc animated:YES completion:nil];
        vc.completionHandler = ^(TWTweetComposeViewControllerResult result){
            
            [self dismissViewControllerAnimated:YES completion:^{
                    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
            }];

    };
        
        
//        [self dismissViewControllerAnimated:YES completion:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"callParent" object:nil];
//        }];

}
/*
-(void)tweet{
    SLComposeViewController * tweet=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
         [tweet setInitialText:@"hello"];
//        [tweet addURL:[NSURL URLWithString:@"files.parsetfss.com/6f563c45-fd64-479c-9d39-b309493666e3/tfss-765bd724-146c-4c4e-b0cb-7323fda58110-myFile.Mov"]];
    PFFile *file=[PFFile fileWithName:@"myfile.mov" data:[NSData dataWithContentsOfURL:self.urlstr]];
    NSURL *url=[NSURL URLWithString:file.url];
    NSLog(@"file url %@",file.url);
    NSLog(@"file.url %@",url);
    NSLog(@"self.url %@",self.urlstr);
    [tweet addURL:url];
     [self presentViewController:tweet animated:YES completion:nil];

}*/



-(void)postVideoToFB{
    
        //=====================khomesh

    NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_actions", nil];

    
    [FBSession.activeSession requestNewPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
        
        if (error) {
            NSLog(@"Error to permission = %@",error);
            
        }
        else{
            
            NSData *data2 = [NSData dataWithContentsOfURL:self.urlstr];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:data2, @"video.mov",@"video/quicktime", @"contentType", @"First Video", @"title",@"uploading video via iOS App", @"description", nil];
            
            FBRequest *uploadRequest =  [FBRequest requestWithGraphPath:@"me/videos" parameters:params HTTPMethod:@"POST"];
            
            [uploadRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                
                if (error) {
                    NSLog(@"Error to upload video = %@",error);
                }
                
                NSLog(@"Result = %@",result);
                
            }];
        }
        
    }];
    
    
}
-(void)contrastAction:(id)sender{
    
}

#pragma mark - UITextFieldDelegate

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self doneButtonAction:textField];
//    [textField resignFirstResponder];
//    return YES;
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.commentTextField resignFirstResponder];
}

-(void)brightnessControll:(id)sender{
    
    
}
#pragma mark - ()

-(void)viewDidAppear:(BOOL)animated{
       [self screenshotOfVideo];
    if (!theMovie) {
        theMovie  =
        [[MPMoviePlayerViewController alloc] initWithContentURL:self.urlstr];
        [theMovie.view setFrame:CGRectMake(20, 5, 280, 200)];
        [theMovie moviePlayer].shouldAutoplay=NO;
        [self.scrollView addSubview:theMovie.view];
    }
 
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver: self
//     selector: @selector(myMovieFinishedCallback:)
//     name: MPMoviePlayerPlaybackDidFinishNotification
//     object: theMovie];
    
}
@end
