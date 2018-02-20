//
//  OMBlurPanel.m
//  OMBlurPanel
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "OMBlurPanel.h"
#import "UIView+AnimationCircleWithMask.h"
#import "UIView+Blur.h"

@interface OMBlurPanel()
@property(strong,nonatomic) CAGradientLayer *gradient;
@property(strong,nonatomic) NSArray *gradientColors;
@end

@implementation OMBlurPanel

@dynamic colors;

-(instancetype) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.alpha               = 1.0;
        self.contentView         = [[UIView alloc] initWithFrame:frame];
        self.contentView.alpha   = 0.68;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius  = 8;
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (self.gradient == nil) {
        self.gradient = [CAGradientLayer layer];
        [self.contentView.layer insertSublayer:self.gradient atIndex:0];
    }


    
    self.gradient.frame = self.frame;
    self.gradient.startPoint = CGPointMake(1, 0);
    self.gradient.endPoint   = CGPointMake(0, 1);
    
    NSMutableArray * colorsCG = [NSMutableArray array];
    for (UIColor * color in _gradientColors) {
        if ([color isKindOfClass:[UIColor class]]) {
            [colorsCG addObject:(id)color.CGColor];
        } else {
            [colorsCG addObject:(id)color];
        }
    }
    self.gradient.colors = colorsCG;;
}

-(NSArray*) colors {
    return _gradientColors;
}

-(void) setColors:(NSArray *)colors {
    _gradientColors = colors;
    [self setNeedsLayout];
}

-(BOOL) isOpen {
   return (self.effectView != nil);
}

-(void) close:(UIView*) sourceView targetFrame:(CGRect) targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    NSParameterAssert(!CGRectEqualToRect(targetFrame, CGRectZero));
    if(CGRectEqualToRect(targetFrame, CGRectZero)) return;
    
    if (_delegate != nil) {
        [_delegate willClosePanel:self];
    }
    //
    // Morphing the UIView (reverse).
    //
    
    CGFloat circleRadius = targetFrame.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:1.0 reverse:YES duration:duration delegate:nil block:^{
        [self.effectView removeFromSuperview];
        self.effectView  = nil;
        if (block) {
            block();
        }
        if (_delegate != nil) {
            [_delegate didClosePanel:self];
        }
    }];
}

-(void) open:(UIView*) sourceView targetFrame:(CGRect)targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    NSParameterAssert(!CGRectEqualToRect(targetFrame, CGRectZero));
    if(CGRectEqualToRect(targetFrame, CGRectZero)) return;

    if (_delegate != nil) {
        [_delegate willOpenPanel:self];
    }
  
    //
    // Morphing the UIView.
    //
    
    self.frame      = targetFrame;
    self.effectView = [self addViewWithBlur:self.contentView style:UIBlurEffectStyleDark addConstrainst:YES];
    CGFloat circleRadius = targetFrame.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:1.0 reverse:NO duration:duration delegate:nil block:^{
        if (block) {
            block();
        }
        if (_delegate != nil) {
            [_delegate didOpenPanel:self];
        }
    }];
}


@end
