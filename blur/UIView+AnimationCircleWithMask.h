//
//  UIView+AnimationCircleWithMask.h
//  Jorge Ouahbi
//
//  Created by Jorge Ouahbi on 15/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView(AnimationCircleWithMask)

-(void) animateMaskWithView:(UIView*) sourceView
               circleRadius:(CGFloat) circleRadius
                      ratio:(CGFloat) ratio
                    reverse:(BOOL) reverse
                   duration:(NSTimeInterval) duration
                   delegate:(id<CAAnimationDelegate>) delegate
                      block:(void (^)(void))block;

@end
