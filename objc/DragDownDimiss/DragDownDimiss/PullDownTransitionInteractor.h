//
//  PanTransitionInteractor.h
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PullDownTransitionInteractor : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interactionInProgress;
@property (nonatomic, strong) NSArray<UIScrollView *> *targetScrollViews;
+ (instancetype)interactorWithTargetViewController:(UIViewController *)targetViewController;
@end
