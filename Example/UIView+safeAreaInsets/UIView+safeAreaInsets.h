//
//  UIView+safeAreaInsets.h
//
//  Created by Jorge Ouahbi on 26/2/18.
//  Copyright © 2018 Jorge Ouahbi . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(safeAreaInsets)
-(UIEdgeInsets) safeEdgeInsets;
-(CGRect) layoutFrame;
-(CGFloat) heightOfSafeArea;
-(CGFloat) widthOfSafeArea;
@end
