//
//  MagnetometerViewController.m
//  iOSSensorDemo
//
//  Created by uwei on 02/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "MagnetometerViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface MagnetometerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *magnetometerXLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnetometerYLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnetometerZLabel;
@property (strong, nonatomic) CMMotionManager *motionManager;
@end

@implementation MagnetometerViewController

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

- (IBAction)startMagnetometer:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Start"]) {
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        if (self.motionManager.magnetometerAvailable) {
            self.motionManager.magnetometerUpdateInterval = 0.5;
            [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
                CMMagneticField field = magnetometerData.magneticField;
                self.magnetometerXLabel.text = [NSString stringWithFormat:@"%@%f", @"x:",field.x];
                self.magnetometerYLabel.text = [NSString stringWithFormat:@"%@%f", @"y:",field.y];
                self.magnetometerZLabel.text = [NSString stringWithFormat:@"%@%f", @"z:",field.z];
            }];
        }
    }
    if ([sender.titleLabel.text isEqualToString:@"Stop"]) {
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [self.motionManager stopMagnetometerUpdates];
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
