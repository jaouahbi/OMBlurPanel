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

@interface ViewController ()
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
    
    //add auto layout constraints so that the blur fills the screen upon rotating device
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


-(void) didTouchUpInside:(id)sender
{
    if ([self.panelView isOpen]) {
        [self.panelView close:self.floatingButton targetFrame:self.view.frame block:^{
            self.floatingButton.hidden = NO;
        }];

    }else {
        [self.panelView open:self.floatingButton targetFrame:self.view.frame block:^{
            self.floatingButton.hidden = YES;
        }];
    }

}

-(void) didCloseTouchUpInside:(id)sender
{
    
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
    [appWindow addSubview:_floatingButton];
    _floatingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [appWindow addConstraints:fixedWidthButton];
    [appWindow addConstraints:fixedHeightButton];
    
    //
    // Set the Bottom of the auraButton, and center on X
    //
    
    NSLayoutConstraint * centerXConstraint =  [NSLayoutConstraint constraintWithItem:_floatingButton attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_floatingButton.superview
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
    self.panelView = [[OMBlurPanel alloc] initWithFrame:CGRectZero];
    if (self.panelView != nil) {
        [self.view addSubview:self.panelView];
        
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
        
        [self.panelView setColors:@[(id)color3.CGColor,(id)color2.CGColor,(id)color1.CGColor,(id)color0.CGColor]];
        
        
        self.buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        UIImage* backgroundImage = [UIImage imageNamed:@"closeButton"];
        CGSize closeButtonSize = CGSizeMake(18 * 1.3, 9  * 1.3);
        [self.buttonClose setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        CGRect buttonFrame = CGRectMake(0, 0, closeButtonSize.width, closeButtonSize.height);
        [self.buttonClose setFrame:buttonFrame];
        [self.buttonClose addTarget:self action:@selector(didCloseTouchUpInside:) forControlEvents:UIControlEventTouchUpInside ];
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
        
        
        NSLayoutConstraint * bottonConstrain =  [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.superview
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0
                                                                              constant:15];
    
        [self.panelView.contentView  addConstraint:centerXConstraint];
        [self.panelView.contentView  addConstraint:bottonConstrain];
        
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
