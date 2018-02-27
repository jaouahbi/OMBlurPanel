//
//  OMBlurPanel.m
//  OMBlurPanel
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "OMBlurPanel.h"
#import "UIView+AnimationCircleWithMask.h"
#import "UIView+CornerRounded.h"
#import "UIView+Blur.h"


#ifndef CLAMP
#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))
#endif

@interface OMBlurPanel()
{
    CGRect _originalPanFrame;
    CGRect _lastChangePanFrame;
}
@property(strong,nonatomic) CAGradientLayer *gradient;
@property(strong,nonatomic) NSArray *gradientColors;
@property(strong,nonatomic) UIView  *sourceView;
@property(assign,nonatomic) UIBlurEffectStyle style;
@property(strong,nonatomic) UIPanGestureRecognizer *panGesture;
@end

@implementation OMBlurPanel

@dynamic colors;
@dynamic allowCloseGesture;

#pragma mark - overwrites

-(instancetype) initWithFrame:(CGRect)frame style:(UIBlurEffectStyle)style{
    if(self = [super initWithFrame:frame]) {
        self.alpha               = 1.0;
        self.contentView         = [[UIView alloc] initWithFrame:frame];
        self.contentView.alpha   = 0.68;
        self.style               = style;
        self.autoresizingMask    = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.cornerRadii         = CGSizeMake(0, 8);
        self.allowCloseGesture   = YES;
    }
    return self;

}

-(void) didMoveToSuperview {
    [super didMoveToSuperview];
    [self setCornerRadius:self.cornerRadii corner:(UIRectCornerTopLeft|UIRectCornerTopRight)];
}


-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (_gradientColors != nil &&  _gradientColors.count > 0) {
        
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
    
}

#pragma mark - Public Properties

-(void) setAllowCloseGesture:(BOOL)allowCloseGesture {
    if (allowCloseGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.panGesture setMinimumNumberOfTouches:1];
        [self.panGesture setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:self.panGesture];
    } else {
        if (self.panGesture) {
            [self removeGestureRecognizer:self.panGesture];
            self.panGesture = nil;
        }
    }
}

-(BOOL) allowCloseGesture {
    return self.panGesture != nil;
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

-(void) closePanel:(UIView*) sourceView targetFrame:(CGRect) targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    NSParameterAssert(!CGRectEqualToRect(targetFrame, CGRectZero));
    if(CGRectEqualToRect(targetFrame, CGRectZero)) return;
    [self closePanel:sourceView targetFrame:targetFrame duration:duration ratio:1.0 block:block];
}

-(void) closePanel:(UIView*) sourceView targetFrame:(CGRect) targetFrame duration:(NSTimeInterval) duration  ratio:(CGFloat) ratio block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    NSParameterAssert(!CGRectEqualToRect(targetFrame, CGRectZero));
    if(CGRectEqualToRect(targetFrame, CGRectZero)) return;
    NSParameterAssert(self.effectView);
    if(self.effectView == nil) return;
    
    if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(willClosePanel:)]) {
            [_delegate willClosePanel:self];
        }
    }
    //
    // Animate the mask (reverse).
    //
    
    CGFloat circleRadius =  (targetFrame.size.height - targetFrame.origin.y)  - sourceView.bounds.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:1.0 reverse:YES duration:duration delegate:nil block:^{
        [self.effectView removeFromSuperview];
        self.effectView  = nil;
        if (block) {
            block();
        }
        if (_delegate != nil) {
            if ([_delegate respondsToSelector:@selector(didClosePanel:)]) {
                [_delegate didClosePanel:self];
            }
        }
    }];
}


-(void) openPanel:(UIView*) sourceView targetFrame:(CGRect)targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    NSParameterAssert(!CGRectEqualToRect(targetFrame, CGRectZero));
    if(CGRectEqualToRect(targetFrame, CGRectZero)) return;
    [self openPanel:sourceView targetFrame:targetFrame duration:duration ratio:1.0 block:block];
}


-(void) openPanel:(UIView*) sourceView targetFrame:(CGRect)targetFrame duration:(NSTimeInterval) duration ratio:(CGFloat) ratio block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    NSParameterAssert(!CGRectEqualToRect(targetFrame, CGRectZero));
    if(CGRectEqualToRect(targetFrame, CGRectZero)) return;

    if (self.allowCloseGesture) {
        self.sourceView = sourceView;
    }
    if (_delegate != nil) {
        if([_delegate respondsToSelector:@selector(willOpenPanel:)]) {
            [_delegate willOpenPanel:self];
        }
    }
    
    //
    // Animate the mask.
    //
    
    self.frame      = targetFrame;
    self.effectView = [self addViewWithBlur:self.contentView style:self.style addConstrainst:YES];
    CGFloat circleRadius = targetFrame.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:CLAMP(ratio, 0.0, 1.0) reverse:NO duration:duration delegate:nil block:^{
        if (block) {
            block();
        }
        if (_delegate != nil) {
            if([_delegate respondsToSelector:@selector(didOpenPanel:)]) {
                [_delegate didOpenPanel:self];
            }
        }
    }];
}

-(void) handlePanGesture:(UIPanGestureRecognizer*)sender {
    if (![self isOpen]) {
        return;
    }
    CGPoint translatedPoint = [sender translationInView:self];
    //CGPoint translatedVelocity = [sender velocityInView:self];
    if ([sender state] == UIGestureRecognizerStateBegan) {
        _originalPanFrame = [self frame];
    } else if([sender state] == UIGestureRecognizerStateChanged) {
        CGFloat newOriginY = _originalPanFrame.origin.y+translatedPoint.y;
        if (newOriginY > 0) {
            _lastChangePanFrame = CGRectMake(_originalPanFrame.origin.x,
                                             newOriginY ,
                                             _originalPanFrame.size.width,
                                             _originalPanFrame.size.height);
            self.effectView.frame = _lastChangePanFrame;
            [UIView animateWithDuration:0.1
                                  delay:0.0
                 usingSpringWithDamping:0.53
                  initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.effectView layoutIfNeeded];
                             } completion:nil];
        }
    } else if([sender state] == UIGestureRecognizerStateEnded ||
              [sender state] == UIGestureRecognizerStateCancelled ||
              [sender state] == UIGestureRecognizerStateFailed) {
        
        CGFloat offset = _lastChangePanFrame.origin.y - _originalPanFrame.origin.y;
        if (offset > 0) {
            CGRect targetFrame = CGRectMake(_originalPanFrame.origin.x,
                                            _lastChangePanFrame.origin.y,
                                            _originalPanFrame.size.width,
                                            _originalPanFrame.size.height);
            self.effectView.frame = _originalPanFrame;
            if (offset > (self.effectView.bounds.size.height * 0.10)) { // 10%
                //
                // Set animation duration commensurate with how far it has to be animated (so the speed is same regardless of distance
                //
                NSTimeInterval  animationDuration = 1 * (1.0  - fabs(offset / self.effectView.bounds.size.height));
                [self closePanel:self.sourceView targetFrame:targetFrame duration:animationDuration block:^{
                    if (_delegate) {
                        if ([_delegate respondsToSelector:@selector(didlClosePanelWithGesture:)]) {
                            [_delegate didlClosePanelWithGesture:self];
                        }
                    }
                }];
            } else {
                self.effectView.frame = _originalPanFrame;
                [UIView animateWithDuration:0.3
                                      delay:0.2
                     usingSpringWithDamping:1.0
                      initialSpringVelocity:1.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.effectView layoutIfNeeded];
                                 } completion:nil];
            }
        }
        _lastChangePanFrame = CGRectZero;
        _originalPanFrame   = CGRectZero;
    }
}

@end
