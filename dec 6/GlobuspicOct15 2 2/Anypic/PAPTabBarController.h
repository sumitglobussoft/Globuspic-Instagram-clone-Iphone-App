//
//  PAPTabBarController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPEditPhotoViewController.h"
//#import "PAPEditVideoViewController.h"
#import "VideoEditingViewController.h"
#import "SCVideoPlayerViewController.h"

@protocol PAPTabBarControllerDelegate;

@interface PAPTabBarController : UITabBarController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
   // PAPEditVideoViewController * viewController1;
    SCVideoPlayerViewController *videoEditVC;
    
    NSURL * url;
    
}

- (BOOL)shouldPresentPhotoCaptureController;

@end

@protocol PAPTabBarControllerDelegate <NSObject>

- (void)tabBarController:(UITabBarController *)tabBarController cameraButtonTouchUpInsideAction:(UIButton *)button;

@end