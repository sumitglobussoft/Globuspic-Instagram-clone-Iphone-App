//
//  VRViewController.m
//  VideoRecorder
//
//  Created by Simon CORSIN on 8/3/13.
//  Copyright (c) 2013 SCorsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SCTouchDetector.h"
#import "SCRecorderViewController.h"
#import "SCAudioTools.h"
#import "SCVideoPlayerViewController.h"
#import "SCRecorderFocusView.h"
#import "SCImageDisplayerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SCSessionListViewController.h"
#import "SCRecordSessionManager.h"

#define kVideoPreset AVCaptureSessionPresetHigh

////////////////////////////////////////////////////////////
// PRIVATE DEFINITION
/////////////////////

@interface SCRecorderViewController () {
    SCRecorder *_recorder;
    UIImage *_photo;
    SCRecordSession *_recordSession;
    UIImageView *_ghostImageView;
    UIProgressView * progessbar;
    int startOrStop;
    NSTimer *aTimer;
    float recordingCount;
    BOOL isPaused;
    float val,curTime;
    SCVideoPlayerViewController *videoPlayer;
    UIImageView * alertImg;
}

@property (strong, nonatomic) SCRecorderFocusView *focusView;
@end

////////////////////////////////////////////////////////////
// IMPLEMENTATION
/////////////////////

@implementation SCRecorderViewController

#pragma mark - UIViewController 

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

//- (UIStatusBarStyle) preferredStatusBarStyle {
////	return UIStatusBarStyleLightContent;
//}

#endif

#pragma mark - Left cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.capturePhotoButton.alpha = 0.0;
    
    _ghostImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _ghostImageView.contentMode = UIViewContentModeScaleAspectFill;
    _ghostImageView.alpha = 0.2;
    _ghostImageView.userInteractionEnabled = NO;
    _ghostImageView.hidden = YES;
    
    [self.view insertSubview:_ghostImageView aboveSubview:self.previewView];
   
    _recorder = [SCRecorder recorder];
    _recorder.sessionPreset = AVCaptureSessionPreset1280x720;
    _recorder.audioEnabled = YES;
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    
    // On iOS 8 and iPhone 5S, enabling this seems to be slow
    _recorder.initializeRecordSessionLazily = NO;
    
    self.previewView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.previewView];
    
    self.downBar=[[UIView alloc] initWithFrame:CGRectMake(0, 420, self.view.frame.size.width, 60)];
    [self.downBar setBackgroundColor:[UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1]];
    [self.view addSubview:self.downBar];
    
    self.recordView=[[UIView alloc]initWithFrame:CGRectMake(135, 0, 60, 60)];
    self.recordView.backgroundColor=[UIColor redColor];
    self.recordView.layer.cornerRadius=30.0;
    self.recordView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.recordView.layer.borderWidth=2.0;
    [self.downBar addSubview:self.recordView];
    
    
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    //headerview.backgroundColor=[UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1];
    headerview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Vheader.png"]];
//    headerview.layer.cornerRadius=30.0;
////    headerview.layer.borderColor=[UIColor whiteColor].CGColor;
//    headerview.layer.borderWidth=2.0;
    [self.view addSubview:headerview];
    
    progessbar = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    progessbar.frame=CGRectMake(3, 418, 315, 30);
    progessbar.progressTintColor=[UIColor greenColor];
    progessbar.trackTintColor=[UIColor grayColor];
    [self.view addSubview: progessbar];
    

    UIButton * cancel=[[UIButton alloc]initWithFrame:CGRectMake(15.0, 10.0, 60, 40)];
    cancel.backgroundColor=[UIColor clearColor];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [headerview addSubview:cancel];
    
    UIButton * nextButton=[[UIButton alloc]initWithFrame:CGRectMake(260, 10.0, 60, 40)];
    nextButton.backgroundColor=[UIColor clearColor];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [headerview addSubview:nextButton];

    self.retakeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.retakeButton.frame=CGRectMake(35, 10, 65, 40);
    [self.retakeButton setImage:[UIImage imageNamed:@"round.png"] forState:UIControlStateNormal];
    [self.downBar addSubview:self.retakeButton];
    
    self.stopButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.stopButton.frame=CGRectMake(240, 10, 65, 40);
    [self.stopButton setImage:[UIImage imageNamed:@"square.png"] forState:UIControlStateNormal];
    [self.downBar addSubview:self.stopButton];
    
    UIView *previewView = self.previewView;
    _recorder.previewView = previewView;
    
    [self.retakeButton addTarget:self action:@selector(handleRetakeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton addTarget:self action:@selector(handleStopButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.reverseCamera addTarget:self action:@selector(handleReverseCameraTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(handleCancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [nextButton addTarget:self action:@selector(handleStopButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.recordView addGestureRecognizer:[[SCTouchDetector alloc] initWithTarget:self action:@selector(handleTouchDetected:)]];
    self.loadingView.hidden = YES;
    
    self.focusView = [[SCRecorderFocusView alloc] initWithFrame:previewView.bounds];
    self.focusView.recorder = _recorder;
    [previewView addSubview:self.focusView];
    
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    self.focusView.insideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    
    [_recorder openSession:^(NSError *sessionError, NSError *audioError, NSError *videoError, NSError *photoError) {
        NSError *error = nil;
        NSLog(@"%@", error);

        NSLog(@"==== Opened session ====");
        NSLog(@"Session error: %@", sessionError.description);
        NSLog(@"Audio error : %@", audioError.description);
        NSLog(@"Video error: %@", videoError.description);
        NSLog(@"Photo error: %@", photoError.description);
        NSLog(@"=======================");
        [self prepareCamera];
    }];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Reset.png"] style:UIBarButtonItemStyleDone target:self action:@selector(handleCancelButtonTapped)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Reset.png"] style:UIBarButtonItemStyleDone target:self action:@selector(handleStopButtonTapped:)];
}

- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {
    NSLog(@"Reconfigured audio input: %@", audioInputError);
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {
    NSLog(@"Reconfigured video input: %@", videoInputError);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self prepareCamera];
    
	self.navigationController.navigationBarHidden = YES;
    [self updateTimeRecordedLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_recorder previewViewFrameChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_recorder startRunningSession];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_recorder endRunningSession];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

// Focus
- (void)recorderDidStartFocus:(SCRecorder *)recorder {
    [self.focusView showFocusAnimation];
}

- (void)recorderDidEndFocus:(SCRecorder *)recorder {
    [self.focusView hideFocusAnimation];
}

- (void)recorderWillStartFocus:(SCRecorder *)recorder {
    [self.focusView showFocusAnimation];
}

#pragma mark - Handle

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*) message {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)showVideo {
    if (!videoPlayer) {
        videoPlayer=nil;
    }
    videoPlayer = [[SCVideoPlayerViewController alloc] init];
     videoPlayer.recordSession = _recordSession;
//    [self presentViewController:videoPlayer animated:YES completion:nil];
   [ self.navigationController pushViewController:videoPlayer animated:YES];

//    [self performSegueWithIdentifier:@"Video" sender:self];
}

-(void)didReceiveMemoryWarning{
    NSLog(@"Recieve memory warning SCRecordingViewController");
}

/*- (void)showPhoto:(UIImage *)photo {
    _photo = photo;
    [self performSegueWithIdentifier:@"Photo" sender:self];
}*/

- (void) handleReverseCameraTapped:(id)sender {
	[_recorder switchCaptureDevices];
}

- (void) handleStopButtonTapped:(id)sender {
    SCRecordSession *recordSession = _recorder.recordSession;
    
    if (recordSession != nil) {
        [self finishSession:recordSession];
        [aTimer invalidate];
    }
}

- (void)finishSession:(SCRecordSession *)recordSession {
    [recordSession endRecordSegment:^(NSInteger segmentIndex, NSError *error) {
        [[SCRecordSessionManager sharedInstance] saveRecordSession:recordSession];
        
        _recordSession = recordSession;
        
        Float64 tm = CMTimeGetSeconds(_recorder.recordSession.currentRecordDuration);
        NSLog(@"Tm %f",tm);
        
        Float64 durInMiliSec = 1000*tm;
        NSLog(@"durInMiliSec %f",durInMiliSec);
        //SCRecordSession *session = [SCRecordSession recordSession];
        //CMTime limitSec=CMTimeMakeWithSeconds(5, 10000);
       // CMTime tm=_recorder.recordSession.currentRecordDuration ;
//        session.currentRecordDuration = CMTimeMakeWithSeconds(5, 10000);
//        _recorder.recordSession=session;
        if(tm>5.0)
        {
        [self showVideo];
        }
        else{
            alertImg.hidden=NO;
        }
        
        //[self prepareCamera];
    }];
}

- (void) handleRetakeButtonTapped:(id)sender {
    SCRecordSession *recordSession = _recorder.recordSession;
    
    if (recordSession != nil) {
        _recorder.recordSession = nil;
        
        // If the recordSession was saved, we don't want to completely destroy it
        if ([[SCRecordSessionManager sharedInstance] isSaved:recordSession]) {
            [recordSession endRecordSegment:nil];
        } else {
            [recordSession cancelSession:nil];
        }
    }
    
	[self prepareCamera];
   // [self updateTimeRecordedLabel];
    [self startRecording];
}

- (IBAction)switchCameraMode:(id)sender {
    if ([_recorder.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.capturePhotoButton.alpha = 0.0;
            self.recordView.alpha = 1.0;
            self.retakeButton.alpha = 1.0;
            self.stopButton.alpha = 1.0;
        } completion:^(BOOL finished) {
			_recorder.sessionPreset = kVideoPreset;
            [self.switchCameraModeButton setTitle:@"Switch Photo" forState:UIControlStateNormal];
            [self.flashModeButton setTitle:@"Flash : Off" forState:UIControlStateNormal];
            _recorder.flashMode = SCFlashModeOff;
        }];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordView.alpha = 0.0;
            self.retakeButton.alpha = 0.0;
            self.stopButton.alpha = 0.0;
            self.capturePhotoButton.alpha = 1.0;
        } completion:^(BOOL finished) {
			_recorder.sessionPreset = AVCaptureSessionPresetPhoto;
            [self.switchCameraModeButton setTitle:@"Switch Video" forState:UIControlStateNormal];
            [self.flashModeButton setTitle:@"Flash : Auto" forState:UIControlStateNormal];
            _recorder.flashMode = SCFlashModeAuto;
        }];
    }
}

- (IBAction)switchFlash:(id)sender {
    NSString *flashModeString = nil;
    if ([_recorder.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        switch (_recorder.flashMode) {
            case SCFlashModeAuto:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeOn;
                break;
            case SCFlashModeOn:
                flashModeString = @"Flash : Light";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Auto";
                _recorder.flashMode = SCFlashModeAuto;
                break;
            default:
                break;
        }
    } else {
        switch (_recorder.flashMode) {
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }
    }
    
    [self.flashModeButton setTitle:flashModeString forState:UIControlStateNormal];
}

- (void) prepareCamera {
    if (_recorder.recordSession == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.suggestedMaxRecordDuration = CMTimeMakeWithSeconds(10, 10000);
        
        _recorder.recordSession = session;
    }
}

- (void)recorder:(SCRecorder *)recorder didCompleteRecordSession:(SCRecordSession *)recordSession {
    [self finishSession:recordSession];
}

- (void)recorder:(SCRecorder *)recorder didInitializeAudioInRecordSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized audio in record session");
    } else {
        NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didInitializeVideoInRecordSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized video in record session");
    } else {
        NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didBeginRecordSegment:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Began record segment: %@", error);
}

- (void)recorder:(SCRecorder *)recorder didEndRecordSegment:(SCRecordSession *)recordSession segmentIndex:(NSInteger)segmentIndex error:(NSError *)error {
    NSLog(@"End record segment %d at %@: %@", (int)segmentIndex, segmentIndex >= 0 ? [recordSession.recordSegments objectAtIndex:segmentIndex] : nil, error);
}

- (void)updateTimeRecordedLabel {
    CMTime currentTime = kCMTimeZero;
    
    if (_recorder.recordSession != nil) {
        currentTime = _recorder.recordSession.currentRecordDuration;
    }

    self.timeRecordedLabel.text = [NSString stringWithFormat:@"Recorded - %.2f sec", CMTimeGetSeconds(currentTime)];
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBuffer:(SCRecordSession *)recordSession {
   // [self updateTimeRecordedLabel];
    [self startRecording];
    
}

- (void)handleTouchDetected:(SCTouchDetector*)touchDetector {
    CGSize s=[UIScreen mainScreen].bounds.size;
    if(!alertImg)
    {
    alertImg =[[UIImageView alloc]initWithFrame:CGRectMake(s.width-230, s.height-125,150,60)];
        
    UIImage * imag=[UIImage imageNamed:@"record.png"];
    alertImg.image=imag;
    alertImg.hidden=YES;
        [self.view addSubview:alertImg];
    }
    else{
        alertImg.hidden=YES;
    }
    
    
    if (touchDetector.state == UIGestureRecognizerStateBegan) {
        _ghostImageView.hidden = YES;
        [_recorder record];
    } else if (touchDetector.state == UIGestureRecognizerStateEnded) {
        [_recorder pause];
       // [self updateGhostImage];
    }
}

- (IBAction)capturePhoto:(id)sender {
   /* [_recorder capturePhoto:^(NSError *error, UIImage *image) {
        if (image != nil) {
            [self showPhoto:image];
        } else {
            [self showAlertViewWithTitle:@"Failed to capture photo" message:error.localizedDescription];
        }
    }];*/
}

- (void)updateGhostImage {
   // _ghostImageView.image = [_recorder snapshotOfLastAppendedVideoBuffer];
   // _ghostImageView.hidden = !_ghostModeButton.selected;
}

- (IBAction)switchGhostMode:(id)sender {
   // _ghostModeButton.selected = !_ghostModeButton.selected;
   // _ghostImageView.hidden = !_ghostModeButton.selected;
}


-(void)handleCancelButtonTapped{
      [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma -mark

- (void)startRecording
{
    CMTime currentTime = kCMTimeZero;
    
    if (_recorder.recordSession != nil) {
        currentTime = _recorder.recordSession.currentRecordDuration;
    }
    
    curTime=CMTimeGetSeconds(currentTime);
//    startOrStop=2;
//    if (startOrStop==2) {
        isPaused=NO;
        //[[CameraEngine engine] startCapture];
        
//        if (curTime/10.0!=1.0){
//            startOrStop=5;
//          
//        }
//        else{
//           // startOrStop=6;
//            
//        }
         [self timerForRecording];
        
   /*}else if (startOrStop==5){
        if (isPaused==YES) {
            isPaused=NO;
            progessbar.progressTintColor=[UIColor greenColor];
            
        }else{
            isPaused=YES;
            progessbar.progressTintColor=[UIColor redColor];
           
        }
    }*/
    
    
    
}


-(void)timerForRecording//:(NSTimer *)timer
{
    if (!isPaused) {
       
        val=curTime/10.0;
        [progessbar setProgress:val animated:YES];
        if (val==1.00) {
            [aTimer invalidate];
        }
        
    }
}


@end
