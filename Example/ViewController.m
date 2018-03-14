
//
//  OMBlurPanel.m
//  OMBlurPanel
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "ViewController.h"
#include "OMBlurPanel.h"
#include "UIView+AnimationCircleWithMask.h"


#define TOP 0
#define BOTTOM 1

#define COLOR_FROM_RGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ViewController ()<OMBlurPanelDelegate>

@property(strong,nonatomic) UIWebView * webView;
@property(strong,nonatomic) NSMutableArray<UIButton *> * floatingButtons;
@property(strong,nonatomic) NSMutableArray<UIButton *>  * closeButtons;
@property(strong,nonatomic) NSMutableArray<OMBlurPanel *> * panelViews;
@property(strong,nonatomic) NSMutableArray<CAGradientLayer *> *gradient;


@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlAddress = @"http://www.apple.com";
    _webView=[[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_webView];
    
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_webView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_webView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_webView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_webView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:requestObj];
    
    
    self.gradient = [NSMutableArray array];
    
    
    self.floatingButtons= [NSMutableArray array];;
    self.closeButtons= [NSMutableArray array];;
    self.panelViews= [NSMutableArray array];;
    
    
    UIColor * color1 = COLOR_FROM_RGB(0x20002c);
    UIColor * color2 = COLOR_FROM_RGB(0xcbb4d4);
    NSArray *colors = @[(id)color1.CGColor,(id)color2.CGColor];
    
    
    
    [self.gradient addObject:[CAGradientLayer layer]];
    [self.gradient addObject:[CAGradientLayer layer]];
    self.gradient[TOP].startPoint = CGPointMake(1, 0);
    self.gradient[TOP].endPoint   = CGPointMake(0, 1);
    self.gradient[TOP].colors = colors;;
    
    
    
    UIColor * color21 = COLOR_FROM_RGB(0x1a2a6c);
    UIColor * color22 = COLOR_FROM_RGB(0xb21f1f);
    UIColor * color23 = COLOR_FROM_RGB(0xfdbb2d);
    NSArray *colors2 = @[(id)color21.CGColor,(id)color22.CGColor,(id)color23.CGColor];
    
    self.gradient[BOTTOM].startPoint = CGPointMake(1, 0);
    self.gradient[BOTTOM].endPoint   = CGPointMake(0, 1);
    self.gradient[BOTTOM].colors = colors2;
    
}
-(void)didlClosePanelWithGesture:(OMBlurPanel *)panel {
    if(self.panelViews[TOP] == panel)
        self.floatingButtons[TOP].hidden = NO;
    else
        self.floatingButtons[BOTTOM].hidden = NO;
}

- (void)didClosePanel:(OMBlurPanel *)panel {
    if(self.panelViews[TOP] == panel)
        self.floatingButtons[TOP].hidden = NO;
    else
        self.floatingButtons[BOTTOM].hidden = NO;
}


- (void)didOpenPanel:(OMBlurPanel *)panel {
    
}


- (void)willClosePanel:(OMBlurPanel *)panel {
    
}


- (void)willOpenPanel:(OMBlurPanel *)panel {
    
    if(self.panelViews[TOP] == panel)
        self.floatingButtons[TOP].hidden = YES;
    else
        self.floatingButtons[BOTTOM].hidden = YES;
}

-(void) didTouchUpInsideTop:(id)sender {
    if (![self.panelViews[TOP] isOpen]) {
        [self.panelViews[TOP] openPanel:self.floatingButtons[TOP] duration:2.0 ratio:0.5 block:nil];
    }
}

-(void) didTouchUpInsideBottom:(id)sender {
    if (![self.panelViews[BOTTOM] isOpen]) {
        [self.panelViews[BOTTOM] openPanel:self.floatingButtons[BOTTOM] duration:2.0 ratio:0.5 block:nil];
    }
}

-(void) didTouchUpInsideCloseTop:(id)sender {
    if ([self.panelViews[TOP] isOpen]) {
        [self.panelViews[TOP] closePanel:2.0 block:^{
            
        }];
    }
}

-(void) didTouchUpInsideCloseBottom:(id)sender {
    if ([self.panelViews[BOTTOM] isOpen]) {
        [self.panelViews[BOTTOM] closePanel:2.0 block:^{
            
        }];
    }
}

- (void)animateFloatingButtonButton:(BOOL)willAnimate{
    if (willAnimate) {
        [self.floatingButtons[0] setEnabled:NO];
        
        CASpringAnimation* springRotation = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
        springRotation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/];
        springRotation.duration = 2.0f;
        springRotation.cumulative = YES;
        springRotation.repeatCount = INT_MAX;
        springRotation.damping = 8;
        [self.floatingButtons[0].layer addAnimation:springRotation forKey:@"rotationAnimation"];
    }else{
        [self.floatingButtons[0] setEnabled:YES];
        [self.floatingButtons[0].layer removeAllAnimations];
    }
}


-(UIButton*) addFloatingButton:(SEL) selector addToTop:(BOOL) addToTop{
    
    //
    // Setup the floating button.
    //
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGSize buttonSize = CGSizeMake(65, 65);
    CGRect buttonFrame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    [button setFrame:buttonFrame];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside ];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.layer.cornerRadius = buttonSize.height*0.5;
    button.layer.masksToBounds = YES;
    
    
    
    
    
    //DBG_BORDER_COLOR(_containerView.layer, [UIColor redColor]);
    UIWindow * appWindow = [[UIApplication sharedApplication] keyWindow];
    if (appWindow == nil) {
        return nil ;
    }
    [appWindow addSubview:button];
    
    [button.superview addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:button.bounds.size.height]];
    
    [button.superview addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:button.bounds.size.width]];
    
    //
    // Set the Bottom of the button, and center on X
    //
    
    NSLayoutConstraint * centerXConstraint =  [NSLayoutConstraint constraintWithItem:button
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:button.superview
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0];
    
    
    NSLayoutConstraint * bottonTopConstrain =  [NSLayoutConstraint constraintWithItem:button
                                                                            attribute:(addToTop)?NSLayoutAttributeTop:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:button.superview
                                                                            attribute:(addToTop)?NSLayoutAttributeTop:NSLayoutAttributeBottom
                                                                           multiplier:1.0
                                                                             constant:(addToTop)?20:-20];
    
    
    [appWindow addConstraints:@[centerXConstraint,bottonTopConstrain]];
    
    
    return button;
}

-(void) setupPanel:(NSInteger) panelIndex selector:(SEL) selector {
    
    [self.panelViews addObject: [[OMBlurPanel alloc] initWithFrame:CGRectZero style:UIBlurEffectStyleDark]];
    if (self.panelViews[panelIndex] != nil) {
        [self.view addSubview:self.panelViews[panelIndex]];
        self.panelViews[panelIndex].delegate = self;
        [self.panelViews[panelIndex].contentView.layer insertSublayer:self.gradient[panelIndex] atIndex:0];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panelViews[panelIndex]
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panelViews[panelIndex]
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panelViews[panelIndex]
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panelViews[panelIndex]
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1
                                                               constant:0]];
        
        
        CGSize closeButtonSize    = CGSizeMake(24, 12);
        UIImage * backgroundImage = [UIImage imageNamed:@"closeButton"];
        
        if (panelIndex == TOP) {
            backgroundImage = [UIImage imageWithCGImage:backgroundImage.CGImage
                                                  scale:backgroundImage.scale
                                            orientation:UIImageOrientationDown];
        }
        
        [self.closeButtons addObject:[UIButton buttonWithType:UIButtonTypeCustom]];
        [self.closeButtons[panelIndex] setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        
        CGRect buttonFrame = CGRectMake(0, 0, closeButtonSize.width, closeButtonSize.height);
        [self.closeButtons[panelIndex] setFrame:buttonFrame];
        [self.closeButtons[panelIndex] addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside ];
        [self.closeButtons[panelIndex] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.panelViews[panelIndex].contentView addSubview:self.closeButtons[panelIndex]];
        
        
        [self.closeButtons[panelIndex].superview addConstraint:[NSLayoutConstraint constraintWithItem:self.closeButtons[panelIndex]
                                                                                            attribute:NSLayoutAttributeHeight
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:nil
                                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                                           multiplier:1
                                                                                             constant:self.closeButtons[panelIndex].bounds.size.height]];
        
        [self.closeButtons[panelIndex].superview addConstraint:[NSLayoutConstraint constraintWithItem:self.closeButtons[panelIndex]
                                                                                            attribute:NSLayoutAttributeWidth
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:nil
                                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                                           multiplier:1
                                                                                             constant:self.closeButtons[panelIndex].bounds.size.width]];
        
        //DBG_BORDER_COLOR(_buttonAURAClose.layer, [UIColor redColor]);
        
        NSLayoutConstraint * centerXConstraint =  [NSLayoutConstraint constraintWithItem:self.closeButtons[panelIndex]
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.closeButtons[panelIndex].superview
                                                                               attribute:NSLayoutAttributeCenterX
                                                                              multiplier:1.0
                                                                                constant:0];
        if (panelIndex == TOP) {
            NSLayoutConstraint * bottomConstrain =  [NSLayoutConstraint constraintWithItem:self.closeButtons[panelIndex]
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.closeButtons[panelIndex].superview
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                multiplier:1.0
                                                                                  constant:-15];
            [self.panelViews[panelIndex].contentView  addConstraint:bottomConstrain];
        } else {
            
            NSLayoutConstraint * topConstrain =  [NSLayoutConstraint constraintWithItem:self.closeButtons[panelIndex]
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.closeButtons[panelIndex].superview
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:15];
            [self.panelViews[panelIndex].contentView  addConstraint:topConstrain];
        }
        
        
        [self.panelViews[panelIndex].contentView  addConstraint:centerXConstraint];
        
        
        [self.panelViews[panelIndex].contentView layoutSubviews];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIImage *image =  nil;
    
    [self.floatingButtons addObject:[self addFloatingButton:@selector(didTouchUpInsideTop:) addToTop:YES]];
    [self.floatingButtons[TOP] layoutIfNeeded];
    self.gradient[TOP].frame      = self.floatingButtons[TOP].bounds;
    UIGraphicsBeginImageContext(self.floatingButtons[TOP].bounds.size);
    [self.gradient[TOP] renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.floatingButtons[TOP] setBackgroundImage:image forState:UIControlStateNormal];
    
    [self.floatingButtons addObject:[self addFloatingButton:@selector(didTouchUpInsideBottom:) addToTop:NO]];
    [self.floatingButtons[BOTTOM] layoutIfNeeded];
    self.gradient[BOTTOM].frame      = self.floatingButtons[BOTTOM].bounds;
    UIGraphicsBeginImageContext(self.floatingButtons[BOTTOM].bounds.size);
    [self.gradient[BOTTOM] renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.floatingButtons[BOTTOM] setBackgroundImage:image forState:UIControlStateNormal];
    
    [self setupPanel:TOP selector:@selector(didTouchUpInsideCloseTop:)];
    [self setupPanel:BOTTOM selector:@selector(didTouchUpInsideCloseBottom:)];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(self.gradient && self.gradient.count == 2 && self.panelViews && self.panelViews.count == 2){
        self.gradient[TOP].frame   = self.panelViews[TOP].bounds;
        self.gradient[BOTTOM].frame   = self.panelViews[BOTTOM].bounds;
    }
}

@end
