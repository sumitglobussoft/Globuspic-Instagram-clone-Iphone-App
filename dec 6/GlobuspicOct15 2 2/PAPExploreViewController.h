//
//  PAPExploreViewController.h
//  Anypic
//
//  Created by Globussoft 1 on 9/1/14.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PAPPhotoDetailsViewController.h"
#import "PAPSearchFriendsViewController.h"

@interface PAPExploreViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>{
    NSMutableArray * imageArray;
    //NSMutableArray *videoArray;
    NSMutableArray * videoObj ;
    NSMutableArray * wholeObj ; 
    UICollectionView * collectioView;
    NSArray * images;
    MPMoviePlayerController *moviePlayer;
    PAPSearchFriendsViewController * searchFriends;
    
}
@property (nonatomic, strong) NSMutableArray * wholeObj;
@property(nonatomic, strong) UIRefreshControl *refreshControl ; 
@end
