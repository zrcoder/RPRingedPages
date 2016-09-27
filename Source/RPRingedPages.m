//
//  RPRingedPages.m
//  RPRingedPages
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "RPRingedPages.h"

@interface RPRingedPages () <RPPagedFlowViewDelegate, RPPagedFlowViewDataSource>

@end

@implementation RPRingedPages

- (void)p_setDefaults {
    self.showPageControl = YES;
    self.carousel.autoScrollInterval = 3;
    self.pageControlPosition = RPPageControlPositonBellowBody;
    self.pageControlHeight = 15;
    self.pageControlMarginToPages = 20;
    self.pageControl.alignment = RPPageControlAlignmentCenter;
    self.pageControl.indicatorMargin = 3;
}

- (instancetype)initWithFrame:(CGRect )frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setDefaults];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self p_setDefaults];
    }
    return self;
}

- (void)reloadData {
    [self p_layoutPageControlAndCarousel];
    [self.carousel reloadData];
}
- (void)scrollToPageIndex:(NSUInteger)index {
    [self.carousel scrollToPage:index];
}
- (NSInteger)currentPageIndex {
    return self.carousel.currentPageIndex;
}
- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    [self scrollToPageIndex:currentPageIndex];
}

- (void)p_layoutPageControlAndCarousel {
    [self layoutIfNeeded];
    self.pageControl.numberOfPages = 0;
    [self.pageControl removeFromSuperview];
    [self.carousel removeFromSuperview];
    
    if (![self.dataSource respondsToSelector:@selector(numberOfItemsInRingedPages:)]) {
        return;
    }
    NSInteger number = [self.dataSource numberOfItemsInRingedPages:self];
    
    if (number < 1) {
        return;
    }
    self.pageControl.numberOfPages = number;
    
    CGRect carouselFrame;
    CGRect pageControlFrame;
    CGSize size = self.frame.size;
    switch (self.pageControlPosition) {
        case RPPageControlPositonAboveBody:
            pageControlFrame = CGRectMake(0, 0, size.width, self.pageControlHeight);
            carouselFrame = CGRectMake(0, self.pageControlHeight + self.pageControlMarginToPages, size.width, size.height - self.pageControlMarginToPages - self.pageControlHeight);
            break;
        case RPPageControlPositonInBodyTop:
            pageControlFrame = CGRectMake(0, self.pageControlMarginToPages, size.width, self.pageControlHeight);
            carouselFrame = CGRectMake(0, 0, size.width, size.height);
            break;
        case RPPageControlPositonInBodyBottom:
            pageControlFrame = CGRectMake(0, size.height - self.pageControlMarginToPages - self.pageControlHeight, size.width, self.pageControlHeight);
            carouselFrame = CGRectMake(0, 0, size.width, size.height);
            break;
        default:
            pageControlFrame = CGRectMake(0, size.height - self.pageControlHeight, size.width, self.pageControlHeight);
            carouselFrame = CGRectMake(0, 0, size.width, size.height - self.pageControlHeight - self.pageControlMarginToPages);
            break;
    }
    self.carousel.frame = carouselFrame;
    self.pageControl.frame = pageControlFrame;
    [self addSubview:self.carousel];
    [self addSubview:self.pageControl];
    if (!self.showPageControl) {
        self.carousel.frame = CGRectMake(0, 0, size.width, size.height);
    }
    
    self.pageControl.numberOfPages = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInRingedPages:)]) {
        NSInteger number = [self.dataSource numberOfItemsInRingedPages:self];
        self.pageControl.numberOfPages = number;
        self.pageControl.currentPage = 0;
    }
}

- (void)p_scrollToNext {
    NSInteger index = self.carousel.currentPageIndex + 1;
    if (index == [self.dataSource numberOfItemsInRingedPages:self] ) {
        index = 0;
    }
    [self.carousel scrollToPage:index];
}

- (NSInteger)numberOfPagesInFlowView:(RPPagedFlowView *)flowView {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInRingedPages:)]) {
        return [self.dataSource numberOfItemsInRingedPages:self];
    }
    return 0;
}
- (UIView *)flowView:(RPPagedFlowView *)flowView pageForItemAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(ringedPages:viewForItemAtIndex:)]) {
        return [self.dataSource ringedPages:self viewForItemAtIndex:index];
    }
    return nil;
}
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(RPPagedFlowView *)flowView {
    if(self.pageControl.currentPage != pageNumber) {
        self.pageControl.currentPage = pageNumber;
    }    
}
- (void)didSelectCurrentPageInFlowView:(RPPagedFlowView *)flowView {
    if ([self.delegate respondsToSelector:@selector(didSelectCurrentPageInPages:)]) {
        [self.delegate didSelectCurrentPageInPages:self];
    }
}

#pragma mark - getters and setters
- (RPPagedFlowView *)carousel {
    if (_carousel == nil) {
        _carousel = [RPPagedFlowView new];
        _carousel.dataSource = self;
        _carousel.delegate = self;
    }
    return _carousel;
}
- (RPPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [RPPageControl new];
        _pageControl.hidden = !self.showPageControl;
//        _pageControl.userInteractionEnabled = NO;
        [_pageControl addTarget:self action:@selector(pageControTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)pageControTapped:(RPPageControl *)pageControl {
    NSInteger page = pageControl.currentPage;
    [self.carousel scrollToPage:page];
}



@end
