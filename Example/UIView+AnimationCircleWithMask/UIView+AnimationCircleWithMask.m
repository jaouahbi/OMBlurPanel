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


const CGFloat MSPButtonDownMarginSpace = 8;

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

-(void) animateMaskWithView:(UIView*) sourceView
               circleRadius:(CGFloat) circleRadius
                      ratio:(CGFloat) ratio
                    reverse:(BOOL) reverse
                   duration:(NSTimeInterval) duration
                   delegate:(id<CAAnimationDelegate>) delegate
                      block:(void (^)(void))block{

    UIBezierPath * maskPath     = [UIBezierPath new];
    UIBezierPath * circlePath   = [UIBezierPath new];
    
    CGFloat frameHeight         = self.frame.size.height;
    CGFloat buttonFrameHeight   = sourceView.bounds.size.height;
    CGPoint buttonCenter        = sourceView.center;
    CGFloat maskRadius          = buttonFrameHeight * 0.5;
    CGPoint center              = buttonCenter;
    
    //
    // Calculate the center position for other ratios than 1.0
    //
    
    if (ratio != 1.0) {
        center = CGPointMake(center.x, (frameHeight - buttonFrameHeight) + MSPButtonDownMarginSpace);
    }
    
    //
    // Create the paths
    //
    
    [maskPath addArcWithCenter:center radius:maskRadius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:true];
    [maskPath addArcWithCenter:center radius:maskRadius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:true];
    [maskPath addArcWithCenter:center radius:maskRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:true];
    [maskPath addArcWithCenter:center radius:maskRadius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:true];
    [maskPath closePath];
    
    
    [circlePath addArcWithCenter:center radius:frameHeight startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:true];
    [circlePath addArcWithCenter:center radius:frameHeight startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:true];
    [circlePath addArcWithCenter:center radius:frameHeight startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:true];
    [circlePath addArcWithCenter:center radius:frameHeight startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:true];
    [circlePath closePath];
    
    //
    //
    //
    
    CGRect maskBounds   = [maskPath bounds];
    CGRect circleBounds = [circlePath bounds];
    
    NSLog(@"mask %@ circle %@, target radius:%f source radius:%f center:%@",
         NSStringFromCGRect(maskBounds),
         NSStringFromCGRect(circleBounds),
         maskRadius,
         circleRadius,
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
    
    [maskLayer addAnimation:animation forKey:@"AURAMorphingAnimation"];
    if (!reverse) {
        [maskLayer setPath:[circlePath CGPath]];
    }
    
    [CATransaction commit];
}

@end