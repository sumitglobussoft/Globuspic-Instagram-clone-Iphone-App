//
//  SCFilterSwitcherView.m
//  SCRecorderExamples
//
//  Created by Simon CORSIN on 29/05/14.
//
//

#import "SCSwipeableFilterView.h"
#import "CIImageRendererUtils.h"
#import "SCSampleBufferHolder.h"
#import "SCFilterSelectorViewInternal.h"

@interface SCSwipeableFilterView() {
    CGFloat _filterGroupIndexRatio;
}

@end

@implementation SCSwipeableFilterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)dealloc {
}

- (void)commonInit {
    [super commonInit];
    
    _refreshAutomaticallyWhenScrolling = YES;
    _selectFilterScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _selectFilterScrollView.delegate = self;
    _selectFilterScrollView.pagingEnabled = YES;
    _selectFilterScrollView.showsHorizontalScrollIndicator = NO;
    _selectFilterScrollView.showsVerticalScrollIndicator = NO;
    _selectFilterScrollView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_selectFilterScrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _selectFilterScrollView.frame = self.bounds;

    [self updateScrollViewContentSize];
}

- (void)updateScrollViewContentSize {
    _selectFilterScrollView.contentSize = CGSizeMake(self.filterGroups.count * self.frame.size.width * 2, self.frame.size.height);
}

static CGRect CGRectTranslate(CGRect rect, CGFloat width, CGFloat maxWidth) {
    rect.origin.x += width;

    return rect;
}

- (void)updateCurrentSelected:(NSInteger)selectedIndex {
    NSUInteger filterGroupsCount = self.filterGroups.count;
//    NSInteger selectedIndex1 = (NSInteger)((_selectFilterScrollView.contentOffset.x + _selectFilterScrollView.frame.size.width / 2) / _selectFilterScrollView.frame.size.width) % filterGroupsCount;
    id newFilterGroup = nil;
    
    if (selectedIndex >= 0 && selectedIndex < filterGroupsCount) {
        newFilterGroup = [self.filterGroups objectAtIndex:selectedIndex];
    } else {
        NSLog(@"Invalid Index");
       // NSLog(@"Invalid contentOffset of scrollView in SCFilterSwitcherView (%f/%f with %d)", _selectFilterScrollView.contentOffset.x, _selectFilterScrollView.contentOffset.y, (int)self.filterGroups.count);
    }
    
    [self setSelectedFilterGroup:newFilterGroup];

}

/*- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self updateCurrentSelected];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateCurrentSelected];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCurrentSelected];
}*/

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat contentSizeWidth = scrollView.contentSize.width;
    CGFloat normalWidth = self.filterGroups.count * width;
    
       NSLog(@"scroll view did scroll width %f",width);
    NSLog(@"scroll view did scroll contentOffset %f",contentOffsetX);
    NSLog(@"scroll view did scroll contentSizewidth %f",contentSizeWidth);
    NSLog(@"scroll view did scroll normalWidth %f",normalWidth);
    NSLog(@"scroll view content offset x1 %f",scrollView.contentOffset.x);
    NSLog(@"scroll view content offset y1 %f",scrollView.contentOffset.y);
    
    
    if (contentOffsetX < 0) {
        scrollView.contentOffset = CGPointMake(contentOffsetX + normalWidth, scrollView.contentOffset.y);
    } else if (contentOffsetX + width > contentSizeWidth) {
        scrollView.contentOffset = CGPointMake(contentOffsetX - normalWidth, scrollView.contentOffset.y);
    }
    NSLog(@"scroll view content offset x2 %f",scrollView.contentOffset.x);
    NSLog(@"scroll view content offset y2 %f",scrollView.contentOffset.y);
    
    CGFloat ratio = scrollView.contentOffset.x / width;
    
    _filterGroupIndexRatio = ratio;
    
    if (_refreshAutomaticallyWhenScrolling) {
        [self refresh];
    }
}*/

-(void)updateScrollViewWithFilter:(NSInteger)index{
    CGFloat width = _selectFilterScrollView.frame.size.width;
  static  CGFloat contentOffsetX = 320;//_selectFilterScrollView.contentOffset.x;
    CGFloat contentSizeWidth = _selectFilterScrollView.contentSize.width;
    CGFloat normalWidth = self.filterGroups.count * width;
    
   
    if(index==1)
    {
        contentOffsetX = width*index;
    }
    if(index==2)
    {
        contentOffsetX = width*index;
    }
    if(index==3)
    {
        contentOffsetX = width*index;
    }
    if(index==4)
    {
        contentOffsetX = width*index;
    }
    if(index==5)
    {
        contentOffsetX = width*index;
    }
    if(index==6)
    {
        contentOffsetX = width*index;
    }
    if(index==7)
    {
        contentOffsetX = width*index;
    }
    if(index==8)
    {
        contentOffsetX = width*index;
    }
    if (contentOffsetX < 0) {
        _selectFilterScrollView.contentOffset = CGPointMake(contentOffsetX + normalWidth, _selectFilterScrollView.contentOffset.y);
    } else if (contentOffsetX + width > contentSizeWidth) {
        _selectFilterScrollView.contentOffset = CGPointMake(contentOffsetX - normalWidth, _selectFilterScrollView.contentOffset.y);
    }
    
  //  CGFloat ratio = _selectFilterScrollView.contentOffset.x / width;
    CGFloat ratio = contentOffsetX / width;
    
    _filterGroupIndexRatio = ratio;
    
    NSUInteger filterGroupsCount = self.filterGroups.count;
    //    NSInteger selectedIndex1 = (NSInteger)((_selectFilterScrollView.contentOffset.x + _selectFilterScrollView.frame.size.width / 2) / _selectFilterScrollView.frame.size.width) % filterGroupsCount;
    id newFilterGroup = nil;
    
    if (index >= 0 && index < filterGroupsCount) {
        newFilterGroup = [self.filterGroups objectAtIndex:index];
    } else {
        NSLog(@"Invalid Index");
        // NSLog(@"Invalid contentOffset of scrollView in SCFilterSwitcherView (%f/%f with %d)", _selectFilterScrollView.contentOffset.x, _selectFilterScrollView.contentOffset.y, (int)self.filterGroups.count);
    }
    
    [self setSelectedFilterGroup:newFilterGroup];

    if (_refreshAutomaticallyWhenScrolling) {
        [self refresh];
    }
    
}

- (void)render:(CIImage *)image toContext:(CIContext *)context inRect:(CGRect)rect {
    CGRect extent = [image extent];
    
    CGFloat ratio = _filterGroupIndexRatio;
    
    NSInteger index = (NSInteger)ratio;
    NSInteger upIndex = (NSInteger)ceilf(ratio);
    CGFloat remainingRatio = ratio - ((CGFloat)index);
    
    NSArray *filterGroups = self.filterGroups;
    
    CGFloat xOutputRect = rect.size.width * -remainingRatio;
    CGFloat xImage = extent.size.width * -remainingRatio;
    
    while (index <= upIndex) {
        NSInteger currentIndex = index % filterGroups.count;
        id obj = [filterGroups objectAtIndex:currentIndex];
        CIImage *imageToUse = image;
        
        if ([obj isKindOfClass:[SCFilterGroup class]]) {
            imageToUse = [((SCFilterGroup *)obj) imageByProcessingImage:imageToUse];
        }
        
        CGRect outputRect = CGRectTranslate(rect, xOutputRect, rect.size.width);
        CGRect fromRect = CGRectTranslate(extent, xImage, extent.size.width);
        
        [context drawImage:imageToUse inRect:outputRect fromRect:fromRect];
        
        xOutputRect += rect.size.width;
        xImage += extent.size.width;
        index++;
    }
}

- (void)setFilterGroups:(NSArray *)filterGroups {
    [super setFilterGroups:filterGroups];
    
    [self updateScrollViewContentSize];
}

@end
