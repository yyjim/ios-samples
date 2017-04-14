//
//  PanTransitionInteractor.h
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PanTransitionInteractor : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interactionInProgress;
+ (instancetype)interactorWithTargetViewController:(UIViewController *)targetViewController;
@end
