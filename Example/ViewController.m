
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
#include "OMGripBarView.h"

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
@property(strong,nonatomic) NSMutableArray<OMGripBarView *>  * gripBars;
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
    self.gripBars= [NSMutableArray array];;
    self.panelViews= [NSMutableArray array];;
    
    
    [self setupGradients];
    
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
        [self.panelViews[TOP] openPanel:self.floatingButtons[TOP] duration:2.0 ratio:0.10 block:nil];
    }
}

-(void) didTouchUpInsideBottom:(id)sender {
    if (![self.panelViews[BOTTOM] isOpen]) {
        [self.panelViews[BOTTOM] openPanel:self.floatingButtons[BOTTOM] duration:2.0 ratio:0.90 block:nil];
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


//
//- (void)animateFloatingButtonButton:(BOOL)willAnimate buttonIndex:(int)buttonIndex {
//    if (willAnimate) {
//        [self.floatingButtons[buttonIndex] setEnabled:NO];
//
//        CASpringAnimation * springRotation = [_panelViews[buttonIndex] animateTransformRotation];
//        [self.floatingButtons[buttonIndex].layer addAnimation:springRotation forKey:@"rotationAnimation"];
//    }else{
//        [self.floatingButtons[buttonIndex] setEnabled:YES];
//        [self.floatingButtons[buttonIndex].layer removeAllAnimations];
//    }
//}


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
                                                                             constant:(addToTop)?40:-20];
    
    
    [appWindow addConstraints:@[centerXConstraint,bottonTopConstrain]];
    
    
    return button;
}

-(void) setupPanel:(NSInteger) panelIndex selector:(SEL) selector {
    OMBlurPanel* panel =  [[OMBlurPanel alloc] initWithFrame:CGRectZero style:UIBlurEffectStyleDark];

    if (panel != nil) {
        [self.panelViews insertObject:panel atIndex: panelIndex];
        [self.view addSubview:panel];
        panel.delegate = self;
        [panel.contentView.layer insertSublayer:self.gradient[panelIndex] atIndex:0];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1
                                                               constant:0]];
        
        
//        CGSize closeButtonSize    = CGSizeMake(24, 12);
//        UIImage * backgroundImage = [UIImage imageNamed:@"closeButton"];
//
//        if (panelIndex == TOP) {
//            backgroundImage = [UIImage imageWithCGImage:backgroundImage.CGImage
//                                                  scale:backgroundImage.scale
//                                            orientation:UIImageOrientationDown];
//        }
        OMGripBarView* gripBar = [[OMGripBarView alloc] initWithFrame:CGRectZero];
        [self.gripBars insertObject:gripBar atIndex: panelIndex];
        gripBar.tintColor = [UIColor blackColor];
        
       // [self.closeButtons[panelIndex] setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        
        //CGRect buttonFrame = CGRectMake(0, 0, closeButtonSize.width, closeButtonSize.height);
       // [self.gripBars[panelIndex] setFrame:buttonFrame];
       // [self.closeButtons[panelIndex] addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside ];
        [gripBar setTranslatesAutoresizingMaskIntoConstraints:NO];
        [panel.contentView addSubview:self.gripBars[panelIndex]];
        
        
        [gripBar.superview addConstraint:[NSLayoutConstraint constraintWithItem:gripBar
                                                                                            attribute:NSLayoutAttributeHeight
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:nil
                                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                                           multiplier:1
                                                                                             constant:25]];
        

        
        [gripBar.superview addConstraint:[NSLayoutConstraint constraintWithItem:gripBar
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:gripBar.superview
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1
                                                               constant:0]];
        
        [gripBar.superview addConstraint:[NSLayoutConstraint constraintWithItem:gripBar
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:gripBar.superview
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1
                                                               constant:0]];
        
        
//        [self.gripBars[panelIndex].superview addConstraint:[NSLayoutConstraint constraintWithItem:self.gripBars[panelIndex]
//                                                                                            attribute:NSLayoutAttributeWidth
//                                                                                            relatedBy:NSLayoutRelationEqual
//                                                                                               toItem:nil
//                                                                                            attribute:NSLayoutAttributeNotAnAttribute
//                                                                                           multiplier:1
//                                                                                             constant:self.gripBars[panelIndex].bounds.size.width]];
        
        //DBG_BORDER_COLOR(_buttonAURAClose.layer, [UIColor redColor]);
        
//        NSLayoutConstraint * centerXConstraint =  [NSLayoutConstraint constraintWithItem:self.gripBars[panelIndex]
//                                                                               attribute:NSLayoutAttributeCenterX
//                                                                               relatedBy:NSLayoutRelationEqual
//                                                                                  toItem:self.gripBars[panelIndex].superview
//                                                                               attribute:NSLayoutAttributeCenterX
//                                                                              multiplier:1.0
//                                                                                constant:0];
        if (panelIndex == TOP) {
            NSLayoutConstraint * bottomConstrain =  [NSLayoutConstraint constraintWithItem:gripBar
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:gripBar.superview
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                multiplier:1.0
                                                                                  constant:-15];
            [panel.contentView  addConstraint:bottomConstrain];
        } else {
            
            NSLayoutConstraint * topConstrain =  [NSLayoutConstraint constraintWithItem:gripBar
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:gripBar.superview
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:15];
            [panel.contentView  addConstraint:topConstrain];
        }
        
        
      //  [self.panelViews[panelIndex].contentView  addConstraint:centerXConstraint];
        
        
        [panel.contentView layoutSubviews];
        
    }
}

- (void) setupGradients {
    
    
    [self.gradient insertObject:[CAGradientLayer layer] atIndex:TOP];

    
    self.gradient[TOP].startPoint = CGPointMake(1, 0);
    self.gradient[TOP].endPoint   = CGPointMake(0, 1);
    
    UIColor * color1 = UIColor.cyanColor;
    UIColor * color2 = UIColor.lightGrayColor;
    NSArray *colors = @[(id)color1.CGColor,(id)color2.CGColor];
    
    self.gradient[TOP].colors = colors;
    
    [self.gradient insertObject:[CAGradientLayer layer] atIndex:BOTTOM];
    
    self.gradient[BOTTOM].startPoint = CGPointMake(1, 0);
    self.gradient[BOTTOM].endPoint   = CGPointMake(0, 1);
    
    UIColor * color21 = UIColor.purpleColor;
    UIColor * color22 = UIColor.grayColor;
    UIColor * color23 = UIColor.blackColor;
    
    NSArray *colors2 = @[(id)color21.CGColor,(id)color22.CGColor,(id)color23.CGColor];
    
    self.gradient[BOTTOM].colors = colors2;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIImage *image =  nil;
    
    UIButton * floatingButtonTop = [self addFloatingButton:@selector(didTouchUpInsideTop:) addToTop:YES];
    UIButton * floatingButtonBottom = [self addFloatingButton:@selector(didTouchUpInsideBottom:) addToTop:NO];
    
    [self.floatingButtons insertObject: floatingButtonTop atIndex: TOP];
    [floatingButtonTop layoutIfNeeded];
    
    self.gradient[TOP].frame = floatingButtonTop.bounds;
    UIGraphicsBeginImageContext(floatingButtonTop.bounds.size);
    [self.gradient[TOP] renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [floatingButtonTop setBackgroundImage:image forState:UIControlStateNormal];
    
    [self.floatingButtons insertObject: floatingButtonBottom atIndex: BOTTOM];
    [floatingButtonBottom layoutIfNeeded];
    
    self.gradient[BOTTOM].frame  = floatingButtonBottom.bounds;
    UIGraphicsBeginImageContext(floatingButtonBottom.bounds.size);
    [self.gradient[BOTTOM] renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [floatingButtonBottom setBackgroundImage:image forState:UIControlStateNormal];
    
    [self setupPanel:TOP selector:@selector(didTouchUpInsideCloseTop:)];
    [self setupPanel:BOTTOM selector:@selector(didTouchUpInsideCloseBottom:)];
    
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
