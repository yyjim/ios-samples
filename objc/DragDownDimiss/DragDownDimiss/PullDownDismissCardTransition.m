//
//  PullDownTransition.m
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "PullDownDismissCardTransition.h"

#pragma mark - PullDownDismissCardTransition

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

#pragma mark - CardTransitionAnimator

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

#pragma mark - PullDownTransitionInteractor

@interface PullDownTransitionInteractor() <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIViewController *targetViewController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) NSMutableArray<UIPanGestureRecognizer *> *scrollViewPanGestures;
@end

@implementation PullDownTransitionInteractor {
    CGFloat _initialY;
}

+ (instancetype)interactorWithTargetViewController:(UIViewController *)targetViewController
{
    PullDownTransitionInteractor *interactor = [PullDownTransitionInteractor new];
    interactor.targetViewController = targetViewController;
    interactor.scrollViewPanGestures = [NSMutableArray new];
    return interactor;
}

- (void)dealloc
{
    self.targetScrollViews = nil;
}

#pragma mark ScrollView Pan

- (void)setTargetScrollViews:(NSArray<UIScrollView *> *)targetScrollViews
{
    [_targetScrollViews enumerateObjectsUsingBlock:^(UIScrollView *scrollView, NSUInteger idx, BOOL *stop) {
        [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        [_scrollViewPanGestures enumerateObjectsUsingBlock:^(UIPanGestureRecognizer *pan, NSUInteger idx, BOOL *stop) {
            [scrollView removeGestureRecognizer:pan];
        }];
    }];
    [_scrollViewPanGestures removeAllObjects];
    
    _targetScrollViews = targetScrollViews;
    
    [_targetScrollViews enumerateObjectsUsingBlock:^(UIScrollView *scrollView, NSUInteger idx, BOOL * _Nonnull stop) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewPan:)];
        pan.delegate = self;
        [scrollView addGestureRecognizer:pan];
        [_scrollViewPanGestures addObject:pan];
        
        [scrollView addObserver:self
                     forKeyPath:NSStringFromSelector(@selector(contentOffset))
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    }];
}

- (void)handleScrollViewPan:(UIPanGestureRecognizer *)panGesture
{
    UIScrollView *scrollView = (UIScrollView *) panGesture.view;
    
    if (scrollView.contentOffset.y > 0) {
        if (self.interactionInProgress) {
            [self endInteractFinished:NO];
        }
        return;
    }
    
    CGFloat currentY = [panGesture locationInView:self.targetViewController.view].y;
    
    if (self.interactionInProgress) {
        
        CGFloat progress = (currentY - _initialY) /CGRectGetHeight(self.targetViewController.view.bounds);
        progress = MIN(MAX(0, progress), 1);
        
        if (panGesture.state == UIGestureRecognizerStateEnded) {
            [self endInteractFinished:progress > 0.3];
        } else {
            [self updateInteractiveTransition:progress];
        }
    } else {
        [self startInteract];
        _initialY = currentY;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (![object isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
    
    UIScrollView *scrollView = (UIScrollView *)object;
    if (contentOffset.y < 0) {
        contentOffset.y = 0;
        scrollView.contentOffset = contentOffset;
    }
}

#pragma mark ViewController Pan

- (void)setTargetViewController:(UIViewController *)targetViewController
{
    _targetViewController = targetViewController;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewControllerPan:)];
    [targetViewController.view addGestureRecognizer:self.panGesture];
}

- (void)handleViewControllerPan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:self.targetViewController.view];
    CGFloat progress = translation.y / CGRectGetHeight(self.targetViewController.view.bounds);
    progress = MIN(MAX(0, progress), 1);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            [self startInteract];
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateEnded:
            [self endInteractFinished:progress > 0.3];
            break;
        case UIGestureRecognizerStateCancelled:
            [self endInteractFinished:NO];
            break;
        default:
            break;
    }
}

#pragma mark Interact

- (void)startInteract
{
    self.interactionInProgress = YES;
    [self.targetViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)endInteractFinished:(BOOL)finished
{
    self.interactionInProgress = NO;
    if (finished) {
        [self finishInteractiveTransition];
    } else {
        [self cancelInteractiveTransition];
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.panGesture) {
        return NO;
    }
    
    return YES;
}

@end
