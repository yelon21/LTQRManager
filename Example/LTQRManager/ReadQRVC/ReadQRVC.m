//
//  ReadQRVC.m
//  LTQRManager
//
//  Created by yelon on 17/2/20.
//  Copyright © 2017年 254956982@qq.com. All rights reserved.
//

#import "ReadQRVC.h"
#import "UIImage+LTQR.h"

@interface ReadQRVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ReadQRVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = [UIImage imageNamed:@"QR.png"];
    
    self.label.text = [self.imageView.image lt_qrContentFromQRImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
