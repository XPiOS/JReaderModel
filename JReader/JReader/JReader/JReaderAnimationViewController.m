//
//  JReaderAnimationViewController.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderAnimationViewController.h"
#import "JReaderPaging.h"
#import "JReaderFormatString.h"
#import "JReaderViewController.h"
#import "JReaderBaseAnimationViewController.h"
#import "JReaderNoneAnimationViewController.h"
#import "JReaderCoverAnimationViewController.h"
#import "JReaderScrollAnimationViewController.h"
#import "JReaderCurlAnimationViewController.h"

@interface JReaderAnimationViewController () <JReaderBaseAnimationViewControllerDelegate, JReaderBaseAnimationViewControllerDataSource>

@property (nonatomic, strong) JReaderPaging *jReaderPaging;
@property (nonatomic, strong) JReaderBaseAnimationViewController *jReaderBaseAnimationViewController;
@property (nonatomic, strong) NSString *jReaderTextString;

@property (nonatomic, assign) BOOL jReaderBefore;

@end

@implementation JReaderAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 根据字符串，获取所在页码
- (NSInteger)jReaderPageIndexWith: (nullable NSString *)pageStr {
    return [self.jReaderPaging getPageIndex:pageStr];
}


#pragma mark - 内部方法
#pragma mark 从新加载数据
- (void)jReaderReloadData {
    self.jReaderTextString = self.jReaderModel.jReaderTextString;
    // 分页
    [self reloadJReaderPaging];
    if (self.jReaderBaseAnimationViewController.view.superview) {
        self.jReaderBaseAnimationViewController.delegate = nil;
        self.jReaderBaseAnimationViewController.dataSource = nil;
        [self.jReaderBaseAnimationViewController.view removeFromSuperview];
        [self.jReaderBaseAnimationViewController removeFromParentViewController];
        self.jReaderBaseAnimationViewController = nil;
    }
    switch (self.jReaderModel.jReaderTransitionStyle) {
        case PageViewControllerTransitionStylePageCurl: {
            JReaderCurlAnimationViewController *jReaderCurlAnimationViewController = [[JReaderCurlAnimationViewController alloc] initWithViewController:[self createReaderViewController:self.jReaderModel.jReaderPageIndex]];
            self.jReaderBaseAnimationViewController = jReaderCurlAnimationViewController;
            break;
        }
        case PageViewControllerTransitionStyleScroll: {
            JReaderScrollAnimationViewController *jReaderScrollAnimationViewController = [[JReaderScrollAnimationViewController alloc] initWithViewController:[self createReaderViewController:self.jReaderModel.jReaderPageIndex]];
            self.jReaderBaseAnimationViewController = jReaderScrollAnimationViewController;
            break;
        }
        case PageViewControllerTransitionStyleCover: {
            JReaderCoverAnimationViewController *jReaderCoverAnimationViewController = [[JReaderCoverAnimationViewController alloc] initWithViewController:[self createReaderViewController:self.jReaderModel.jReaderPageIndex]];
            self.jReaderBaseAnimationViewController = jReaderCoverAnimationViewController;
            break;
        }
        default:
        case PageViewControllerTransitionStyleNone: {
            JReaderNoneAnimationViewController *jReaderNoneAnimationViewController = [[JReaderNoneAnimationViewController alloc] initWithViewController:[self createReaderViewController:self.jReaderModel.jReaderPageIndex]];
            self.jReaderBaseAnimationViewController = jReaderNoneAnimationViewController;
            break;
        }
    }
    self.jReaderBaseAnimationViewController.delegate = self;
    self.jReaderBaseAnimationViewController.dataSource = self;
    [self addChildViewController:self.jReaderBaseAnimationViewController];
    [self.view addSubview:self.jReaderBaseAnimationViewController.view];
}

#pragma mark 分页
- (void)reloadJReaderPaging {
    NSString *content;
    if (self.jReaderModel.jReaderChapterName) {
        content = [NSString stringWithFormat:@"%@%@", self.jReaderModel.jReaderChapterName, [JReaderFormatString jReaderFormatString:self.jReaderTextString]];
        [self.jReaderPaging paging:content attributes:self.jReaderModel.jReaderAttributes rect:self.jReaderModel.jReaderFrame nameRange:NSMakeRange(0, self.jReaderModel.jReaderChapterName.length) nameAttributes:self.jReaderModel.jReaderChapterNameAttributes];
    } else {
        content = [JReaderFormatString jReaderFormatString:self.jReaderTextString];
        [self.jReaderPaging paging:content attributes:self.jReaderModel.jReaderAttributes rect:self.jReaderModel.jReaderFrame nameRange:NSMakeRange(0, 0) nameAttributes:self.jReaderModel.jReaderChapterNameAttributes];
    }
    self.jReaderModel.jReaderPageCount = self.jReaderPaging.pageCount;
}
#pragma mark 创建阅读页面控制器
- (JReaderViewController *)createReaderViewController: (NSUInteger)pageIndex {
    JReaderViewController *jReaderViewController = [[JReaderViewController alloc] init];
    jReaderViewController.jReaderContentStr = [self.jReaderPaging stringOfPage:pageIndex];
    jReaderViewController.jReaderFrame = self.jReaderModel.jReaderFrame;
    jReaderViewController.jReaderAttributes = self.jReaderModel.jReaderAttributes;
    jReaderViewController.jReaderPageIndex = pageIndex;
    jReaderViewController.jReaderPageCount = self.jReaderPaging.pageCount;
    jReaderViewController.jReaderNameStr = self.jReaderModel.jReaderChapterName;
    if (self.jReaderModel.jReaderChapterName && pageIndex == 0) {
        jReaderViewController.jReaderNameRange = NSMakeRange(0, self.jReaderModel.jReaderChapterName.length);
        jReaderViewController.jReaderNameAttributes = self.jReaderModel.jReaderChapterNameAttributes;
    }
    if (self.jReaderModel.jReaderBackgroundImage) {
        jReaderViewController.view.backgroundColor = [UIColor colorWithPatternImage:self.jReaderModel.jReaderBackgroundImage];
    } else {
        if (self.jReaderModel.jReaderBackgroundColor) {
            jReaderViewController.view.backgroundColor = self.jReaderModel.jReaderBackgroundColor;
        }
    }
    jReaderViewController.userDefinedProperty = self.userDefinedProperty;
    jReaderViewController.jReaderPageIndex = pageIndex;
    return jReaderViewController;
}

#pragma mark - JReaderBaseAnimationViewControllerDelegate
#pragma mark 点击手势回调
- (BOOL)jReaderBaseAnimationViewController:(JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController tapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(jReaderAnimationViewController:tapGestureRecognizer:)]) {
        return [self.delegate jReaderAnimationViewController:self tapGestureRecognizer:tapGestureRecognizer];
    } else {
        return YES;
    }
}
#pragma mark 翻页开始
- (void)jReaderBaseAnimationViewController:(JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController {
    if ([self.delegate respondsToSelector:@selector(jReaderAnimationViewController:)]) {
        [self.delegate jReaderAnimationViewController:self];
    }
}
#pragma mark 翻页结束
- (void)jReaderBaseAnimationViewController:(nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController didFinishAnimating:(BOOL)finished transitionCompleted:(BOOL)completed {
    if (finished && !completed) {
        if (self.jReaderBefore) {
            if ([self.dataSource respondsToSelector:@selector(appointContent:userDefinedProperty:)]) {
                NSString *textStr = [self.dataSource afterContent:self userDefinedProperty: self.userDefinedProperty];
                if (textStr) {
                    self.jReaderTextString = textStr;
                    [self reloadJReaderPaging];
                }
            }
        } else {
            if ([self.dataSource respondsToSelector:@selector(beforeContent:userDefinedProperty:)]) {
                NSString *textStr = [self.dataSource beforeContent:self userDefinedProperty:self.userDefinedProperty];
                if (textStr) {
                    self.jReaderTextString = textStr;
                    [self reloadJReaderPaging];
                }
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(jReaderAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
        [self.delegate jReaderAnimationViewController:self didFinishAnimating:finished transitionCompleted:completed];
    }
}
#pragma mark - JReaderAnimationViewControllerDataSource
#pragma mark 获取上一页控制器
- (nullable UIViewController *)jReaderBaseAnimationViewController:(nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController viewControllerBeforeViewController:(nullable UIViewController *)viewController {
    if (!self.userInteractionEnabled) {
        return nil;
    }
    JReaderViewController *jReaderViewController = (JReaderViewController *)viewController;
    
    if (self.userDefinedProperty != jReaderViewController.userDefinedProperty) {
        if ([self.dataSource respondsToSelector:@selector(appointContent:userDefinedProperty:)]) {
            NSString *textStr = [self.dataSource appointContent:self userDefinedProperty: jReaderViewController.userDefinedProperty];
            if (textStr) {
                self.jReaderTextString = textStr;
                [self reloadJReaderPaging];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    }
    
    self.jReaderModel.jReaderPageIndex = jReaderViewController.jReaderPageIndex - 1;
    if (self.jReaderModel.jReaderPageIndex < 0) {
        // 获取上一章内容
        if ([self.dataSource respondsToSelector:@selector(beforeContent:userDefinedProperty:)]) {
            NSString *textStr = [self.dataSource beforeContent:self userDefinedProperty:jReaderViewController.userDefinedProperty];
            if (textStr) {
                self.jReaderBefore = YES;
                self.jReaderTextString = textStr;
                [self reloadJReaderPaging];
                self.jReaderModel.jReaderPageIndex = self.jReaderPaging.pageCount - 1;
                return [self createReaderViewController:self.jReaderModel.jReaderPageIndex];
            } else {
                self.jReaderModel.jReaderPageIndex = jReaderViewController.jReaderPageIndex;
                return nil;
            }
        } else {
            self.jReaderModel.jReaderPageIndex = jReaderViewController.jReaderPageIndex;
            return nil;
        }
    } else {
        return [self createReaderViewController:self.jReaderModel.jReaderPageIndex];
    }
}

#pragma mark 获取下一页控制器
- (nullable UIViewController *)jReaderBaseAnimationViewController:(nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController viewControllerAfterViewController:(nullable UIViewController *)viewController {
    if (!self.userInteractionEnabled) {
        return nil;
    }
    JReaderViewController *jReaderViewController = (JReaderViewController *)viewController;

    if (self.userDefinedProperty != jReaderViewController.userDefinedProperty) {
        if ([self.dataSource respondsToSelector:@selector(appointContent:userDefinedProperty:)]) {
            NSString *textStr = [self.dataSource appointContent:self userDefinedProperty: jReaderViewController.userDefinedProperty];
            if (textStr) {
                self.jReaderTextString = textStr;
                [self reloadJReaderPaging];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    }
    
    self.jReaderModel.jReaderPageIndex = jReaderViewController.jReaderPageIndex + 1;
    if (self.jReaderModel.jReaderPageIndex > self.jReaderPaging.pageCount - 1) {
        if ([self.dataSource respondsToSelector:@selector(afterContent:userDefinedProperty:)]) {
            NSString *textStr = [self.dataSource afterContent:self userDefinedProperty:jReaderViewController.userDefinedProperty];
            if (textStr) {
                self.jReaderBefore = NO;
                self.jReaderTextString = textStr;
                [self reloadJReaderPaging];
                self.jReaderModel.jReaderPageIndex = 0;
                return [self createReaderViewController:self.jReaderModel.jReaderPageIndex];
            } else {
                self.jReaderModel.jReaderPageIndex = jReaderViewController.jReaderPageIndex;
                return nil;
            }
        } else {
            self.jReaderModel.jReaderPageIndex = jReaderViewController.jReaderPageIndex;
            return nil;
        }
    } else {
        JReaderViewController *newJReaderViewController = [self createReaderViewController:self.jReaderModel.jReaderPageIndex];
        return newJReaderViewController;
    }
}
#pragma mark - get/set
- (JReaderPaging *)jReaderPaging {
    if (!_jReaderPaging) {
        _jReaderPaging = [[JReaderPaging alloc] init];
    }
    return _jReaderPaging;
}
- (void)setJReaderModel:(JReaderModel *)jReaderModel {
    _jReaderModel = jReaderModel;
    [self jReaderReloadData];
}
- (NSString *)jReaderPageString {
    return ((JReaderViewController *)self.jReaderBaseAnimationViewController.currentViewController).jReaderContentStr;
}
- (NSInteger)jReaderPageCount {
    return self.jReaderPaging.pageCount;
}
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    _userInteractionEnabled = userInteractionEnabled;
    self.jReaderBaseAnimationViewController.view.userInteractionEnabled = userInteractionEnabled;
}
@end
