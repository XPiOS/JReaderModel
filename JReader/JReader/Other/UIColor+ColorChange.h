//
//  UIColor+ColorChange.h
//  Live
//
//  Created by XuPeng on 2017/2/13.
//  Copyright © 2017年 XP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color alpha: (float)alpha;

@end
