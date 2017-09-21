//
//  JReaderViewController.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JReaderViewController : UIViewController
/**
 当前的页面索引
 */
@property (nonatomic, assign) NSInteger jReaderPageIndex;
/**
 总页数
 */
@property (nonatomic, assign) NSInteger jReaderPageCount;
/**
 预留自定义字段  可以用来存储 章节索引，防止章节混乱
 */
@property (nonatomic, copy) id userDefinedProperty;
/**
 页面相关
 */
@property (nonatomic, copy) NSString *jReaderContentStr;
@property (nonatomic, assign) CGRect jReaderFrame;
@property (nonatomic, copy) NSDictionary *jReaderAttributes;
/**
 章节名称
 */
@property (nonatomic, assign) NSString *jReaderNameStr;
@property (nonatomic, assign) NSRange jReaderNameRange;
@property (nonatomic, copy) NSDictionary *jReaderNameAttributes;

@end
