//
//  SecondViewController.m
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "SecondViewController.h"
#import "CardTransitionAnimator.h"
#import "PanTransitionInteractor.h"

@interface SecondViewController () <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) CardTransitionAnimator *animator;
@property (nonatomic, strong) PanTransitionInteractor *interactor;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.transitioningDelegate = self;
    self.animator = [CardTransitionAnimator new];
    self.interactor = [PanTransitionInteractor interactorWithTargetViewController:self];
    self.interactor.targetScrollViews = @[self.textView];
}

- (IBAction)actionDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
