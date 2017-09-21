//
//  NSObject+JReaderKVO.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/19.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "NSObject+JReaderKVO.h"
#import <objc/runtime.h>

@implementation NSObject (JReaderKVO)

+ (void)load {
    // 交换 添加KVO方法
    Method addObserverMethod = class_getClassMethod([self class], @selector(addObserver:forKeyPath:options:context:));
    Method addJReaderObserverMethod = class_getClassMethod([self class], @selector(addJReaderObserver:forKeyPath:options:context:));
    method_exchangeImplementations(addObserverMethod, addJReaderObserverMethod);
    
    // 交换 移除KVO方法
    Method removeObserverMethod = class_getClassMethod([self class], @selector(removeObserver:forKeyPath:));
    Method removeJReaderObserverMethod = class_getClassMethod([self class], @selector(removeJReaderObserver:forKeyPath:));
    method_exchangeImplementations(removeObserverMethod, removeJReaderObserverMethod);
}

#pragma mark - 防止多次添加KVO
- (void)addJReaderObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    if (![self observerKeyPath:keyPath]) {
        [self addJReaderObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

#pragma mark - 防止多次释放 KVO
- (void)removeJReaderObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if ([self observerKeyPath:keyPath]) {
        [self removeJReaderObserver:observer forKeyPath:keyPath];
    }
}

#pragma mark - 检索key 是否存在
- (BOOL)observerKeyPath:(NSString *)key {
    id info =self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            return YES;
        }
    }
    return NO;
}

@end
