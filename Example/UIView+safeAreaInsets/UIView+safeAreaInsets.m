//
//  UIView+safeAreaInsets.h
//
//  Created by Jorge Ouahbi on 26/2/18.
//  Copyright © 2018 Jorge Ouahbi . All rights reserved.
//

#import "UIView+safeAreaInsets.h"

@implementation UIView(safeAreaInsets)

/**!
 * @brief Get the safe edge insets
 *
 * @return UIEdgeInsets
 */

-(UIEdgeInsets) safeEdgeInsets {
      UIEdgeInsets windowSafeAreaInsets = UIEdgeInsetsZero;
      UIWindow * window = [[UIApplication sharedApplication] keyWindow];
     [window layoutIfNeeded];
      if (@available(iOS 11.0, *)) {
          windowSafeAreaInsets = window.safeAreaInsets;
      } else {
          // Fallback on earlier versions (UIEdgeInsetsZero)
      }
    
      CGRect viewFrameInWindowCoordinateSystem = [self convertRect:self.bounds toView: window];
  
      CGFloat maxX = CGRectGetMaxX(viewFrameInWindowCoordinateSystem);
      CGFloat maxY = CGRectGetMaxY(viewFrameInWindowCoordinateSystem);
      CGFloat minX = CGRectGetMinX(viewFrameInWindowCoordinateSystem);
      CGFloat minY = CGRectGetMinY(viewFrameInWindowCoordinateSystem);
  
      return UIEdgeInsetsMake(minY < windowSafeAreaInsets.top ? windowSafeAreaInsets.top - minY : 0,
                        minX < windowSafeAreaInsets.left ? windowSafeAreaInsets.left - minX : 0,
                        maxY > window.frame.size.height - windowSafeAreaInsets.bottom ? maxY - window.frame.size.height + windowSafeAreaInsets.bottom : 0,
                          maxY > window.frame.size.width - windowSafeAreaInsets.right ? maxX - window.frame.size.width + windowSafeAreaInsets.right : 0
                       );
    
}


/**!
 * @brief Get the safe layout frame
 *
 * @return CGRect
 */
 -(CGRect) layoutFrame {
    UIWindow * const   window = [UIApplication sharedApplication].keyWindow;
    [window layoutIfNeeded];
    CGRect frame = window.frame;
    if (@available(iOS 11.0, *)) {
        frame = window.safeAreaLayoutGuide.layoutFrame;
    } else {
        frame = window.frame;
        // Fallback on earlier versions
    }
    return frame;
}

-(CGFloat) widthOfSafeArea {
    UIWindow * const  window = [UIApplication sharedApplication].keyWindow;
        [window layoutIfNeeded];
    if (@available(iOS 11.0, *)) {
        const CGFloat leftInset   = window.safeAreaInsets.left;
        const CGFloat rightInset  = window.safeAreaInsets.right;
        return window.bounds.size.width - leftInset - rightInset;
    } else {
        return window.bounds.size.width;
    }
}

-(CGFloat) heightOfSafeArea {
    UIWindow * const window = [UIApplication sharedApplication].keyWindow;
    [window layoutIfNeeded];
    if (@available(iOS 11.0, *)) {
        const CGFloat topInset = window.safeAreaInsets.top;
        const CGFloat bottomInset = window.safeAreaInsets.bottom;
        return window.bounds.size.width - topInset - bottomInset;
    } else {
        return window.bounds.size.width;
    }
}

@end
