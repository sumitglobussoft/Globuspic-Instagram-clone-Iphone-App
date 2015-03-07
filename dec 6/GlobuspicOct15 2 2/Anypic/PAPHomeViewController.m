//
//  PAPHomeViewController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/2/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPHomeViewController.h"
#import "PAPSettingsActionSheetDelegate.h"
#import "PAPSettingsButtonItem.h"
#import "PAPInboxButton.h"
#import "InboxTableView.h"
#import "PAPFindFriendsViewController.h"
#import "MBProgressHUD.h"
#import "JSBadgeView.h"

@interface PAPHomeViewController ()
{
    JSBadgeView *badgeView;
}
@property (nonatomic, strong) PAPSettingsActionSheetDelegate *settingsActionSheetDelegate;
@property (nonatomic, strong) UIView *blankTimelineView;
@end

@implementation PAPHomeViewController
@synthesize firstLaunch;
@synthesize settingsActionSheetDelegate;
@synthesize blankTimelineView;


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incrementBadgeCount:) name:@"InboxNotification" object:nil];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

    self.navigationItem.rightBarButtonItem = [[PAPSettingsButtonItem alloc] initWithTarget:self action:@selector(settingsButtonAction:)];
   self.navigationItem.leftBarButtonItem=[[PAPInboxButton alloc]initWithTarget:self action:@selector(inboxButtonAction:)];
    badgeView = [[JSBadgeView alloc] initWithParentView:self.navigationItem.leftBarButtonItem alignment:JSBadgeViewAlignmentTopRight];
    NSInteger badgeValue=[[NSUserDefaults standardUserDefaults]integerForKey:@"inboxBadge"];
    if (badgeValue==0) {
        badgeView.badgeText =nil;
    }
    else
        badgeView.badgeText = [NSString stringWithFormat:@"%zd", badgeValue];
    
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 33.0f, 96.0f, 253.0f, 173.0f);
    [button setBackgroundImage:[UIImage imageNamed:@"invitefriends.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSInteger badgeValue=[[NSUserDefaults standardUserDefaults]integerForKey:@"inboxBadge"];
    if (badgeValue==0) {
        badgeView.badgeText=nil;
    }else
        badgeView.badgeText = [NSString stringWithFormat:@"%zd", badgeValue];
    
}


-(void)incrementBadgeCount:(NSNotification *)notification {

    NSInteger badgeValue=[[NSUserDefaults standardUserDefaults]integerForKey:@"inboxBadge"];
        badgeView.badgeText = [NSString stringWithFormat:@"%zd", badgeValue];

}

#pragma mark - PFQueryTableViewController

-(void)inboxButtonAction:(id)sender{
    
    badgeView.badgeText=nil;
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"inboxBadge"];
    InboxTableView *inboxView=[[InboxTableView alloc] init];
    [self.navigationController pushViewController:inboxView animated:YES];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult] & !self.firstLaunch) {
        self.tableView.scrollEnabled = NO;
        
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
    }    
}


#pragma mark - ()

- (void)settingsButtonAction:(id)sender {
    self.settingsActionSheetDelegate = [[PAPSettingsActionSheetDelegate alloc] initWithNavigationController:self.navigationController];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self.settingsActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"My Profile",@"Find Friends",@"Log Out", nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}


- (void)inviteFriendsButtonAction:(id)sender {
    PAPFindFriendsViewController *detailViewController = [[PAPFindFriendsViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
