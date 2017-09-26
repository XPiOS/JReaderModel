//
//  JReaderBaseAnimationViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderBaseAnimationViewController.h"

@interface JReaderBaseAnimationViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong, nullable) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation JReaderBaseAnimationViewController

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.currentViewController = viewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    if (self.currentViewController) {
        [self addChildViewController:self.currentViewController];
        [self.view addSubview:self.currentViewController.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jumpViewController:(UIViewController *)viewController {
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = viewController;
    [self.view addSubview:self.currentViewController.view];
    [self addChildViewController:self.currentViewController];
}

#pragma mark - 拖动手势
- (void)panGestureRecognizerClick: (UIPanGestureRecognizer *)panGes {
    // 用于辨别方向
    CGFloat pointX = [panGes translationInView:self.view].x;
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.panGesRecBeganX = [panGes locationInView:self.view].x;
        [self panGesBegan:pointX];
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        [self panGesChanged:pointX];
    } else {
        [self panGesEnded:pointX];
    }
}
#pragma mark - 点击手势
- (void)tapGestureRecognizerClick: (UITapGestureRecognizer *)tapGes {
    if ([self.delegate respondsToSelector:@selector(jReaderBaseAnimationViewController:tapGestureRecognizer:)]) {
        if ([self.delegate jReaderBaseAnimationViewController:self tapGestureRecognizer:tapGes]) {
            CGFloat tapGesX = [tapGes locationInView:self.view].x;
            if (tapGesX >= JREADER_SCREEN_WIDTH / 2) {
                [self gotoNextPage];
            } else {
                [self gotoPreviousPage];
            }
        }
    }
}

#pragma mark - 对外暴露方法
#pragma mark 跳转上一页
- (void)gotoPreviousPage {
    if ([self.dataSource respondsToSelector:@selector(jReaderBaseAnimationViewController:viewControllerBeforeViewController:)]) {
        self.nextViewController = [self.dataSource jReaderBaseAnimationViewController:self viewControllerBeforeViewController:self.currentViewController];
        if (!self.nextViewController) {
            return;
        }
    }
    [self addChildViewController:self.nextViewController];
    [self.view insertSubview:self.nextViewController.view belowSubview:self.currentViewController.view];
}
#pragma mark 跳转下一页
- (void)gotoNextPage {
    if ([self.dataSource respondsToSelector:@selector(jReaderBaseAnimationViewController:viewControllerAfterViewController:)]) {
        self.nextViewController = [self.dataSource jReaderBaseAnimationViewController:self viewControllerAfterViewController:self.currentViewController];
        if (!self.nextViewController) {
            return;
        }
    }
    [self addChildViewController:self.nextViewController];
    [self.view insertSubview:self.nextViewController.view belowSubview:self.currentViewController.view];
}
#pragma mark 开始拖动
- (void)panGesBegan:(CGFloat)pointX {
    if (pointX >= 0) {
        self.panGesRecMax = -999;
        self.isLeftPan = NO;
        if ([self.dataSource respondsToSelector:@selector(jReaderBaseAnimationViewController:viewControllerBeforeViewController:)]) {
            self.nextViewController = [self.dataSource jReaderBaseAnimationViewController:self viewControllerBeforeViewController:self.currentViewController];
            if (!self.nextViewController) {
                return;
            }
        }
        [self addChildViewController:self.nextViewController];
        [self.view insertSubview:self.nextViewController.view belowSubview:self.currentViewController.view];
    } else {
        self.isLeftPan = YES;
        self.panGesRecMax = 999;
        if ([self.dataSource respondsToSelector:@selector(jReaderBaseAnimationViewController:viewControllerAfterViewController:)]) {
            self.nextViewController = [self.dataSource jReaderBaseAnimationViewController:self viewControllerAfterViewController:self.currentViewController];
            if (!self.nextViewController) {
                return;
            }
        }
        [self addChildViewController:self.nextViewController];
        [self.view insertSubview:self.nextViewController.view belowSubview:self.currentViewController.view];
    }
}
#pragma mark 拖动过程中
- (void)panGesChanged: (CGFloat)pointX {
    if (self.isLeftPan) {
        self.panGesRecMax = self.panGesRecMax > pointX ? pointX : self.panGesRecMax;
    } else{
        self.panGesRecMax = self.panGesRecMax > pointX ? self.panGesRecMax : pointX;
    }
}
#pragma mark 拖动结束
- (void)panGesEnded: (CGFloat)pointX {
}

#pragma mark - get/set
- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerClick:)];
    }
    return _panGestureRecognizer;
}
- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick:)];
    }
    return _tapGestureRecognizer;
}

@end
