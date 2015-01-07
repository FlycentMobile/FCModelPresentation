//
//  UIViewController+FCModelPresentation.h
//  FCModelPresentationSample
//
//  Created by Harley.xk on 14/12/25.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCModelPresentationProtocol <NSObject>
@optional
/**
 *  视图界面的尺寸大小，默认与系统FormSheet相同（540，600）
 *
 *  @attention 只会在初始化时访问一次该方法
 */
- (CGSize)fc_modelPresentationSize;

/**
 *  是否可以通过点击外围的背景关闭,默认为YES
 *  实现该方法后会在每次点击外围背景时询问
 *
 *  @attention 如果键盘处于显示状态，点击外围背景会首先隐藏键盘，不会触发关闭事件
 */
- (BOOL)fc_canDismissViaTapOutside;

/**
 *  是否使用自定义的呈现动画
 *  实现该方法后会根据返回值来判断是否需要使用自定义的动画
 */
- (BOOL)fc_shouldUseCustomPresentAnimation;
/**
 *  自定义的呈现动画，建议控制为0.25秒
 *  不实现该方法则使用默认的动画呈现
 *
 *  @attention 0.25秒后会回调present的completcion回调，无论动画是否完成
 */
- (void)fc_runModelPresentAnimation;

/**
 *  是否使用自定义的关闭动画
 *  实现该方法后会根据返回值来判断是否需要使用自定义的动画
 */
- (BOOL)fc_shouldUseCustomDismissAnimation;
/**
 *  自定义的关闭动画，建议控制为0.25秒
 *  不实现该方法则使用默认的动画呈现
 *
 *  @attention 0.25秒后会清空相关视图，无论动画是否完成
 */
- (void)fc_runModelDismissAnimation;

/**
 *  视图定位到父视图中心的AutoLayout属性，使用 @synthesize 实现使属性可用
 */
@property (strong, nonatomic) NSLayoutConstraint *fc_centerConstraintX;
@property (strong, nonatomic) NSLayoutConstraint *fc_centerConstraintY;


@end


@interface UIViewController (FCModelPresentation)

/**
 *  显示符合FCModelPresentationProtocol标准的FormSheet风格Model界面
 */
- (void)fc_modelPresentViewController:(UIViewController<FCModelPresentationProtocol>*)controller animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 *  关闭FCModel的界面
 */
- (void)fc_dismissModelViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end

/**
 *  自定义连线，实现在StoryBoard中使用segue操作
 */
@interface FCModelPresentationSegue : UIStoryboardSegue

@end






