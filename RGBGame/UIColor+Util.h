//
//  UIColor+Util.h
//  MyLimitFree
//
//  Created by LUOHao on 16/2/15.
//  Copyright (c) 2016年 mobiletrain. All rights reserved.
//

#import <UIKit/UIKit.h>

/**UIColor扩展*/
@interface UIColor (Util)

/**用16进制数指定颜色*/
+ (instancetype) colorWithHexValue:(NSUInteger) hexValue;

/**用16进制数和alpha通道指定颜色*/
+ (instancetype) colorWithHexValue:(NSUInteger) hexValue alpha:(CGFloat) alpha;

/**导航栏标题颜色*/
+ (instancetype) barTitleColor;

/**按钮标题颜色*/
+ (instancetype) buttonTitleColor;

/**内容标题颜色*/
+ (instancetype) contentTitleColor;

+ (instancetype) tableViewBackColor;

+ (instancetype) buttonRedColor;

+ (instancetype) buttonBlueColor;

+ (instancetype) buttonGreenColor;
@end
