# RPRingedPages
Pages in a ring!<br>
You can set auto scroll time, and custom the pageControl appearance.<br>

![img](https://github.com/DingHub/ScreenShots/blob/master/RPRingedPages/0.png)
![img](https://github.com/DingHub/ScreenShots/blob/master/RPRingedPages/1.png)
![img](https://github.com/DingHub/ScreenShots/blob/master/RPRingedPages/2.png)
![img](https://github.com/DingHub/ScreenShots/blob/master/RPRingedPages/3.png)

Usage:
---
If in a UIViewController
```
@interface ViewController () <RPRingedPagesDelegate, RPRingedPagesDataSource>

@property (nonatomic, strong) RPRingedPages *pages;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end
        
```
```
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

```
```
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

- (void)didSelectCurrentPageInPages:(RPRingedPages *)pages {
    NSLog(@"pages selected, the current index is %zd", pages.currentPageIndex);
}
```
