//
//  ScanQRVC.m
//  LTQRManager
//
//  Created by yelon on 17/2/20.
//  Copyright © 2017年 254956982@qq.com. All rights reserved.
//

#import "ScanQRVC.h"
#import "LTQRScanManager.h"
#import "LTScanCoverView.h"

@interface ScanQRVC ()

@property (strong, nonatomic) LTQRScanManager *scanManager;
@property (weak, nonatomic) IBOutlet LTScanCoverView *maskView;

@end

@implementation ScanQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.scanManager lt_startRunning];
    [self.maskView lt_startRunning];
}

-(void)viewDidLayoutSubviews{

    self.scanManager.layerFrame = self.view.bounds;
}

-(LTQRScanManager *)scanManager{
    
    if (!_scanManager) {
        
        _scanManager = [LTQRScanManager LT_ShowInView:self.view];
        __weak typeof(self)weakSelf = self;
        [_scanManager setBlockDidDecodeResult:^(LTQRScanManager *manager, NSString *result) {
            
            [manager lt_stopRunning];
            [weakSelf.maskView lt_stopRunning];
            NSLog(@"result=%@",result);
        }];
    }
    return _scanManager;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    
    [self startScan];
}

- (void)startScan{
    
    [self.scanManager lt_startRunning];
    [self.maskView lt_startRunning];
}

@end
