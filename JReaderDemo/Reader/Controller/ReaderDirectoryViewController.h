//
//  ReaderDirectoryViewController.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/26.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderDirectoryViewController : UIViewController

@property (nonatomic, strong) Parameter1Block cellClickBlock;
@property (nonatomic, strong) Parameter1Block cancelClickBlock;

- (void)refreshView: (NSMutableArray *)chapterArr;

@end
