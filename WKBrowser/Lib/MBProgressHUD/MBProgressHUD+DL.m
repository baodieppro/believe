//
//  MBProgressHUD+DL.m
//  TestForEasemob
//
//  Created by dali on 16/4/9.
//  Copyright © 2016年 hellodali. All rights reserved.
//

#import "MBProgressHUD+DL.h"

@implementation MBProgressHUD (DL)
/**
 *  快速显示正确和错误信息
 */
+ (void)showWarning:(NSString *)warn
{
    [self show:warn icon:nil view:nil];
}
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}
+ (void)showSuccess:(NSString *)success to:(UIView *)view {
    [self showSuccess:success toView:view];
}
+ (void)showError:(NSString *)error to:(UIView *)view {
    [self showError:error toView:view];
}
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    //    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:2.0];
}

/**
 *  将正确和错误信息显示在哪个view上面
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}


/**
 *  显示一些信息
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = false;
    return hud;
}


/**
 *  隐藏信息
 */
+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}
@end
