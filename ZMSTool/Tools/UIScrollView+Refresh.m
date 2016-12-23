//
//  UIScrollView+Refresh.m
//  ZMSTool
//
//  Created by 李高锋 on 2016/12/23.
//  Copyright © 2016年 GaoF. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>


@interface UIScrollView()

@property (nonatomic, strong)RefreshFooterView *refreshFooterView;
@property (nonatomic, strong)RefreshHeaderView *refreshHeaderView;

@end

static char headerViewChar;
static char footererViewChar;

@implementation UIScrollView (Refresh)

- (void)addHeaderRefreshViewBlock:(onHeaderRefreshing)refreshing{
    
    if (self.headerView) {
        [self.headerView removeFromSuperview];
    }
    
    self.refreshHeaderView = [[RefreshHeaderView alloc] initWithFrame:CGRectMake(0, - HEADER_H, CGRectGetWidth(self.frame), HEADER_H)];
    self.refreshHeaderView.headerViewHeight = HEADER_H;
    self.refreshHeaderView.status = HeaderRefreshStatusNomal;
    self.refreshHeaderView.parentScrollView = self;
    self.refreshHeaderView.isHeaderRefreshing = ^(void){
        refreshing();
    };
    [self addSubview:self.headerView];
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addFooterRefreshViewBlock:(onFooterRefreshing)refreshing{
    
    if (self.footerView) {
        [self.footerView removeFromSuperview];
    }
    
    CGFloat Y = 0.0;
    CGFloat footH = 0.0;
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat contentSizeH = self.contentSize.height;
    
    if (height <= contentSizeH) {
        Y = contentSizeH;
        footH = contentSizeH - height + FOOTER_H;
    } else {
        Y = height;
        footH = FOOTER_H;
    }
    
    self.refreshFooterView = [[RefreshFooterView alloc] initWithFrame:CGRectMake(0, Y, CGRectGetWidth(self.frame), FOOTER_H)];
    self.refreshFooterView.footerViewHeight = footH;
    self.refreshFooterView.status = FooterRefreshStatusNomal;
    self.refreshFooterView.parentScrollView = self;
    self.refreshFooterView.isFooterRefreshing = ^(void){
        refreshing();
    };
    [self addSubview:self.footerView];
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        NSValue *value = [change objectForKey:@"new"];
        CGPoint point = [value CGPointValue];
        
        if (point.y < 0) {
            [self.headerView freshHeaderViewFrameByFloat:point.y];
        }
        else{
            [self.footerView freshFooterViewFrameByFloat:point.y];
        }
    }
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGFloat Y = 0.0;
        CGFloat footH = 0.0;
        CGFloat height = CGRectGetHeight(self.frame);
        CGFloat contentSizeH = self.contentSize.height;
        
        if (height <= contentSizeH) {
            Y = contentSizeH;
            footH = contentSizeH - height + FOOTER_H;
        } else {
            Y = height;
            footH = FOOTER_H;
        }
        
        self.refreshFooterView.frame = CGRectMake(0, Y, CGRectGetWidth(self.frame), FOOTER_H);
        self.refreshFooterView.footerViewHeight = footH;
    }
}

- (void)beginHeaderRefresh{
    self.refreshHeaderView.status = HeaderRefreshStatusFreshing;
}

- (void)endRefresh{
    self.refreshHeaderView.status = HeaderRefreshStatusDone;
    self.refreshFooterView.status = FooterRefreshStatusDone;
}

- (void)isFooterViewNoMoreData:(BOOL)noMoreData{
    self.refreshFooterView.noMoreData = noMoreData;
}

- (RefreshHeaderView *)headerView{
    return objc_getAssociatedObject(self, &headerViewChar);
}

- (void)setHeaderView:(RefreshHeaderView *)headerView{
    objc_setAssociatedObject(self, &headerViewChar, headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RefreshFooterView *)footerView{
    return objc_getAssociatedObject(self, &footererViewChar);
}

- (void)setFooterView:(RefreshFooterView *)footerView{
    objc_setAssociatedObject(self, &footererViewChar, footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
