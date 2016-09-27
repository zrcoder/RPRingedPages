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
        pages.carousel.mainPageSize = CGSizeMake(pagesFrame.size.height * 0.8, pagesFrame.size.height);
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
    for (int i=0; i<7; i++) {
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
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:50];
    label.text = self.dataSource[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.layer.backgroundColor = [UIColor blackColor].CGColor;
    label.layer.cornerRadius = 5;
    return label;
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
            CGFloat pagesHeight = self.pages.frame.size.height;
            self.pages.carousel.mainPageSize = CGSizeMake(pagesHeight * 0.8, pagesHeight);
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

@end
