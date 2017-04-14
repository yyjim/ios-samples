//
//  PanTransitionInteractor.m
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "PullDownTransitionInteractor.h"

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

#pragma mark - ScrollView Pan

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

#pragma mark - ViewController Pan

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

#pragma mark - Interact

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

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.panGesture) {
        return NO;
    }
    
    return YES;
}


@end
