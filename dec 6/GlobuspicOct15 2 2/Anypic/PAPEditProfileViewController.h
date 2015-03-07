//
//  PAPEditProfileViewController.h
//  Anypic
//
//  Created by Sumit Ghosh on 06/09/14.
//
//

#import <UIKit/UIKit.h>
#import  <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface PAPEditProfileViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>

@property(nonatomic,strong) UITableView * editable;
@property(nonatomic,strong)UIView * topview, * bottomView,* thirdview,* map;
@property(nonatomic,strong)UIScrollView * scorlView, * scrolBottom;
@property(nonatomic,strong)UITextField   * nameText,* website,* education,*phono ,* email,* workplace,* homeplace;
@property(nonatomic,strong)UIImageView * profolePic;
@property(nonatomic,strong)PFUser * user;
@property(nonatomic,assign)CGPoint  orginalscale;
@property(nonatomic,strong) PFImageView *profilePictureImageView;
@property(nonatomic,strong)UIImagePickerController * picker;
@property(nonatomic,strong)UIImage * Img;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property(nonatomic,strong)PFFile * photoFile,*thumbnailFile;
@property(nonatomic,strong)MKMapView * mapview;
@property(nonatomic,strong) CLLocationManager * manager1;
@property(nonatomic,strong) NSString * locationName, * Area;
@property(nonatomic,strong)UISwitch * toggle2;
@end
