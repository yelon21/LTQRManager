//
//  LYViewController.m
//  LTQRManager
//
//  Created by 254956982@qq.com on 02/15/2017.
//  Copyright (c) 2017 254956982@qq.com. All rights reserved.
//

#import "LYViewController.h"

#import "ReadQRVC.h"
#import "ScanQRVC.h"
#import "WriteQRVC.h"

@interface LYViewController (){

    
}



@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.translucent = NO;

}

- (IBAction)writeQR:(id)sender {
    
    WriteQRVC *vc = [[WriteQRVC alloc]initWithNibName:@"WriteQRVC"
                                               bundle:nil];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}
- (IBAction)readQR:(id)sender {
    
    ReadQRVC *vc = [[ReadQRVC alloc]initWithNibName:@"ReadQRVC"
                                               bundle:nil];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}
- (IBAction)sacnQR:(id)sender {
    
    ScanQRVC *vc = [[ScanQRVC alloc]initWithNibName:@"ScanQRVC"
                                               bundle:nil];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}
@end
