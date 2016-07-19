//
//  NUIUtil.h
//  niuguwang
//
//  Created by 李明 on 16/4/11.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NUIUtil : NSObject

+ (CGSize) sizeWith:(NSString *) text
               fontSize:(NSInteger) fontSize;
+ (CGSize) sizeWith:(NSString *) text
                width:(CGFloat) width
               fontSize:(NSInteger)fontSize;
+ (CGSize) screenSize;
+ (NSString *) screenWidth;
+ (NSString *) screenHeight;

+ (void) refreshWithHeader:(UITableView *) tableView
                   refresh:(dispatch_block_t)refresh;
+ (void)refreshWithFooter:(UITableView *) tableView
                  refresh:(dispatch_block_t) refresh;

+ (void) fixedLabel:(UILabel *)label fontSize:(NSInteger)fontSize;
+ (CGSize) fitSize:(UILabel *)label;
+ (UIFont *) fixedFont:(CGFloat) size;
+ (CGFloat) fixedFontSize:(CGFloat) size;
+ (CGFloat) fixedWidth:(CGFloat) width;
+ (CGFloat) fixedHeight:(CGFloat) height;
+ (CGSize) fixedWidth:(CGFloat) width
               height:(CGFloat) height;
// 是否已经显示
+ (BOOL) isVisible:(UIViewController *)current;
// 放到顶层
+ (void) putToTop:(UIView *)view;
+ (UIImage *) imageWithColor:(UIColor *)color;
+ (UIImage *) imageWithColor:(UIColor *)color
                        size:(CGSize)size;
@end
