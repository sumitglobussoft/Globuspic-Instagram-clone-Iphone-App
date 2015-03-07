//
//  PAPEditVideoViewController.h
//  Anypic
//
//  Created by Sumit on 02/09/14.
//
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "PAPPhotoDetailsFooterView.h"
#import "ViewController.h"
#import "UIImage+ResizeAdditions.h"
//

@interface PAPEditVideoViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>{
    PFFile *videoFile;
}
//-(BOOL) shouldUploadVideo: (NSURL *)anVideo;
//- (id)initWithVideo:(NSURL *)aVideo;
@property(nonatomic,strong)UIImage *thumbnailImage;
@property(nonatomic,strong)  PFFile *videoFile;
@property(nonatomic,strong) NSURL * videoURL;
@property(nonatomic,strong) NSURL *urlstr;
@property(nonatomic,strong)  NSMutableArray * array ; 
@property(nonatomic,strong) UIImage *thumbnail;
-(void)directBttnClicked:(UIButton *)button;
-(void)cancelButtonAction:(UIButton *)button;
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>



@end
