//
//  VideoEditingViewController.h
//  Anypic
//
//  Created by Globussoft 1 on 9/18/14.
//
//

#import <UIKit/UIKit.h>
#import "PAPEditVideoViewController.h"

@interface VideoEditingViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *filtercollectioView;
    UICollectionView *framecollectioView;
// PAPEditVideoViewController *viewController1;
    // PAPEditVideoViewController *viewController1;
}

@property(nonatomic,strong) NSURL *urlstr;
-(void)gestureRcog:(UIPanGestureRecognizer *)gesture;
@end
