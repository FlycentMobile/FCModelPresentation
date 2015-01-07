//
//  FCModelPresentationRootViewController.h
//  FCModelPresentation
//
//  Created by Harley.xk on 14/12/25.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+FCModelPresentation.h"

@interface FCModelPresentationRootViewController : UIViewController

/**
 *  创建一个根视图控制器，与即将呈现的视图控制器关联
 */
- (instancetype)initWithBuiltinViewController:(UIViewController<FCModelPresentationProtocol>*)controller;

/**
 *  显示动画完毕后的回调
 */
@property (copy, nonatomic) void(^presentationCompletionCallback)(void);

/**
 *  关闭
 */
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;


@end
