//
//  PAPEditProfileViewController.m
//  Anypic
//
//  Created by Sumit Ghosh on 06/09/14.
//
//

#import "PAPEditProfileViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ResizeAdditions.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "GameState.h"

//#import "customCell.h"

@interface PAPEditProfileViewController ()
{
    NSString *privacySetting;
    PFObject *object;
}
@end

@implementation PAPEditProfileViewController

@synthesize topview,scorlView,thirdview,nameText,website,bottomView,profolePic,scrolBottom,education,phono,email,user,orginalscale,mapview,manager1,locationName,Area,map;
@synthesize editable,profilePictureImageView,picker,Img,fileUploadBackgroundTaskId,photoFile,thumbnailFile,homeplace,workplace,toggle2;
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
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked)] ;
 

    
    ///TopView
    
    scorlView=[[UIScrollView alloc]init];
    [scorlView setContentSize:CGSizeMake(self.view.bounds.size.width, 570)];
    [self.view addSubview:self.scorlView];
    self.orginalscale=self.scorlView.center;
    
    topview=[[UIView alloc]init ];
    topview.backgroundColor=[UIColor whiteColor];
    [scorlView addSubview:topview];
    
    nameText=[[UITextField alloc]init] ;
    nameText.font=[UIFont systemFontOfSize:17.0f];
    [nameText setEnabled:NO];
       nameText.delegate=self;
    [self.topview addSubview:nameText];
    
    website=[[UITextField alloc]init];
    website.font=[UIFont systemFontOfSize:17.0f];
    website.delegate=self;
    [self.topview addSubview:website];
    
    
    education=[[UITextField alloc]init];
    education.font=[UIFont systemFontOfSize:17.0f];
    education.delegate=self;
    [education setEnabled:YES];
    [self.topview addSubview:education];

    
    UIImageView * seprator1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SeparatorTimeline.png"]];
    [topview addSubview:seprator1];
    
    UIImageView * seprator2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SeparatorTimeline.png"]];
   [topview addSubview:seprator2];
    

    
    UIView *profilePictureBackgroundView = [[UIView alloc] init];
    [profilePictureBackgroundView setBackgroundColor:[UIColor darkGrayColor]];
    profilePictureBackgroundView.alpha = 0.0f;
    CALayer *layer = [profilePictureBackgroundView layer];
    layer.cornerRadius = 10.0f;
    layer.masksToBounds = YES;
    [self.topview addSubview:profilePictureBackgroundView];
    
    profilePictureImageView = [[PFImageView alloc] init];
    [self.topview addSubview:profilePictureImageView];
    [profilePictureImageView setContentMode:UIViewContentModeScaleAspectFill];
    layer = [profilePictureImageView layer];
    layer.cornerRadius = 10.0f;
    layer.masksToBounds = YES;
    profilePictureImageView.alpha = 0.0f;
   
    
    
    PFFile *imageFile = [[PFUser currentUser] objectForKey:kPAPUserProfilePicMediumKey];
    if (imageFile) {
        [profilePictureImageView setFile:imageFile];
        [profilePictureImageView loadInBackground:^(UIImage *image, NSError *error) {
            if (!error) {
                [UIView animateWithDuration:0.2f animations:^{
                    profilePictureBackgroundView.alpha = 1.0f;
                    
                    profilePictureImageView.alpha = 1.0f;
                }];
            }
        }];
    }
    
    
    //Bottom View
    bottomView=[[UIView alloc]init ];
    bottomView.backgroundColor=[UIColor whiteColor];
    [scorlView addSubview:bottomView];
    
    
    email=[[UITextField alloc]init ];
    email.font=[UIFont systemFontOfSize:17.0f];
    email.delegate=self;
   

    [self.bottomView addSubview:email];
    
    phono=[[UITextField alloc]init];
    phono.font=[UIFont systemFontOfSize:17.0f];
    phono.delegate=self;
   

    [self.bottomView addSubview:phono];
    
    
    UIImageView * seprator3=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SeparatorTimeline.png"]];
    [bottomView addSubview:seprator3];
        
        thirdview=[[UIView alloc]init];
        thirdview.backgroundColor=[UIColor whiteColor];
        [scorlView addSubview:thirdview];
        
        UIImageView * seprator4=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SeparatorTimeline.png"]];
        [thirdview addSubview:seprator4];
        
        homeplace=[[UITextField alloc]init];
        homeplace.font=[UIFont systemFontOfSize:17.0f];
        homeplace.delegate=self;
    
        
        [thirdview addSubview:homeplace];
        
        workplace=[[UITextField alloc]init];
        workplace.font=[UIFont systemFontOfSize:17.0f];
        workplace.delegate=self;
    
        [thirdview addSubview:workplace];
        
        
        UIImageView * user1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user.png"]];
        [topview addSubview:user1];
       
        UIImageView * web=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"website.png"]];
        [topview addSubview:web];

        UIImageView * mailid=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"email.png"]];
        [bottomView addSubview:mailid];
        
        UIImageView * phoicon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone.png"]];
        [bottomView addSubview:phoicon];
        
        UIImageView * work=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"workplace.png"]];
        [thirdview addSubview:work];
        
    
    UIButton * home=[UIButton buttonWithType: UIButtonTypeCustom];
    [home setImage:[UIImage imageNamed:@"home1.png"] forState:UIControlStateNormal];
    [home addTarget:self action:@selector(getlocation) forControlEvents:UIControlEventTouchUpInside];
    
        [thirdview addSubview:home];
        
        UIImageView * edu=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"education.png"]];
        [topview addSubview:edu];
        
        
    if([UIScreen mainScreen].bounds.size.height>500)
    {
        topview.frame=CGRectMake(0, 0, self.view.bounds.size.width, 180);
        nameText.frame=CGRectMake(25, 3, 190, 50);
        user1.frame=CGRectMake(2, 15, 20, 20);
        education.frame=CGRectMake(26, 63, 190, 50);
        edu.frame=CGRectMake(2, 78, 20, 20);
        website.frame=CGRectMake(28, 126, self.topview.bounds.size.width-30, 50);
        web.frame=CGRectMake(2, 139, 20, 20);
        
        seprator1.frame=CGRectMake(0, 60, 210, 1);
        seprator2.frame=CGRectMake(0, 120, self.topview.bounds.size.width, 1);
        bottomView.frame=CGRectMake(0, 190, self.view.bounds.size.width, 120);
        email.frame=CGRectMake(27, 3, self.bottomView.bounds.size.width-30, 50);
        mailid.frame=CGRectMake(2, 18, 20, 20);
        phono.frame=CGRectMake(25, 63, self.bottomView.bounds.size.width-30, 50);
        phoicon.frame=CGRectMake(2, 75, 20, 20);
        seprator3.frame=CGRectMake(0, 62, self.bottomView.bounds.size.width, 1);
        profilePictureBackgroundView.frame=CGRectMake( 220.0f, 10.0f, 90.0f, 90.0f);
        profilePictureImageView.frame=CGRectMake( 220.0f, 10.0f, 90.0f, 90.0f);
        scorlView.frame=CGRectMake(0, 5, self.view.bounds.size.width,self.view.bounds.size.height);
        thirdview.frame=CGRectMake(0, 320,self.view.bounds.size.width, 120);
        seprator4.frame=CGRectMake(0, 62, thirdview.bounds.size.width, 1);
        workplace.frame=CGRectMake(25, 3, thirdview.bounds.size.width-30, 50);
        work.frame=CGRectMake(2, 18, 20, 20);
        homeplace.frame=CGRectMake(25, 63, thirdview.bounds.size.width-30, 50);
        home.frame=CGRectMake(2, 75, 20, 20);


    }
    else{
        user1.frame=CGRectMake(2, 15, 20, 20);
        edu.frame=CGRectMake(2, 78, 20, 20);
        web.frame=CGRectMake(2, 139, 20, 20);
        mailid.frame=CGRectMake(2, 18, 20, 20);
        phoicon.frame=CGRectMake(2, 75, 20, 20);
        work.frame=CGRectMake(2, 18, 20, 20);
        home.frame=CGRectMake(2, 75, 20, 20);
        
        topview.frame=CGRectMake(0, 0, self.view.bounds.size.width, 180);
        nameText.frame=CGRectMake(25, 3, 190, 50);
        education.frame=CGRectMake(26, 63, 190, 50);
        website.frame=CGRectMake(25, 126, self.topview.bounds.size.width-30, 50);
        seprator1.frame=CGRectMake(0, 60, 210, 1);
        seprator2.frame=CGRectMake(0, 120, self.topview.bounds.size.width, 1);
        bottomView.frame=CGRectMake(0, 190, self.view.bounds.size.width, 120);
        email.frame=CGRectMake(25, 3, self.bottomView.bounds.size.width-30, 50);
        phono.frame=CGRectMake(25, 63, self.bottomView.bounds.size.width-30, 50);
        seprator3.frame=CGRectMake(0, 62, self.bottomView.bounds.size.width, 1);
        profilePictureBackgroundView.frame=CGRectMake( 220.0f, 10.0f, 90.0f, 90.0f);
        profilePictureImageView.frame=CGRectMake( 220.0f, 10.0f, 90.0f, 90.0f);
        scorlView.frame=CGRectMake(0, 5, self.view.bounds.size.width,self.view.bounds.size.height+20);
        
        thirdview.frame=CGRectMake(0, 320,self.view.bounds.size.width, 120);
        seprator4.frame=CGRectMake(0, 62, thirdview.bounds.size.width, 1);
        workplace.frame=CGRectMake(25, 3, thirdview.bounds.size.width-30, 50);
        homeplace.frame=CGRectMake(25, 63, thirdview.bounds.size.width-30, 50);
    }
    
    
    // add privacy settings button
    UIView * placeview=[[UIView alloc]initWithFrame:CGRectMake(0, 450, scorlView.bounds.size.width,50)];
    placeview.backgroundColor=[UIColor whiteColor];
    placeview.layer.cornerRadius=4.0f;
    [scorlView addSubview:placeview];
    
    
    UILabel * addLocationlbl=[[UILabel alloc]initWithFrame:CGRectMake(20, 0,150 , 50)];
    addLocationlbl.text=@"Privacy settings";
    [addLocationlbl setTextColor:[UIColor blackColor]];
    [placeview addSubview:addLocationlbl];
    
    toggle2=[[UISwitch alloc]initWithFrame:CGRectMake(240, 460, 40, 20)];
    [toggle2 addTarget:self action:@selector(privacySettings:) forControlEvents:UIControlEventValueChanged];
 NSString *srt=   [[NSUserDefaults standardUserDefaults]objectForKey:@"toggle"];
       //toggle.tintColor=[UIColor greenColor];
    if ([srt isEqualToString:@"On"]) {
        [toggle2 setOn:YES];
    }
    else{
        [toggle2 setOn:NO];
    }
    // toggle.thumbTintColor=[UIColor grayColor] ;
    toggle2.onTintColor=[UIColor blueColor];
    [scorlView addSubview:toggle2];

    
    
    PFQuery * get=[PFQuery queryWithClassName:@"_User"];
    [get whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    // NSArray * arr=[get findObjects];
    [get getObjectInBackgroundWithId:[[PFUser currentUser]objectId] block:^(PFObject *obj, NSError *error) {
        
        object=obj;
        if([[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]==nil|| [[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey] isEqualToString:@""])
        {
            nameText.text=@" User Name";
        }
        else{
            self.nameText.text=[NSString stringWithFormat:@"%@",[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]];
        }
       
        if([obj[@"website"]isEqualToString:@""]||obj[@"website"]==nil )
        {
            website.placeholder=@"Website";
        }
        else{
            website.text=[NSString stringWithFormat:@"%@",obj[@"website"]];
        }
        if([obj[@"education"]isEqualToString:@""]||obj[@"education"]==nil)
        {
            education.placeholder=@"Education";
        }
        else{
            education.text=[NSString stringWithFormat:@"%@",obj[@"education"]];
        }
        if([obj[@"email"] isEqualToString:@""]|| obj[@"email"]==nil)
        {
            email.placeholder=@"Email ID";
        }
        else{
           
            email.text=[NSString stringWithFormat:@"%@",obj[@"email"]];
            
        }
        if([obj[@"phoneno"]isEqualToString:@""]||obj[@"phoneno"]==nil)
        {
            phono.placeholder=@"Phone Number";
        }
        else{
            phono.text=[NSString stringWithFormat:@"%@",obj[@"phoneno"]];
        }
        if([obj[@"homePlace"]isEqualToString:@""]||obj[@"homePlace"]==nil)
        {
            homeplace.placeholder=@"Current Location";
        }
        else{
            homeplace.text=[NSString stringWithFormat:@"%@",obj[@"homePlace"]];
        }
        if([obj[@"workPlace"]isEqualToString:@""]||obj[@"workPlace"]==nil)
        {
            workplace.placeholder=@"work Place";
        }
        else{
            workplace.text=[NSString stringWithFormat:@"%@",obj[@"workPlace"]];
        }
        privacySetting=obj[@"followRequest"];
        if([privacySetting isEqualToString:@"No"])
        {
            [toggle2 setOn:YES];
        }
     }];
    
}
-(void)privacySettings:(id)sender{
   
    NSString *fbid=[[PFUser currentUser]objectForKey:kPAPUserFacebookIDKey];
                    if(toggle2.on)
                    {
                        NSLog(@"toggle is on");
//                        PFUser  *user = [PFUser currentUser];
                        PFQuery *query2 = [PFQuery queryWithClassName:@"_User"];
                        [query2 whereKey:@"facebookId" equalTo:fbid];
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            
                            NSArray * arr=[query2 findObjects];
                            for(int i=0;i<arr.count;i++)
                            {
                                
                                PFObject * obj=[arr objectAtIndex:i];
                                [obj setObject:@"No" forKey:@"followRequest"];
                                [obj saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
                                    
                                    if (succeed) {
                                        NSLog(@"Save to Parse");
                                    }
                                    else {
                                        NSLog(@"Error to Save == %@",error.localizedDescription);
                                    }
                                }];
                            }
                        });
                        [[NSUserDefaults standardUserDefaults]setObject:@"On" forKey:@"toggle"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }else{
                        NSLog(@"toggle is off");
//                        PFUser  *user = [PFUser currentUser];
                        PFQuery *query2 = [PFQuery queryWithClassName:@"_User"];
                        [query2 whereKey:@"facebookId" equalTo:fbid];
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            
                            NSArray * arr=[query2 findObjects];
                            for(int i=0;i<arr.count;i++)
                            {
                                
                                PFObject * obj=[arr objectAtIndex:i];
                                [obj setObject:@"Yes" forKey:@"followRequest"];
                                [obj saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
                                    
                                    if (succeed) {
                                        NSLog(@"Save to Parse");
                                    }
                                    else {
                                        NSLog(@"Error to Save == %@",error.localizedDescription);
                                    }
                                }];
                            }
                        });
                        [[NSUserDefaults standardUserDefaults]setObject:@"Off" forKey:@"toggle"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
//    self.scorlView.center = CGPointMake(self.orginalscale.x, self.orginalscale.y+50);
    if(textField==email || textField==phono || textField==workplace || textField==homeplace){
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	scorlView.frame = CGRectMake(scorlView.frame.origin.x, (scorlView.frame.origin.y - 170.0), scorlView.frame.size.width, scorlView.frame.size.height);
	[UIView commitAnimations];
    }
   /* if(textField==homeplace)
    {
        
        [self getlocation];
    }*/
    return YES;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
    if([UIScreen mainScreen].bounds.size.height>500)
    {
	 scorlView.frame=CGRectMake(0, 5, self.view.bounds.size.width,self.view.bounds.size.height);
    }
    else{
        scorlView.frame=CGRectMake(0, 5, self.view.bounds.size.width,self.view.bounds.size.height+20);
    }
	[UIView commitAnimations];

     return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)Edit{
    self.picker=[[UIImagePickerController alloc]init];
    self.picker.delegate=self;
    self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   // self.seletectedImg=[[UIImage alloc]init];
   self.Img=(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    self.profilePictureImageView.image=self.Img;
    //[self shouldUploadImage:self.Img];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)saveButtonClicked{
   
    NSString * EmailregexPat=@"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSRegularExpression *regex=[[NSRegularExpression alloc]initWithPattern:EmailregexPat options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger emailregmatch=[regex numberOfMatchesInString:email.text options:0 range:NSMakeRange(0, [email.text length])];

    // NSString * phoneregexPat=@"^(([2-9]{1})?)?(([0-9]{8,9})?)?$";
    NSString  * phoneregexPat=@"^(([2-9]{1})?)+(([0-9]{9,10})?)$";
    NSRegularExpression * regexPhone=[[NSRegularExpression alloc]initWithPattern:phoneregexPat options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger phoneregmatch=[regexPhone numberOfMatchesInString:phono.text options:0 range:NSMakeRange(0, phono.text.length)];
   
    

    NSString * mail;
    NSString * phoneno;
    
    if(emailregmatch!=0)
    {
         mail=email.text;
    }
    else{
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Email Id is not valid." message:@"Enter valid email id." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
        return;
    }
    if(phoneregmatch!=0)
    {
      phoneno =phono.text;
    }
    else{
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Phone number is not in format." message:@"Enter valid phone number." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

        return;
    }
    
    NSString * edu=education.text;
    NSString * web=website.text;
    
    
    NSString * work=workplace.text;
    NSString * home=homeplace.text;
    
    NSLog(@" user %@",[[PFUser currentUser]objectForKey:kPAPUserFacebookIDKey]);
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    NSArray * arr=[query findObjects];
    for(int i=0;i<arr.count;i++)
    {
    
        PFObject * obj=[arr objectAtIndex:i];
        obj[@"phoneno"]=phoneno;
        obj[@"education"]=edu;
        obj[@"website"]=web;
        [obj setObject:mail forKey:@"email"];
        [obj setObject:work forKey:@"workPlace"];
        [obj setObject:home forKey:@"homePlace"];
 
//        [obj setObject:self.photoFile forKey:kPAPUserProfilePicMediumKey];
//        [obj setObject:self.thumbnailFile forKey:kPAPUserProfilePicSmallKey];
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [obj saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
        
            if (succeed) {
                NSLog(@"Save to Parse");
            }
            if (error) {
                NSLog(@"Error to Save == %@",error.localizedDescription);
            }
        }];
    });
        
    }

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
    
     photoFile = [PFFile fileWithData:imageData];
     thumbnailFile = [PFFile fileWithData:thumbnailImageData];
     
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
                       
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                  
                }
                else{
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
                }
            }];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
   

    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameText resignFirstResponder];
    [self.education resignFirstResponder];
    [self.website resignFirstResponder];
    [self.email resignFirstResponder];
    [self.phono resignFirstResponder];
     [self.workplace resignFirstResponder];
     [self.homeplace resignFirstResponder];
    return YES;
}


-(void)getlocation
{
   // self.scorlView.hidden=YES;
    map=[[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:map];
    manager1=[[CLLocationManager alloc]init];
    manager1.delegate=self;
    manager1.desiredAccuracy=kCLLocationAccuracyBest;
    [manager1 startUpdatingLocation];
    self.mapview=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.map.bounds.size.width, self.map.bounds.size.height)];
    self.mapview.delegate=self;
    self.mapview.showsUserLocation=YES;
    NSLog(@"longitude %.7f",manager1.location.coordinate.longitude);
    NSLog(@"lattitude %.7f",manager1.location.coordinate.latitude);
   
    UIButton * cancel=[[UIButton alloc]initWithFrame:CGRectMake(map.bounds.size.width-60, 5, 70, 15)];
    [cancel setTitle:@"cancel" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelmethod) forControlEvents:UIControlEventTouchUpInside];
    [mapview addSubview:cancel];

    [map addSubview:mapview];
    
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
            NSLog(@"\nCurrent Location Detected\n");
            NSLog(@"placemark %@",placemark);
            //NSLog(@"lattitude %.7f",locationMgr.location.coordinate.latitude );
           // NSLog(@"longitude %.7f",locationMgr.location.coordinate.longitude);
            
            Area = [[NSString alloc]initWithString:placemark.locality];
            NSString *Country = [[NSString alloc]initWithString:placemark.country];
            NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
            NSLog(@"%@",CountryArea);
            self.homeplace.text=Area;
            
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = curLocation.coordinate;
            point.title =@"I m here..!";
            //point.subtitle =
            [self.mapview addAnnotation:point];
        }
    }];
    
}
-(void)cancelmethod{
    //[ self.map dismissViewControllerAnimated:YES completion:nil];
    self.map.hidden=YES;
}



@end
