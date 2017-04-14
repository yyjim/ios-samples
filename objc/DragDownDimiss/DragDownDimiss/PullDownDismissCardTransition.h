//
//  PullDownTransition.h
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PullDownDismissCardTransition : NSObject <UIViewControllerTransitioningDelegate>
- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController;
@property (nonatomic, strong) NSArray<UIScrollView *> *targetScrollViews;
@end

@interface CardTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL appearing;
@property (nonatomic, assign) NSTimeInterval duration;
@end

@interface PullDownTransitionInteractor : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interactionInProgress;
@property (nonatomic, strong) NSArray<UIScrollView *> *targetScrollViews;
+ (instancetype)interactorWithTargetViewController:(UIViewController *)targetViewController;
@end
