//
//  GyroViewController.m
//  iOSSensorDemo
//
//  Created by uwei on 02/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "GyroViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface GyroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *gyroXLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroYLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroZLabel;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation GyroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.motionManager) {
        self.motionManager = [CMMotionManager new];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startGyro:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Start"]) {
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        if (self.motionManager.gyroAvailable) {
            self.motionManager.gyroUpdateInterval = 0.5;
            [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
                CMRotationRate rate = gyroData.rotationRate;
                self.gyroXLabel.text = [NSString stringWithFormat:@"%@%f", @"x:",rate.x];
                self.gyroYLabel.text = [NSString stringWithFormat:@"%@%f", @"y:",rate.y];
                self.gyroZLabel.text = [NSString stringWithFormat:@"%@%f", @"z:",rate.z];
            }];
        }
    }
    if ([sender.titleLabel.text isEqualToString:@"Stop"]) {
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [self.motionManager stopGyroUpdates];
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
