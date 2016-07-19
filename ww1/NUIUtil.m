//
//  NUIUtil.m
//  niuguwang
//
//  Created by 李明 on 16/4/11.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "NUIUtil.h"
#import "MJRefresh.h"

@implementation NUIUtil

static CGSize _screenSize;
static NSString *_screenWidth;
static NSString *_screenHeight;
static CGFloat _fixedWidthScale;
static CGFloat _fixedHeightScale;

// 根据字体计算最大宽度的自动尺寸
+ (CGSize) sizeWith:(NSString *) text
               fontSize:(NSInteger) fontSize
{
    UIView *v=[[UIView alloc]init];
    return [NUIUtil sizeWith:text width:MAXFLOAT fontSize:fontSize];
}
// 根据字体计算指定宽度的自动尺寸
+ (CGSize) sizeWith:(NSString *) text
                width:(CGFloat) width
               fontSize:(NSInteger)fontSize
{
    CGSize size=[text boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil].size;
    size.width=ceil(size.width);
    size.height=ceil(size.height);
    return size;
}

// 屏幕尺寸
+ (CGSize ) screenSize{
    if(_screenSize.width!=0 && _screenSize.height!=0){
        return _screenSize;
    }
    CGSize size=[UIScreen mainScreen].bounds.size;
    CGFloat scale=[[UIScreen mainScreen] scale];
    _screenSize.width=size.width*scale;
    _screenSize.height=size.height*scale;
    return _screenSize;
}
// 屏幕宽度
+ (NSString *)screenWidth
{
    if(_screenWidth.length>0){
        return _screenWidth;
    }
    CGSize size=[NUIUtil screenSize];
    _screenWidth=[NSString stringWithFormat:@"%.0f",size.width];
    return _screenWidth;
}
// 屏幕高度
+ (NSString *)screenHeight
{
    if(_screenHeight.length>0){
        return _screenHeight;
    }
    CGSize size=[NUIUtil screenSize];
    _screenHeight=[NSString stringWithFormat:@"%.0f",size.height];
    return _screenHeight;
}

+ (void)refreshWithHeader:(UITableView *) tableView
                  refresh:(dispatch_block_t) refresh
{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开后刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    // 设置箭头
    [header arrowView].image=[UIImage imageNamed:@"refresh_arrow"];
    tableView.mj_header=header;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}


+ (void)refreshWithFooter:(UITableView *) tableView
                  refresh:(dispatch_block_t) refresh
{
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    
    [footer setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    
    [footer setTitle:@"已加载全部数据" forState:MJRefreshStateNoMoreData];

    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    // 设置箭头

    [footer arrowView].image=[UIImage imageNamed:@"refresh_arrow"];
    
    tableView.mj_footer=footer;
    
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    
}

+ (void) fixedLabel:(UILabel *)label
           fontSize:(NSInteger)fontSize
{
    label.font=[UIFont fontWithName:label.font.fontName size:[NUIUtil fixedFontSize:fontSize]];
}
// 字体适配
+ (UIFont *) fixedFont:(CGFloat)size
{
    return [UIFont systemFontOfSize:[self fixedFontSize:size]];
}
// 字体尺寸适配
+(CGFloat) fixedFontSize:(CGFloat) size
{
    CGFloat scale=1.0f;
    if(IS_IPHONE_6P){
        scale=1.0f;
    }else if(IS_IPHONE_6){
        scale=1.0f;
    }else if(IS_IPHONE_5){
        scale=0.95f;
    }else if(IS_IPHONE_4_OR_LESS){
        scale=0.95f;
    }
    return size*scale;
}
+(CGSize) fitSize:(UILabel *)label
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    NSDictionary * attributes=@{NSFontAttributeName : label.font,
                                NSParagraphStyleAttributeName : paragraphStyle};
    CGSize contentSize = [label.text boundingRectWithSize:label.frame.size
                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes:attributes
                                                  context:nil].size;
    contentSize.width+=1;
    return contentSize;
}

+ (CGFloat) fixedWidth:(CGFloat) width
{
    if(_fixedWidthScale==0){
        _fixedWidthScale=[UIScreen mainScreen].bounds.size.width/375;
    }
    return width*_fixedWidthScale;
}

+ (CGFloat) fixedHeight:(CGFloat) height
{
    if(_fixedHeightScale==0){
        _fixedHeightScale=[UIScreen mainScreen].bounds.size.height/667;
    }
    return height*_fixedHeightScale;
}

+ (CGSize) fixedWidth:(CGFloat) width
               height:(CGFloat) height
{
    if(_fixedWidthScale==0){
        _fixedWidthScale=[UIScreen mainScreen].bounds.size.width/375;
    }
    return CGSizeMake(width*_fixedWidthScale,height*_fixedWidthScale);
}
// 是否已经显示
+ (BOOL) isVisible:(UIViewController *)current
{
    if(current==nil){
        return NO;
    }
    if(!current.isViewLoaded){
        return NO;
    }
    if(current.view.window==nil){
        return NO;
    }
    return YES;
}
// 放到顶层
+ (void) putToTop:(UIView *)view
{
    if(!view){
        return;
    }
    UIWindow *parentView = nil;
    NSArray *windows = [UIApplication sharedApplication].windows;
    if([windows count]<1){
        return;
    }
    UIWindow *window = [windows objectAtIndex:0];
    if(window && window.subviews.count > 0){
        parentView = [window.subviews objectAtIndex:0];
    }else{
        return;
    }
    [parentView addSubview:view];
    [parentView bringSubviewToFront:view];
}

+ (UIImage *) imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1,1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
{
    if(color==nil){
        color=[UIColor redColor];
    }
    if(size.width<1){
        size.width=1;
    }
    if(size.height<1){
        size.height=1;
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width,size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end