//
//  CardTransitionAnimator.m
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "CardTransitionAnimator.h"

@implementation UIView(Card)
- (void)setRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}
@end

@interface CardTransitionAnimator ()
@end

@implementation CardTransitionAnimator {
    UIView *_backgroundView;
    UIView *_dimmingView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.3;
        
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    if (self.appearing) {
        [self presentTransition:transitionContext duration:duration];
    } else {
        [self dismissTransition:transitionContext duration:duration];
    }
}

- (void)presentTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                 duration:(CGFloat)duration
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    
    [fromVC beginAppearanceTransition:NO animated:YES];
    [toVC beginAppearanceTransition:YES animated:YES];

    // Round the corners
    [toView setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadius:12];
    
    // Add previous view as background
    _backgroundView = ({
        UIView *backgroundView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        backgroundView.frame = containerView.bounds;
        backgroundView;
    });
    [containerView addSubview:_backgroundView];

    // Add a dimming on background view
    _dimmingView = [[UIView alloc] initWithFrame:_backgroundView.bounds];
    _dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [_backgroundView addSubview:_dimmingView];
    
    // Finally, add the view about to present
    [containerView addSubview:toView];
    
    CGFloat topPadding = 20;
    
    CGRect startFrame = ({
        CGRect frame = toView.frame;
        // Move to the bottom
        frame.origin.y += frame.size.height;
        // Minus height to make background appear on top
        frame.size.height -= topPadding;
        frame;
    });

    CGRect endFrame = ({
        CGRect frame = startFrame;
        frame.origin.y = topPadding;
        frame;
    });
    
    toView.frame = startFrame;
    
    fromView.userInteractionEnabled = NO;
    _dimmingView.alpha = 0;
    [UIView animateWithDuration:duration animations: ^{
        toView.frame = endFrame;
        _dimmingView.alpha = 1;
    } completion: ^(BOOL finished) {
        
        BOOL isTransitionCanceled = [transitionContext transitionWasCancelled];
        
        [transitionContext completeTransition:!isTransitionCanceled];
        
        if (![transitionContext transitionWasCancelled]) {
            [fromVC endAppearanceTransition];
            [toVC endAppearanceTransition];
        }
    }];
}

- (void)dismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                 duration:(CGFloat)duration
{
    UIViewController *toVC =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [toVC beginAppearanceTransition:YES animated:YES];
    [fromVC beginAppearanceTransition:NO animated:YES];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    
    UIView *snapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = fromView.frame;
    [containerView addSubview:snapshot];
    
    CGRect endFrame = snapshot.frame;
    endFrame.origin.y += endFrame.size.height;
    
    fromView.hidden = YES;
    [UIView animateWithDuration:duration animations: ^{
        snapshot.frame = endFrame;
        _dimmingView.alpha = 0;
    } completion: ^(BOOL finished) {
        fromView.hidden = NO;
        toView.userInteractionEnabled = YES;
        [snapshot removeFromSuperview];
        
        if ([transitionContext transitionWasCancelled]) {
            _dimmingView.alpha = 1;
        } else {
            [_backgroundView removeFromSuperview];
            
            [fromVC endAppearanceTransition];
            [toVC endAppearanceTransition];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
