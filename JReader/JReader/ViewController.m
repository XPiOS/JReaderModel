//
//  ViewController.m
//  JReader
//
//  Created by Jerry on 2017/10/19.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ViewController.h"
#import "ReaderViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) ReaderViewController *readerViewController;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JReaderDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *beginReaderButton = [[UIButton alloc] init];
    [beginReaderButton setTitle:@"开始阅读" forState:UIControlStateNormal];
    beginReaderButton.backgroundColor = [UIColor grayColor];
    [beginReaderButton addTarget:self action:@selector(beginReaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    beginReaderButton.layer.masksToBounds = YES;
    beginReaderButton.layer.cornerRadius = 5;
    
    [self.view addSubview:beginReaderButton];
    beginReaderButton.wd_layout
    .centerXEqualToSuperView()
    .centerYEqualToSuperView()
    .width(100)
    .height(44);
    
    
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
- (void)beginReaderButtonClick: (UIButton *)button {
        [self.navigationController pushViewController:self.readerViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get/set
- (ReaderViewController *)readerViewController {
    if (!_readerViewController) {
        _readerViewController = [[ReaderViewController alloc] init];
    }
    return _readerViewController;
}
@end
