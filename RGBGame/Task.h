//
//  Task.h
//  RGBGame
//
//  Created by 千锋 on 16/2/28.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Task : NSObject <NSCoding>

@property (nonatomic, strong) UIColor *taskColor;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, assign) NSInteger checkPoint;
@property (nonatomic, copy) NSString *colorStr;
@property (nonatomic, assign) NSInteger animation; //开始进入界面的动画
@property (nonatomic, strong) CALayer *myLayer;
@property (nonatomic, assign) NSInteger hightScore;
@end
