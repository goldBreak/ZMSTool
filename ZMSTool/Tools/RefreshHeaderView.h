//
//  RefreshHeaderView.h
//  ZMSTool
//
//  Created by 李高锋 on 2016/12/23.
//  Copyright © 2016年 GaoF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , HeaderRefreshStatus){
    HeaderRefreshStatusDone,
    HeaderRefreshStatusNomal,
    HeaderRefreshStatusFreshing,
    HeaderRefreshStatusBeforeFresh
};


@interface RefreshHeaderView : UIView


@property (nonatomic, assign) HeaderRefreshStatus status;
@property (nonatomic, assign) CGFloat             headerViewHeight;
@property (nonatomic, strong) UIScrollView        *parentScrollView;
@property (nonatomic, copy)   void (^isHeaderRefreshing)(void);

- (void)freshHeaderViewFrameByFloat:(CGFloat)y;

@end
