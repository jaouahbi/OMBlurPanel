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


#define COLOR_FROM_RGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ViewController ()<OMBlurPanelDelegate>

@property(strong,nonatomic) UIWebView * webView;
@property(strong,nonatomic) UIButton * floatingButton;
@property(strong,nonatomic) UIButton * buttonClose;
@property(strong,nonatomic) OMBlurPanel *panelView;

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
    
}
-(void)didlClosePanelWithGesture:(OMBlurPanel *)panel {
    self.floatingButton.hidden = NO;
}

- (void)didClosePanel:(OMBlurPanel *)panel {
    
}


- (void)didOpenPanel:(OMBlurPanel *)panel {
    
}


- (void)willClosePanel:(OMBlurPanel *)panel {

}


- (void)willOpenPanel:(OMBlurPanel *)panel {

}

-(void) didTouchUpInside:(id)sender {
    if (![self.panelView isOpen]) {
        [self.panelView openPanel:self.floatingButton parentFrame:self.view.frame duration:2.0 ratio:0.80 block:^{
            self.floatingButton.hidden = YES;
        }];
    }
}
-(void) didCloseTouchUpInside:(id)sender {
    if ([self.panelView isOpen]) {
        [self.panelView closePanel:self.floatingButton parentFrame:self.view.frame duration:1.0 block:^{
            self.floatingButton.hidden = NO;
        }];
    }
}
- (void)animateFloatingButtonButton:(BOOL)willAnimate{
    if (willAnimate) {
        [self.floatingButton setEnabled:NO];
        
        CASpringAnimation* springRotation = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
        springRotation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/];
        springRotation.duration = 2.0f;
        springRotation.cumulative = YES;
        springRotation.repeatCount = INT_MAX;
        springRotation.damping = 8;
        [self.floatingButton.layer addAnimation:springRotation forKey:@"rotationAnimation"];
    }else{
        [self.floatingButton setEnabled:YES];
        [self.floatingButton.layer removeAllAnimations];
    }
}


-(void) setUpFloatingButton {

    //
    // Setup the floating button.
    //
    
    _floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    UIImage* backgroundImage = [UIImage imageNamed:@"floatingButton"];
    CGSize backgroundImageSize = CGSizeMake(65, 65);
    [_floatingButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    CGRect buttonFrame = CGRectMake(0, 0, backgroundImageSize.width, backgroundImageSize.height);
    [_floatingButton setFrame:buttonFrame];
    [_floatingButton addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside ];
    [_floatingButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    UIView * view = _floatingButton;
    NSArray * fixedWidthButton = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[view(==%f)]", backgroundImageSize.width]
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(view)];
    
    NSArray * fixedHeightButton = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[view(==%f)]", backgroundImageSize.height]
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(view)];
    
    
    //DBG_BORDER_COLOR(_containerView.layer, [UIColor redColor]);
    UIWindow * appWindow = [[UIApplication sharedApplication] keyWindow];
    if (appWindow == nil) {
        return ;
    }
    [appWindow addSubview:view];
    [appWindow addConstraints:fixedWidthButton];
    [appWindow addConstraints:fixedHeightButton];
    
    //
    // Set the Bottom of the auraButton, and center on X
    //
    
    NSLayoutConstraint * centerXConstraint =  [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:view.superview
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0];
    
    
    NSLayoutConstraint * bottonConstrain =  [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:view.superview
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:-20];
    
    
    [appWindow addConstraints:@[centerXConstraint, bottonConstrain]];
    
}

-(void) setupPanel {
    
    self.panelView = [[OMBlurPanel alloc] initWithFrame:CGRectZero style:UIBlurEffectStyleDark];
    if (self.panelView != nil) {
        [self.view addSubview:self.panelView];
        _panelView.delegate = self;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panelView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panelView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panelView
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panelView
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1
                                                               constant:0]];
        UIColor * color3 = COLOR_FROM_RGB(0x4AC7F0);
        UIColor * color2 = COLOR_FROM_RGB(0x10AFE3);
        UIColor * color1 = COLOR_FROM_RGB(0x00A7E0);
        UIColor * color0 = COLOR_FROM_RGB(0x008FDB);
        
        //
        // Set the diagonal gradient colors
        //
        
        [self.panelView setColors:@[(id)color3.CGColor,
                                    (id)color2.CGColor,
                                    (id)color1.CGColor,
                                    (id)color0.CGColor]];
        
        CGSize closeButtonSize    = CGSizeMake(24, 12);
        UIImage * backgroundImage = [UIImage imageNamed:@"closeButton"];
        //self.buttonClose.contentEdgeInsets = UIEdgeInsetsMake(12, 16, 12, 16);
        self.buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonClose setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        CGRect buttonFrame = CGRectMake(0, 0, closeButtonSize.width, closeButtonSize.height);
        [self.buttonClose setFrame:buttonFrame];
        [self.buttonClose addTarget:self action:@selector(didCloseTouchUpInside:) forControlEvents:UIControlEventTouchUpInside ];
        
        [self.buttonClose setTranslatesAutoresizingMaskIntoConstraints:NO];
        UIView * view = self.buttonClose;
        NSArray * fixedWidthButton = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[view(==%f)]", self.buttonClose.bounds.size.width]
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(view)];
        
        NSArray * fixedHeightButton = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[view(==%f)]", self.buttonClose.bounds.size.height]
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(view)];
        [self.panelView.contentView addSubview:view];
        [self.panelView.contentView addConstraints:fixedWidthButton];
        [self.panelView.contentView addConstraints:fixedHeightButton];
        
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
        
        [self.panelView.contentView  addConstraint:centerXConstraint];
        [self.panelView.contentView  addConstraint:topConstrain];
        
        [self.panelView.contentView layoutSubviews];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpFloatingButton];
    [self setupPanel];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
