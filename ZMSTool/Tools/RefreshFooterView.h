//
//  RefreshFooterView.h
//  ZMSTool
//
//  Created by 李高锋 on 2016/12/23.
//  Copyright © 2016年 GaoF. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger , FooterRefreshStatus){
    FooterRefreshStatusDone,
    FooterRefreshStatusNomal,
    FooterRefreshStatusFreshing,
    FooterRefreshStatusBeforeFresh,
};

@interface RefreshFooterView : UIView

@property (nonatomic, assign) FooterRefreshStatus status;
@property (nonatomic, assign) CGFloat             footerViewHeight;
@property (nonatomic, strong) UIScrollView        *parentScrollView;
@property (nonatomic, assign) BOOL                noMoreData;
@property (nonatomic, copy)   void (^isFooterRefreshing)(void);

- (void)freshFooterViewFrameByFloat:(CGFloat)y;


@end
