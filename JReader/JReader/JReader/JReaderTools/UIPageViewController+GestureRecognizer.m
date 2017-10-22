//
//  UIPageViewController+GestureRecognizer.m
//  JReader
//
//  Created by Jerry on 2017/10/20.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "UIPageViewController+GestureRecognizer.h"

@implementation UIPageViewController (GestureRecognizer)

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end
