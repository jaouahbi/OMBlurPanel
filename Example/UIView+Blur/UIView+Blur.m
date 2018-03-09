//
//  OMBlurPanel.m
//  OMBlurPanel
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "UIView+Blur.h"
#import "UIVisualEffectView+Intensity.h"

@implementation UIView(Blur)
//https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-2-430de537ba96
//https://www.omnigroup.com/developer/how-to-make-text-in-a-uivisualeffectview-readable-on-any-background
-(UIVisualEffectView *)addViewWithBlur:(UIView*) view style:(UIBlurEffectStyle) style addConstrainst:(BOOL)addConstrainst
{
    // Blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.bounds];
    [self addSubview:blurEffectView];
    
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.bounds];

    UIView * contentView = [blurEffectView contentView];
    
    // Add the vibrancy view to the blur view
    [contentView addSubview:vibrancyEffectView];
    // Add view to the vibrancy view
    [vibrancyEffectView.contentView addSubview:view];
    
    if (addConstrainst) {
    
        [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [blurEffectView.superview addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:blurEffectView.superview
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
        
        [blurEffectView.superview addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:blurEffectView.superview
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
        
        [blurEffectView.superview addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:blurEffectView.superview
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1
                                                          constant:0]];
        
        [blurEffectView.superview addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:blurEffectView.superview
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1
                                                          constant:0]];
        
        
        // vibrancy
        
        [vibrancyEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [vibrancyEffectView.superview addConstraint:[NSLayoutConstraint constraintWithItem:vibrancyEffectView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:vibrancyEffectView.superview
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
        
        [vibrancyEffectView.superview addConstraint:[NSLayoutConstraint constraintWithItem:vibrancyEffectView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:vibrancyEffectView.superview
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
        
        [vibrancyEffectView.superview addConstraint:[NSLayoutConstraint constraintWithItem:vibrancyEffectView
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:vibrancyEffectView.superview
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1
                                                          constant:0]];
        
        [vibrancyEffectView.superview addConstraint:[NSLayoutConstraint constraintWithItem:vibrancyEffectView
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:vibrancyEffectView.superview
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1
                                                          constant:0]];
        
    }
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1
                                                             constant:0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1
                                                             constant:0]];
    
    
    return blurEffectView;
}

@end
