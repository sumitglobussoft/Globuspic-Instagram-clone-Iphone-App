//
//  CustomTagLabel.m
//  TagOnImage
//
//  Created by GBS-ios on 10/16/14.
//  Copyright (c) 2014 Globussoft. All rights reserved.
//

#import "CustomTagLabel.h"

@implementation CustomTagLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    CGRect frame = self.frame;
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat cenX = width/2;
    x = x - width/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
    
    if (x < 10) {
        cenX = 5;
        CGContextMoveToPoint(context, cenX, 0);
        CGContextAddLineToPoint(context, cenX-5, 5);
        CGContextAddLineToPoint(context, cenX-5, height-1);
        CGContextAddLineToPoint(context, width-1, height-1);
        CGContextAddLineToPoint(context, width-1, 5);
        CGContextAddLineToPoint(context, cenX+5, 5);
        CGContextAddLineToPoint(context, cenX, 0);
        self.frame = CGRectMake(x+width/2-cenX, y, width, height);
    }
    else if (x>245){
        cenX = width-5;
        CGContextMoveToPoint(context, cenX, 0);
        CGContextAddLineToPoint(context, cenX+5, 5);
        CGContextAddLineToPoint(context, cenX+5, height-1);
        CGContextAddLineToPoint(context, 1, height-1);
        CGContextAddLineToPoint(context, 1, 5);
        CGContextAddLineToPoint(context, cenX-5, 5);
        CGContextAddLineToPoint(context, cenX, 0);
        self.frame = CGRectMake(x-width/2+5, y, width, height);
    }
    else{
        CGContextMoveToPoint(context, cenX, 0);
        CGContextAddLineToPoint(context, cenX-5, 5);
        CGContextAddLineToPoint(context, 1, 5);
        CGContextAddLineToPoint(context, 1, height-1);
        CGContextAddLineToPoint(context, width-1, height-1);
        CGContextAddLineToPoint(context, width-1, 5);
        CGContextAddLineToPoint(context, cenX+5, 5);
        CGContextAddLineToPoint(context, cenX, 0);
        self.frame = CGRectMake(x, y, width, height);
    }
    CGContextStrokePath(context);

    [super drawRect:rect];
}


@end
