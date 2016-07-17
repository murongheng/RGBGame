//
//  DrawView.h
//  RGBGame
//
//  Created by 千锋 on 16/3/2.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaletteView;

@interface DrawView : UIView

@property (nonatomic, copy) NSMutableArray *drawLines;

@property (nonatomic, strong) PaletteView *paletteView;

- (void) clear;

- (void) back;

- (void) eraser;
@end
