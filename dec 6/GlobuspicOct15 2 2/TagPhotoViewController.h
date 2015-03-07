//
//  TagPhotoViewController.h
//  Anypic
//
//  Created by Sumit on 14/10/14.
//
//
#import "PAPHomeViewController.h"
#import <UIKit/UIKit.h>

@protocol senddataProtocol <NSObject>
-(void)sendDataToA:(NSArray *)taglistArray; //I am thinking my data is NSArray , you can use another object for store your information.
@end






@interface TagPhotoViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
//@property (assign) id <TagPhotoViewControllerDelegate> delegate;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *headingLabel ;
@property(nonatomic,strong) UILabel *tagLabel ;
@property(nonatomic,strong) UIButton *whoIsThis ;
@property(nonatomic,strong) UITextField *searchBox ;
@property (nonatomic,strong)NSMutableArray * searchResults;
@property (nonatomic,strong) UISearchBar * searchBar;
@property(nonatomic,assign) BOOL  srch;
@property(nonatomic,assign) BOOL selectedRow ; 
@property(nonatomic,strong)NSMutableArray *fbIdArray,*searchImg,*serchFbid;
@property(nonatomic,strong)NSMutableArray  *names ;
@property (nonatomic,strong)NSMutableArray *friends;
@property (nonatomic,strong) UITableView * tableView1;
@property(nonatomic,strong)  NSMutableArray *selectedFriendsArray ;
@property (nonatomic,strong)NSArray * recipes;
@property (nonatomic,strong)NSMutableArray *friendsphoto;
@property(nonatomic,strong)NSMutableArray *images1 ;
@property (nonatomic,strong)PFObject * obj;
@property (nonatomic,strong) UIView *tableHeaderView ; 
@property(nonatomic,strong) UIButton * search ;
@property(nonatomic,strong) UIButton * cancel ;
@property(nonatomic,strong)  UILabel *whoText ;
@property(nonatomic,strong) UIButton * close ;
@property(nonatomic,strong) UIButton *triangleButton ;
@property(nonatomic,strong)NSMutableArray *frameLocation,*filteredArray;
@property(nonatomic,strong)UIImage *tagimage;
@property(nonatomic,assign)id delegate;
@property(nonatomic,strong) NSMutableArray * userIDArray ; 


@end
