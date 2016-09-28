//
//  RPPagesCarousel.h
//  RPRingedPages
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPPagesCarouselDataSource;
@protocol RPPagesCarouselDelegate;

@interface RPPagesCarousel : UIView

@property (nonatomic,assign) CGSize mainPageSize;
@property (nonatomic, assign) CGFloat pageScale;
@property (nonatomic, assign) NSTimeInterval autoScrollInterval; //if == 0, will not scroll autoly.

@property (nonatomic,assign)   id <RPPagesCarouselDataSource> dataSource;
@property (nonatomic,assign)   id <RPPagesCarouselDelegate>   delegate;

@property (nonatomic, assign, readonly) NSInteger currentPageIndex;
- (void)reloadData;
- (void)scrollToPage:(NSUInteger)pageNumber;

@end

@protocol  RPPagesCarouselDelegate<NSObject>

@optional

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(RPPagesCarousel *)flowView;
- (void)didSelectCurrentPageInFlowView:(RPPagesCarousel *)flowView;

@end


@protocol RPPagesCarouselDataSource <NSObject>

- (NSInteger)numberOfPagesInFlowView:(RPPagesCarousel *)flowView;
- (UIView *)flowView:(RPPagesCarousel *)flowView pageForItemAtIndex:(NSInteger)index;

@end
