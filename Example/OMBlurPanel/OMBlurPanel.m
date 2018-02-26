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
{
    CGRect _originalPanFrame;
    CGRect _lastChangePanFrame;
    
}
@property(strong,nonatomic) CAGradientLayer *gradient;
@property(strong,nonatomic) NSArray *gradientColors;
@property(strong,nonatomic) UIView * sourceView;
@property(assign,nonatomic) UIBlurEffectStyle style;
@property(strong,nonatomic) UIPanGestureRecognizer *panGesture;
@property(strong,nonatomic) UIButton * buttonClose;
@end

@implementation OMBlurPanel

@dynamic colors;

-(instancetype) initWithFrame:(CGRect)frame style:(UIBlurEffectStyle)style{
    if(self = [super initWithFrame:frame]) {
        self.alpha               = 1.0;
        self.contentView         = [[UIView alloc] initWithFrame:frame];
        self.contentView.alpha   = 0.68;
        self.style               = style;
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.panGesture setMinimumNumberOfTouches:1];
        [self.panGesture setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:self.panGesture];
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

-(void) closePanel:(UIView*) sourceView targetFrame:(CGRect) targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    NSParameterAssert(!CGRectEqualToRect(targetFrame, CGRectZero));
    if(CGRectEqualToRect(targetFrame, CGRectZero)) return;
    NSParameterAssert(self.effectView);
    if(self.effectView == nil) return;
    
    if (_delegate != nil) {
        if([_delegate respondsToSelector:@selector(willClosePanel:)])
            [_delegate willClosePanel:self];
    }
    //
    // Morphing the UIView (reverse).
    //
    
    CGFloat circleRadius =  (targetFrame.size.height - targetFrame.origin.y)  - sourceView.bounds.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:1.0 reverse:YES duration:duration delegate:nil block:^{
        [self.effectView removeFromSuperview];
        self.effectView  = nil;
        if (block) {
            block();
        }
        if (_delegate != nil) {
            if([_delegate respondsToSelector:@selector(didClosePanel:)])
                [_delegate didClosePanel:self];
        }
    }];
}

-(void) openPanel:(UIView*) sourceView targetFrame:(CGRect)targetFrame duration:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    self.sourceView = sourceView;
    NSParameterAssert(!CGRectEqualToRect(targetFrame, CGRectZero));
    if(CGRectEqualToRect(targetFrame, CGRectZero)) return;
    
    if (_delegate != nil) {
        if([_delegate respondsToSelector:@selector(willOpenPanel:)])
            [_delegate willOpenPanel:self];
    }
    
    //
    // Morphing the UIView.
    //
    
    self.frame      = targetFrame;
    self.effectView = [self addViewWithBlur:self.contentView style:self.style addConstrainst:YES];
    CGFloat circleRadius = targetFrame.size.height;
    [self.effectView animateMaskWithView:sourceView circleRadius:circleRadius ratio:1.0 reverse:NO duration:duration delegate:nil block:^{
        if (block) {
            block();
        }
        if (_delegate != nil) {
            if([_delegate respondsToSelector:@selector(didOpenPanel:)])
                [_delegate didOpenPanel:self];
        }
    }];
}


-(void)handlePanGesture:(UIPanGestureRecognizer*)sender {
    
    if (![self isOpen]) {
        return;
    }
    CGPoint translatedPoint = [sender translationInView:self];
    
    if([sender state] == UIGestureRecognizerStateBegan) {
        _originalPanFrame = [self frame];
    }else if([sender state] == UIGestureRecognizerStateChanged) {
        _lastChangePanFrame = CGRectMake(_originalPanFrame.origin.x,
                                         _originalPanFrame.origin.y+translatedPoint.y,
                                         _originalPanFrame.size.width,
                                         _originalPanFrame.size.height);
        self.effectView.frame = _lastChangePanFrame;
        [UIView animateWithDuration:0.1 animations:^{
            [self.effectView layoutIfNeeded ];
        } completion:^(BOOL finished) {
        }];
    }else if([sender state] == UIGestureRecognizerStateEnded ||
       [sender state] == UIGestureRecognizerStateCancelled) {
        CGRect targetFrame = CGRectMake(_originalPanFrame.origin.x,
                                        _lastChangePanFrame.origin.y,
                                        _originalPanFrame.size.width,
                                        _originalPanFrame.size.height);
        self.effectView.frame = _originalPanFrame;
        CGFloat offset = (_lastChangePanFrame.origin.y - _originalPanFrame.origin.y);
        NSTimeInterval  animationDuration = 1 * (1.0  - fabs(offset / self.effectView.bounds.size.height)); // set animation duration commensurate with how far it has to be animated (so the speed is same regardless of distance
        [self closePanel:self.sourceView targetFrame:targetFrame duration:animationDuration block:^{
            if(_delegate) {
                if([_delegate respondsToSelector:@selector(didlClosePanelWithGesture:)])
                    [_delegate didlClosePanelWithGesture:self];
            }
        }];
    }
}

-(void)addCloseButton:(UIImage*) backgroundImage closeButtonSize:(CGSize) closeButtonSize action:(SEL)action {
    self.buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonClose setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    CGRect buttonFrame = CGRectMake(0, 0, closeButtonSize.width, closeButtonSize.height);
    [self.buttonClose setFrame:buttonFrame];
    [self.buttonClose addTarget:self action:action forControlEvents:UIControlEventTouchUpInside ];
    [self.buttonClose setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    UIView * view = self.buttonClose;
    NSArray * fixedWidthButton = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[view(==%f)]", closeButtonSize.width]
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(view)];
    
    NSArray * fixedHeightButton = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[view(==%f)]", closeButtonSize.height]
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(view)];
    
    [self.contentView addSubview:view];
    
    
    [self.contentView addConstraints:fixedWidthButton];
    [self.contentView addConstraints:fixedHeightButton];
    
    //DBG_BORDER_COLOR(_buttonAURAClose.layer, [UIColor redColor]);
    
    NSLayoutConstraint * centerXConstraint =  [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:view.superview
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0];
    
    
    NSLayoutConstraint * topConstrain =  [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:view.superview
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:15];
    
    [self.contentView  addConstraint:centerXConstraint];
    [self.contentView  addConstraint:topConstrain];
    
    [self.contentView layoutSubviews];
}

@end
