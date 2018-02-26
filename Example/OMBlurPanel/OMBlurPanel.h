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
-(instancetype) initWithFrame:(CGRect)frame style:(UIBlurEffectStyle)style;
-(void) closePanel:(UIView*) sourceView targetFrame:(CGRect) targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block;
-(void) openPanel:(UIView*) sourceView targetFrame:(CGRect) targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block ;
-(BOOL) isOpen;
-(void) addCloseButton:(UIButton*) buttonClose;

@property(strong,nonatomic) UIVisualEffectView* effectView;
@property(strong,nonatomic) UIView *contentView;
@property(strong,nonatomic) NSArray *colors;
// Must be set before add to the superview.
@property(assign,nonatomic) CGSize cornerRadii;
@property(weak,nonatomic) id<OMBlurPanelDelegate> delegate;
@property(assign,nonatomic) BOOL allowCloseGesture;

@end
