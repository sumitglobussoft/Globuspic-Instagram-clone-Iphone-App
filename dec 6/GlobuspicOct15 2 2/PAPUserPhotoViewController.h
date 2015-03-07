//
//  PAPUserPhotoViewController.h
//  Anypic
//
//  Created by Sumit Ghosh on 04/10/14.
//
//

#import <UIKit/UIKit.h>

@interface PAPUserPhotoViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UINavigationController * navController;
    UICollectionView * collectionView;
    NSMutableArray * images,*wholeObj,*videoObj;
    
}
@property(nonatomic,strong)PFUser * user1;
@end
