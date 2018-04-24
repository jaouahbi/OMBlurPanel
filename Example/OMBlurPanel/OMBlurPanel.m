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
#import "UIVisualEffectView+Intensity.h"

#ifndef CLAMP
#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))
#endif

@interface OMBlurPanel()<UIGestureRecognizerDelegate>

@property(strong,nonatomic) UIView  *sourceView;
@property(assign,nonatomic) UIBlurEffectStyle style;
@property(strong,nonatomic) UIPanGestureRecognizer *panGesture;
@property(assign,nonatomic) CGFloat currentRatio;
@property(assign,nonatomic) NSTimeInterval  animationDurationPan;
@property(assign,nonatomic) CGRect originalPanFrame;
@property(assign,nonatomic) CGRect lastChangePanFrame;
@property(strong,nonatomic) UITapGestureRecognizer *tapRecognizer;
@property(assign,nonatomic) BOOL openFromTop;
@end

@implementation OMBlurPanel

@dynamic allowCloseGesture;

#pragma mark - Overrides

-(instancetype) initWithFrame:(CGRect)frame style:(UIBlurEffectStyle)style{
    if(self = [super initWithFrame:frame]) {
        [self defaultInitWithStyle:UIBlurEffectStyleDark];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:UIBlurEffectStyleDark];
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self defaultInitWithStyle:UIBlurEffectStyleDark];
    }
    return self;
}


-(void) defaultInitWithStyle:(UIBlurEffectStyle)style {
    self.alpha               = 1.0;
    self.contentView         = [[UIView alloc] initWithFrame:self.frame];
    self.contentView.alpha   = 1;
    self.style               = style;
    self.autoresizingMask    = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.cornerRadii         = CGSizeMake(0, 8);
    self.openFromTop         =NO;
    self.allowCloseGesture   = YES;
    self.currentRatio        = 0;
    self.originalPanFrame    = CGRectZero;
    self.lastChangePanFrame  = CGRectZero;
    self.minimunPanFactor    = 0.1;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [super willMoveToSuperview:newSuperview];
        //
        // Setup the gesture recognize
        //
        self.tapRecognizer                       = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerMethod:)];
        self.tapRecognizer.delegate              = self;
        self.tapRecognizer.numberOfTapsRequired  = 1;
        // https://stackoverflow.com/a/9248827/6387073
        self.tapRecognizer.cancelsTouchesInView  = NO;
        //
        // Add to the main view.
        //
        [newSuperview addGestureRecognizer:self.tapRecognizer];
    } else {
        [self removeGestureRecognizer:self.tapRecognizer];
        [super willMoveToSuperview:newSuperview];
    }
}

-(void) didMoveToSuperview {
    [super didMoveToSuperview];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setCornerRadius:self.cornerRadii
                   corner:self.openFromTop?(UIRectCornerBottomLeft |UIRectCornerBottomRight):(UIRectCornerTopLeft|UIRectCornerTopRight)];
}

#pragma mask - UITapGestureRecognizer method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view != self;
}

/**!
 * @brief Tap recognizer
 *
 * @param gestureRecognizer UITapGestureRecognizer*.
 */

- (void)tapRecognizerMethod:(UITapGestureRecognizer *)gestureRecognizer {
    UIView *tappedView = nil;
    if (self.tapRecognizer == gestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            tappedView = [gestureRecognizer.view hitTest:[gestureRecognizer locationInView:gestureRecognizer.view] withEvent:nil];
            if (tappedView != nil) {
                BOOL isChild = [self viewIsChildViewOfClassView:tappedView viewClass:[self class]];
                if (!isChild && [self isOpen]) {
                    [self closePanel:self.animationDurationPan ratio:self.currentRatio  block:^{
                        if (_delegate) {
                            if ([_delegate respondsToSelector:@selector(didlClosePanelWithGesture:)]) {
                                [_delegate didlClosePanelWithGesture:self];
                            }
                        }
                    }];
                }
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mask - Helpers


-(BOOL) viewIsChildViewOfClassView:(UIView*) view  viewClass:(Class) viewClass {
    if ([view isKindOfClass:viewClass]) {
        return YES;
    }
    UIView * superview = view.superview;
    while (superview != nil) {
        if([superview isKindOfClass:viewClass]) return YES;
        superview = superview.superview;
    }
    
    return NO;
    
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

-(BOOL) isOpen {
    return (self.effectView != nil);
}

-(void) closePanel:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(_sourceView);
    if(_sourceView == nil) return;
    [self closePanel:duration ratio:self.currentRatio block:block];
}

-(void) closePanel:(NSTimeInterval) duration  ratio:(CGFloat) ratio  block:(void (^)(void))block {
    NSParameterAssert(self.sourceView);
    if(self.sourceView == nil) return;
    NSParameterAssert(self.effectView);
    if (self.effectView == nil) return;
    
    if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(willClosePanel:)]) {
            [_delegate willClosePanel:self];
        }
    }
    //
    // Animate the mask (reverse).
    //
    [self.sourceView layoutIfNeeded];
    const CGFloat maxRadius    = ((self.superview.frame.size.height - self.superview.frame.origin.y) - _sourceView.bounds.size.height) * ratio;
    const CGFloat minRadius    = self.sourceView.bounds.size.height * 0.5;
    const CGPoint sourceCenter = CGPointMake(self.sourceView.frame.origin.x+self.sourceView.bounds.size.width*0.5,
                                             self.sourceView.frame.origin.y+self.sourceView.bounds.size.height*0.5);
    
    [self.effectView fadeInEffect:self.style withDuration:duration];
     const CGPoint sourceCenter2 = [self.sourceView.superview convertPoint:sourceCenter toView:self];
    [self animateMaskWithCenter:sourceCenter
                      maxRadius:maxRadius
                      minRadius:minRadius
                          ratio:ratio
                        reverse:YES
                       duration:duration
                       delegate:nil block:^{
                           self.frame = CGRectZero;
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


-(void) openPanel:(UIView*) sourceView duration:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    [self openPanel:sourceView duration:duration ratio:1.0 block:block];
}


-(void) openPanel:(UIView*) sourceView duration:(NSTimeInterval) duration ratio:(CGFloat) ratio block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    
    self.currentRatio         = CLAMP(ratio, 0.0, 1.0);
    self.animationDurationPan = duration;
    self.sourceView           = sourceView;
    self.openFromTop          = sourceView.frame.origin.y < self.superview.frame.size.height*0.5;
    
    if (_delegate != nil) {
        if([_delegate respondsToSelector:@selector(willOpenPanel:)]) {
            [_delegate willOpenPanel:self];
        }
    }
    
    self.effectView = [self addViewWithBlur:self.contentView style:self.style addConstrainst:YES];
    [self layoutIfNeeded];
    
    
    [self.sourceView layoutIfNeeded];
    const CGRect superviewFrame = self.superview.frame;
    const CGFloat maxRadius     = superviewFrame.size.height * self.currentRatio;
    const CGFloat minRadius     = sourceView.bounds.size.height * 0.5;
    const CGPoint sourceCenter  = CGPointMake(sourceView.frame.origin.x+sourceView.bounds.size.width*0.5,
                                              sourceView.frame.origin.y+sourceView.bounds.size.height*0.5);
    if (self.openFromTop) {
        const CGFloat newHeight =  superviewFrame.origin.y + superviewFrame.size.height * self.currentRatio;
        self.frame  = CGRectMake(superviewFrame.origin.x, superviewFrame.origin.y , superviewFrame.size.width, newHeight);
    } else {
        const CGFloat newHeight = superviewFrame.size.height * self.currentRatio;
        self.frame  = CGRectMake(superviewFrame.origin.x, superviewFrame.origin.y + superviewFrame.size.height - newHeight , superviewFrame.size.width, newHeight);;
    }
    
    [self.effectView fadeInEffect:self.style withDuration:duration];
    [self animateMaskWithCenter: sourceCenter
                      maxRadius:maxRadius
                      minRadius:minRadius
                          ratio:self.currentRatio
                        reverse:NO
                       duration:duration
                       delegate:nil
                          block:^{
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

-(void) handlePanGesture:(UIPanGestureRecognizer*)gestureRecognizer {
    if (![self isOpen]) {
        return;
    }
    const CGPoint translatedPoint    = [gestureRecognizer translationInView:self];
    const CGPoint translatedVelocity = [gestureRecognizer velocityInView:self];
    switch ([gestureRecognizer state]){
        case UIGestureRecognizerStateBegan: {
            _originalPanFrame = [self.effectView frame];
            break;
        }
        case  UIGestureRecognizerStateChanged: {
            const CGFloat newOriginY = _originalPanFrame.origin.y+translatedPoint.y;
            CGFloat intensity = 1.0 - (1.0/_originalPanFrame.size.height) * fabs(newOriginY);
            [self.effectView setEffectWithIntensity:self.effectView.effect
                                          intensity:intensity
                                           duration:1.0];
            if (newOriginY > 0 && translatedVelocity.y > 0 && !self.openFromTop) {
                _lastChangePanFrame = CGRectMake(_originalPanFrame.origin.x,
                                                 newOriginY ,
                                                 _originalPanFrame.size.width,
                                                 _originalPanFrame.size.height);

            } else {
                _lastChangePanFrame = CGRectMake(_originalPanFrame.origin.x,
                                                 _originalPanFrame.origin.y,
                                                 _originalPanFrame.size.width,
                                                 _originalPanFrame.size.height + newOriginY);
            }
            
            self.effectView.frame = _lastChangePanFrame;
            [UIView animateWithDuration:0.5f
                                  delay:0
                 usingSpringWithDamping:0.4f
                  initialSpringVelocity:0.5
                                options:0
                             animations:^{
                                 [self.effectView layoutIfNeeded];
                             } completion:nil];
            
            
            break;
        }
        case  UIGestureRecognizerStateEnded:
        case  UIGestureRecognizerStateCancelled:
        case  UIGestureRecognizerStateFailed:
        {
            CGRect targetFrame = CGRectZero;
            CGFloat panOffset = 0;
            if (!self.openFromTop) {
                panOffset = (_lastChangePanFrame.origin.y - _originalPanFrame.origin.y);
                targetFrame = CGRectMake(_originalPanFrame.origin.x,
                                         _lastChangePanFrame.origin.y,
                                         _originalPanFrame.size.width,
                                         _originalPanFrame.size.height);
            }
            else
            {
                panOffset = (_originalPanFrame.size.height  - _lastChangePanFrame.size.height);
                targetFrame = CGRectMake(_originalPanFrame.origin.x,
                                         _originalPanFrame.origin.y,
                                         _originalPanFrame.size.width,
                                         _lastChangePanFrame.size.height);
            }
            
            if (panOffset > 0){
                self.effectView.frame = targetFrame;
//                [UIView animateWithDuration:0.5f
//                                      delay:0
//                     usingSpringWithDamping:0.25f
//                      initialSpringVelocity:0.5
//                                    options:0
//                                 animations:^{
//                                     [self.effectView layoutIfNeeded];
//                                 } completion:nil];
                [UIView animateWithDuration:0.7
                                      delay:0
                     usingSpringWithDamping:0.6f
                      initialSpringVelocity:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [self.effectView layoutIfNeeded];
                                 } completion:nil];
                if (panOffset > (self.effectView.bounds.size.height * self.minimunPanFactor)) { // %
                    //
                    // Set animation duration commensurate with how far it has to be animated (so the speed is same regardless of distance
                    //
                    const NSTimeInterval  animationDuration = 1.0 * (1.0  - fabs(panOffset / self.effectView.bounds.size.height));
                    [self closePanel:animationDuration block:^{
                        if (_delegate) {
                            if ([_delegate respondsToSelector:@selector(didlClosePanelWithGesture:)]) {
                                [_delegate didlClosePanelWithGesture:self];
                            }
                        }
                    }];
                } else {
                    self.effectView.frame = _originalPanFrame;
                    [UIView animateWithDuration:0.5
                                          delay:0
                         usingSpringWithDamping:0.25
                          initialSpringVelocity:0
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         [self.effectView layoutIfNeeded];
                                     } completion:nil];
                }
            }
            
            _lastChangePanFrame = CGRectZero;
            _originalPanFrame   = CGRectZero;
        }
        case UIGestureRecognizerStatePossible:
            break;
        default:
            break;
    }
}
@end
