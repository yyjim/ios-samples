//
//  ViewController.m
//  PathDrawing
//
//  Created by CBLUE on 4/12/17.
//  Copyright © 2017 Wani. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Helper.h"

@interface LineDrawingView : UIView
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) UIImage *cacheImage;
@end

@implementation LineDrawingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.points = [NSMutableArray new];
    
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture locationInView:self];
    
    [self.points addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];

    if (panGesture.state == UIGestureRecognizerStateEnded ||
        panGesture.state == UIGestureRecognizerStateCancelled) {
        self.cacheImage = [self pd_captureImage];
        [self.points removeAllObjects];
    }
}

- (void)drawRect:(CGRect)rect
{
    if (self.cacheImage) {
        [self.cacheImage drawInRect:rect];
    }
    
    UIBezierPath *path = [UIBezierPath new];
    
    [self.points enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = pointValue.CGPointValue;
        
        if (idx == 0) {
            [path moveToPoint:point];
        }
        
        if (pointValue != self.points.lastObject) {
            CGPoint nextPoint = [self.points[idx + 1] CGPointValue];
            [path addLineToPoint:nextPoint];
        }
    }];
    
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineWidth:3];
    [[UIColor blackColor] setStroke];
    [path stroke];
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
