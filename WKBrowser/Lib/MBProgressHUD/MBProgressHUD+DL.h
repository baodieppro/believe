//
//  MBProgressHUD+DL.h
//  TestForEasemob
//
//  Created by dali on 16/4/9.
//  Copyright © 2016年 hellodali. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (DL)
+ (void)showWarning:(NSString *)warn;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (void)showSuccess:(NSString *)success to:(UIView *)view;
+ (void)showError:(NSString *)error to:(UIView *)view;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)hideHUDForView:(UIView *)view;
@end
