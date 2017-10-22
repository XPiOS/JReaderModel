//
//  JReaderView.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JReaderView : UIView

@property (nonatomic, copy) NSString *jReaderContentStr;
@property (nonatomic, copy) NSDictionary *jReaderAttributes;

@property (nonatomic, assign) NSRange jReaderNameRange;
@property (nonatomic, copy) NSDictionary *jReaderNameAttributes;

@end
