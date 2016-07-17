//
//  UIColor+Util.m
//  MyLimitFree
//
//  Created by LUOHao on 16/2/15.
//  Copyright (c) 2016年 mobiletrain. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

+ (instancetype) colorWithHexValue:(NSUInteger) hexValue {
    return [self colorWithHexValue:hexValue alpha:1];
}

+ (instancetype) colorWithHexValue:(NSUInteger) hexValue alpha:(CGFloat) alpha {
    return [UIColor colorWithRed:((hexValue & 0xFF0000) >> 16) / 255.0 green:((hexValue & 0xFF00) >> 8) / 255.0 blue:(hexValue & 0xFF) / 255.0 alpha:alpha];
}

+ (instancetype) barTitleColor {
    return [UIColor colorWithHexValue:0x228B22];
}

+ (instancetype) buttonTitleColor {
    return [UIColor blackColor];
}

+ (instancetype) contentTitleColor {
    return [UIColor blackColor];
}

+ (instancetype)tableViewBackColor {
    return [UIColor colorWithHexValue:0xdadcdc]; //218 da 220 220
}

+ (instancetype) buttonBlueColor {
    return [UIColor colorWithHexValue:0x4b5cc4];
}

+ (instancetype) buttonRedColor {
    return [UIColor colorWithHexValue:0xff461f];
}

+ (instancetype) buttonGreenColor {
    return [UIColor colorWithHexValue:0x00e500];
}
@end
