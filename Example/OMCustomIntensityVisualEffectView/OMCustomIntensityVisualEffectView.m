//
//  OMCustomIntensityVisualEffectView.m
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "OMCustomIntensityVisualEffectView.h"

@implementation OMCustomIntensityVisualEffectView

-(instancetype) initWithEffect:(UIVisualEffect*) effect intensity:(CGFloat) intensity {
    self = [super initWithEffect:effect];
    if(self) {
        
        self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.1 curve:UIViewAnimationCurveLinear animations:^{
            self.effect = effect;
        }];
        
        self.animator.fractionComplete = intensity;
    }
    
    return self;
}

@end
