//
//  NextViewController.m
//  TransparentNavigationDemo
//
//  Created by geekbruce on 2019/1/18.
//  Copyright © 2019 GeekBruce. All rights reserved.
//

#import "NextViewController.h"
#import "ViewController.h"
#import <TransparentNavigation/TransparentNavigation-Swift.h>

@interface NextViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation NextViewController

static NSString * const cellID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Second";
    self.view.backgroundColor = [UIColor colorWithRed:0xe0/255.0f green:0x7a/255.0f blue:0x40/255.0f alpha:1.0f];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
    [btn setTitle:@"Next" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (@available(iOS 11, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBarBgAlpha = self.navBarBgAlpha ?: @0;
}

// 进入新界面
- (void)toNextView {
    ViewController *nextVC = [[ViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowlayout.minimumInteritemSpacing = 1;
        flowlayout.minimumLineSpacing = 1;
        flowlayout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
        flowlayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
        flowlayout.estimatedItemSize = flowlayout.itemSize;
        flowlayout.sectionInset = UIEdgeInsetsZero;
        
        if (!_collectionView) {
            _collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0 , 0 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowlayout];
        }
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

#pragma mark -- UICollectionView  Delegate、DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.section % 2 == 0) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor purpleColor];
    }
    
    return cell;
}

#pragma mark - UIScrollviewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0) {
        offset = 0;
    }
    CGFloat alpha = offset / 88.f;
    self.navBarBgAlpha = @(alpha);
    [self.navigationController setNeedsNavigationBackground:alpha animationDuration:0];
}

@end
