//
//  VRViewController.h
//  VideoRecorder
//
//  Created by Simon CORSIN on 8/3/13.
//  Copyright (c) 2013 rFlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"

@interface SCRecorderViewController : UIViewController<SCRecorderDelegate>

@property (strong, nonatomic)  UIView *recordView;
@property (weak, nonatomic)  UIButton *stopButton;
@property (weak, nonatomic)  UIButton *retakeButton;
@property (strong, nonatomic)  UIView *previewView;
@property (weak, nonatomic)  UIView *loadingView;
@property (weak, nonatomic)  UILabel *timeRecordedLabel;
@property (strong, nonatomic)  UIView *downBar;
@property (weak, nonatomic)  UIButton *switchCameraModeButton;
@property (weak, nonatomic)  UIButton *reverseCamera;
@property (weak, nonatomic)  UIButton *flashModeButton;
@property (weak, nonatomic)  UIButton *capturePhotoButton;
@property (weak, nonatomic)  UIButton *ghostModeButton;

- (void)switchCameraMode:(id)sender;
- (void)switchFlash:(id)sender;
- (void)capturePhoto:(id)sender;
- (void)switchGhostMode:(id)sender;

@end
