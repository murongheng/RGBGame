//
//  DrawViewController.m
//  RGBGame
//
//  Created by 千锋 on 16/3/2.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawView.h"
#import "MBProgressHUD.h"

static const int DefaultTag = 300;
@implementation DrawViewController {
    DrawView *_drawView;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    _drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)];
    _drawView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_drawView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    CGFloat w = self.view.frame.size.width / 5;
    NSArray *nameArray = @[@"清屏", @"撤销", @"橡皮擦", @"保存", @"返回"];
    for (int i = 0; i < nameArray.count; ++i) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(w * i, 10, w, 45)];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = DefaultTag + i;
        [self.view addSubview:button];
    }
}

- (void) clicked: (UIButton *) button {
    switch (button.tag) {
        case DefaultTag:{
            [_drawView clear];
        }
            break;
        case DefaultTag + 1:{
            [_drawView back];
        }
            break;
        case DefaultTag + 2:{
            [_drawView eraser];
        }
            break;
        case DefaultTag + 3:
            [self saveToAlbum];
            break;
        case DefaultTag + 4:{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        
        default:
            break;
    }
}
//通过截屏获取
- (void) saveToAlbum {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_drawView.frame.size.width, _drawView.frame.size.height - 140), NO, 0.0);
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //把内容渲染到图形上下文中
    [_drawView.layer renderInContext:ctx];
    //获取图片
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(getImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [self showHintMsg:@"保存失败" onView:self.view];
    }
    else{

        [self showHintMsg:@"保存成功" onView:self.view];
    }
    
//    NSLog(@"%@",str);
}
- (void) showHintMsg:(NSString *) message onView:(UIView *) view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    [hud hide:YES afterDelay:2];
}
    

@end
