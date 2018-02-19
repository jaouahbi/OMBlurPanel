//
//  OMBlurView.m
//  blur
//
//  Created by io on 17/2/18.
//  Copyright © 2018 io. All rights reserved.
//

#import "UIView+Blur.h"

@implementation UIView(Blur)

-(UIVisualEffectView *)addViewWithBlur:(UIView*) view style:(UIBlurEffectStyle) style addConstrainst:(BOOL)addConstrainst
{
    // Blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.bounds];
    [self addSubview:blurEffectView];
    
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.bounds];
    
    // Add view to the vibrancy view
    [[vibrancyEffectView contentView] addSubview:view];
    
    // Add the vibrancy view to the blur view
    [[blurEffectView contentView] addSubview:vibrancyEffectView];
    
    if(addConstrainst) {
    
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1
                                                      constant:0]];
        
    }
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [blurEffectView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:blurEffectView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    
    [blurEffectView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:blurEffectView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    
    [blurEffectView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:blurEffectView
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:0]];
    
    [blurEffectView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:blurEffectView
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1
                                                      constant:0]];
    

    return blurEffectView;
}


-(void)animateFromDownToUpWithFactor:(CGFloat)factor
{
    CGRect r = self.frame;
    self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:1.0  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat newHeight  = r.size.height * factor;
        self.frame = CGRectMake(r.origin.x,  r.size.height  - newHeight, r.size.width, newHeight);
    } completion:^(BOOL finished) {
        
    }];
}
#define DEGREES_TO_RADIANS(degrees) (M_PI*degrees/180)
-(void)animateFrom:(UIView*) view rect:(CGRect)rect duration:(NSTimeInterval) duration
{
    UIBezierPath * maskPath = [UIBezierPath new];
    CGPoint p = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    [maskPath addArcWithCenter:p radius:view.bounds.size.height startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:true];
    [maskPath addArcWithCenter:p radius:view.bounds.size.height startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:true];
    [maskPath addArcWithCenter:p radius:view.bounds.size.height startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:true];
    [maskPath addArcWithCenter:p radius:view.bounds.size.height startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:true];
    [maskPath closePath];
    
    UIBezierPath * endPath = [UIBezierPath new];
    [endPath moveToPoint:CGPointMake(0,0)];
    [endPath addLineToPoint:endPath.currentPoint];
    [endPath addLineToPoint:CGPointMake(rect.size.width, 0)];
    [endPath addLineToPoint:endPath.currentPoint];
    [endPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [endPath addLineToPoint:endPath.currentPoint];
    [endPath addLineToPoint:CGPointMake(0, rect.size.height)];
    [endPath addLineToPoint:endPath.currentPoint];
    [endPath closePath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (id)maskPath.CGPath;
    animation.toValue = (id)endPath.CGPath;
    animation.duration = duration;
    [maskLayer addAnimation:animation forKey:nil];
    [maskLayer setPath:endPath.CGPath];
}

@end
