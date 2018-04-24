//
//  OMGripBarView.m
//  Example
//
//  Created by Jorge Ouahbi on 18/3/18.
//  Copyright © 2018 Jorge Ouahbi. All rights reserved.
//

#import "OMGripBarView.h"

@interface OMGripBarView()
{
    NSMutableArray<CAShapeLayer*> *_barLayers ;
    UIView * _separatorLine;
    NSLayoutConstraint *_separatorLineTop;
    NSUInteger _numberOfGripLines;
}
@end

@implementation OMGripBarView
@synthesize numberOfLines;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}


-(void) setNumberOfLines:(NSInteger)numberOfLines {
    _numberOfGripLines = numberOfLines;
    _barLayers = [NSMutableArray arrayWithCapacity:numberOfLines];
}

-(NSInteger) numberOfLines{
    return _numberOfGripLines;
}

-(void) defaultInit {
    
    _lineMargin = 2;
    _numberOfGripLines = 1;
     _lineWidth        = 4;
    _showSeparatorLine = NO;
    _separatorLineWidth = 1;
    
    _separatorLine = [UIView new];
    _separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    _separatorLine.backgroundColor = [UIColor lightGrayColor];
    _separatorLine.hidden = !_showSeparatorLine;
    [self addSubview:_separatorLine];
    
    _separatorLineTop = [NSLayoutConstraint constraintWithItem:_separatorLine
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                    constant:0];
    
    [self addConstraint:_separatorLineTop];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1
                                                      constant:0]];
    
    
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:_separatorLineWidth]];

}

-(void )layoutSubviews  {
    [super layoutSubviews];
    UIColor * fill = [UIColor colorWithRed:252/256.0 green:252/256.0 blue:252/256.0 alpha:1];
    UIColor * shadowColor = [UIColor blackColor];
    
    CGFloat width        = self.frame.size.width * 0.15;
    CGFloat height       = _lineWidth;
    CGFloat cornerRadius = height / 2.0;
    CGRect  pathRect     = CGRectZero;
    CGFloat midX         = CGRectGetMidX(self.frame);
    
    if(_barLayers.count != self.numberOfLines) {
        [_barLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [_barLayers removeAllObjects];
        for (int i = 0; i < self.numberOfLines ; i++) {
            CAShapeLayer *_barLayer = [CAShapeLayer layer];
            _barLayer.shadowRadius   = 2;
            _barLayer.shadowOpacity  = 1.0;
            _barLayer.shadowColor    = shadowColor.CGColor;
            _barLayer.fillColor      = fill.CGColor;
            _barLayer.shadowOffset   = CGSizeMake(0, 1);
            _barLayer.lineCap        = kCALineCapRound;
            _barLayer.lineJoin       = kCALineJoinRound;
            
            pathRect = CGRectMake(midX - (width / 2.0),  i * (height + _lineMargin), width, height);
            
            UIBezierPath *  bpath = [UIBezierPath bezierPathWithRoundedRect: pathRect cornerRadius: cornerRadius];
            _barLayer.path = [bpath CGPath];
            
            [_barLayers addObject:_barLayer];
            [self.layer addSublayer:_barLayer];
        }
    }
    _separatorLineTop.constant = (self.bounds.size.height - _separatorLineWidth);
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
}

@end
