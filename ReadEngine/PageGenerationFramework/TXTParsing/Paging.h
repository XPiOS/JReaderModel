//
//  Paging.h
//  创新版
//
//  Created by XuPeng on 16/5/21.
//  Copyright © 2016年 cxb. All rights reserved.
//  分页

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Paging : NSObject

- (instancetype)initWithFont:(CGFloat)font pageRect:(CGRect)pageRect;

/**
 *  分页
 */
- (void)paginate:(NSString *)contentText;

/**
 *  一共分了多少页
 *
 *  @return 一章所分的页数
 */
- (NSUInteger)pageCount;

/**
 *  获得page页的文字内容
 *
 *  @param page 页
 *
 *  @return 内容
 */
- (NSString *)stringOfPage:(NSUInteger)page;

/**
 *  修改字体大小
 */
- (void)setFont:(CGFloat)font;

@end
