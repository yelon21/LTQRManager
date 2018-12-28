//
//  LTScanCoverView.h
//  Pods
//
//  Created by yelon on 17/2/17.
//
//

#import <UIKit/UIKit.h>

@interface LTScanCoverView : UIView

@property(nonatomic,assign,readonly) BOOL isRunning;

//开始扫描
- (void)lt_startRunning;
//停止扫描
- (void)lt_stopRunning;
@end
