//
//  RPPagedFlowView.h
//  RPRingedPages
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPPagedFlowViewDataSource;
@protocol RPPagedFlowViewDelegate;

@interface RPPagedFlowView : UIView<UIScrollViewDelegate>

@property (nonatomic,assign) CGSize mainPageSize;
@property (nonatomic, assign) CGFloat pageScale;
@property (nonatomic, assign) NSTimeInterval autoScrollInterval; //if == 0, will not scroll autoly.

@property (nonatomic,assign)   id <RPPagedFlowViewDataSource> dataSource;
@property (nonatomic,assign)   id <RPPagedFlowViewDelegate>   delegate;

@property (nonatomic, assign, readonly) NSInteger currentPageIndex;
- (void)reloadData;
- (void)scrollToPage:(NSUInteger)pageNumber;

@end

@protocol  RPPagedFlowViewDelegate<NSObject>

@optional

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(RPPagedFlowView *)flowView;

- (void)didSelectCurrentPageInFlowView:(RPPagedFlowView *)flowView;

@end


@protocol RPPagedFlowViewDataSource <NSObject>

- (NSInteger)numberOfPagesInFlowView:(RPPagedFlowView *)flowView;

- (UIView *)flowView:(RPPagedFlowView *)flowView pageForItemAtIndex:(NSInteger)index;

@end
