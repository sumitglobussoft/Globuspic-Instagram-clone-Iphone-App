//
//  PAPSettingsButtonItem.m
//  Anypic
//
//  Created by Héctor Ramos on 5/18/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPSettingsButtonItem.h"

@implementation PAPSettingsButtonItem

#pragma mark - Initialization

- (id)initWithTarget:(id)target action:(SEL)action {
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
//
    self = [super initWithCustomView:settingsButton];
//    self = [super initWithCustomView:inBoxButton];
    if (self) {

        [settingsButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [settingsButton setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 20.0f)];
        [settingsButton setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
        [settingsButton setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateHighlighted];
        
    }
    
    return self;
}
@end
