//
//  WriteQRVC.m
//  LTQRManager
//
//  Created by yelon on 17/2/20.
//  Copyright © 2017年 254956982@qq.com. All rights reserved.
//

#import "WriteQRVC.h"
#import "UIImage+LTQR.h"

@interface WriteQRVC ()

@property (weak, nonatomic) IBOutlet UITextField *TF;

@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;

@end

@implementation WriteQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.TF.text = @"哈哈哈。。😁测试";
    [self clickActgion:nil];
}

- (IBAction)clickActgion:(id)sender {
    
    [self.view endEditing:YES];
    NSString *content = self.TF.text;
    if (![content isKindOfClass:[NSString class]]) {
        content = @"";
    }
    self.imageV1.image = [UIImage LT_QRImageWithContentString:content
                                                  defaultSize:200.0];
    
    self.imageV2.image = [UIImage LT_QRImageWithContentString:content
                                                  defaultSize:200.0
                                              foregroundColor:[CIColor colorWithRed:1
                                                                              green:0
                                                                               blue:0
                                                                              alpha:1]
                                              backgroundColor:[CIColor colorWithRed:1
                                                                              green:0
                                                                               blue:0
                                                                              alpha:0]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
