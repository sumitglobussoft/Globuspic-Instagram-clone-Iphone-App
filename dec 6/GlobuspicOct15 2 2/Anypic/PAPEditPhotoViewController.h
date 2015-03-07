//
//  PAPEditPhotoViewController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol callParentView <NSObject>
- (void)callParentViewController;
@end

@interface PAPEditPhotoViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate>
{
    UISlider *  sliderSaturation;
    UIButton *brightness;
    
}
@property(nonatomic,strong) id delegate ;
@property(nonatomic,strong)NSMutableArray *tagMutArray;
- (id)initWithImage:(UIImage *)aImage;
-(void)brightnessControll:(id)sender;
-(void)sliderAction:(id)sender;
-(void)settingsButtonActions:(id)sender;
- (void) postImageToFB:(UIImage*)image;
-(void)tagPeople:(UIButton *)button;
@end
