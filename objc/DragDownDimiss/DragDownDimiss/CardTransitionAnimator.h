//
//  CardTransitionAnimator.h
//  DragDownDimiss
//
//  Created by CBLUE on 4/14/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CardTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL appearing;
@property (nonatomic, assign) NSTimeInterval duration;
@end
