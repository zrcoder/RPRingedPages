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
@property (nonatomic, assign) NSTimeInterval autoScrollInterval; //if <= 0, will not scroll automatically.

@property (nonatomic,assign)   id <RPPagesCarouselDataSource> dataSource;
@property (nonatomic,assign)   id <RPPagesCarouselDelegate>   delegate;

@property (nonatomic, assign, readonly) NSInteger currentIndex;
- (void)reloadData;
- (void)scrollToIndex:(NSUInteger)pageIndex;
- (UIView *)dequeueReusablePage;

@end

@protocol  RPPagesCarouselDelegate<NSObject>

@optional

- (void)didScrollToIndex:(NSInteger)index inCarousel:(RPPagesCarousel *)carousel;
- (void)didSelectedCurrentPageInCarousel:(RPPagesCarousel *)carousel;

@end


@protocol RPPagesCarouselDataSource <NSObject>

- (NSInteger)numberOfPagesInCarousel:(RPPagesCarousel *)carousel;
- (UIView *)carousel:(RPPagesCarousel *)carousel pageForItemAtIndex:(NSInteger)index;

@end
