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

@interface OMBlurPanel()<UIGestureRecognizerDelegate>
@property(strong,nonatomic) CAGradientLayer *gradient;
@property(strong,nonatomic) NSArray *gradientColors;
@property(strong,nonatomic) UIView  *sourceView;
@property(assign,nonatomic) UIBlurEffectStyle style;
@property(strong,nonatomic) UIPanGestureRecognizer *panGesture;
@property(assign,nonatomic) CGFloat ratio;
@property(assign,nonatomic) NSTimeInterval  animationDurationPan;
@property(assign,nonatomic) CGRect originalPanFrame;
@property(assign,nonatomic) CGRect lastChangePanFrame;
@property(strong,nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation OMBlurPanel

@dynamic colors;
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
    self.contentView.alpha   = 0.68;
    self.style               = style;
    self.autoresizingMask    = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.cornerRadii         = CGSizeMake(0, 8);
    self.allowCloseGesture   = YES;
    self.ratio               =  0;
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
        [self.tapRecognizer.view removeGestureRecognizer:self.tapRecognizer];
        [super willMoveToSuperview:newSuperview];
    }
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
        self.gradient.frame      = self.bounds;
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
                    [self closePanel:self.sourceView duration:self.animationDurationPan ratio:self.ratio  block:^{
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

-(CGRect) rectFromRatio:(CGRect) frame ratio:(CGFloat) ratio {
    CGFloat newHeight = frame.size.height * CLAMP(ratio, 0.0, 1.0);
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - newHeight , frame.size.width, newHeight);
    return rect;
}

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


-(void) closePanel:(UIView*) sourceView duration:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    [self closePanel:sourceView duration:duration ratio:self.ratio block:block];
}

-(void) closePanel:(UIView*) sourceView duration:(NSTimeInterval) duration  ratio:(CGFloat) ratio  block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
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
    
    CGFloat maxRadius =  ((self.superview.frame.size.height - self.superview.frame.origin.y)  - sourceView.bounds.size.height) * ratio;
    CGFloat minRadius = sourceView.bounds.size.height * 0.5;
 
  
    CGPoint sourceCenter =CGPointMake(sourceView.frame.origin.x+sourceView.frame.size.width*0.5,sourceView.frame.origin.y-sourceView.frame.size.height*0.5);
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


-(void) openPanel:(UIView*) sourceView  duration:(NSTimeInterval) duration block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
   [self openPanel:sourceView duration:duration ratio:1.0 block:block];
}


-(void) openPanel:(UIView*) sourceView duration:(NSTimeInterval) duration ratio:(CGFloat) ratio block:(void (^)(void))block {
    NSParameterAssert(sourceView);
    if(sourceView == nil) return;
    
    self.ratio                = CLAMP(ratio, 0.0, 1.0);
    self.animationDurationPan = duration;
    if (self.allowCloseGesture) {
        self.sourceView = sourceView;
    }
    
    if (_delegate != nil) {
        if([_delegate respondsToSelector:@selector(willOpenPanel:)]) {
            [_delegate willOpenPanel:self];
        }
    }
    
    //
    // Create the blur view
    //
    self.effectView = [self addViewWithBlur:self.contentView style:self.style addConstrainst:YES];
    [self layoutIfNeeded];
    //
    // Calculate the target frame;
    //
    self.frame        = [self rectFromRatio:self.superview.frame ratio:self.ratio];
    CGFloat maxRadius = self.superview.frame.size.height * self.ratio;
    CGFloat minRadius = sourceView.bounds.size.height * 0.5;
    
    
    //
    // Animate the mask.
    //
    CGPoint sourceCenter =CGPointMake(sourceView.frame.origin.x+sourceView.frame.size.width*0.5,sourceView.frame.origin.y-sourceView.frame.size.height*0.5);
    
    [self animateMaskWithCenter: sourceCenter
                            maxRadius:maxRadius
                               minRadius:minRadius
                                   ratio:self.ratio
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

-(void) handlePanGesture:(UIPanGestureRecognizer*)sender {
    if (![self isOpen]) {
        return;
    }
    CGPoint translatedPoint = [sender translationInView:self];
    CGPoint translatedVelocity = [sender velocityInView:self];
    if ([sender state] == UIGestureRecognizerStateBegan) {
        _originalPanFrame = [self.effectView frame];
    } else if([sender state] == UIGestureRecognizerStateChanged) {
        CGFloat newOriginY = _originalPanFrame.origin.y+translatedPoint.y;
        if (newOriginY > 0 && translatedVelocity.y > 0) {
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
        if (offset > 0 && translatedVelocity.y > 0) {
            CGRect targetFrame = CGRectMake(_originalPanFrame.origin.x,
                                            _lastChangePanFrame.origin.y,
                                            _originalPanFrame.size.width,
                                            _originalPanFrame.size.height);
             self.effectView.frame = targetFrame;
            [UIView animateWithDuration:0.1
                                  delay:0.0
                 usingSpringWithDamping:0.53
                  initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.effectView layoutIfNeeded];
                             } completion:nil];
            if (offset > (self.effectView.bounds.size.height * self.minimunPanFactor)) { // 5%
                //
                // Set animation duration commensurate with how far it has to be animated (so the speed is same regardless of distance
                //
                NSTimeInterval  animationDuration = 1 * (1.0  - fabs(offset / self.effectView.bounds.size.height));
                [self closePanel:self.sourceView  duration:animationDuration block:^{
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
        _lastChangePanFrame = CGRectZero;
        _originalPanFrame   = CGRectZero;
    }
}
@end
