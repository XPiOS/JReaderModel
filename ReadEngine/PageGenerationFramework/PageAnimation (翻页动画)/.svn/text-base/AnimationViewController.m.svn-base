//
//  AnimationViewController.m
//  zwsc
//
//  Created by XuPeng on 16/3/5.
//  Copyright © 2016年 中文万维. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()

// 点击手势  截取左右各三分之一，用来上一页或下一页
@property (nonatomic, retain) UITapGestureRecognizer  *tapGestureRecognizer;
// 拖动手势
@property (nonatomic, retain) UIPanGestureRecognizer  *panGestureRecognizer;

// 开始的 X位置
@property (nonatomic, assign) CGFloat                  beginX;
// 结束的 X位置
@property (nonatomic, assign) CGFloat                  endX;
// 移动的 X位置
@property (nonatomic, assign) CGFloat                  changedX;
// 移动的 上一次X位置
@property (nonatomic, assign) CGFloat                  beforeChangedX;
// 记录移动过程中的最大值
@property (nonatomic, assign) CGFloat                  maxX;

// 用来记录是否翻到下一页
@property (nonatomic, assign) BOOL                     isNextPage;
// 是否为第一次进入拖动中
@property (nonatomic, assign) BOOL                     isFirstChanged;

// 用来记录是否响应用户手势
@property (nonatomic, assign) BOOL                     isResponseGestures;

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

// 视图将要加载执行
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.currentViewController.view];
    _isFirstChanged                = YES;
    _isNextPage                    = NO;

    // 点击手势
    _tapGestureRecognizer          = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick:)];
//    _tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_tapGestureRecognizer];

    // 拖动手势
    _panGestureRecognizer          = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerClick:)];
    [self.view addGestureRecognizer:_panGestureRecognizer];
}

#pragma mark - 设置是否响应手势
- (BOOL)setGestureRecognizerState:(BOOL)gestureRecognizerState {
    self.isResponseGestures = gestureRecognizerState;
    return YES;
}

#pragma mark - 拖动手势响应区域
- (void)panGestureRecognizerClick:(UIPanGestureRecognizer *)panGes {
    
    if (self.isResponseGestures == NO) {
        return;
    }
    // 拖动开始
    if (panGes.state == UIGestureRecognizerStateBegan) {
        // 记录开始位置
        _beginX         = [panGes locationInView:self.view].x;
        _beforeChangedX = 0;
        // 视图滑动到手指位置
    }
    // 拖动结束 或 手指离开屏幕
    if (panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateFailed) {
        // 将第一次进入拖动置为YES
        _isFirstChanged = YES;

        // 记录结束位置
        _endX           = [panGes locationInView:self.view].x;
        
        // 手指松开的位置，与拖动过程中的最大值进行比较，不是跟起始位置进行比较。比较的是一个模糊值，也就是可以相差几个单位(误差范围为4)
        if (_isNextPage) {
            // 下一页比较的是谁更小
            if (_endX - 4 < _maxX) {
                NSLog(@"翻页成功");
                [self nextPageSuccessful];
            } else {
                NSLog(@"翻页失败");
                // 翻页失败
                [self nextPageFailure];
            }
        } else {
            // 上一页，比较谁更大
            if (_endX + 4 > _maxX) {
                NSLog(@"翻页成功");
                [self previousPageSuccessful];
            } else {
                NSLog(@"翻页失败");
                [self previousPageFailure];
            }
        }
    }
    
    // 拖动中
    if (panGes.state == UIGestureRecognizerStateChanged) {
        // 视图随手指移动
        _changedX = [panGes locationInView:self.view].x;
        
        // 翻页完成后，要置为YES   是否为第一次进入拖动
        if (_isFirstChanged) {
            _isFirstChanged = NO;
            _beforeChangedX = _changedX;
            _maxX           = _changedX;
            // 判断翻页方向
            if (_changedX - _beginX > 0) {
                // 第一次拖动，向前翻
                [self dragForTheFirstTimePreviousPage:_changedX];
                // 设置标志位为  不是下一页
                _isNextPage = NO;
            } else {
                // 第一次拖动，向后翻
                [self dragForTheFirstTimeNextPage:(_changedX - _beginX)];
                // 设置标志位为 是下一页
                _isNextPage = YES;
            }
            
        } else {
            if (_isNextPage) {
                // 正常拖动，后翻
                [self dragChangeNextPage:(_changedX - _beforeChangedX)];
                // 记录这次的点击位置，给下次用
                _beforeChangedX = _changedX;
                // 向下一页翻页的时候，是取得最小值
                if (_changedX < _maxX) {
                    _maxX = _changedX;
                }
                
            } else {
                // 正常拖动，前翻
                [self dragChangePreviousPage:_changedX];
                // 向上一页翻页的时候，取得是最大值
                if (_changedX > _maxX) {
                    _maxX = _changedX;
                }
            }
        }
    }
}
#pragma mark - 点击手势响应区域
- (void)tapGestureRecognizerClick:(UITapGestureRecognizer *)tapGes {
    if (self.isResponseGestures == NO) {
        return;
    }
    // 上一页的响应区域
    CGRect previousRect = CGRectMake(0, 0, kScreenWidth / 2, kScreenHeight);
    // 下一页的响应区域
    CGRect nextRect     = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, kScreenHeight);

    // 获取点击位置
    CGPoint point       = [tapGes locationInView:self.view];

    // 根据点击位置所在区域，分发事件
    if (CGRectContainsPoint(previousRect, point)) {
        // 上一页
        [self gotoPreviousPage];
    } else if (CGRectContainsPoint(nextRect, point)) {
        // 下一页
        [self gotoNextPage];
    }
}

#pragma mark - 拖动后，后翻成功
- (void)nextPageSuccessful {
}
#pragma mark - 拖动后，后翻失败
- (void)nextPageFailure {
}
#pragma mark - 拖动后，前翻成功
- (void)previousPageSuccessful {
}
#pragma mark - 拖动后，前翻失败
- (void)previousPageFailure {
}
#pragma mark - 拖动中，第一次拖动，前翻
- (void)dragForTheFirstTimePreviousPage:(CGFloat)changeValue {
}
#pragma mark - 拖动中，第一次拖动，后翻
- (void)dragForTheFirstTimeNextPage:(CGFloat)changeValue {
}
#pragma mark - 正常拖动，后翻
- (void)dragChangeNextPage:(CGFloat)changeValue {
}
#pragma mark - 正常拖动，前翻
- (void)dragChangePreviousPage:(CGFloat)changeValue {
}
#pragma mark - 点击跳转到下一页
- (void)gotoNextPage {
}
#pragma mark - 点击跳转到下一页
- (void)gotoPreviousPage {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
