//
//  OMBlurPanel.m
//  OMBlurPanel
//
//  Created by Jorge Ouahbi on 19/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "UIView+Blur.h"
#import "OMCustomIntensityVisualEffectView.h"

@implementation UIView(Blur)

-(UIVisualEffectView *)addViewWithBlur:(UIView*) view style:(UIBlurEffectStyle) style addConstrainst:(BOOL)addConstrainst
{
    // Blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    OMCustomIntensityVisualEffectView *blurEffectView = [[OMCustomIntensityVisualEffectView alloc] initWithEffect:blurEffect intensity:1.0];
    [blurEffectView setFrame:self.bounds];
    [self addSubview:blurEffectView];
    
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    OMCustomIntensityVisualEffectView *vibrancyEffectView = [[OMCustomIntensityVisualEffectView alloc] initWithEffect:vibrancyEffect intensity:1.0];
    [vibrancyEffectView setFrame:self.bounds];

    UIView * contentView = [blurEffectView contentView];
    
    // Add the vibrancy view to the blur view
    [contentView addSubview:vibrancyEffectView];
    // Add view to the vibrancy view
    [contentView addSubview:view];
    
    if (addConstrainst) {
    
        [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1
                                                          constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
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
