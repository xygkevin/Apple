//
//  ViewController.m
//  RACMVVMDemo
//
//  Created by uwei on 2020/3/10.
//  Copyright © 2020 TEG of Tencent. All rights reserved.
//

#import "ViewController.h"
#import "SCOrderPayResultViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)openMVVMUI:(id)sender {
    [self.navigationController pushViewController:[SCOrderPayResultViewController new] animated:YES];
}


@end
