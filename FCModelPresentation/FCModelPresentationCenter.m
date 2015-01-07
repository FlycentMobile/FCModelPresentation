//
//  FCModelPresentationCenter.m
//  FCModelPresentation
//
//  Created by Harley.xk on 14/12/25.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import "FCModelPresentationCenter.h"
#import "FCModelPresentationRootViewController.h"

@interface FCModelPresentationCenter ()

@property (strong, nonatomic) NSMutableArray *presentedWindows;

@end

@implementation FCModelPresentationCenter

/**
 *  返回单例的控制中心
 */
+ (instancetype)sharedCenter
{
    static FCModelPresentationCenter *instanceFCModelPresentationCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceFCModelPresentationCenter = [FCModelPresentationCenter new];
    });
    return instanceFCModelPresentationCenter;
}

- (instancetype)init
{
    self = [super init];
    
    self.presentedWindows = [NSMutableArray array];
    
    return self;
}

/**
 *  present新的ViewController到最上层
 */
- (void)presentViewController:(UIViewController<FCModelPresentationProtocol>*)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    // 如果有键盘则隐藏
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.windowLevel = UIWindowLevelNormal + 1;
    
    FCModelPresentationRootViewController *controller = [[FCModelPresentationRootViewController alloc] initWithBuiltinViewController:viewControllerToPresent];
    controller.presentationCompletionCallback = completion;
    window.rootViewController = controller;
    
    [window makeKeyAndVisible];
    [self.presentedWindows addObject:window];
}

/**
 *  dismiss最上层的ViewController
 */
- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.presentedWindows.count <= 0) {
        return;
    }
    UIWindow *topWindow = [self.presentedWindows lastObject];
    
    FCModelPresentationRootViewController *controller = (FCModelPresentationRootViewController*)[topWindow rootViewController];
    
    [controller dismissAnimated:animated completion:^{
        topWindow.windowLevel = -1;
        topWindow.rootViewController = nil;
        
        [self.presentedWindows removeObject:topWindow];

        if (completion) {
            completion();
        }
    }];
}


@end
