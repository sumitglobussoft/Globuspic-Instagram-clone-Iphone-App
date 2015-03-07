//
//  SCVideoPlayerViewController.m
//  SCAudioVideoRecorder
//
//  Created by Simon CORSIN on 8/30/13.
//  Copyright (c) 2013 rFlex. All rights reserved.
//

#import "SCVideoPlayerViewController.h"
#import "SCEditVideoViewController.h"
#import "SCAssetExportSession.h"
 #import "ImageViewCustomCell.h"
#import "PAPEditVideoViewController.h"

@interface SCVideoPlayerViewController () {
    SCPlayer *_player;
   
        NSMutableArray *thumbTimes;
        NSMutableArray *arrayOfImages;
        NSMutableArray *filterImageArray;
        UIImageView *imageV;
        UIPanGestureRecognizer *panGestureRecognizer;
        NSURL *urls;
        UIImage *thumbnailImage;
        UIView *frameView;
        CGFloat firstX,firstY;
        AVAssetImageGenerator *generate1;

    PAPEditVideoViewController * videoVC;
}
@property(nonatomic,strong) UIImageView *thumbnailImageView;
@property(nonatomic,strong) UIImageView *thumbnailImagePicker;
@end

@implementation SCVideoPlayerViewController

@synthesize urlStr,thumbnailImageView,thumbnailImagePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
        // Custom initialization
    }
	
    return self;
}

- (void)dealloc {
    self.filterSwitcherView = nil;
    [_player pause];
    _player = nil;
}

#pragma mark -
#pragma mark UIViewControllerDelegate

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        if (urlStr) {
        AVURLAsset *asset = [AVURLAsset assetWithURL:urlStr];
        [self gettingAllFramesOfVideo:asset];

        [_player setItemByUrl:urlStr];
    }
    else{
         [self gettingAllFramesOfVideo:_recordSession.assetRepresentingRecordSegments];
         [_player setItemByAsset:_recordSession.assetRepresentingRecordSegments];
    }
    
	[_player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player pause];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.filterSwitcherView=[[SCSwipeableFilterView alloc] initWithFrame:CGRectMake(0.0, 70.0, self.view.bounds.size.width, 290)];
    [self.view addSubview:self.filterSwitcherView];
    
    self.filterSwitcherView.refreshAutomaticallyWhenScrolling = NO;
    self.filterSwitcherView.contentMode = UIViewContentModeScaleAspectFit;
    self.filterSwitcherView.filterGroups =@[
                                             [NSNull null],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectNoir"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectChrome"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectInstant"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectTonal"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectFade"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIColorMonochrome"]],
                                             //[SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectTransfer"]]
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CISepiaTone"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIColorInvert"]]
                                             ];
    

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveToCameraRoll)];
    
    _player = [SCPlayer player];
    _player.CIImageRenderer = self.filterSwitcherView;
    
	_player.loopEnabled = YES;
    
    UIButton *filterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame=CGRectMake(90,0,50,50);
    [filterButton setImage:[UIImage imageNamed:@"brightNormal.png"] forState:UIControlStateNormal];
    [filterButton setImage:[UIImage imageNamed:@"brightNormal.png"] forState:UIControlStateSelected];
    [filterButton setImage:[UIImage imageNamed:@"brightNormal.png"] forState:UIControlStateHighlighted];
    [filterButton addTarget:self action:@selector(filterButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *frameButton=[UIButton buttonWithType:UIButtonTypeCustom];
    frameButton.frame=CGRectMake(170,0,100,50);
//    [frameButton setTitle:@"setFrame" forState:UIControlStateNormal];
     [frameButton setImage:[UIImage imageNamed:@"framenormal.png"] forState:UIControlStateNormal];
    [frameButton setImage:[UIImage imageNamed:@"Frameactive.png"] forState:UIControlStateSelected];
//    [frameButton setImage:[UIImage imageNamed:@"Frameactive.png"] forState:UIControlStateHighlighted];
    [frameButton addTarget:self action:@selector(frameButton:) forControlEvents:UIControlEventTouchUpInside];
     
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(10,0,50,50);
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * left3=[[UIBarButtonItem alloc]initWithCustomView:back];
    UIBarButtonItem * left1=[[UIBarButtonItem alloc]initWithCustomView:filterButton];
    UIBarButtonItem * left2=[[UIBarButtonItem alloc]initWithCustomView:frameButton];
    self.navigationItem.leftBarButtonItems=@[left3,left1,left2];
    
    filterImageArray=[[NSMutableArray alloc]init];
    for (int i=1; i<=8; i++) {
        
        [filterImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image%d.png",i]]];
    }
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    filtercollectioView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 370, self.view.frame.size.width, 120) collectionViewLayout:flowLayout];
    [filtercollectioView setDataSource:self];
    [filtercollectioView setDelegate:self];
    [filtercollectioView registerClass:[ImageViewCustomCell class] forCellWithReuseIdentifier:@"cell"];
    
    [filtercollectioView setBackgroundColor:[UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1]];
    [filtercollectioView setCollectionViewLayout:flowLayout];
    [self.view addSubview:filtercollectioView];
    
    
}

#pragma mark -
#pragma mark Frames of Video

-(void )gettingAllFramesOfVideo:(AVAsset *)asset{
    arrayOfImages=[[NSMutableArray alloc] init];
    thumbTimes=[[NSMutableArray alloc]init];
    if (generate1) {
        generate1=nil;
    }
        //        AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset] ;
    generate1.apertureMode = AVAssetImageGeneratorApertureModeCleanAperture;
    generate1.appliesPreferredTrackTransform = TRUE;
    generate1.requestedTimeToleranceBefore = kCMTimeZero;
    generate1.requestedTimeToleranceAfter = kCMTimeZero;
    int t,value;
    float dur =CMTimeGetSeconds(asset.duration);
    

    if (urlStr) {
        if(dur<11.0 && dur>=4.5 )
        {
            if(dur>=4.5 && dur<7.0)
            {
                value=200;
            }
            else
            {
                value=700;
            }
        }
    }
    else{
        value=30000;
    }
      for(t=0;t < asset.duration.value;t=t+value) {
        
        CMTime thumbTime = CMTimeMake(t, asset.duration.timescale);
        NSValue *v=[NSValue valueWithCMTime:thumbTime];
        [thumbTimes addObject:v];
        
    }
    
    NSLog(@"thumbTimes array  video %lu",(unsigned long)thumbTimes.count);
    
    [generate1 generateCGImagesAsynchronouslyForTimes:thumbTimes completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
        
        if (result == AVAssetImageGeneratorSucceeded) {
            
            if (image != nil) {
                    //                NSString *imgPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png", i]];
                    //                [self savePNGImage:image path:imgPath];
                
                [arrayOfImages addObject:[UIImage imageWithCGImage:image]];
                
                    //[arrayOfImages addObject:(__bridge id)(image)];
                
//                if (arrayOfImages.count == thumbTimes.count) {
//                    CFRelease(image);
//                }
                
            }
            
        }
            //    i++;
    }];
    
        //    }
    
}


-(void)frameButton:(UIButton *)button{
    
    self.filterSwitcherView.hidden=YES;
    filtercollectioView.hidden=YES;
    [self frameViewCreate];
}

-(void)generateThumbnailImage
{
    AVAssetImageGenerator *generator;
    if(urlStr){
        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:urlStr options:nil];
        generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    }
    else{
        
      generator = [[AVAssetImageGenerator alloc] initWithAsset:_recordSession.assetRepresentingRecordSegments];
}
       generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0,1);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
          thumbnailImage=[UIImage imageWithCGImage:im] ;
       
    };
    
    CGSize maxSize = CGSizeMake(320, 180);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
}



-(void)frameViewCreate{
    
    if (!frameView) {
        frameView = [[UIView alloc]initWithFrame:CGRectMake (0, 350, self.view.frame.size.width, 120)];
        frameView.backgroundColor = [UIColor grayColor ];
        [frameView setBackgroundColor:[UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1]];
        [self.view addSubview:frameView];
        if (arrayOfImages.count<7) {
            for (int i=0; i<arrayOfImages.count; i++)
            {
                imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15+i*40, 40, 40,40)];
                imageV.image=[arrayOfImages objectAtIndex:i];
                [frameView addSubview:imageV];
            }

        }
        else{
            for (int i=0; i<7; i++)
            {
                imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15+i*40, 40, 40,40)];
                imageV.image=[arrayOfImages objectAtIndex:i];
                [frameView addSubview:imageV];
            }

        
        }
        
        if ( !thumbnailImageView) {
            
            thumbnailImageView =[[UIImageView alloc] init ];
                // [ self.thumbNail setClipsToBounds:YES];
            [thumbnailImageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
            [thumbnailImageView.layer setBorderWidth: 2.0];
            [thumbnailImageView setUserInteractionEnabled:YES];
            thumbnailImageView.frame = CGRectMake(5, 30, 50, 50);
            [frameView addSubview:thumbnailImageView];
        }
            //     [frameView addSubview:self.thumbNail];
        thumbnailImageView.image =[arrayOfImages objectAtIndex:0];
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
        [panGestureRecognizer setDelegate:self];
        
        [thumbnailImageView addGestureRecognizer:panGestureRecognizer];
        
        
            //for main image .
        if (!thumbnailImagePicker) {
            thumbnailImagePicker = [[UIImageView alloc]init];
            [thumbnailImagePicker.layer setBorderColor:[[UIColor whiteColor]CGColor]];
            [thumbnailImagePicker.layer setBorderWidth:2.0];
            thumbnailImagePicker.frame = CGRectMake(5, 70, self.view.frame.size.width-5, 270);
            [self.view addSubview:thumbnailImagePicker];
            
        }
        thumbnailImagePicker.image =imageV.image ;
        [frameView reloadInputViews];
        
    }
    else{
    
        frameView.hidden=NO;
        thumbnailImagePicker.hidden=NO;
    }
}




- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer{
//    NSLog(@"pannn");
   UIImageView *iv = (UIImageView *)[recognizer view];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)recognizer translationInView:frameView];
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
        firstX = [[recognizer view] center].x;
        firstY = [[recognizer view] center].y;
    }
        // translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY);
    
    if (translatedPoint.x>290) {
        return;
    }
    
    if (translatedPoint.x<37) {
        return;
    }

    
    [[recognizer view] setCenter:translatedPoint];
    
     thumbnailImageView.image = iv.image ;
    thumbnailImagePicker.image=iv.image;
//    int count = 0;
    
    if (translatedPoint.x<40) {
        thumbnailImagePicker.image = [arrayOfImages objectAtIndex:0];
        thumbnailImageView.image = [arrayOfImages objectAtIndex:0];
        NSLog(@"translated point =-=-=-=-=--=-==-- %f",translatedPoint.x);
    }
    if (translatedPoint.x>40) {
//        count=0;
        thumbnailImagePicker.image = [arrayOfImages objectAtIndex:1];
      thumbnailImageView.image = [arrayOfImages objectAtIndex:1];
        
    }
    if (translatedPoint.x>80) {
        thumbnailImagePicker.image = [arrayOfImages objectAtIndex:2];
        thumbnailImageView.image = [arrayOfImages objectAtIndex:2];
    }
    if (translatedPoint.x>120) {
        
    thumbnailImagePicker.image = [arrayOfImages objectAtIndex:3];
      thumbnailImageView.image = [arrayOfImages objectAtIndex:3];
    }
    if (translatedPoint.x>160) {
        
       thumbnailImagePicker.image = [arrayOfImages objectAtIndex:4];
        thumbnailImageView.image = [arrayOfImages objectAtIndex:4];
        
    }
    if (translatedPoint.x>200) {
        
        thumbnailImagePicker.image = [arrayOfImages objectAtIndex:5];
        thumbnailImageView.image = [arrayOfImages objectAtIndex:5];
        
    }
    if (translatedPoint.x>240) {
        
        thumbnailImagePicker.image = [arrayOfImages objectAtIndex:6];
        thumbnailImageView.image = [arrayOfImages objectAtIndex:6];
        
    }

}


#pragma mark -
#pragma mark  Save Filter Video

- (void)saveToCameraRoll {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    SCFilterGroup *currentFilter = self.filterSwitcherView.selectedFilterGroup;
    
    void(^completionHandler)(NSError *error) = ^(NSError *error) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (error == nil) {
            if (!videoVC) {
                videoVC=[[PAPEditVideoViewController alloc]init];
            }

            
                if(thumbnailImagePicker.image==NULL)
                {
                      thumbnailImage=[arrayOfImages objectAtIndex:0];                }
                else{
                    thumbnailImage=thumbnailImagePicker.image;
                }
                

            
                if (urlStr) {
                    UISaveVideoAtPathToSavedPhotosAlbum(urlStr.path, nil, nil, nil);
                    videoVC.urlstr=urlStr;
                    videoVC.thumbnailImage=thumbnailImage;
                    [self.navigationController pushViewController:videoVC animated:YES];
                }
                else{
                    [self.recordSession saveToCameraRoll];
                    videoVC.urlstr=self.recordSession.outputUrl;
                    videoVC.thumbnailImage=thumbnailImage;
                    [self.navigationController pushViewController:videoVC animated:YES];
                }
                   
                [SCRecorder recorder].recordSession=nil;
//            });
           
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    };
    
   if (currentFilter == nil) {
       if (urlStr) {
           
           AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:urlStr options:nil];
           SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:avAsset];
           exportSession.filterGroup = currentFilter;
           exportSession.sessionPreset = SCAssetExportSessionPresetHighestQuality;
           exportSession.outputUrl = urlStr;
           exportSession.outputFileType = AVFileTypeMPEG4;
           exportSession.keepVideoSize = YES;
           [exportSession exportAsynchronouslyWithCompletionHandler:^{
               completionHandler(exportSession.error);
           }];
       }else{
        [self.recordSession mergeRecordSegments:completionHandler];
       }
    } else {
        
        if (urlStr) {
            
            AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:urlStr options:nil];
            SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:avAsset];
            exportSession.filterGroup = currentFilter;
            exportSession.sessionPreset = SCAssetExportSessionPresetHighestQuality;
            exportSession.outputUrl = urlStr;
              exportSession.outputFileType = AVFileTypeMPEG4;
            exportSession.keepVideoSize = YES;
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                completionHandler(exportSession.error);
            }];
          }
          else{
              SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:self.recordSession.assetRepresentingRecordSegments];
              exportSession.filterGroup = currentFilter;
              exportSession.sessionPreset = SCAssetExportSessionPresetHighestQuality;
              exportSession.outputUrl = self.recordSession.outputUrl;
              exportSession.outputFileType = self.recordSession.suggestedFileType;
              exportSession.keepVideoSize = YES;
              [exportSession exportAsynchronouslyWithCompletionHandler:^{
                  completionHandler(exportSession.error);
              }];
          
          }
  
    }

}

-(void)filterButton:(UIBarButtonItem *)barButton{
    
    filtercollectioView.hidden=NO;
    self.filterSwitcherView.hidden=NO;
    frameView.hidden=YES;
    thumbnailImagePicker.hidden=YES;
    
}

#pragma mark -
#pragma mark Back button


-(void)backButton{
//    filtercollectioView.hidden=YES;
    [SCRecorder recorder].recordSession=nil;
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -
#pragma mark Select video filter CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    if (collectionView==framecollectioView) {
        return arrayOfImages.count;
    }
    else {
        return filterImageArray.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier=@"cell";
    ImageViewCustomCell * cell=(ImageViewCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    if (collectionView==framecollectioView) {
//        cell.imageView.image=[arrayOfImages objectAtIndex:indexPath.row];
//    }
//    else{
        cell.imageView.image=[filterImageArray objectAtIndex:indexPath.row];
    //}
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
       // NSInteger   filterValue=indexPath.row;
//        if(filterValue==1)
//        {
            //[self.filterSwitcherView updateCurrentSelected:indexPath.row+1];
    [self.filterSwitcherView updateScrollViewWithFilter:indexPath.row+1];
//        }
    
}

@end
