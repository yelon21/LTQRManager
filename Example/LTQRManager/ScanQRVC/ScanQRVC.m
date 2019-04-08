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
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self startScan];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    if (_scanManager) {
        
        [self.scanManager lt_startRunning];
    }
    
    [self.maskView lt_startRunning];
}

-(void)viewDidLayoutSubviews{

    if (_scanManager) {
    
        self.scanManager.layerFrame = self.view.bounds;
    }
}

-(LTQRScanManager *)scanManager{
    
    if (!_scanManager) {
        
        _scanManager = [LTQRScanManager LT_ShowInView:self.view cameraNotAvailableBlock:^{
            
            NSLog(@"请打开相机访问权限");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"请打开相机访问权限"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                               
                                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                           }];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }];
        __weak typeof(self)weakSelf = self;
        [_scanManager setBlockDidDecodeResult:^(LTQRScanManager *manager, NSString *result) {
            
            [manager lt_stopRunning];
            [weakSelf.maskView lt_stopRunning];
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
//    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
//                             completionHandler:^(BOOL granted) {
//
//                                 dispatch_async(dispatch_get_main_queue(), ^{
//
//                                     if (granted) {
//
//                                         [self.scanManager lt_startRunning];
//                                         [self.maskView lt_startRunning];
//                                     }
//                                     else{
//                                         UIAlertController *viewCon = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                                                          message:@"请打开相机访问权限"
//                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
//
//                                         UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
//                                                                                          style:UIAlertActionStyleDefault
//                                                                                        handler:^(UIAlertAction * _Nonnull action) {
//
//                                                                                            [self.navigationController popViewControllerAnimated:YES];
//                                                                                        }];
//
//                                         [viewCon addAction:action];
//
//                                         [self presentViewController:viewCon animated:YES completion:nil];
//                                     }
//                                 });
//
//                             }];
    
}

@end
