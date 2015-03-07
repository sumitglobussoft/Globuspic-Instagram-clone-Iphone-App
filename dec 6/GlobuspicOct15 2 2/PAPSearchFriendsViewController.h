//
//  PAPSearchFriendsViewController.h
//  Anypic
//
//  Created by Sumit Ghosh on 27/09/14.
//
//

#import <UIKit/UIKit.h>


@interface PAPSearchFriendsViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    UINavigationController * navigationCtrl;
    UITextField * searchBox;
    NSMutableArray * namesOfUser,* fbidArr, * searchResults,* userId,*objdetail,*images1,*searchImg,*srchDetail,*srchFbArr;
    UITableView * table1;
    NSMutableArray *user;
    NSMutableDictionary *dict;
   
    BOOL search;
  
    
}
@property(nonatomic,strong) PFObject * obj;
@end
