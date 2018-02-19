//
//  OMBlurView.h
//  blur
//
//  Created by io on 17/2/18.
//  Copyright © 2018 io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Blur)

-(UIVisualEffectView *)addViewWithBlur:(UIView*) view style:(UIBlurEffectStyle) style addConstrainst:(BOOL)addConstrainst;
-(void)animateFromDownToUpWithFactor:(CGFloat) factor;

-(void)animateFrom:(UIView*) view rect:(CGRect)rect duration:(NSTimeInterval) duration;
@end
