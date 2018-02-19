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


#define COLOR_FROM_RGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]


@interface OMBlurPanel()
    @property(strong,nonatomic) CAGradientLayer *gradient;
@end

@implementation OMBlurPanel

-(instancetype) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.alpha               = 1.0;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius  = 6;
        self.contentView = [[UIView alloc] initWithFrame:frame];
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (self.gradient != nil) {
        [self.gradient removeFromSuperlayer];
        self.gradient = nil;
    }
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.contentView.frame;
    
    UIColor * color3 = COLOR_FROM_RGB(0x4AC7F0);
    UIColor * color2 = COLOR_FROM_RGB(0x10AFE3);
    UIColor * color1 = COLOR_FROM_RGB(0x00A7E0);
    UIColor * color0 = COLOR_FROM_RGB(0x008FDB);
    
    self.gradient.startPoint = CGPointMake(1, 0);
    self.gradient.endPoint   = CGPointMake(0, 1);
    
    self.gradient.colors = @[(id)color3.CGColor,
                             (id)color2.CGColor,
                             (id)color1.CGColor,
                             (id)color0.CGColor];
    
    
    //   panelView.backgroundColor = [UIColor blueColor];
    [self.contentView.layer insertSublayer:self.gradient atIndex:0];

}

-(BOOL) isOpen {
   return (self.effectView != nil);
}

-(void) close:(UIView*) sourceView  block:(void (^)(void))block {
    // reverse
    UIView * targetView  = self;
    CGFloat circleRadius = targetView.bounds.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:1.0 reverse:YES duration:1.0 delegate:nil block:^{
        [self.effectView removeFromSuperview];
        self.effectView  = nil;
        if (block) {
            block();
        }
    }];
}

-(void) open:(UIView*) sourceView   block:(void (^)(void))block {
    //
    // Morphing the UIView.
    //
    self.effectView = [self addViewWithBlur:self.contentView style:UIBlurEffectStyleDark addConstrainst:YES];
    CGFloat circleRadius =  self.effectView.bounds.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:1.0 reverse:NO duration:1.0 delegate:nil block:block];
}
@end
