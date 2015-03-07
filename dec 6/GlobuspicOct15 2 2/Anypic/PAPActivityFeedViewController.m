//
//  PAPActivityFeedViewController.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/9/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPActivityFeedViewController.h"
#import "PAPSettingsActionSheetDelegate.h"
#import "PAPActivityCell.h"
#import "PAPAccountViewController.h"
#import "PAPPhotoDetailsViewController.h"
#import "PAPBaseTextCell.h"
#import "PAPLoadMoreCell.h"
#import "PAPSettingsButtonItem.h"
#import "PAPFindFriendsViewController.h"
#import "MBProgressHUD.h"

@interface PAPActivityFeedViewController ()

@property (nonatomic, strong) PAPSettingsActionSheetDelegate *settingsActionSheetDelegate;
@property (nonatomic, strong) NSDate *lastRefresh;
@property (nonatomic, strong) UIView *blankTimelineView;
@end

@implementation PAPActivityFeedViewController

@synthesize settingsActionSheetDelegate;
@synthesize lastRefresh;
@synthesize blankTimelineView;
//@synthesize toggle ; 

#pragma mark - Initialization

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil];    
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // The className to query on
        self.parseClassName = kPAPActivityClassKey;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;

        // The number of objects to show per page
        self.objectsPerPage = 15;
        
//         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTimeNotification:) name:@"CheckTimeForLife" object:nil];
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [super viewDidLoad];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    self.tableView.backgroundView = texturedBackgroundView;

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    // Add Settings button
    self.navigationItem.rightBarButtonItem = [[PAPSettingsButtonItem alloc] initWithTarget:self action:@selector(settingsButtonAction:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveRemoteNotification:) name:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil];
    
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"inviteActivity.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(24.0f, 113.0f, 271.0f, 140.0f)];
    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];

    lastRefresh = [[NSUserDefaults standardUserDefaults] objectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"self.objects is %@",self.objects);
//    NSLog(@"self.objects.count is %lu",(unsigned long)self.objects.count);
    
    if (indexPath.row < self.objects.count) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        NSString *activityString = [PAPActivityFeedViewController stringForActivityType:(NSString*)[object objectForKey:kPAPActivityTypeKey]];

        PFUser *user = (PFUser*)[object objectForKey:kPAPActivityFromUserKey];
        NSString *nameString = NSLocalizedString(@"Someone", nil);
        if (user && [user objectForKey:kPAPUserDisplayNameKey] && [[user objectForKey:kPAPUserDisplayNameKey] length] > 0) {
            nameString = [user objectForKey:kPAPUserDisplayNameKey];
        }
        
        return [PAPActivityCell heightForCellWithName:nameString contentString:activityString];
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView reloadData] ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.objects.count) {
        PFObject *activity = [self.objects objectAtIndex:indexPath.row];
        if ([activity objectForKey:kPAPActivityPhotoKey]) {
            PAPPhotoDetailsViewController *detailViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:[activity objectForKey:kPAPActivityPhotoKey]];
            [self.navigationController pushViewController:detailViewController animated:YES];
        } else if ([activity objectForKey:kPAPActivityFromUserKey]) {
            PAPAccountViewController *detailViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
            [detailViewController setUser:[activity objectForKey:kPAPActivityFromUserKey]];

            
            NSString * str1 = [activity objectForKey:@"type"];
            if ([str1  isEqualToString: @"request"]) {
               detailViewController.requestCheck =  YES;
            }else{
               detailViewController.requestCheck =  NO;
            }
              [self.navigationController pushViewController:detailViewController animated:YES];
          
//            NSLog(@"str1 is %@",str1);
            }
    } else if (self.paginationEnabled) {
        // load more
//        [self loadNextPage];
    }
}


#pragma mark - PFQueryTableViewController
-(void) checkTimeNotification:(NSNotification *)notification{
    
    NSLog(@"Notification Received");
    //[self queryForTable];
    [self activityDateCompare];

}

-(void)activityDateCompare{
        
    lastRefresh = [[NSUserDefaults standardUserDefaults]objectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if(!lastRefresh)
    {
        lastRefresh=[NSDate date];
    }
    NSLog(@"%lu",(unsigned long)self.objects.count);
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        self.tableView.scrollEnabled = NO;
        self.navigationController.tabBarItem.badgeValue = nil;
        
        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;
            
            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
        
        NSUInteger unreadCount = 0;
        for (PFObject *activity in self.objects) {
            NSLog(@"creadte activity %@",[activity createdAt]);
            if ([lastRefresh compare:[activity createdAt]] == NSOrderedAscending && ![[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeJoined]) {
                unreadCount++;
            }
        }
        
        if (unreadCount > 0) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)unreadCount];
        } else {
            self.navigationController.tabBarItem.badgeValue = nil;
        }
        
        lastRefresh = [NSDate date];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:lastRefresh forKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
    }
}

- (PFQuery *)queryForTable {
    NSLog(@"query table");
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }

    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kPAPActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kPAPActivityFromUserKey notEqualTo:[PFUser currentUser]];
    [query whereKeyExists:kPAPActivityFromUserKey];
    [query includeKey:kPAPActivityFromUserKey];
    [query includeKey:kPAPActivityPhotoKey];
    [query orderByDescending:@"createdAt"];

    [query setCachePolicy:kPFCachePolicyNetworkOnly];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
//    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
//        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
//    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
   // [self activityDateCompare];
    
//            int newcount=(int)self.objects.count-count;
//            count=(int)self.objects.count;
//            NSLog(@"new count %d",newcount);
//        
//          self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)newcount];
        
//            NSString * msg=[NSString stringWithFormat:@"You got %d new activities",newcount];
//            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"New Activities." message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//            [alert show];
        
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"ActivityCell";
//    if (indexPath.row == self.objects.count) {
//        [self loadNextPage ];
//        
//    }

    PAPActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PAPActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }

    [cell setActivity:object];

    if ([lastRefresh compare:[object createdAt]] == NSOrderedAscending) {
        [cell setIsNew:YES];
    } else {
        [cell setIsNew:NO];
    }

    [cell hideSeparator:(indexPath.row == self.objects.count - 1)];

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
   }
    return cell;
}


#pragma mark - PAPActivityCellDelegate Methods

- (void)cell:(PAPActivityCell *)cellView didTapActivityButton:(PFObject *)activity {    
    // Get image associated with the activity
    PFObject *photo = [activity objectForKey:kPAPActivityPhotoKey];
    
    // Push single photo view controller
    PAPPhotoDetailsViewController *photoViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:photo];
    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)cell:(PAPBaseTextCell *)cellView didTapUserButton:(PFUser *)user {    
    // Push account view controller
    PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
}


#pragma mark - PAPActivityFeedViewController

+ (NSString *)stringForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:kPAPActivityTypeLike]) {
        return NSLocalizedString(@"liked your photo", nil);
    } else if ([activityType isEqualToString:kPAPActivityTypeFollow]) {
        return NSLocalizedString(@"started following you", nil);
    } else if ([activityType isEqualToString:kPAPActivityTypeComment]) {
        return NSLocalizedString(@"commented on your photo", nil);
    } else if ([activityType isEqualToString:kPAPActivityTypeJoined]) {
        return NSLocalizedString(@"joined Anypic", nil);
    }else if([activityType isEqualToString:@"request"]) {
        return NSLocalizedString(@"sent you request", nil);
    } else {
        return nil;
    }
}


#pragma mark - ()

- (void)settingsButtonAction:(id)sender {
    settingsActionSheetDelegate = [[PAPSettingsActionSheetDelegate alloc] initWithNavigationController:self.navigationController];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:settingsActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"My Profile", nil), NSLocalizedString(@"Find Friends", nil), NSLocalizedString(@"Log Out", nil), nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)inviteFriendsButtonAction:(id)sender {
    PAPFindFriendsViewController *detailViewController = [[PAPFindFriendsViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)applicationDidReceiveRemoteNotification:(NSNotification *)note {
    [self loadObjects];
}

@end
