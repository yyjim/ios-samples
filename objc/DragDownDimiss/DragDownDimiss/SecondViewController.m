//
//  SecondViewController.m
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "SecondViewController.h"
#import "DragDownDismissTransition.h"

@interface SecondViewController ()
@property (nonatomic, strong) DragDownDismissTransition *transition;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.transition = [DragDownDismissTransition new];
    self.transitioningDelegate = self.transition;
}

- (IBAction)actionDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
