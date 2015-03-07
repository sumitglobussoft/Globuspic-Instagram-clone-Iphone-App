//
//  PAPActivityFeedViewController.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/9/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPActivityCell.h"
#import <UIKit/UIKit.h>

@interface PAPActivityFeedViewController : PFQueryTableViewController <PAPActivityCellDelegate>


+ (NSString *)stringForActivityType:(NSString *)activityType;
 @property(nonatomic,strong)UISwitch * toggle;


@end
