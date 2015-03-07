//
//  InboxTableView.h
//  Anypic
//
//  Created by Globussoft 1 on 9/8/14.
//
//

#import <UIKit/UIKit.h>
#import "TTTTimeIntervalFormatter.h"
static TTTTimeIntervalFormatter *timeFormatter;
@interface InboxTableView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray * arr;
}
@property(nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong)  PFQuery *followingActivitiesQuery ;
@property (nonatomic,strong)  PFQuery *photosFromCurrentUserQuery ;
@property (nonatomic,strong) PFQuery *query ;
@property(nonatomic,strong) PFQuery * query1 ;

@property(nonatomic,strong)UIRefreshControl * refreshControl;

@end
