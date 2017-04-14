//
//  PullDownTransition.m
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "PullDownDismissCardTransition.h"
#import "CardTransitionAnimator.h"
#import "PullDownTransitionInteractor.h"

@interface PullDownDismissCardTransition()
@property (nonatomic, strong) CardTransitionAnimator *animator;
@property (nonatomic, strong) PullDownTransitionInteractor *interactor;
@end

@implementation PullDownDismissCardTransition

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController
{
    self = [super init];
    
    if (self) {
        _animator = [CardTransitionAnimator new];
        _interactor = [PullDownTransitionInteractor interactorWithTargetViewController:targetViewController];

    }
    
    return self;
}

- (void)setTargetScrollViews:(NSArray<UIScrollView *> *)targetScrollViews
{
    _targetScrollViews = targetScrollViews;
    
    _interactor.targetScrollViews = targetScrollViews;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactor.interactionInProgress ? self.interactor : nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    self.animator.appearing = YES;
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.animator.appearing = NO;
    return self.animator;
}

@end
