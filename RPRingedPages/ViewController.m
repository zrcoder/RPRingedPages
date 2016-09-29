//
//  ViewController.m
//  RPRingedPages
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "ViewController.h"
#import "RPRingedPages.h"

@interface ViewController () <RPRingedPagesDelegate, RPRingedPagesDataSource>

@property (nonatomic, strong) RPRingedPages *pages;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (RPRingedPages *)pages {
    if (_pages == nil) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect pagesFrame = CGRectMake(0, 100, screenWidth, screenWidth * 0.4);
        
        RPRingedPages *pages = [[RPRingedPages alloc] initWithFrame:pagesFrame];
        CGFloat height = pagesFrame.size.height - pages.pageControlHeight - pages.pageControlMarginTop - pages.pageControlMarginBottom;
        pages.carousel.mainPageSize = CGSizeMake(height * 0.8, height);
        pages.carousel.pageScale = 0.6;
        pages.dataSource = self;
        pages.delegate = self;
        
        _pages = pages;
    }
    return _pages;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pages];
    [self makeDataSource];
    [self.pages reloadData];
}

- (void)makeDataSource {
    for (int i=0; i<3; i++) {
        NSString *s = [NSString stringWithFormat:@"%c", i + 'A'];
        [self.dataSource addObject:s];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfItemsInRingedPages:(RPRingedPages *)pages {
    return self.dataSource.count;
}
- (UIView *)ringedPages:(RPRingedPages *)pages viewForItemAtIndex:(NSInteger)index {
    UILabel *label = (UILabel *)[pages dequeueReusablePage];
    if (![label isKindOfClass:[UILabel class]]) {
        label = [UILabel new];
        label.font = [UIFont systemFontOfSize:50];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.layer.backgroundColor = [UIColor blackColor].CGColor;
        label.layer.cornerRadius = 5;
    }
    label.text = self.dataSource[index];
    return label;
}
- (void)didSelectedCurrentPageInPages:(RPRingedPages *)pages {
    NSLog(@"pages selected, the current index is %zd", pages.currentIndex);
}
- (void)didScrollToIndex:(NSInteger)index inPages:(RPRingedPages *)pages {
    NSLog(@"pages scrolled to index: %zd", index);
}

- (IBAction)changeMainPageSize:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 1:
            self.pages.carousel.mainPageSize = CGSizeMake(60, 100);
            break;
        case 2:
            self.pages.carousel.mainPageSize = CGSizeMake(100, 100);
            break;
        default: {
            self.pages.carousel.mainPageSize = self.originMainPageSize;
            break;
        }
    }
    [self.pages reloadData];
}

- (IBAction)changePageScale:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 1:
            self.pages.carousel.pageScale = 0.8;
            break;
        case 2:
            self.pages.carousel.pageScale = 0.5;
            break;
        default:
            self.pages.carousel.pageScale = 0.6;
            break;
    }
    [self.pages reloadData];
}

- (CGSize)originMainPageSize {
    CGFloat height = [UIScreen mainScreen].bounds.size.width * 0.4;
    height -= (self.pages.pageControlHeight + self.pages.pageControlMarginTop + self.pages.pageControlMarginBottom);
    return CGSizeMake(height * 0.8, height);
}

@end
