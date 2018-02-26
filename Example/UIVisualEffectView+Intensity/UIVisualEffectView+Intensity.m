//
//  UIVisualEffectView+Intensity.m
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "UIVisualEffectView+Intensity.h"

@implementation UIVisualEffectView(Intensity)

-(void) setEffectWithIntensity:(UIVisualEffect*) effect  intensity:(CGFloat) intensity duration:(NSTimeInterval) duration {
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:UIViewAnimationCurveLinear animations:^{
        self.effect = effect;
    }];
    animator.fractionComplete = intensity;
}

-(void) fadeInEffect:(UIBlurEffectStyle) style withDuration: (NSTimeInterval) duration {
    if (@available(iOS 10.0, *)) {
        UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:UIViewAnimationCurveEaseIn animations:^{
            self.effect = [UIBlurEffect effectWithStyle:style];
        }];
        [animator startAnimation];
    }else {
        // Fallback on earlier versions
        [UIView animateWithDuration:duration animations:^{
            self.effect = [UIBlurEffect effectWithStyle:style];
        }];
    }
}

-(void) fadeOutEffect:(NSTimeInterval) duration {
    if (@available(iOS 10.0, *)) {
        UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:UIViewAnimationCurveLinear animations:^{
            self.effect = nil;
        }];
        [animator startAnimation];
        animator.fractionComplete = 1;
    }else {
        // Fallback on earlier versions
        [UIView animateWithDuration:duration animations:^{
            self.effect = nil;
        }];
    }
}


@end
