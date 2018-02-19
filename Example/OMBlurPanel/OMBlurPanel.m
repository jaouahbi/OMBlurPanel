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
    
    
    self.gradient.colors = colorsCG;
    
    
    //   panelView.backgroundColor = [UIColor blueColor];
    [self.contentView.layer insertSublayer:self.gradient atIndex:0];
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

-(void) close:(UIView*) sourceView targetFrame:(CGRect) targetFrame block:(void (^)(void))block {
    
    //
    // Morphing the UIView (reverse).
    //
    CGFloat circleRadius = targetFrame.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:1.0 reverse:YES duration:1.0 delegate:nil block:^{
        [self.effectView removeFromSuperview];
        self.effectView  = nil;
        if (block) {
            block();
        }
    }];
}

-(void) open:(UIView*) sourceView  targetFrame:(CGRect)targetFrame block:(void (^)(void))block {
    //
    // Morphing the UIView.
    //
    self.frame = targetFrame;
    self.effectView = [self addViewWithBlur:self.contentView style:UIBlurEffectStyleDark addConstrainst:YES];
    CGFloat circleRadius = targetFrame.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:1.0 reverse:NO duration:1.0 delegate:nil block:block];
}
@end
