//
//  UIView+AnimationCircleWithMask.m
//  Jorge Ouahbi
//
//  Created by Desarrollo on 15/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "UIView+AnimationCircleWithMask.h"

#ifdef MODULE_PREFIX
#undef MODULE_PREFIX
#endif

#define MODULE_PREFIX @"VIEWMSK"

#define DEGREES_TO_RADIANS(degrees) (M_PI*degrees/180)

CGFloat dist(CGPoint p2,CGPoint p1){

    CGFloat xDist = (p2.x - p1.x); //[2]
    CGFloat yDist = (p2.y - p1.y); //[3]
    return  sqrt((xDist * xDist) + (yDist * yDist)); //[4]
}

@implementation UIView(AnimationCircleWithMask)

/*
 * @brief Morphing from a circle in rect to a circle.
 *
 * @param CGFloat radius
 * @param BOOL reverse
 * @param CGFloat ratio
 * @param NSTimeInterval duration
 * @param id<CAAnimationDelegate> delegate
 * @param void (^)(void) block
 */

-(void) animateMaskWithCenter: (CGPoint) center
               maxRadius:(CGFloat) maxRadius
                    minRadius:(CGFloat) minRadius
                      ratio:(CGFloat) ratio
                    reverse:(BOOL) reverse
                   duration:(NSTimeInterval) duration
                   delegate:(id<CAAnimationDelegate>) delegate
                      block:(void (^)(void))block{

    UIBezierPath * maskPath     = [UIBezierPath new];
    UIBezierPath * circlePath   = [UIBezierPath new];

    //
    // Calculate the center position for other ratios than 1.0
    //
    
     center = CGPointMake(center.x ,  center.y * ratio);
    
    //
    // Create the paths
    //
    
    [maskPath addArcWithCenter:center radius:minRadius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:true];
    [maskPath addArcWithCenter:center radius:minRadius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:true];
    [maskPath addArcWithCenter:center radius:minRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:true];
    [maskPath addArcWithCenter:center radius:minRadius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:true];
    [maskPath closePath];
    
    
    [circlePath addArcWithCenter:center radius:maxRadius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:true];
    [circlePath addArcWithCenter:center radius:maxRadius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:true];
    [circlePath addArcWithCenter:center radius:maxRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:true];
    [circlePath addArcWithCenter:center radius:maxRadius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:true];
    [circlePath closePath];
    
    //
    //
    //
    
    CGRect maskBounds   = [maskPath bounds];
    CGRect circleBounds = [circlePath bounds];
    
    NSLog(@"mask %@ circle %@, target radius:%f source radius:%f center:%@",
         NSStringFromCGRect(maskBounds),
         NSStringFromCGRect(circleBounds),
         minRadius,
         maxRadius,
         NSStringFromCGPoint(center));
    
    //
    // Setup the mask layer.
    //
    
    CAShapeLayer *maskLayer       = [CAShapeLayer layer];
    maskLayer.frame               = self.bounds;
    maskLayer.path                = maskPath.CGPath;
    self.layer.mask               = maskLayer;
    
    //
    // Animate the path.
    //
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    CABasicAnimation * animation  = [CABasicAnimation animationWithKeyPath:@"path"];
    
    animation.fromValue           = reverse ? (id)[circlePath CGPath] : (id)maskPath.CGPath;
    animation.toValue             = reverse ? (id)maskPath.CGPath  : (id)[circlePath CGPath];
    animation.duration            = duration;
    animation.delegate            = delegate;
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    if (block != nil) {
        [CATransaction setCompletionBlock:^{
            self.layer.mask = nil;
            block();
        }];
    }
    
    [maskLayer addAnimation:animation forKey:@"MaskAnimation"];
    if (!reverse) {
        [maskLayer setPath:[circlePath CGPath]];
    }
    
    [CATransaction commit];
}

@end
