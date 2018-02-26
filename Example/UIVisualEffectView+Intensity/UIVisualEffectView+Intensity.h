//
//  UIVisualEffectView+Intensity.h
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIVisualEffectView(Intensity)
/**!
 *  @brief Set the effect view with given effect and its intensity
 *
 *  @param effect UIVisualEffect* Visual effect, eg [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
 *  @param intensity CGFloat Custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
 *  @param duration NSTimeInterval duration
 */
-(void) setEffectWithIntensity:(UIVisualEffect*) effect  intensity:(CGFloat) intensity duration:(NSTimeInterval) duration ;
/**!
 * @brief Fade out
 *
 * @param duration NSTimeInterval
 */
-(void) fadeOutEffect:(NSTimeInterval) duration;
/**!
 * @brief Fade in
 *
 * @param style UIBlurEffectStyle
 * @param duration NSTimeInterval
 */
-(void) fadeInEffect:(UIBlurEffectStyle) style withDuration: (NSTimeInterval) duration;

@end
