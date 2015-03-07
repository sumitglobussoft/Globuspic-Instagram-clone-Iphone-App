//
//  AppDelegate.m
//  Anypic
//
//  Created by Héctor Ramos on 5/04/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "PAPHomeViewController.h"
#import "PAPLogInViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "PAPAccountViewController.h"
#import "PAPWelcomeViewController.h"
#import "PAPActivityFeedViewController.h"
#import "PAPPhotoDetailsViewController.h"
#import "PAPExploreViewController.h"

@interface AppDelegate () {
    NSMutableData *_data;
    BOOL firstLaunch;
}
@property (nonatomic,strong)  PAPExploreViewController *exploreViewController;
@property (nonatomic, strong) PAPHomeViewController *homeViewController;
@property (nonatomic, strong) PAPActivityFeedViewController *activityViewController;
@property (nonatomic, strong) PAPWelcomeViewController *welcomeViewController;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;

- (void)setupAppearance;
- (BOOL)shouldProceedToMainInterface:(PFUser *)user;
- (BOOL)handleActionURL:(NSURL *)url;
@end

@implementation AppDelegate
@synthesize session ;
#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // ****************************************************************************
    [Parse setApplicationId:@"had0Idu7pIYDgc1C04KYS9CzcbITLPlVhohxRraX" clientKey:@"NqewKWzUiAcwQ5imq0bVNCNztP5z69mfHdDBk176"];
    [PFFacebookUtils initializeFacebook];
    // ****************************************************************************
    /*
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    */
    // Track app open.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }

//        [Flurry startSession:@"MMDN4MGR4RMRWZKSF5C3"];
    
//    PFACL *defaultACL = [PFACL ACL];
//    // Enable public read access by default, with any newly created PFObjects belonging to the current user
//    [defaultACL setPublicReadAccess:YES];
//    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

    // Set up our app's global UIAppearance
    [self setupAppearance];

    // Use Reachability to monitor connectivity
    [self monitorReachability];

    self.welcomeViewController = [[PAPWelcomeViewController alloc] init];

    self.navController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
    self.navController.navigationBarHidden = YES;
 
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];

    [self handlePush:launchOptions];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([self handleActionURL:url]) {
        return YES;
    }
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    PFUser *user = [PFUser currentUser] ;
    
    //    NSString *str=[[NSUserDefaults standardUserDefaults]objectForKey:@"connectedUserFbid"];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    //    [currentInstallation addUniqueObject:str forKey:@"channels"];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setObject:user forKey:@"userId"] ;
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	if (error.code != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"userinfo is %@",userInfo);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
            // Track app opens due to a push notification being acknowledged while the app wasn't active.
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    NSString *str=[userInfo valueForKey:@"p"];
    NSString *str1=[userInfo valueForKey:@"t"];
    NSString *followUserId=[userInfo valueForKey:@"fu"];
    
        //    NSLog(@"follow user id is %@",followUserId valueForKey: @"fromUser");
    
    if ([PFUser currentUser]) {
        if ([str isEqualToString:@"a"]) {
            
            if ([self.tabBarController viewControllers].count > PAPActivityTabBarItemIndex) {
                UITabBarItem *tabBarItem = [[self.tabBarController.viewControllers objectAtIndex:PAPActivityTabBarItemIndex] tabBarItem];
                
                NSString *currentBadgeValue = tabBarItem.badgeValue;
                
                if (currentBadgeValue && currentBadgeValue.length > 0) {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
                    NSNumber *newBadgeValue = [NSNumber numberWithInt:[badgeValue intValue] + 1];
                    tabBarItem.badgeValue = [numberFormatter stringFromNumber:newBadgeValue];
                } else {
                    tabBarItem.badgeValue = @"1";
                }
            }
        }
        else if ([str isEqualToString:@"i"]){
            
            
            NSInteger badge=[[NSUserDefaults standardUserDefaults]integerForKey:@"inboxBadge"];
            badge=badge + 1;
            [[NSUserDefaults standardUserDefaults]setInteger:badge forKey:@"inboxBadge"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"InboxNotification" object:nil];
        }
    }
    if ([str1 isEqualToString:@"f"]) {
            //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            // });
//        PFUser *user =(PFUser *)[PFQuery getObjectOfClass:@"_User" objectId:followUserId];
//        
//        [PAPUtility followUserEventually:user block:^(BOOL succeeded, NSError *error) {
//            if (!error) {
//                NSLog(@"saving current user");
//            }
//            else {
//                NSLog(@"error is  %@",error.description);
//            }
//        }];//block close
//    } // if f close
}
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckTimeForLife" object:nil];
    
    // Clear badge and update installation, required for auto-incrementing badges.
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }

    // Clears out all notifications from Notification Center.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 1;
    application.applicationIconBadgeNumber = 0;
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)aTabBarController shouldSelectViewController:(UIViewController *)viewController {
    // The empty UITabBarItem behind our Camera button should not load a view controller
    return ![viewController isEqual:aTabBarController.viewControllers[PAPEmptyTabBarItemIndex]];
}


#pragma mark - PFLoginViewController

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    // user has logged in - we need to fetch all of their Facebook data before we let them in
    if (![self shouldProceedToMainInterface:user]) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.navController.presentedViewController.view animated:YES];
        self.hud.labelText = NSLocalizedString(@"Loading", nil);
        self.hud.dimBackground = YES;
    }
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [self facebookRequestDidLoad:result];
        } else {
            [self facebookRequestDidFailWithError:error];
        }
    }];
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [PAPUtility processFacebookProfilePictureData:_data];
}


#pragma mark - AppDelegate

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    PAPLogInViewController *loginViewController = [[PAPLogInViewController alloc] init];
    [loginViewController setDelegate:self];
    loginViewController.fields = PFLogInFieldsFacebook;
    loginViewController.facebookPermissions = @[ @"user_about_me",@"user_friends",@"publish_actions",@"publish_stream" ];
    NSLog(@"FBSession.activeSession.permissions is %@",FBSession.activeSession.permissions);
    [self.welcomeViewController presentViewController:loginViewController animated:NO completion:nil];
}

- (void)presentLoginViewController {
    [self presentLoginViewControllerAnimated:YES];
}

- (void)presentTabBarController {    
    self.tabBarController = [[PAPTabBarController alloc] init];
    self.exploreViewController=[[PAPExploreViewController alloc]init];
    self.homeViewController = [[PAPHomeViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.homeViewController setFirstLaunch:firstLaunch];
    self.activityViewController = [[PAPActivityFeedViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    UINavigationController *emptyNavigationController = [[UINavigationController alloc] init];
    UINavigationController *activityFeedNavigationController = [[UINavigationController alloc] initWithRootViewController:self.activityViewController];
    UINavigationController *exploreNavigationViewController=[[UINavigationController alloc]initWithRootViewController:self.exploreViewController];
    
    [PAPUtility addBottomDropShadowToNavigationBarForNavigationController:homeNavigationController];
    [PAPUtility addBottomDropShadowToNavigationBarForNavigationController:emptyNavigationController];
    [PAPUtility addBottomDropShadowToNavigationBarForNavigationController:activityFeedNavigationController];
     [PAPUtility addBottomDropShadowToNavigationBarForNavigationController:exploreNavigationViewController];
    
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Home", @"Home") image:[[UIImage imageNamed:@"home_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeTabBarItem setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor colorWithRed:45.0f/255.0f green:125.0f/255.0f blue:159.0f/255.0f alpha:1.0f] } forState:UIControlStateNormal];
    [homeTabBarItem setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor colorWithRed:45.0f/255.0f green:125.0f/255.0f blue:159.0f/255.0f alpha:1.0f] } forState:UIControlStateSelected];
    
    
    UITabBarItem *exploreTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Explore",@"Explore") image:[[UIImage imageNamed:@"explorer_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"explorer.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [exploreTabBarItem setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor colorWithRed:45.0f/255.0f green:125.0f/255.0f blue:159.0f/255.0f alpha:1.0f] } forState:UIControlStateNormal];
    [exploreTabBarItem setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor colorWithRed:45.0f/255.0f green:125.0f/255.0f blue:159.0f/255.0f alpha:1.0f] } forState:UIControlStateSelected];

    
    
    UITabBarItem *activityFeedTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Activity", @"Activity") image:[[UIImage imageNamed:@"chat_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"chat_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [activityFeedTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:45.0f/255.0f green:125.0f/255.0f blue:159.0f/255.0f alpha:1.0f] } forState:UIControlStateNormal];
    [activityFeedTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:45.0f/255.0f green:125.0f/255.0f blue:159.0f/255.0f alpha:1.0f] } forState:UIControlStateSelected];
    
    [homeNavigationController setTabBarItem:homeTabBarItem];
    [activityFeedNavigationController setTabBarItem:activityFeedTabBarItem];
    [exploreNavigationViewController setTabBarItem:exploreTabBarItem];
    
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[ homeNavigationController, emptyNavigationController, activityFeedNavigationController,exploreNavigationViewController];
    
    [self.navController setViewControllers:@[ self.welcomeViewController, self.tabBarController ] animated:NO];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
        
    // Download user's profile picture
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
}

- (void)logOut {
    // clear cache
    [[PAPCache sharedCache] clear];

    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"toggle"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    [self.navController popToRootViewControllerAnimated:NO];
    
    [self presentLoginViewController];
    
    self.homeViewController = nil;
    self.activityViewController = nil;
}


#pragma mark - ()

// Set up appearance parameters to achieve Anypic's custom look and feel
- (void)setupAppearance {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.750f];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);

    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.498f green:0.388f blue:0.329f alpha:1.0f]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                NSShadowAttributeName: shadow
                                }];

        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"]
              forBarMetrics:UIBarMetricsDefault];
      
    
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f]
     forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                NSForegroundColorAttributeName:
                                    [UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f],
                                NSShadowAttributeName: shadow
                                }
                                                forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:32.0f/255.0f green:19.0f/255.0f blue:16.0f/255.0f alpha:1.0f]];
}

- (void)monitorReachability {
    Reachability *hostReach = [Reachability reachabilityWithHostname:@"api.parse.com"];

    hostReach.reachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
        
        if ([self isParseReachable] && [PFUser currentUser] && self.homeViewController.objects.count == 0) {
            // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
            // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
            [self.homeViewController loadObjects];
        }
    };
    
    hostReach.unreachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
    };
    
    [hostReach startNotifier];
}

- (void)handlePush:(NSDictionary *)launchOptions {

    // If the app was launched in response to a push notification, we'll handle the payload here
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:remoteNotificationPayload];
        
        if (![PFUser currentUser]) {
            return;
        }
                
        // If the push notification payload references a photo, we will attempt to push this view controller into view
        NSString *photoObjectId = [remoteNotificationPayload objectForKey:kPAPPushPayloadPhotoObjectIdKey];
        if (photoObjectId && photoObjectId.length > 0) {
            [self shouldNavigateToPhoto:[PFObject objectWithoutDataWithClassName:kPAPPhotoClassKey objectId:photoObjectId]];
            return;
        }
        
        // If the push notification payload references a user, we will attempt to push their profile into view
        NSString *fromObjectId = [remoteNotificationPayload objectForKey:kPAPPushPayloadFromUserObjectIdKey];
        if (fromObjectId && fromObjectId.length > 0) {
            PFQuery *query = [PFUser query];
            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
            [query getObjectInBackgroundWithId:fromObjectId block:^(PFObject *user, NSError *error) {
                if (!error) {
                    UINavigationController *homeNavigationController = self.tabBarController.viewControllers[PAPHomeTabBarItemIndex];
                    self.tabBarController.selectedViewController = homeNavigationController;
                    
                    PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
                    accountViewController.user = (PFUser *)user;
                    [homeNavigationController pushViewController:accountViewController animated:YES];
                }
            }];
        }
    }
}

- (void)autoFollowTimerFired:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
    [MBProgressHUD hideHUDForView:self.homeViewController.view animated:YES];
    [self.homeViewController loadObjects];
}

- (BOOL)shouldProceedToMainInterface:(PFUser *)user {
    if ([PAPUtility userHasValidFacebookData:[PFUser currentUser]]) {
        [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
        [self presentTabBarController];

        [self.navController dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    
    return NO;
}

- (BOOL)handleActionURL:(NSURL *)url {
    if ([[url host] isEqualToString:kPAPLaunchURLHostTakePicture]) {
        if ([PFUser currentUser]) {
            return [self.tabBarController shouldPresentPhotoCaptureController];
        }
    } else {
        if ([[url fragment] rangeOfString:@"^pic/[A-Za-z0-9]{10}$" options:NSRegularExpressionSearch].location != NSNotFound) {
            NSString *photoObjectId = [[url fragment] substringWithRange:NSMakeRange(4, 10)];
            if (photoObjectId && photoObjectId.length > 0) {
                [self shouldNavigateToPhoto:[PFObject objectWithoutDataWithClassName:kPAPPhotoClassKey objectId:photoObjectId]];
                return YES;
            }
        }
    }

    return NO;
}

- (void)shouldNavigateToPhoto:(PFObject *)targetPhoto {
    for (PFObject *photo in self.homeViewController.objects) {
        if ([photo.objectId isEqualToString:targetPhoto.objectId]) {
            targetPhoto = photo;
            break;
        }
    }
    
    // if we have a local copy of this photo, this won't result in a network fetch
    [targetPhoto fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            UINavigationController *homeNavigationController = [[self.tabBarController viewControllers] objectAtIndex:PAPHomeTabBarItemIndex];
            [self.tabBarController setSelectedViewController:homeNavigationController];
            
            PAPPhotoDetailsViewController *detailViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:object];
            [homeNavigationController pushViewController:detailViewController animated:YES];
        }
    }];
}

- (void)facebookRequestDidLoad:(id)result {
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    PFUser *user = [PFUser currentUser];
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"toggle"];
    NSLog(@"str is === %@",str);
    
    if ([str isEqualToString:@"Off"]|| str == nil) {
        [user setObject:@"Off" forKey:@"toggle"];
    }else{
        
    }
//    PFObject * obj=[arr objectAtIndex:i];
//    [obj setObject:@"Yes" forKey:@"followRequest"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"Off" forKey:@"toggle"];
//    [[NSUserDefaults standardUserDefaults]synchronize];

    
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            if (friendData[@"id"]) {
                [facebookIds addObject:friendData[@"id"]];
            }
        }
        NSLog(@"facebook ID count %lu",(unsigned long)facebookIds.count);
        // cache friend data
        [[PAPCache sharedCache] setFacebookFriends:facebookIds];
        
        if (user) {
            if ([user objectForKey:kPAPUserFacebookFriendsKey]) {
                [user removeObjectForKey:kPAPUserFacebookFriendsKey];
            }
            
            if (![user objectForKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey]) {
                self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                firstLaunch = YES;
                
                [user setObject:@YES forKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey];
                NSError *error = nil;
                
                // find common Facebook friends already using Anypic
                PFQuery *facebookFriendsQuery = [PFUser query];
                [facebookFriendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookIds];
                
                // auto-follow Parse employees
                PFQuery *parseEmployeesQuery = [PFUser query];
                [parseEmployeesQuery whereKey:kPAPUserFacebookIDKey containedIn:kPAPParseEmployeeAccounts];
                
                // combined query
                PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:parseEmployeesQuery,facebookFriendsQuery, nil]];
                
                NSArray *anypicFriends = [query findObjects:&error];
                
                if (!error) {
                    [anypicFriends enumerateObjectsUsingBlock:^(PFUser *newFriend, NSUInteger idx, BOOL *stop) {
                        PFObject *joinActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
                        [joinActivity setObject:user forKey:kPAPActivityFromUserKey];
                        [joinActivity setObject:newFriend forKey:kPAPActivityToUserKey];
                        [joinActivity setObject:kPAPActivityTypeJoined forKey:kPAPActivityTypeKey];
                        
                        PFACL *joinACL = [PFACL ACL];
                        [joinACL setPublicReadAccess:YES];
                        joinActivity.ACL = joinACL;
                        
                        // make sure our join activity is always earlier than a follow
                        [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            [PAPUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
                                // This block will be executed once for each friend that is followed.
                                // We need to refresh the timeline when we are following at least a few friends
                                // Use a timer to avoid refreshing innecessarily
                                if (self.autoFollowTimer) {
                                    [self.autoFollowTimer invalidate];
                                }
                                
                                self.autoFollowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoFollowTimerFired:) userInfo:nil repeats:NO];
                            }];
                        }];
                    }];
                }
                
                if (![self shouldProceedToMainInterface:user]) {
                    [self logOut];
                    return;
                }
                
                if (!error) {
                    [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:NO];
                    if (anypicFriends.count > 0) {
                        self.hud = [MBProgressHUD showHUDAddedTo:self.homeViewController.view animated:NO];
                        self.hud.dimBackground = YES;
                        self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                    } else {
                        [self.homeViewController loadObjects];
                    }
                }
            }
            
            [user saveEventually];
        } else {
            NSLog(@"No user session found. Forcing logOut.");
            [self logOut];
        }
    } else {
        self.hud.labelText = NSLocalizedString(@"Creating Profile", nil);

        if (user) {
            NSString *facebookName = result[@"name"];
            [[NSUserDefaults standardUserDefaults]setObject:facebookName forKey:@"connectedUserName"];
            if (facebookName && [facebookName length] != 0) {
                [user setObject:facebookName forKey:kPAPUserDisplayNameKey];
            } else {
                [user setObject:@"Someone" forKey:kPAPUserDisplayNameKey];
            }
            
            NSString *facebookId = result[@"id"];
            [[NSUserDefaults standardUserDefaults]setObject:facebookId forKey:@"connectedUserFbid"];

            if (facebookId && [facebookId length] != 0) {
                [user setObject:facebookId forKey:kPAPUserFacebookIDKey];
            }
            
            [user saveEventually];
        }
        
//        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//            if (!error) {
//                [self facebookRequestDidLoad:result];
//            } else {
//                [self facebookRequestDidFailWithError:error];
//            }
//        }];
        FBRequest *friendsRequest = [FBRequest requestForGraphPath:@"/me/friends"];
        [ friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                              [self facebookRequestDidLoad:result];
                             } else {
                                [self facebookRequestDidFailWithError:error];
                            }
        }];
    }
}

- (void)facebookRequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if ([PFUser currentUser]) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            [self logOut];
        }
    }
}



#pragma -mark 
/*
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"Url== %@", url);
    return [FBSession.activeSession handleOpenURL:url];
    
}


-(BOOL)openSessionWithAllowLoginUI:(NSInteger)isLoginReq image:(UIImage *)image{
    
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"email",@"status_update",@"user_photos",@"user_birthday",@"user_about_me",@"user_friends",@"photo_upload",@"read_friendlists", nil];
    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    
    //imports an existing access token and opens a session with it.....
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
                    
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    NSLog(@"AccessToken==%@",accessToken);
                    
                    // [self shareOnFacebook];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    
                    
                    
                    [FBRequestConnection
                     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                       id<FBGraphUser> user,
                                                       NSError *error){
                         if(!error)
                         {
                             [self postImageToFB:image];
                         }
                     }];
                    
                }
                else{
                    
                    NSLog(@"Session not open==%@",error);
                }
                
                // Respond to session state changes,
                // ex: updating the view
            }];
    
    return YES;
}
-(void) shareOnFacebook{
    
    NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
    
    [params setObject:@"Hi" forKey:@"image"];
    
    //provides webdialog for apprequest.
    //
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            NSLog(@"result==%u",result);
            NSLog(@"Url==%@",resultUrl);
            if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
                NSLog(@"User cancel Request");
            }//End Result Check
            else{
                NSString *sss= [NSString stringWithFormat:@"%@",resultUrl];
                if ([sss rangeOfString:@"post_id"].location == NSNotFound) {
                    NSLog(@"User Cancel Share");
                }
                else{
                    NSLog(@"posted on wall");
                }
            }//End Else Block Result Check
        }
    }];
}

- (void) postImageToFB:(UIImage * )image{
    //UIImage *img1=[UIImage imageNamed:@"fb.jpeg"];
    UIImage *img1=image;
    
    NSData* imageData = UIImageJPEGRepresentation(img1, 90);
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"This image is posted from device library !", @"message",
                                    imageData, @"source",
                                    nil];
    
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              NSLog(@"error== %@",error);
                          }];
    
    
    
}
*/
#pragma mark~facebook share
#pragma mark================
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}


-(BOOL) openSessionWithLoginUI:(UIImage *)image {
    //[self closeSession];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"user_friends",@"publish_actions", nil];
    
    
    self.session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
                    //[NSThread detachNewThreadSelector:@selector(fetchFacebookGameFriends) toTarget:self withObject:nil];
                    FBAccessTokenData *tokenData= self.session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    NSLog(@"AccessToken==%@",accessToken);
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    
                    
                    
//                    if (image) {
//                        
//                        PAPEditPhotoViewController *pap = [PAPEditPhotoViewController alloc];
//                        [pap postImageToFB:image];
//                        
//                    }
                    
                    
                }
                else{
                    
                    NSLog(@"Session not open==%@",error);
                }
                
                // Respond to session state changes,
                // ex: updating the view
            }];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"Url== %@", url);
    return [FBSession.activeSession handleOpenURL:url];
}



@end
