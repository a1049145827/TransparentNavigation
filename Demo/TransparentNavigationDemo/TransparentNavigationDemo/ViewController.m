//
//  ViewController.m
//  TransparentNavigationDemo
//
//  Created by geekbruce on 2019/1/18.
//  Copyright © 2019 GeekBruce. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "TransparentNavigationDemo-Swift.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"First View";
    
    self.view.backgroundColor = [UIColor colorWithRed:0x32/255.0f green:0xAB/255.0f blue:0x64/255.0f alpha:1.0f];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    btn.center = CGPointMake(self.view.bounds.size.width * 0.5, 180);
    [btn setTitle:@"Next View" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self getSub:self.navigationController.navigationBar andLevel:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBarBgAlpha = @1;
}

// 获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    if ([subviews count] == 0) return;
    for (UIView *subview in subviews) {
        
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        NSLog(@"%@%d: %@", blank, level, subview.class);
        [self getSub:subview andLevel:(level+1)];
    }
}

// 按钮响应
- (void)toNextView {
    NextViewController *nextVC = [[NextViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
