//
//  VideoViewController.h
//  Anypic
//
//  Created by Globussoft 1 on 9/2/14.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController : UIViewController
{
    NSData *data;
    MPMoviePlayerViewController *moviePlayerView;
    NSURL *strUrl;
}
-(void) playVideoWithUrl:(NSURL *)videoUrl;
@property(nonatomic,strong) NSURL *strUrl;
@property (nonatomic) UIWebView *videoPlayWebView;
@end
