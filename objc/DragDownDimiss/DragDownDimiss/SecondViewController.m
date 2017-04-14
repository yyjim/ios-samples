//
//  SecondViewController.m
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "SecondViewController.h"
#import "PullDownDismissCardTransition.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonnull) PullDownDismissCardTransition *transition;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.transition = [[PullDownDismissCardTransition alloc] initWithTargetViewController:self];
    self.transitioningDelegate = self.transition;
    self.transition.targetScrollViews = @[self.textView];
}

- (IBAction)actionDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
