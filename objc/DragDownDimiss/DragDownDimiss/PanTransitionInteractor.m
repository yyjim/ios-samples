//
//  PanTransitionInteractor.m
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "PanTransitionInteractor.h"

@interface PanTransitionInteractor()
@property (nonatomic, strong) UIViewController *targetViewController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@end

@implementation PanTransitionInteractor {
    BOOL _shouldCompleteTransition;
}

+ (instancetype)interactorWithTargetViewController:(UIViewController *)targetViewController
{
    PanTransitionInteractor *interactor = [PanTransitionInteractor new];
    interactor.targetViewController = targetViewController;
    return interactor;
}

- (void)setTargetViewController:(UIViewController *)targetViewController
{
    _targetViewController = targetViewController;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [targetViewController.view addGestureRecognizer:self.panGesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:self.targetViewController.view];
    CGFloat progress = translation.y / CGRectGetHeight(self.targetViewController.view.bounds);
    progress = MIN(MAX(0, progress), 1);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.interactionInProgress = YES;
            [self.targetViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
            _shouldCompleteTransition = progress > 0.3;
            [self updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateEnded:
            self.interactionInProgress = NO;
            
            if (_shouldCompleteTransition) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        case UIGestureRecognizerStateCancelled:
            self.interactionInProgress = NO;
            [self cancelInteractiveTransition];
            break;
        default:
            break;
    }
}

@end
