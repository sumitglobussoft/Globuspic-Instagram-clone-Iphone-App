//
//  SCVideoPlayerViewController.h
//  SCAudioVideoRecorder
//
//  Created by Simon CORSIN on 8/30/13.
//  Copyright (c) 2013 rFlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCVideoPlayerView.h"
#import "SCRecorder.h"

@interface SCVideoPlayerViewController : UIViewController<SCPlayerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
{
    UICollectionView *filtercollectioView;
    UICollectionView *framecollectioView;
   
}

@property (nonatomic,strong)NSURL * urlStr;
@property (strong, nonatomic) SCRecordSession *recordSession;
@property (strong, nonatomic)  SCSwipeableFilterView *filterSwitcherView;

@end
