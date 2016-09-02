//
//  BackViewController.m
//  zwsc
//
//  Created by XuPeng on 16/2/29.
//  Copyright © 2016年 中文万维. All rights reserved.
//

#import "BackViewController.h"

@interface BackViewController ()
@property (nonatomic, strong) UIImage *backgroundImage;
@end

@implementation BackViewController {
    CGFloat      _alpha;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateWithViewController:(ReaderViewController *)viewController {
    [self.view addSubview:[self captureView:viewController.view]];
}

- (void)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
}

- (UIImageView *)captureView:(UIView *)view {
    CGSize size                 = view.bounds.size;
    CGAffineTransform transform = CGAffineTransformMake(-1,0,0,1,size.width,0);
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, 0.0f);
    CGContextRef context        = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    [view.layer renderInContext:context];
    UIImage *image              = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView      = [[UIImageView alloc] initWithImage:image];
    imageView.alpha             = _alpha;
    return imageView;
}

@end
