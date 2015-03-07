//
//  PAPphotoViewController.h
//  Anypic
//
//  Created by Globussoft 1 on 9/1/14.
//
//

#import <UIKit/UIKit.h>
#import "PAPEditVideoViewController.h"
#import "PAPEditPhotoViewController.h"

@interface PAPphotoViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSArray * arrUser;
    NSString * fbid;
    UITextView * caption;
}
@property (nonatomic)UIImage *imageset;
@property (nonatomic, strong) UITextField *commentTextField ; 
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong)NSArray* arrUser;
@property(nonatomic,strong)NSURL *url;
@property (nonatomic,strong) UINavigationController *navController;
@property(nonatomic,strong)NSString * message;
-(void) displaySelctedImage:(UIImage*) image;
-(void)initWithanImage:(UIImage *)image1;
@end
