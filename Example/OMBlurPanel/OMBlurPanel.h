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
@end

@interface OMBlurPanel : UIView
-(instancetype) initWithFrame:(CGRect)frame;
-(void) close:(UIView*) sourceView targetFrame:(CGRect) targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block;
-(void) open:(UIView*) sourceView targetFrame:(CGRect) targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block ;
-(BOOL) isOpen;
@property(strong,nonatomic) UIVisualEffectView* effectView;
@property(strong,nonatomic) UIView *contentView;
@property(strong,nonatomic) NSArray *colors;
@property(weak,nonatomic) id<OMBlurPanelDelegate> delegate;

@end
