//
//  AnimationViewController.m
//  zwsc
//
//  Created by XuPeng on 16/3/5.
//  Copyright © 2016年 中文万维. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()
@property (nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) CGFloat                beginX;
@property (nonatomic, assign) CGFloat                endX;
@property (nonatomic, assign) CGFloat                changedX;
@property (nonatomic, assign) CGFloat                beforeChangedX;
@property (nonatomic, assign) CGFloat                maxX;
@property (nonatomic, assign) BOOL                   isNextPage;
@property (nonatomic, assign) BOOL                   isFirstChanged;
@property (nonatomic, assign) BOOL                   isResponseGestures;

@end

@implementation AnimationViewController

- (instancetype)initWithView:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.currentViewController = viewController;
        self.isResponseGestures    = YES;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.currentViewController.view];
    _isFirstChanged       = YES;
    _isNextPage           = NO;
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick:)];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerClick:)];
    [self.view addGestureRecognizer:_panGestureRecognizer];
}
- (BOOL)setGestureRecognizerState:(BOOL)gestureRecognizerState {
    self.isResponseGestures = gestureRecognizerState;
    return YES;
}
- (void)panGestureRecognizerClick:(UIPanGestureRecognizer *)panGes {
    if (self.isResponseGestures == NO) {
        return;
    }
    if (panGes.state == UIGestureRecognizerStateBegan) {
        _beginX         = [panGes locationInView:self.view].x;
        _beforeChangedX = 0;
    }
    if (panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateFailed) {
        _isFirstChanged = YES;
        _endX           = [panGes locationInView:self.view].x;
        if (_isNextPage) {
            if (_endX - 4 < _maxX) {
                [self nextPageSuccessful];
            } else {
                [self nextPageFailure];
            }
        } else {
            if (_endX + 4 > _maxX) {
                [self previousPageSuccessful];
            } else {
                [self previousPageFailure];
            }
        }
    }
    if (panGes.state == UIGestureRecognizerStateChanged) {
        _changedX = [panGes locationInView:self.view].x;
        if (_isFirstChanged) {
            _isFirstChanged = NO;
            _beforeChangedX = _changedX;
            _maxX           = _changedX;
            if (_changedX - _beginX > 0) {
                [self dragForTheFirstTimePreviousPage:_changedX];
                _isNextPage = NO;
            } else {
                [self dragForTheFirstTimeNextPage:(_changedX - _beginX)];
                _isNextPage = YES;
            }
        } else {
            if (_isNextPage) {
                [self dragChangeNextPage:(_changedX - _beforeChangedX)];
                _beforeChangedX = _changedX;
                if (_changedX < _maxX) {
                    _maxX = _changedX;
                }
            } else {
                [self dragChangePreviousPage:_changedX];
                if (_changedX > _maxX) {
                    _maxX = _changedX;
                }
            }
        }
    }
}
- (void)tapGestureRecognizerClick:(UITapGestureRecognizer *)tapGes {
    if (self.isResponseGestures == NO) {
        return;
    }
    CGRect previousRect = CGRectMake(0, 0, kScreenWidth / 2, kScreenHeight);
    CGRect nextRect     = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, kScreenHeight);
    CGPoint point       = [tapGes locationInView:self.view];
    if (CGRectContainsPoint(previousRect, point)) {
        [self gotoPreviousPage];
    } else if (CGRectContainsPoint(nextRect, point)) {
        [self gotoNextPage];
    }
}
- (void)nextPageSuccessful {
}
- (void)nextPageFailure {
}
- (void)previousPageSuccessful {
}
- (void)previousPageFailure {
}
- (void)dragForTheFirstTimePreviousPage:(CGFloat)changeValue {
}
- (void)dragForTheFirstTimeNextPage:(CGFloat)changeValue {
}
- (void)dragChangeNextPage:(CGFloat)changeValue {
}
- (void)dragChangePreviousPage:(CGFloat)changeValue {
}
- (void)gotoNextPage {
}
- (void)gotoPreviousPage {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
