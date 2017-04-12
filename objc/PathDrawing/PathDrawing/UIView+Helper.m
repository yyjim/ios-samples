//
//  UIView+Helper.m
//  PathDrawing
//
//  Created by CBLUE on 4/12/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (UIImage *)pd_captureImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
