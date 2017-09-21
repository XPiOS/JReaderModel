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
    
    self.jReaderPageIndex = self.jReaderModel.jReaderPageIndex;
    self.jReaderTextString = self.jReaderModel.jReaderTextString;
    // 分页
    [self reloadJReaderPaging];

    if (self.jReaderBaseAnimationViewController) {
        [self.jReaderBaseAnimationViewController.view removeFromSuperview];
        [self.jReaderBaseAnimationViewController removeFromParentViewController];
        self.jReaderBaseAnimationViewController = nil;
    }
    switch (self.jReaderModel.jReaderTransitionStyle) {
        case PageViewControllerTransitionStylePageCurl: {
            JReaderCurlAnimationViewController *jReaderCurlAnimationViewController = [[JReaderCurlAnimationViewController alloc] initWithViewController:[self createReaderViewController:self.jReaderPageIndex]];
            self.jReaderBaseAnimationViewController = jReaderCurlAnimationViewController;
            break;
        }
        case PageViewControllerTransitionStyleScroll: {
            JReaderScrollAnimationViewController *jReaderScrollAnimationViewController = [[JReaderScrollAnimationViewController alloc] initWithViewController:[self createReaderViewController:self.jReaderPageIndex]];
            self.jReaderBaseAnimationViewController = jReaderScrollAnimationViewController;
            break;
        }
        case PageViewControllerTransitionStyleCover: {
            JReaderCoverAnimationViewController *jReaderCoverAnimationViewController = [[JReaderCoverAnimationViewController alloc] initWithViewController:[self createReaderViewController:self.jReaderPageIndex]];
            self.jReaderBaseAnimationViewController = jReaderCoverAnimationViewController;
            break;
        }
        default:
        case PageViewControllerTransitionStyleNone: {
            JReaderNoneAnimationViewController *jReaderNoneAnimationViewController = [[JReaderNoneAnimationViewController alloc] initWithViewController:[self createReaderViewController:self.jReaderPageIndex]];
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
        content = [NSString stringWithFormat:@"%@\n%@", self.jReaderModel.jReaderChapterName, [JReaderFormatString jReaderFormatString:self.jReaderTextString]];
        [self.jReaderPaging paging:content attributes:self.jReaderModel.jReaderAttributes rect:self.jReaderModel.jReaderFrame nameRange:NSMakeRange(0, self.jReaderModel.jReaderChapterName.length + 1) nameAttributes:self.jReaderModel.jReaderChapterNameAttributes];
    } else {
        content = [JReaderFormatString jReaderFormatString:self.jReaderTextString];
        [self.jReaderPaging paging:content attributes:self.jReaderModel.jReaderAttributes rect:self.jReaderModel.jReaderFrame nameRange:NSMakeRange(0, 0) nameAttributes:self.jReaderModel.jReaderChapterNameAttributes];
    }

}
#pragma mark 创建阅读页面控制器
- (UIViewController *)createReaderViewController: (NSUInteger)pageIndex {
    
    NSLog(@"将要 绘制的页面 Index  %zd", pageIndex);
    
    JReaderViewController *jReaderViewController = [[JReaderViewController alloc] init];
    jReaderViewController.jReaderContentStr = [self.jReaderPaging stringOfPage:pageIndex];
    jReaderViewController.jReaderFrame = self.jReaderModel.jReaderFrame;
    jReaderViewController.jReaderAttributes = self.jReaderModel.jReaderAttributes;
    jReaderViewController.jReaderPageIndex = pageIndex;
    jReaderViewController.jReaderPageCount = self.jReaderPaging.pageCount;
    jReaderViewController.jReaderNameStr = self.jReaderModel.jReaderChapterName;
    if (self.jReaderModel.jReaderChapterName && pageIndex == 0) {
        jReaderViewController.jReaderNameRange = NSMakeRange(0, self.jReaderModel.jReaderChapterName.length + 1);
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
    if ([self.delegate respondsToSelector:@selector(jReaderAnimationViewController:didFinishAnimating:transitionCompleted:)]) {
        [self.delegate jReaderAnimationViewController:self didFinishAnimating:finished transitionCompleted:completed];
    }
}
#pragma mark - JReaderAnimationViewControllerDataSource
#pragma mark 获取上一页控制器
- (nullable UIViewController *)jReaderBaseAnimationViewController:(nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController viewControllerBeforeViewController:(nullable UIViewController *)viewController {
    JReaderViewController *jReaderViewController = (JReaderViewController *)viewController;
    if (self.userDefinedProperty != jReaderViewController.userDefinedProperty) {
        if ([self.delegate respondsToSelector:@selector(jReaderAnimationViewController:dataException:)]) {
            [self.delegate jReaderAnimationViewController:self dataException:jReaderViewController.userDefinedProperty];
        }
        return nil;
    } else {
        
        self.jReaderPageIndex = jReaderViewController.jReaderPageIndex - 1;
        if (self.jReaderPageIndex < 0) {
            // 获取上一章内容
            if ([self.dataSource respondsToSelector:@selector(beforeContent:)]) {
                NSString *textStr = [self.dataSource beforeContent:self];
                if (textStr) {
                    self.jReaderTextString = textStr;
                    [self reloadJReaderPaging];
                    self.jReaderPageIndex = self.jReaderPaging.pageCount - 1;
                    return [self createReaderViewController:self.jReaderPageIndex];
                } else {
                    self.jReaderPageIndex = jReaderViewController.jReaderPageIndex;
                    return nil;
                }
            } else {
                self.jReaderPageIndex = jReaderViewController.jReaderPageIndex;
                return nil;
            }
        } else {
            return [self createReaderViewController:self.jReaderPageIndex];
        }
    }
}
#pragma mark 获取下一页控制器
- (nullable UIViewController *)jReaderBaseAnimationViewController:(nullable JReaderBaseAnimationViewController *)jReaderBaseAnimationViewController viewControllerAfterViewController:(nullable UIViewController *)viewController {
    JReaderViewController *jReaderViewController = (JReaderViewController *)viewController;
    if (self.userDefinedProperty != jReaderViewController.userDefinedProperty) {
        if ([self.delegate respondsToSelector:@selector(jReaderAnimationViewController:dataException:)]) {
            [self.delegate jReaderAnimationViewController:self dataException:jReaderViewController.userDefinedProperty];
        }
        return nil;
    } else {
        self.jReaderPageIndex = jReaderViewController.jReaderPageIndex + 1;
        if (self.jReaderPageIndex > self.jReaderPaging.pageCount - 1) {
            if ([self.dataSource respondsToSelector:@selector(afterContent:)]) {
                NSString *textStr = [self.dataSource afterContent:self];
                if (textStr) {
                    self.jReaderTextString = textStr;
                    [self reloadJReaderPaging];
                    self.jReaderPageIndex = 0;
                    return [self createReaderViewController:self.jReaderPageIndex];
                } else {
                    self.jReaderPageIndex = jReaderViewController.jReaderPageIndex;
                    return nil;
                }
            } else {
                self.jReaderPageIndex = jReaderViewController.jReaderPageIndex;
                return nil;
            }
        } else {
            NSLog(@"当前页  Index  %zd", self.jReaderPageIndex);
            return [self createReaderViewController:self.jReaderPageIndex];
        }
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
@end
