//
//  customCell.h
//  MoveytProject
//
//  Created by Globussoft 1 on 4/29/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customCell : UITableViewCell<UIActionSheetDelegate>{
}

@property(nonatomic,strong) UILabel *userName;
@property(nonatomic,strong)UILabel *toUserlabel;
@property(nonatomic,strong) UILabel *forShowingTime ;
@property(nonatomic,strong) UIImageView *imageView ;
@property(nonatomic,strong)UIImageView *photoDownloaded;
@end
