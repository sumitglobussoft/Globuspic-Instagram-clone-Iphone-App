//
//  ImageEditingViewController.h
//  Anypic
//
//  Created by Globussoft 1 on 9/11/14.
//
//

#import <UIKit/UIKit.h>

@interface ImageEditingViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    
    UIImageView *photoImageView,*rotateImgView;
    UICollectionView *filtercollectioView;
    UICollectionView *editorCollectionView;
    UIScrollView *scrollView;
    UIView * rotateView,*view1,* tiltView;
    CGFloat lastScale;
	CGFloat lastRotation;
	
	CGFloat firstX;
	CGFloat firstY;
   
}
@property(nonatomic,strong)UIImage *image1,* newimage;
@property(nonatomic,strong)UIView *headerView;
//@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *btnLevels;
@property (nonatomic,strong)UISlider *mySlider,* slide;
@property (nonatomic,strong)NSMutableArray *editorImagesArray;
@property(nonatomic,strong) UINavigationController * navigationController;

-(void)getSliderValue:(UISlider *)slider;
- (void)callParentViewController ;

@end
