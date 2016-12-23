//
//  RefreshFooterView.m
//  ZMSTool
//
//  Created by 李高锋 on 2016/12/23.
//  Copyright © 2016年 GaoF. All rights reserved.
//

#import "RefreshFooterView.h"

@interface RefreshFooterView(){
    
    CGFloat lastValue;
}


@property (nonatomic, strong) UIView        *showView;
@property (nonatomic, strong) CAShapeLayer  *showLayer;
@property (nonatomic, strong) UILabel       *showLabel;


@end


@implementation RefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.showView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _showView.center = CGPointMake(self.center.x, self.frame.size.height/2);
}

- (void)freshFooterViewFrameByFloat:(CGFloat)y{
    
    if (_noMoreData) {
        return;
    }
    
    if (self.parentScrollView.isDragging) {
        
        if (y >= _footerViewHeight) {
            
            self.status = FooterRefreshStatusBeforeFresh;
        }
        else{
            self.status = FooterRefreshStatusNomal;
            
            [self refreshCircleValue:fabs(y)/_footerViewHeight];
        }
    }
    else{
        if (y >= _footerViewHeight) {
            self.status = FooterRefreshStatusFreshing;
        }
    }
}

- (void)setStatus:(FooterRefreshStatus)status{
    
    if (_status == status) {
        return;
    }
    _status = status;
    
    switch (status) {
        case FooterRefreshStatusBeforeFresh:{
            [self.showLabel setText:@"松开加载"];
            [self.showLayer removeAnimationForKey:@"showLayer"];
        }
            break;
        case FooterRefreshStatusNomal:{
            
            [self.showLabel setText:@"上拉加载更多"];
            [self.showLayer removeAnimationForKey:@"showLayer"];
            [UIView animateWithDuration:0.4 animations:^{
                self.parentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        }
            break;
        case FooterRefreshStatusFreshing:{
            
            [self.showLabel setText:@"正在加载"];
            [self refreshCircleValue:0.94];
            [self.showLayer addAnimation:[self rotation:0.2 degree:2 * M_PI direction:1] forKey:@"showLayer"];
            
            [UIView animateWithDuration:0.4 animations:^{
                self.parentScrollView.contentInset = UIEdgeInsetsMake(-_footerViewHeight, 0, 0, 0);
            }];
            
            self.isFooterRefreshing();
        }
            break;
        case FooterRefreshStatusDone:{
            
            [self.showLabel setText:@"加载成功!"];
            [UIView animateWithDuration:0.4 animations:^{
                self.parentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
            [self.showLayer removeAnimationForKey:@"showLayer"];
        }
            break;
        default:
            break;
    }
    
}

- (void)setNoMoreData:(BOOL)noMoreData{
    _noMoreData = noMoreData;
    if (_noMoreData) {
        
        [self.showLayer removeFromSuperlayer];
        self.showLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_showView.frame), 20);
        self.showLabel.textAlignment = NSTextAlignmentCenter;
        [self.showLabel setText:@"已无更多数据"];
        
    } else {
        
        [_showView.layer addSublayer:self.showLayer];
        self.showLabel.frame = CGRectMake(CGRectGetWidth(_showView.frame)/2, 0, CGRectGetWidth(_showView.frame)/2, 20);
        self.showLabel.textAlignment = NSTextAlignmentLeft;
        [self.showLabel setText:@"上拉加载更多"];
    }
}

- (void)refreshCircleValue:(CGFloat)currentValue{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(lastValue);
    animation.toValue = @(currentValue);
    animation.duration = 0.1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.showLayer addAnimation:animation forKey:nil];
    
    lastValue = currentValue;
}

- (CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,direction);
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration= dur;
    animation.autoreverses = NO;
    animation.cumulative = YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= MAXFLOAT;
    
    return animation;
}

- (UIView *)showView{
    
    if (!_showView) {
        _showView = [[UIView alloc] init];
        _showView.backgroundColor = [UIColor clearColor];
        _showView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), 20);
        _showView.center = CGPointMake(self.center.x, 10);
        _showView.alpha = 1;
        
        [_showView.layer addSublayer:self.showLayer];
        
        [_showView addSubview:self.showLabel];
    }
    return _showView;
}

- (CAShapeLayer *)showLayer{
    
    if (!_showLayer) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(9, 9) radius:9 startAngle:-M_PI_2 endAngle:M_PI * 3/2 clockwise:YES];
        _showLayer = [CAShapeLayer layer];
        _showLayer.frame = CGRectMake(CGRectGetWidth(_showView.frame)/2 - 18 - 15, CGRectGetHeight(_showView.frame)/2 - 9, 18, 18);
        _showLayer.path = path.CGPath;
        _showLayer.lineCap = kCALineCapRound;
        _showLayer.lineWidth = 1;
        _showLayer.fillColor = [UIColor clearColor].CGColor;
        _showLayer.strokeColor = [UIColor colorWithWhite:0.2 alpha:1].CGColor;
        _showLayer.strokeStart = 0.0;
        lastValue = 0.0;
    }
    return _showLayer;
}

- (UILabel *)showLabel{
    
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_showView.frame)/2 - 10, 0, CGRectGetWidth(_showView.frame)/2, 20)];
        _showLabel.textColor = [UIColor blackColor];
        _showLabel.font = [UIFont systemFontOfSize:13.0];
        _showLabel.textAlignment = NSTextAlignmentLeft;
        _showLabel.text = @"上拉加载更多";
        _showLabel.alpha = 1;
    }
    return _showLabel;
}

- (void)setFooterViewHeight:(CGFloat)footerViewHeight{
    _footerViewHeight = footerViewHeight;
}

@end
