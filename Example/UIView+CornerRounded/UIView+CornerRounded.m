//
//  UIView+CornerRounded.m
//
//  Created by Jorge Ouahbi on 21/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "UIView+CornerRounded.h"

@implementation UIView(Rounded)

#pragma mark - Private
-(void) maskCornerWithBezierPathWithRoundedRect:(UIRectCorner) roundingCorners radii:(CGSize) radii {
   if (@available(iOS 11.0, *)) {
       self.clipsToBounds      = YES;
       self.layer.cornerRadius = radii.height;
       self.layer.maskedCorners = (CACornerMask) roundingCorners;
   } else {
       
       UIBezierPath *maskPath = [UIBezierPath
                                 bezierPathWithRoundedRect:self.bounds
                                 byRoundingCorners:roundingCorners
                                 cornerRadii:radii];
       
       CAShapeLayer *maskLayer = [CAShapeLayer layer];
       maskLayer.frame = self.bounds;
       maskLayer.path = maskPath.CGPath;
       self.layer.mask = maskLayer;
   }
}

#pragma mark - public

-(void) setCornerRadius:(CGSize) radii corner:(UIRectCorner) corner
{
    //
    // Round the upper cornels
    //
    
    [self maskCornerWithBezierPathWithRoundedRect:corner radii:radii];
}

@end
