//
//  ImageViewCustomCell.m
//  Anypic
//
//  Created by Globussoft 1 on 9/2/14.
//
//

#import "ImageViewCustomCell.h"
@implementation ImageViewCustomCell
@synthesize imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // self.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"adjustBack.png"]];
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
       
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
