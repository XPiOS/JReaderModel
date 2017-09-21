//
//  JReaderViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderViewController.h"
#import "JReaderView.h"
#import "jReaderPageHeaderView.h"
#import "jReaderPageFooterView.h"

@interface JReaderViewController ()

@property (nonatomic, strong) JReaderView *jReaderView;

@property (nonatomic, strong) jReaderPageHeaderView *headerView;
@property (nonatomic, strong) jReaderPageFooterView *footerView;

@end

@implementation JReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.jReaderView) {
        self.jReaderView = [[JReaderView alloc] init];
        [self.view addSubview:self.jReaderView];
        self.jReaderView.frame = self.jReaderFrame;
    }
    self.jReaderView.jReaderContentStr = self.jReaderContentStr;
    self.jReaderView.jReaderAttributes = self.jReaderAttributes;
    self.jReaderView.jReaderNameRange = self.jReaderNameRange;
    self.jReaderView.jReaderNameAttributes = self.jReaderNameAttributes;
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(6, 6);
    self.view.layer.shadowOpacity = 0.5;
    
    [self.view addSubview:self.headerView];
    self.headerView.titleLabel.text = self.jReaderNameStr;
    self.headerView.frame = CGRectMake(self.jReaderFrame.origin.x, 0, self.jReaderFrame.size.width, self.jReaderFrame.origin.y);
    
    [self.view addSubview:self.footerView];
    self.footerView.progressLabel.text = [NSString stringWithFormat:@"%zd / %zd", self.jReaderPageIndex + 1, self.jReaderPageCount];
    self.footerView.frame = CGRectMake(self.jReaderFrame.origin.x, self.jReaderFrame.origin.y + self.jReaderFrame.size.height, self.jReaderFrame.size.width, self.view.bounds.size.height - self.jReaderFrame.origin.y - self.jReaderFrame.size.height);
}
- (jReaderPageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[jReaderPageHeaderView alloc] init];
    }
    return _headerView;
}
- (jReaderPageFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[jReaderPageFooterView alloc] init];
    }
    return _footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
