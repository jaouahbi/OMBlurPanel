//
//  OMBlurPanel.m
//  OMBlurPanel
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBlurPanel : UIView
-(instancetype) initWithFrame:(CGRect)frame;
-(void) close:(UIView*) sourceView  block:(void (^)(void))block;
-(void) open:(UIView*) sourceView   block:(void (^)(void))block;
-(BOOL) isOpen;
@property(strong,nonatomic) UIVisualEffectView* effectView;
@property(strong,nonatomic) UIView *contentView;
@end
