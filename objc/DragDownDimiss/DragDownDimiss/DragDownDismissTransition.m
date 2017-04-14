//
//  DragDownDismissAnimator.m
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "DragDownDismissTransition.h"
#import "CardTransitionAnimator.h"
#import "PanTransitionInteractor.h"

@interface DragDownDismissTransition()
@property (nonatomic, strong) CardTransitionAnimator *animator;
@property (nonatomic, strong) PanTransitionInteractor *interactor;
@end

@implementation DragDownDismissTransition

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.animator = [CardTransitionAnimator new];
    }
    
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactor.interactionInProgress ? self.interactor : nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    self.interactor = [PanTransitionInteractor interactorWithTargetViewController:presented];

    self.animator.appearing = YES;
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    
    self.animator.appearing = NO;
    return self.animator;
}

@end


