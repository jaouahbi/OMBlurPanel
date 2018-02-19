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


@interface ViewController ()
@property(strong,nonatomic) UIWebView * webView;
@property(strong,nonatomic) UIButton *  floatingButton;
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

-(void) setUpFloatingButton {
    
    
    //
    // Setup the AURA button.
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
        
        
        [self.view layoutIfNeeded];
        
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
