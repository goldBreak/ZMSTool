//
//  UIScrollView+Refresh.h
//  ZMSTool
//
//  Created by 李高锋 on 2016/12/23.
//  Copyright © 2016年 GaoF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHeaderView.h"
#import "RefreshFooterView.h"

#define HEADER_H  50
#define FOOTER_H  50

typedef void(^onHeaderRefreshing)(void);
typedef void(^onFooterRefreshing)(void);


@interface UIScrollView (Refresh)

/**
 *  添加下拉刷新
 *
 *  @param refreshing 刷新
 */
- (void)addHeaderRefreshViewBlock:(onHeaderRefreshing)refreshing;

/**
 *  添加上拉加载更多
 *
 *  @param refreshing 刷新
 */
- (void)addFooterRefreshViewBlock:(onFooterRefreshing)refreshing;

/**
 *  开始下拉刷新,此方法用于进入页面就开始刷新时
 */


- (void)beginHeaderRefresh;

/**
 *  结束上拉和下拉动作
 */
- (void)endRefresh;

/**
 *  上拉加载没有更多数据时调用
 */
- (void)isFooterViewNoMoreData:(BOOL)noMoreData;
@end
