//
//  ViewController.m
//  blur
//
//  Created by io on 17/2/18.
//  Copyright © 2018 io. All rights reserved.
//

#import "ViewController.h"
#include "UIView+Blur.h"
@interface ViewController ()
{
    UIWebView *_webView;
}
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _webView.frame= self.view.bounds;
    
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectZero];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = panelView.bounds;
    UIColor *topColor = [UIColor colorWithRed:0.5 green:0.22 blue:0.36 alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:0.38 green:0.18 blue:0.38 alpha:1];

    gradient.colors = @[(id)topColor.CGColor, (id)bottomColor.CGColor];
    [panelView.layer insertSublayer:gradient atIndex:0];
    
    panelView.alpha = 1.0;
    panelView.layer.masksToBounds = YES;
    panelView.layer.cornerRadius = 6;
    UIVisualEffectView * eff = [self.view addViewWithBlur:panelView style:UIBlurEffectStyleDark addConstrainst:YES];
    [self.view layoutIfNeeded];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect r = eff.frame;
        eff.frame = CGRectMake(0, eff.frame.size.height, eff.frame.size.width, eff.frame.size.height);
        [UIView animateWithDuration:1.0  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat newHeight  = r.size.height * 0.40;
            eff.frame = CGRectMake(r.origin.x,  r.size.height  - newHeight, r.size.width, newHeight);
        } completion:^(BOOL finished) {
            
        }];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
