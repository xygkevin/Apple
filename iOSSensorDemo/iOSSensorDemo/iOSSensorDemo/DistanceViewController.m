//
//  DistanceViewController.m
//  iOSSensorDemo
//
//  Created by uwei on 02/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "DistanceViewController.h"

@interface DistanceViewController ()
@property (strong, nonatomic) UILabel *myLabel;
@end

@implementation DistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.width/2, self.view.bounds.size.width, 30)];
    self.myLabel.textAlignment = NSTextAlignmentCenter;
    self.myLabel.textColor = [UIColor blackColor];
    self.myLabel.text = @"test";
    [self.view addSubview:self.myLabel];
    
    // Do any additional setup after loading the view.
    if (![UIDevice currentDevice].isProximityMonitoringEnabled) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)show {
    if ([UIDevice currentDevice].proximityState) {
        self.myLabel.text = @"有物体在靠近";
    } else {
        self.myLabel.text = @"有物体在远离";
    }
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
