//
//  OMBlurPanel.m
//  OMBlurPanel
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+AnimationCircleWithMask.h"

@interface UIView(Blur)

-(UIVisualEffectView *)addViewWithBlur:(UIView*) view style:(UIBlurEffectStyle) style addConstrainst:(BOOL)addConstrainst;

@end
