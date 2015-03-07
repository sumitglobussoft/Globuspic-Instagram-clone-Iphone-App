//
//  PAPMessageViewController.h
//  Anypic
//
//  Created by Sumit Ghosh on 03/09/14.
//
//

#import <UIKit/UIKit.h>
#import "PAPActivityFeedViewController.h"
#import "PAPSettingsActionSheetDelegate.h"
//#import "PAPDirectViewController.h"
//#import "PAPFollowTableViewController.h"

#import "PAPProfileImageView.h"
#import "PAPLoadMoreCell.h"
#import "PAPAccountViewController.h"
#import "MBProgressHUD.h"
#import "PAPFindFriendsViewController.h"

@protocol callParentView1 <NSObject>
- (void)callParentViewController1;
@end


@interface PAPMessageViewController : UIViewController <PAPActivityCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,PAPFindFriendsCellDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>{

    NSMutableArray *fbIdArray,*searchImg,*images1;
    NSMutableArray *nameArray,*serchFbid;
    PFFile *photoFile;
    PFFile *videoFile;
    PFFile * thumbnailFile;
    UIImage * image;
    UITextView * textView1;
    UITextField * searchBox;
    BOOL searched;
}

@property(nonatomic,strong)  PFFile *videoFile;
@property(nonatomic,strong) UIImage *imageSet;
@property(nonatomic,strong) NSURL *videoUrl;
@property(nonatomic,strong) id delegate ; 
- (id)initWithImage:(UIImage *)aImage;
- (void)cancelButtonAction:(id)sender;
-(void) sendButtonClicked;

@end
