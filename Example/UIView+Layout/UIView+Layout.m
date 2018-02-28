//
//  UIView+Layout.h
//
//  Created by Jorge Ouahbi on 26/2/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView(Layout)

/**!
 * Get the safe edge insets
 *
 * @return UIEdgeInsets
 */

-(UIEdgeInsets) safeEdgeInsets {
      UIEdgeInsets windowSafeAreaInsets = UIEdgeInsetsZero;
      UIWindow * window = [[UIApplication sharedApplication] keyWindow];
      if (@available(iOS 11.0, *)) {
          windowSafeAreaInsets = window.safeAreaInsets;
      } else {
          // Fallback on earlier versions
      }
    
      CGRect viewFrameInWindowCoordinateSystem = [self convertRect:self.bounds toView: window];
  
      CGFloat maxX = CGRectGetMaxX(viewFrameInWindowCoordinateSystem);
      CGFloat maxY = CGRectGetMaxY(viewFrameInWindowCoordinateSystem);
      CGFloat minX = CGRectGetMinX(viewFrameInWindowCoordinateSystem);
      CGFloat minY = CGRectGetMinY(viewFrameInWindowCoordinateSystem);
  
      return UIEdgeInsetsMake(minY < windowSafeAreaInsets.top ? windowSafeAreaInsets.top - minY : 0,
                        minX < windowSafeAreaInsets.left ? windowSafeAreaInsets.left - minX : 0,
                        maxY > window.frame.size.height - windowSafeAreaInsets.bottom ? maxY - window.frame.size.height + windowSafeAreaInsets.bottom : 0,
                          maxY > window.frame.size.width- windowSafeAreaInsets.right ? maxX - window.frame.size.width + windowSafeAreaInsets.right : 0
                       );
    
}


/**!
 * Get the safe layout frame
 *
 * @return CGRect
 */
-(CGRect) layoutFrame {
    CGRect frame = self.frame;
    if (@available(iOS 11.0, *)) {
        frame = self.safeAreaLayoutGuide.layoutFrame;
    } else {
        // Fallback on earlier versions
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat maxY =  CGRectGetMaxY(statusBarFrame);
        frame  = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y + maxY,
                            self.frame.size.width,
                            self.frame.size.height - maxY);
    }
    return frame;
}

@end
