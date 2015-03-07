//
//  InboxViewController.h
//  Anypic
//
//  Created by Sumit on 04/09/14.
//
//

#import <UIKit/UIKit.h>
#import "customCell.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKitDefines.h>

//@interface InboxViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@interface InboxViewController :UITableView<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) UITableView *inboxTable;
//- (id)initWithStyle:(UITableViewStyle)style;

@end
