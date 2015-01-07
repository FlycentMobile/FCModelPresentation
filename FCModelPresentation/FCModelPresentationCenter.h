//
//  FCModelPresentationCenter.h
//  FCModelPresentation
//
//  Created by Harley.xk on 14/12/25.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FCModelPresentationCenter : NSObject

/**
 *  控制中心单例
 */
+ (instancetype)sharedCenter;

/**
 *  present新的ViewController到最上层
 */
- (void)presentViewController:(UIViewController*)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

/**
 *  dismiss最上层的ViewController
 */
- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
