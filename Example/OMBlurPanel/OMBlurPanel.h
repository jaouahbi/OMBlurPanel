//
//  OMBlurPanel.m
//  OMBlurPanel
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBlurPanel;
@protocol OMBlurPanelDelegate<NSObject>
-(void) didClosePanel:(OMBlurPanel*) panel;
-(void) didOpenPanel:(OMBlurPanel*) panel;
-(void) willClosePanel:(OMBlurPanel*) panel;
-(void) willOpenPanel:(OMBlurPanel*) panel;
-(void) didlClosePanelWithGesture:(OMBlurPanel*) panel;
@end

@interface OMBlurPanel : UIView
/**!
 * @brief initWithFrame
 *
 * @param frame CGRect
 * @param style UIBlurEffectStyle
 * @return self
 */
-(instancetype) initWithFrame:(CGRect)frame style:(UIBlurEffectStyle)style;
/**!
 * @brief Close the panel
 *
 * @param duration NSTimeInterval
 * @param ratio CGFloat
 * @param block Completion block
 */
-(void) closePanel:(NSTimeInterval) duration  ratio:(CGFloat) ratio  block:(void (^)(void))block;
/**!
 * @brief Close the panel
 *
 * @param duration NSTimeInterval
 * @param block Completion block
 */
-(void) closePanel:(NSTimeInterval) duration block:(void (^)(void))block;
/**!
 * @brief Open the panel
 *
 * @param sourceView UIView - The view used as source of the mask animation.
 * @param duration NSTimeInterval
 * @param block Completion block
 */
-(void) openPanel:(UIView*) sourceView duration:(NSTimeInterval) duration block:(void (^)(void))block ;
/**!
 * @brief Open the panel
 *
 * @param sourceView UIView
 * @param duration NSTimeInterval
 * @param ratio CGFloat
 * @param block Completion block
 */
-(void) openPanel:(UIView*) sourceView duration:(NSTimeInterval) duration ratio:(CGFloat) ratio block:(void (^)(void))block;
/**!
 * @brief Panel open state.
 *
 * @return BOOL
 */
-(BOOL) isOpen;


#pragma mark - Properties

@property(strong,nonatomic) UIVisualEffectView* effectView;
@property(strong,nonatomic) UIView *contentView;

// Must be set before add to the superview.
@property(assign,nonatomic) CGSize cornerRadii;
@property(weak,nonatomic) id<OMBlurPanelDelegate> delegate;
@property(assign,nonatomic) BOOL allowCloseGesture;
@property(assign,nonatomic) CGFloat minimunPanFactor;

@end
