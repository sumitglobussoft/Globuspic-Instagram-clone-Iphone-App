//
//  InboxViewController.m
//  Anypic
//
//  Created by Sumit on 04/09/14.
//
//
#import "PAPHomeViewController.h"
#import "PAPSettingsActionSheetDelegate.h"
#import "PAPSettingsButtonItem.h"
#import "PAPFindFriendsViewController.h"
#import "MBProgressHUD.h"
#import "InboxViewController.h"
#import "PAPLoadMoreCell.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKitDefines.h>

@interface InboxViewController ()
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation InboxViewController
//@synthesize blankTimelineView;

@synthesize inboxTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // The className to query on
        self.parseClassName = @"OneToOne";
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageArray=[[NSMutableArray alloc] init];
//     [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self  retrieveOneToOneData];
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
   // self.inboxTable.backgroundView = texturedBackgroundView
    
    self.navigationItem.title=@"Inbox";

    inboxTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:inboxTable];
    inboxTable.dataSource=self;
    inboxTable.delegate=self;
    // Do any additional setup after loading the view.
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSInteger sections = self.objects.count;
//    if (self.paginationEnabled && sections != 0)
//        sections++;
//    return sections;
//}
#pragma mark - tableview Delegate methods .
#pragma mark===============

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
//    
//    PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
////    if (!cell) {
////        cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
////        cell.selectionStyle =UITableViewCellSelectionStyleGray;
////        cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
////        cell.hideSeparatorBottom = YES;
////        cell.mainView.backgroundColor = [UIColor clearColor];
////    }
//    return cell;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    
    customCell *cell = (customCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.userName.text=[self.imageArray objectAtIndex:indexPath.row ];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == self.objects.count && self.paginationEnabled) {
        // Load More Cell
        [self loadNextPage];
    }
}

-(void)retrieveOneToOneData{
    
//    NSString *username=[[NSUserDefaults standardUserDefaults]objectForKey:@"connectedUserName"];
    NSString *fbid=[[NSUserDefaults standardUserDefaults]objectForKey:@"connectedUserFbid"];
    
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:@"OneToOne"];
    [followingActivitiesQuery whereKey:@"toUserFBID" equalTo:fbid ];
    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:@"OneToOne"];
    [photosFromCurrentUserQuery whereKey:@"fromUserFBID" equalTo:fbid];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:followingActivitiesQuery, photosFromCurrentUserQuery, nil]];
//    [query includeKey:@"image"];
    [query orderByDescending:@"createdAt"];
      [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    NSArray *ary = [query findObjects];
    
    for (int i=0; i<ary.count; i++) {
        PFObject *obj = [ary objectAtIndex:i];
        NSLog(@"obj is %@",obj);
        PFFile *userImageFile = obj[@"image"];
        NSString *name=obj[@"fromUserName"];
          [self.imageArray addObject:name];
//        NSData *data= []
        
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
//                UIImage *image =[UIImage imageWithData:imageData];
//                [self.imageArray addObject:image];
                
            }
        }];
    }
    
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
