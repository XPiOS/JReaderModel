//
//  JReaderBackViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/15.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderBackViewController.h"

@interface JReaderBackViewController ()

@end

@implementation JReaderBackViewController

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.view.backgroundColor = viewController.view.backgroundColor;
        [self.view addSubview:[self captureView:viewController.view]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)captureView:(UIView *)view {
    CGSize size = view.bounds.size;
    CGAffineTransform transform = CGAffineTransformMake(-1,0,0,1,size.width,0);
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.alpha = 0.5;
    return imageView;
}

@end
