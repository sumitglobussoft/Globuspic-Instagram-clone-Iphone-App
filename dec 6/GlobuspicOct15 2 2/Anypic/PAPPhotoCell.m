//
//  PAPPhotoCell.m
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPPhotoCell.h"
#import "PAPUtility.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation PAPPhotoCell
@synthesize photoButton;

#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
 
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor clearColor];

        UIView *dropshadowView = [[UIView alloc] init];
        dropshadowView.backgroundColor = [UIColor whiteColor];
        dropshadowView.frame = CGRectMake( 20.0f, -44.0f, 280.0f, 322.0f);
        [self.contentView addSubview:dropshadowView];
        
        CALayer *layer = dropshadowView.layer;
        layer.masksToBounds = NO;
        layer.shadowRadius = 3.0f;
        layer.shadowOpacity = 0.5f;
        layer.shadowOffset = CGSizeMake( 0.0f, 1.0f);
        layer.shouldRasterize = YES;
        
        self.imageView.frame = CGRectMake( 20.0f, 0.0f, 280.0f, 280.0f);
        self.imageView.backgroundColor = [UIColor blackColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoButton.frame = CGRectMake( 20.0f, 0.0f, 280.0f, 280.0f);
        self.photoButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.photoButton];
        
//        self.webview=[[UIWebView alloc]initWithFrame:CGRectMake(20, 20, 200, 200)];
//        [self.contentView addSubview:self.webview];
       
    
//              self.moviePlayer = [[MPMoviePlayerViewController alloc] init];
//               [self.moviePlayer.view setFrame:CGRectMake(20, 50, 280, 200)];
//               [[self.moviePlayer moviePlayer]prepareToPlay];
//               [self.contentView addSubview:self.moviePlayer.view];
        
            //    [[NSNotificationCenter defaultCenter]
            //     addObserver: self
            //     selector: @selector(myMovieFinishedCallback:)
            //     name: MPMoviePlayerPlaybackDidFinishNotification
            //     object: theMovie];

        [self.contentView bringSubviewToFront:self.imageView];
    }

    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 20.0f, 0.0f, 280.0f, 280.0f);
    self.photoButton.frame = CGRectMake( 20.0f, 0.0f, 280.0f, 280.0f);
}

@end
