//
//  RPPageControl.m
//  RPRingedPages
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "RPPageControl.h"

static const CGFloat defaultIndicatorWidth = 6.0f;
static const CGFloat defaultIndicatorMargin = 10.0f;
static const CGFloat defaultMinHeight = 36.0f;

typedef NS_ENUM(NSUInteger, RPPageControlImageType) {
    RPPageControlImageTypeNormal = 1,
    RPPageControlImageTypeCurrent
};

@interface RPPageControl ()
@property (strong, readwrite, nonatomic) NSArray *pageRects;
@property (nonatomic, strong) UIPageControl *accessibilityPageControl;
@end

@implementation RPPageControl {
@private
    NSInteger			_displayedPage;
    CGFloat				_measuredIndicatorWidth;
    CGFloat				_measuredIndicatorHeight;
}

- (void)_initialize {
    _numberOfPages = 0;
    self.backgroundColor = [UIColor clearColor];

    self.indicatorDiameter = defaultIndicatorWidth;
    self.indicatorMargin = defaultIndicatorMargin;
    self.minHeight = defaultMinHeight;
    
    _alignment = RPPageControlAlignmentCenter;
    _verticalAlignment = RPPageControlVerticalAlignmentMiddle;
    _indicatorTintColor = [UIColor lightGrayColor];
    _currentIndicatorTintColor = [UIColor blueColor];
    
    self.isAccessibilityElement = YES;
    self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
    self.accessibilityPageControl = [[UIPageControl alloc] init];
    self.accessibilityPageControl.pageIndicatorTintColor = self.indicatorTintColor;
    self.accessibilityPageControl.currentPageIndicatorTintColor = self.currentIndicatorTintColor;
    self.accessibilityPageControl.userInteractionEnabled = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (nil == self) {
        return nil;
    }
    [self _initialize];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (nil == self) {
        return nil;
    }
    [self _initialize];
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self _renderPages:context rect:rect];
}

- (void)_renderPages:(CGContextRef)context rect:(CGRect)rect {
    NSMutableArray *pageRects = [NSMutableArray arrayWithCapacity:self.numberOfPages];
    
    CGFloat left = [self _leftOffset];
    
    CGFloat xOffset = left;
    CGFloat yOffset = 0.0f;
    UIImage *image = nil;
    
    for (NSInteger i = 0; i < _numberOfPages; i++) {
        
        if (i == _displayedPage) {
            image = _currentPageIndicatorImage;
        } else {
            image = _pageIndicatorImage;
        }
        CGRect indicatorRect;
        if (image) {
            yOffset = [self _topOffsetForHeight:image.size.height rect:rect];
            CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - image.size.width) / 2.0f);
            [image drawAtPoint:CGPointMake(centeredXOffset, yOffset)];
            indicatorRect = CGRectMake(centeredXOffset, yOffset, image.size.width, image.size.height);
        } else {
            yOffset = [self _topOffsetForHeight:_indicatorDiameter rect:rect];
            CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - _indicatorDiameter) / 2.0f);
            indicatorRect = CGRectMake(centeredXOffset, yOffset, _indicatorDiameter, _indicatorDiameter);
            CGContextFillEllipseInRect(context, indicatorRect);
        }
        
        [pageRects addObject:[NSValue valueWithCGRect:indicatorRect]];
        xOffset += _measuredIndicatorWidth + _indicatorMargin;
    }
    
    self.pageRects = pageRects;
    [self layoutIfNeeded];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_currentPageIndicatorImage && !_pageIndicatorImage) {
        self.accessibilityPageControl.frame = self.bounds ;
        [self addSubview:self.accessibilityPageControl];
        self.accessibilityPageControl.pageIndicatorTintColor = self.indicatorTintColor;
        self.accessibilityPageControl.currentPageIndicatorTintColor = self.currentIndicatorTintColor;
    } else {
        [self.accessibilityPageControl removeFromSuperview];
    }
}

- (CGFloat)_leftOffset {
    CGRect rect = self.bounds;
    CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat left = 0.0f;
    switch (_alignment) {
        case RPPageControlAlignmentCenter:
            left = ceilf(CGRectGetMidX(rect) - (size.width / 2.0f));
            break;
        case RPPageControlAlignmentRight:
            left = CGRectGetMaxX(rect) - size.width;
            break;
        default:
            break;
    }
    
    return left;
}

- (CGFloat)_topOffsetForHeight:(CGFloat)height rect:(CGRect)rect {
    CGFloat top = 0.0f;
    switch (_verticalAlignment) {
        case RPPageControlVerticalAlignmentMiddle:
            top = CGRectGetMidY(rect) - (height / 2.0f);
            break;
        case RPPageControlVerticalAlignmentBottom:
            top = CGRectGetMaxY(rect) - height;
            break;
        default:
            break;
    }
    return top;
}

- (void)updateCurrentPageDisplay {
    _displayedPage = _currentPage;
    [self setNeedsDisplay];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    CGFloat marginSpace = MAX(0, pageCount - 1) * _indicatorMargin;
    CGFloat indicatorSpace = pageCount * _measuredIndicatorWidth;
    CGSize size = CGSizeMake(marginSpace + indicatorSpace, _measuredIndicatorHeight);
    return size;
}

- (CGRect)rectForPageIndicator:(NSInteger)pageIndex {
    if (pageIndex < 0 || pageIndex >= _numberOfPages) {
        return CGRectZero;
    }
    
    CGFloat left = [self _leftOffset];
    CGSize size = [self sizeForNumberOfPages:pageIndex + 1];
    CGRect rect = CGRectMake(left + size.width - _measuredIndicatorWidth, 0, _measuredIndicatorWidth, _measuredIndicatorWidth);
    return rect;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [self sizeForNumberOfPages:self.numberOfPages];
    sizeThatFits.height = MAX(sizeThatFits.height, _minHeight);
    return sizeThatFits;
}

- (CGSize)intrinsicContentSize {
    if (_numberOfPages < 1) {
        return CGSizeMake(UIViewNoIntrinsicMetric, 0.0f);
    }
    CGSize intrinsicContentSize = CGSizeMake(UIViewNoIntrinsicMetric, MAX(_measuredIndicatorHeight, _minHeight));
    return intrinsicContentSize;
}

- (void)updatePageNumberForScrollView:(UIScrollView *)scrollView {
    NSInteger page = (int)floorf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.currentPage = page;
}

- (void)setScrollViewContentOffsetForCurrentPage:(UIScrollView *)scrollView animated:(BOOL)animated {
    CGPoint offset = scrollView.contentOffset;
    offset.x = scrollView.bounds.size.width * self.currentPage;
    [scrollView setContentOffset:offset animated:animated];
}

#pragma mark -

- (void)_updateMeasuredIndicatorSizeWithSize:(CGSize)size {
    _measuredIndicatorWidth = MAX(_measuredIndicatorWidth, size.width);
    _measuredIndicatorHeight = MAX(_measuredIndicatorHeight, size.height);
}

- (void)_updateMeasuredIndicatorSizes {
    _measuredIndicatorWidth = _indicatorDiameter;
    _measuredIndicatorHeight = _indicatorDiameter;
    
    if ( self.pageIndicatorImage && self.currentPageIndicatorImage ) {
        _measuredIndicatorWidth = 0;
        _measuredIndicatorHeight = 0;
    }
    
    if (self.pageIndicatorImage) {
        [self _updateMeasuredIndicatorSizeWithSize:self.pageIndicatorImage.size];
    }
    
    if (self.currentPageIndicatorImage) {
        [self _updateMeasuredIndicatorSizeWithSize:self.currentPageIndicatorImage.size];
    }
    
    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }
}


#pragma mark - Tap Gesture
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat left = [self _leftOffset];
    CGFloat middle = left + (size.width / 2.0f);
    if (point.x < middle) {
        [self setCurrentPage:self.currentPage - 1 sendEvent:YES canDefer:YES];
    } else {
        [self setCurrentPage:self.currentPage + 1 sendEvent:YES canDefer:YES];
    }
    
}

#pragma mark - Accessors

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter {
    if (indicatorDiameter == _indicatorDiameter) {
        return;
    }
    if (_minHeight < indicatorDiameter) {
        self.minHeight = indicatorDiameter;
    }
    [self _updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}

- (void)setIndicatorMargin:(CGFloat)indicatorMargin {
    if (indicatorMargin == _indicatorMargin) {
        return;
    }
    _indicatorMargin = indicatorMargin;
    [self setNeedsDisplay];
}

- (void)setMinHeight:(CGFloat)minHeight {
    if (minHeight == _minHeight) {
        return;
    }
    if (minHeight < _indicatorDiameter) {
        minHeight = _indicatorDiameter;
    }
    _minHeight = minHeight;
    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }
    [self setNeedsLayout];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages == _numberOfPages) {
        return;
    }
    self.accessibilityPageControl.numberOfPages = numberOfPages;
    if (numberOfPages > 0) {
        self.accessibilityPageControl.currentPage = 0;
    }
    _numberOfPages = MAX(0, numberOfPages);
    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }
    [self updateAccessibilityValue];
    [self setNeedsDisplay];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [self setCurrentPage:currentPage sendEvent:NO canDefer:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage sendEvent:(BOOL)sendEvent canDefer:(BOOL)defer {
    _currentPage = MIN(MAX(0, currentPage), _numberOfPages - 1);
    self.accessibilityPageControl.currentPage = self.currentPage;
    [self updateAccessibilityValue];
    if (!defer) {
        _displayedPage = _currentPage;
        [self setNeedsDisplay];
    }
    if (sendEvent) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage {
    if ([currentPageIndicatorImage isEqual:_currentPageIndicatorImage]) {
        return;
    }
    _currentPageIndicatorImage = currentPageIndicatorImage;
    [self _updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage {
    if ([pageIndicatorImage isEqual:_pageIndicatorImage]) {
        return;
    }
    _pageIndicatorImage = pageIndicatorImage;
    [self _updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}


#pragma mark - UIAccessibility
- (void)updateAccessibilityValue {
    NSString *accessibilityValue = self.accessibilityPageControl.accessibilityValue;
    self.accessibilityValue = accessibilityValue;
}

@end

