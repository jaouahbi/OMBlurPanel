//
//  OMCustomIntensityVisualEffectView.h
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OMCustomIntensityVisualEffectView : UIVisualEffectView

/// Create visual effect view with given effect and its intensity
///
/// - Parameters:
///   - effect: visual effect, eg UIBlurEffect(style: .dark)
///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
-(instancetype) initWithEffect:(UIVisualEffect*) effect  intensity:(CGFloat) intensity;

// MARK: Private
@property(nonatomic, strong) UIViewPropertyAnimator * animator;
@end
