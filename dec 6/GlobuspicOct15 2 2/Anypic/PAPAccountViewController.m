//
//  PAPAccountViewController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/2/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPAccountViewController.h"
#import "PAPPhotoCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "PAPLoadMoreCell.h"
#import "UIImage+ImageEffects.h"
#import "PAPEditProfileViewController.h"
#import "PAPUserPhotoViewController.h"
//#import "GameState.h"
#import "PAPSearchFriendsViewController.h"
//#import "PAPActivityFeedViewController.m"


@interface PAPAccountViewController(){

    NSString *privacySetting;
    BOOL requestSent;
}
@property (nonatomic, strong) UIView *headerView;
@end

@implementation PAPAccountViewController
@synthesize headerView,acccount;
@synthesize user1,request,toggle1,requestCheck,checkBox,wrongButton,checkBoxSelected,placeview,acceptRequest;

#pragma mark - Initialization

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.user) {
        [NSException raise:NSInvalidArgumentException format:@"user cannot be nil"];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered ;

    // self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 222.0f)];
    [self.headerView setBackgroundColor:[UIColor clearColor]]; // should be clear, this will be the container for our avatar, photo count, follower count, following count, and so on
    
    
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    self.tableView.backgroundView = texturedBackgroundView;
    
    UIView *profilePictureBackgroundView = [[UIView alloc] initWithFrame:CGRectMake( 15.0f, 34.0f, 70.0f, 70.0f)];
    [profilePictureBackgroundView setBackgroundColor:[UIColor darkGrayColor]];
    profilePictureBackgroundView.alpha = 0.0f;
    CALayer *layer = [profilePictureBackgroundView layer];
    layer.cornerRadius = 10.0f;
    layer.masksToBounds = YES;
    [self.headerView addSubview:profilePictureBackgroundView];
    
    // create UI for accepting the request .
    NSLog(@"self.request check is %d",self.requestCheck) ;

    
    if (self.requestCheck) {
        
//        if (!placeview) {
            placeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,40)];
            placeview.backgroundColor=[UIColor whiteColor];
            placeview.layer.cornerRadius=4.0f;
            [self.headerView addSubview:placeview];
        
        acceptRequest=[[UILabel alloc]initWithFrame:CGRectMake(20,-10,150 , 50)];
        acceptRequest.text=@"accept request ? ";
        [acceptRequest setTextColor:[UIColor redColor]];
        [self.headerView addSubview:acceptRequest];
    
        checkBox=[[UIButton alloc]initWithFrame:CGRectMake(230, 5, 40, 20) ];
        [checkBox addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
        [checkBox setImage:[UIImage imageNamed: @"Right-checkbox.png"] forState:UIControlStateNormal];
        [self.headerView addSubview:checkBox];
        
        wrongButton=[[UIButton alloc]initWithFrame:CGRectMake(270, 5, 40, 20) ];
        [wrongButton addTarget:self action:@selector(cancelFollow:) forControlEvents:UIControlEventTouchUpInside];
        [wrongButton setImage:[UIImage imageNamed: @"cancle-checkbox.png"] forState:UIControlStateNormal];
        [self.headerView addSubview:wrongButton];
//          }
    }
    
    PFImageView *profilePictureImageView = [[PFImageView alloc] initWithFrame:CGRectMake( 15.0f, 34.0f, 70.0f, 70.0f)];
    [self.headerView addSubview:profilePictureImageView];
    [profilePictureImageView setContentMode:UIViewContentModeScaleAspectFill];
    layer = [profilePictureImageView layer];
    layer.cornerRadius = 10.0f;
    layer.masksToBounds = YES;
    profilePictureImageView.alpha = 0.0f;
    UIImageView *profilePictureStrokeImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 13.0f, 33.0f, 74.0f, 73.0f)];
    profilePictureStrokeImageView.alpha = 0.0f;
    [profilePictureStrokeImageView setImage:[UIImage imageNamed:@"ProfilePictureStroke.png"]];
    [self.headerView addSubview:profilePictureStrokeImageView];
    
    NSLog(@"USerid %@",self.user);
    
    PFFile *imageFile = [self.user objectForKey:kPAPUserProfilePicMediumKey];
    if (imageFile) {
        [profilePictureImageView setFile:imageFile];
        [profilePictureImageView loadInBackground:^(UIImage *image, NSError *error) {
            if (!error) {
                [UIView animateWithDuration:0.2f animations:^{
                    profilePictureBackgroundView.alpha = 1.0f;
                    profilePictureStrokeImageView.alpha = 1.0f;
                    profilePictureImageView.alpha = 1.0f;
                }];
                
                UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[image applyLightEffect]];
                backgroundImageView.frame = self.tableView.backgroundView.bounds;
                backgroundImageView.alpha = 0.0f;
                [self.tableView.backgroundView addSubview:backgroundImageView];
                
                [UIView animateWithDuration:0.2f animations:^{
                    backgroundImageView.alpha = 1.0f;
                }];
            }
        }];
    }
    
   /* UIImageView *photoCountIconImageView = [[UIImageView alloc] initWithImage:nil];
    [photoCountIconImageView setImage:[UIImage imageNamed:@"IconPics.png"]];
    [photoCountIconImageView setFrame:CGRectMake( 170.0f, 30.0f, 45.0f, 37.0f)];
    [self.headerView addSubview:photoCountIconImageView];*/
    
    UIButton * photos=[[UIButton alloc]initWithFrame:CGRectMake( 170.0f, 30.0f, 45.0f, 37.0f)];
    photos.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"IconPics.png"]];
    [photos addTarget:self action:@selector(photosBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:photos];
    
    UILabel *photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 160.0f, 68.0f, 72.0f, 22.0f)];
    [photoCountLabel setTextAlignment:NSTextAlignmentCenter];
    [photoCountLabel setBackgroundColor:[UIColor clearColor]];
    [photoCountLabel setTextColor:[UIColor whiteColor]];
    [photoCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [photoCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [photoCountLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.headerView addSubview:photoCountLabel];
    
    UIImageView *followersIconImageView = [[UIImageView alloc] initWithImage:nil];
    [followersIconImageView setImage:[UIImage imageNamed:@"IconFollowers.png"]];
    [followersIconImageView setFrame:CGRectMake( 247.0f, 30.0f, 52.0f, 37.0f)];
    [self.headerView addSubview:followersIconImageView];
    
    UILabel *followerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 226.0f, 70.0f, self.headerView.bounds.size.width - 226.0f, 16.0f)];
    [followerCountLabel setTextAlignment:NSTextAlignmentCenter];
    [followerCountLabel setBackgroundColor:[UIColor clearColor]];
    [followerCountLabel setTextColor:[UIColor whiteColor]];
    [followerCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [followerCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [followerCountLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [self.headerView addSubview:followerCountLabel];
    
    UILabel *followingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 226.0f, 85.0f, self.headerView.bounds.size.width - 226.0f, 16.0f)];
    [followingCountLabel setTextAlignment:NSTextAlignmentCenter];
    [followingCountLabel setBackgroundColor:[UIColor clearColor]];
    [followingCountLabel setTextColor:[UIColor whiteColor]];
    [followingCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [followingCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [followingCountLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [self.headerView addSubview:followingCountLabel];
    
    UILabel *userDisplayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 135.0f, self.headerView.bounds.size.width, 22.0f)];
    //[userDisplayNameLabel setTextAlignment:NSTextAlignmentCenter];
    [userDisplayNameLabel setBackgroundColor:[UIColor clearColor]];
    [userDisplayNameLabel setTextColor:[UIColor whiteColor]];
    [userDisplayNameLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [userDisplayNameLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [userDisplayNameLabel setText:[self.user objectForKey:@"displayName"]];
    [userDisplayNameLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.headerView addSubview:userDisplayNameLabel];
    
    [photoCountLabel setText:@"0 photos"];
    
    PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
    [queryPhotoCount whereKey:kPAPPhotoUserKey equalTo:self.user];
    [queryPhotoCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [photoCountLabel setText:[NSString stringWithFormat:@"%d photo%@", number, number==1?@"":@"s"]];
            [[PAPCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:self.user];
        }    }];
    
    [followerCountLabel setText:@"0 followers"];
    
    PFQuery *queryFollowerCount = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryFollowerCount whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [queryFollowerCount whereKey:kPAPActivityToUserKey equalTo:self.user];
    [queryFollowerCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowerCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [followerCountLabel setText:[NSString stringWithFormat:@"%d follower%@", number, number==1?@"":@"s"]];
        }
    }];
    
    NSDictionary *followingDictionary = [[PFUser currentUser] objectForKey:@"following"];
    [followingCountLabel setText:@"0 following"];
    if (followingDictionary) {
        [followingCountLabel setText:[NSString stringWithFormat:@"%lu following", (unsigned long)[[followingDictionary allValues] count]]];
    }
    
    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryFollowingCount whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [queryFollowingCount whereKey:kPAPActivityFromUserKey equalTo:self.user];
    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [followingCountLabel setText:[NSString stringWithFormat:@"%d following", number]];
        }
    }];
    
    if (![[self.user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loadingActivityIndicatorView startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
        
        // check if the currentUser is following this user
        PFQuery *queryIsFollowing = [PFQuery queryWithClassName:kPAPActivityClassKey];
        [queryIsFollowing whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
        [queryIsFollowing whereKey:kPAPActivityToUserKey equalTo:self.user];
        [queryIsFollowing whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
        [queryIsFollowing setCachePolicy:kPFCachePolicyCacheThenNetwork];
        [queryIsFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error && [error code] != kPFErrorCacheMiss) {
                NSLog(@"Couldn't determine follow relationship: %@", error);
                
            } else {
                if (number == 0) {
                    if (!self.requestCheck) {
                        [self configureFollowButton];
                    }
                    
                } else {
                    [self configureUnfollowButton];
                }
            }
        }];
    }
    if([[self.user objectId]isEqualToString:[[PFUser currentUser] objectId]])
    {
        UIButton * editProfile=[[UIButton alloc]initWithFrame:CGRectMake(130, 110.0f, 180, 22.0f)];
        [editProfile setTitle:@"Edit Your Profile" forState:UIControlStateNormal];
        editProfile.backgroundColor=[UIColor lightGrayColor];
        [editProfile setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        editProfile.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        editProfile.alpha=0.6;
        editProfile.opaque=YES;
        editProfile.layer.cornerRadius=2.0;
        [editProfile addTarget:self action:@selector(EditProfile:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headerView addSubview:editProfile];
    }
    privacySetting=[self.user objectForKey:@"followRequest"];
}

-(void)showRequestSend{
    self.navigationItem.rightBarButtonItem.title=@"Request Sent";
    self.navigationItem.rightBarButtonItem.action=nil;
}

-(void)selectOption:(id)sender{
    
    NSLog(@"selected") ;
    
    placeview.hidden = YES ;
    acceptRequest.hidden = YES ;
    checkBox.hidden = YES ;
    wrongButton.hidden = YES ;
    
    //query to delete the follow request
    
    PFQuery *remove = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [remove whereKey:kPAPActivityTypeKey equalTo:@"request"];
    //    [remove whereKey:kPAPActivityToUserKey equalTo:self.user];
    //    [remove whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
    [remove whereKey:kPAPActivityToUserKey equalTo:[PFUser currentUser]];
    [remove whereKey:kPAPActivityFromUserKey equalTo:self.user];
    [remove getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"printe object %@",object);
        //        [object setObject:@"follow" forKey:kPAPActivityTypeKey];
        //       [object deleteInBackground];
        [object delete];
        //        [self.tableView reloadData];
    }];
    
    [PAPUtility followedUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"saving requested user");
        }
        else {
            NSLog(@"error is  %@",error.description);
        }
    }];
    [ PAPUtility followUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"saving current user");
        }
        else {
            NSLog(@"error is  %@",error.description);
        }
        
    }];
}

-(void)cancelFollow:(id)sender{
    
    placeview.hidden = YES ;
    acceptRequest.hidden = YES ;
    checkBox.hidden = YES ;
    wrongButton.hidden = YES ;
    
    NSLog(@"cancelled") ;
    //query to delete the follow request
    
    // set follow status to no in the cache .
    [[PAPCache sharedCache] setFollowStatus:NO user:self.user];
    
    PFQuery *remove = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [remove whereKey:kPAPActivityTypeKey equalTo:@"request"];
    [remove whereKey:kPAPActivityToUserKey equalTo:[PFUser currentUser]];
    [remove whereKey:kPAPActivityFromUserKey equalTo:self.user];
    
    [remove findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            NSLog(@"objects is %@",objects) ;
            
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];


}

-(void)EditProfile:(id)sender{
    PAPEditProfileViewController * editPro=[[PAPEditProfileViewController alloc]init];
    //[self presentViewController:editPro animated:YES completion:nil];
    [self.navigationController pushViewController:editPro animated:YES];
    
}

#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    self.tableView.tableHeaderView = headerView;
}

- (PFQuery *)queryForTable {
    if (!self.user) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query whereKey:kPAPPhotoUserKey equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    [query includeKey:kPAPPhotoUserKey];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleGray;
        cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}


#pragma mark - ()
-(void) getuserPermissionStatus{
    PFQuery * query=[PFQuery queryWithClassName:@"_User"];
   // [query orderByAscending:kPAPUserDisplayNameKey];
    
    user1=(NSMutableArray*)[query findObjects];
    
        for(int i=0;i<user1.count;i++)
       {
          PFObject *obj=[user1 objectAtIndex:i];
            NSLog(@"Object -==- %@",obj);
    
           NSString *str=[obj objectId];
            NSLog(@"object id %@",[obj objectId]);
            if(![str isEqualToString:[[PFUser currentUser]objectId]])
            {
               
                
                //NSLog(@"names of Array %@",namesOfUser);
            }
        }

    
}
-(void)getUserId{
    PFQuery * query=[PFQuery queryWithClassName:@"_User"];
    [query orderByAscending:kPAPUserDisplayNameKey];
    
    user1=(NSMutableArray*)[query findObjects];
    
    for (int i=0; i<user1.count; i++) {
        NSLog(@"user array is %@",user1[i]);
    }
}

- (void)followButtonAction:(id)sender {
  
    NSString *check = @"Yes" ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered ;
    NSLog(@"self.user %@",self.user);
    

    NSString * str=self.user [@"followRequest"];
    if([str isEqualToString:@"No"] /*|| [str isEqualToString:nil] */)
        {
            self.navigationItem.rightBarButtonItem.target = self ;
            self.navigationItem.rightBarButtonItem.title=@"Request Sent";
            requestSent=NO;
            [self conditionTOCheck:nil];
        }
        else{
            self.navigationItem.rightBarButtonItem.target = self ;
            self.navigationItem.rightBarButtonItem.title=@"Following";
            [self conditionTOCheck1:nil];
        }
            // }
        // }];
}


-(void)conditionTOCheck1:(id)sender{
    NSLog(@"do not store in parse") ;
    
    [[PAPCache sharedCache] setFollowStatus:YES user:self.user];
//    NSString *str=[self.user objectForKey:kPAPUserFacebookIDKey];
//    [[PAPCache sharedCache]setFacebookFriend:str];
    [PAPUtility followUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
        if (error) {
//            [self configureFollowButton];
            if (succeeded) {
                NSLog(@"succeded");
            }
        }
    }];

}

-(void)conditionTOCheck:(id)sender{
    NSLog(@"hi");
    
    PFObject *object = [PFObject objectWithClassName:kPAPActivityClassKey];
    [object setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
    NSLog(@"self.user is %@",self.user);
    [object setObject:self.user forKey:kPAPActivityToUserKey];
//    [object setObject:@"Yes" forKey:@"followRequest"];
    [object setObject:@"request" forKey:@"type"];
    //[object saveEventually];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [object saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
            
            if (succeed) {
                NSLog(@"Save to Parse");
            }
            if (error) {
                NSLog(@"Error to Save == %@",error.localizedDescription);
            }
        }];
    });

}

-(void) unfollowAction : (id)sender{
    
    
}

- (void)unfollowButtonAction:(id)sender {
    UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
    
    [self configureFollowButton];
    
    [PAPUtility unfollowUserEventually:self.user];
}



- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureFollowButton {
//         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];//WithTitle:@"Follow" style:UIBarButtonItemStyleBordered target:self action:@selector(followButtonAction:)];
    PFQuery *queryIsFollowing = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryIsFollowing whereKey:@"type" equalTo:@"request"];
    [queryIsFollowing whereKey:kPAPActivityToUserKey equalTo:self.user];
   [queryIsFollowing whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryIsFollowing setCachePolicy:kPFCachePolicyCacheThenNetwork];
        //[queryIsFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    [queryIsFollowing findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
        if(objects.count!=0) 
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
            self.navigationItem.rightBarButtonItem.target = self ;
            self.navigationItem.rightBarButtonItem.title = @"Request Sent";
////            [self conditionTOCheck:nil];
//            
        }
        else
{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
            self.navigationItem.rightBarButtonItem.target = self ;
            self.navigationItem.rightBarButtonItem.title=@"Follow";
            id sender;
            self.navigationItem.rightBarButtonItem.action=@selector(followButtonAction:);
            requestSent=YES;
        }
    }];

    [[PAPCache sharedCache] setFollowStatus:NO user:self.user];
    
}

- (void)configureUnfollowButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Unfollow" style:UIBarButtonItemStyleBordered target:self action:@selector(unfollowButtonAction:)];
    [[PAPCache sharedCache] setFollowStatus:YES user:self.user];
}

-(void)photosBtnClicked{
    
    PAPUserPhotoViewController * explore=[[PAPUserPhotoViewController alloc]init];
    explore.user1=self.user;
    [self.navigationController pushViewController:explore animated:YES];
}

@end