//
//  PAPTabBarController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPTabBarController.h"
#import "VideoEditingViewController.h"
#import "ImageEditingViewController.h"
//#import "PAPEditVideoViewController.h"
#import "SCRecorderViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SCVideoPlayerViewController.h"


@interface PAPTabBarController (){
    ImageEditingViewController *view1;
    SCRecorderViewController *recordView;
}
@property (nonatomic,strong) UINavigationController *navController;
@end

@implementation PAPTabBarController
@synthesize navController;


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self tabBar] setBackgroundImage:[UIImage imageNamed:@"footer.png"]];
//    [[self tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"BackgroundTabBarItemSelected.png"]];
    self.tabBar.tintColor = [UIColor colorWithRed:139.0f/255.0f green:111.0f/255.0f blue:95.0f/255.0f alpha:1.0f];
    
      self.navController = [[UINavigationController alloc] init];
    [PAPUtility addBottomDropShadowToNavigationBarForNavigationController:self.navController];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITabBarController

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake( 55.0f, 0.0f, 131.0f, self.tabBar.bounds.size.height);
    [cameraButton setImage:[UIImage imageNamed:@"camra_normal.png"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"camra_active.png"] forState:UIControlStateSelected];
    [cameraButton addTarget:self action:@selector(photoCaptureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:cameraButton];
    
    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeUpGestureRecognizer setNumberOfTouchesRequired:1];
    [cameraButton addGestureRecognizer:swipeUpGestureRecognizer];
    
    
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
     
    PAPEditPhotoViewController *viewController = [[PAPEditPhotoViewController alloc] initWithImage:image];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self.navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navController pushViewController:viewController animated:NO];
    
    [self presentViewController:self.navController animated:YES completion:nil];
}*/


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
       if(image)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        if (view1) {
            view1=nil;
        }
      view1=[[ImageEditingViewController alloc] init];
      view1.image1=image;
     [self.navController pushViewController:view1 animated:NO];
     [self presentViewController:self.navController animated:YES completion:nil];
    
    }
   else
    {

        NSString * mediaType=[info objectForKey:UIImagePickerControllerMediaType];

       [self dismissViewControllerAnimated:NO completion:nil];
        
            // Handle a movie capture
        if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0)
            == kCFCompareEqualTo) {
            
            
            NSString *moviePath = [[info objectForKey:
                                    UIImagePickerControllerMediaURL] path];
            url=[[NSURL alloc] initFileURLWithPath:moviePath];
            
        }
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        int  bytes = (int)data.length ;
        NSLog(@"data length is %d",bytes);
        

//        AVAsset * durUrl=[AVAsset assetWithURL:url];
//       float tm =CMTimeGetSeconds(durUrl.duration);
//        if(tm>=4.5&&tm<11.0)
        if (bytes < 10000000) {
    
        if (videoEditVC) {
            videoEditVC=nil;
        }
            
        videoEditVC=[[SCVideoPlayerViewController alloc] init];
        videoEditVC.urlStr =[info objectForKey:UIImagePickerControllerMediaURL];
        [self.navController pushViewController:videoEditVC animated:NO];
        [self presentViewController:self.navController animated:YES completion:nil];
        }
        else{
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@" Select video of size less than 10 mb  . " delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
        
//       viewController1=[[PAPEditVideoViewController  alloc]init];
//        viewController1.urlstr=[info objectForKey:
//                                UIImagePickerControllerMediaURL];
//       [self.navController pushViewController:viewController1 animated:NO];
//        [self presentViewController:self.navController animated:YES completion:nil];
        
        }



//            viewController1.urlstr=url;
    
            // NSURL *soundFileURL = [NSURL fileURLWithPath:mediaType];
//          [self presentViewController:self.navController animated:YES completion:nil];
   
}

- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self shouldStartCameraController];
    } else if (buttonIndex == 1) {
        [self shouldStartPhotoLibraryPickerController];
    }
    else if(buttonIndex == 2)
    {
        [self shouldStartCameraControllerVideo];
    }
    else if (buttonIndex ==3)
    {
        [self shouldStartPhotoLibraryPickerControllerVideo];
    }
}


-(void) myMovieFinishedCallback: (NSNotification*) aNotification
{
    [self dismissMoviePlayerViewControllerAnimated];
    NSLog(@"my moview is playing from my movie player");
    MPMoviePlayerController* theMovie = [aNotification object];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: theMovie];
        // Release the movie instance created in playMovieAtURL:
}



- (BOOL)shouldStartPhotoLibraryPickerControllerVideo {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeMovie]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeMovie]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}


- (BOOL)shouldStartCameraControllerVideo {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
   
    if (recordView) {
        recordView=nil;
        NSLog(@"i m doing record view nil");
        
    }
    recordView=[[SCRecorderViewController alloc] init];
    [self.navController pushViewController:recordView animated:YES];
    [self presentViewController:self.navController animated:YES completion:nil];
    return YES;
}


#pragma mark - PAPTabBarController

- (BOOL)shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}

#pragma mark - ()

- (void)photoCaptureButtonAction:(id)sender {
    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if (cameraDeviceAvailable && photoLibraryAvailable) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo",@"Take Video",@"Choose Video", nil];
        [actionSheet showFromTabBar:self.tabBar];
    } else {
            // if we don't have at least two options, we automatically show whichever is available (camera or roll)
        [self shouldPresentPhotoCaptureController];
    }
}

- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO 
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
       return YES;
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    [self shouldPresentPhotoCaptureController];
}

@end
