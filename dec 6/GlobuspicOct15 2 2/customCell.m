//
//  customCell.m
//  MoveytProject
//
//  Created by Globussoft 1 on 4/29/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "customCell.h"
#import "RoundedImageView.h"


@implementation customCell

@synthesize forShowingTime;
@synthesize imageView;
@synthesize userName;
@synthesize toUserlabel;
@synthesize photoDownloaded;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.forShowingTime = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 200, 20)];
        self.forShowingTime.textColor = [UIColor blackColor];
        self.forShowingTime.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [self.contentView addSubview:self.forShowingTime];
        
        self.toUserlabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 150, 20)];
        self.toUserlabel.textColor = [UIColor blackColor];
        self.toUserlabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [self.contentView addSubview:self.toUserlabel];

        
        self.imageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(15, 10,60, 60)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;

        
        self.photoDownloaded = [[UIImageView alloc] initWithFrame:CGRectMake(245, 10, 60, 60)];
        self.photoDownloaded.contentMode = UIViewContentModeScaleAspectFill;
        self.photoDownloaded.clipsToBounds = YES;
        [self.photoDownloaded.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [self.photoDownloaded.layer setBorderWidth: 0.7];
        [self.contentView addSubview:self.photoDownloaded];


        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 150, 30)];
        self.userName.textColor = [UIColor blackColor];
        self.userName.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [self.contentView addSubview:self.userName];
//        [self.userName sizeToFit];
        [self.contentView addSubview:self.imageView];
       
        
 
    }
    
    return self;
}
-(void)options:(UIButton *)button{
}


    
    
    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
