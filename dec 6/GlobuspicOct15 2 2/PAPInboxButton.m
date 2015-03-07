//
//  PAPInboxButton.m
//  Anypic
//
//  Created by Globussoft 1 on 9/6/14.
//
//

#import "PAPInboxButton.h"

@implementation PAPInboxButton

- (id)initWithTarget:(id)target action:(SEL)action {
    
         inBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
          self = [super initWithCustomView:inBoxButton];
    if (self) {
        
     [inBoxButton setBackgroundImage:[UIImage imageNamed:@"inbox.png"] forState:UIControlStateNormal];
     [inBoxButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
     [inBoxButton setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 20.0f)];
     //[inBoxButton setImage:[UIImage imageNamed:@"inbox.png"] forState:UIControlStateNormal];
    // [inBoxButton setImage:[UIImage imageNamed:@"inbox.png"] forState:UIControlStateHighlighted];
        
    }
    
    return self;
}



@end
