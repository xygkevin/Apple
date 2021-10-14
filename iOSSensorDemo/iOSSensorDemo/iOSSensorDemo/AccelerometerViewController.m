//
//  AccelerometerViewController.m
//  iOSSensorDemo
//
//  Created by uwei on 02/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "AccelerometerViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface AccelerometerViewController ()<UIAccelerometerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentContoller;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerXLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerYLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerZLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) UIAccelerometer *accelerometer;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) CMSensorRecorder *recorder;

@end

@implementation AccelerometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.delegate = self;
    self.accelerometer.updateInterval = 0.5;
    
    [self.segmentContoller addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)change:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            self.tipsLabel.text = @"Frmo UIAccelerometer";
            if (self.motionManager) {
                [self.motionManager stopAccelerometerUpdates];
                self.motionManager = nil;
            }
            if (!self.accelerometer) {
                self.accelerometer = [UIAccelerometer sharedAccelerometer];
                self.accelerometer.delegate = self;
            }
            break;
        }
        case 1:
        {
            self.tipsLabel.text = @"Frmo Core Motion";
            if (self.accelerometer) {
                self.accelerometer.delegate = nil;
                self.accelerometer = nil;
            }
            
            if (!self.motionManager) {
                self.motionManager = [CMMotionManager new];
            }
            if (self.motionManager.accelerometerAvailable) {
                self.motionManager.accelerometerUpdateInterval = 0.5;
                
                // 此处是使用push的方式获取数据
//                [self.motionManager startAccelerometerUpdates]; //此种方式是pull的方式
//                CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration; //在需要的时候再去获取数据
                
                [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
                    if (error) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                        [self presentViewController:alert animated:NO completion:nil];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        [alert addAction:cancel];
                        return;
                    }
                    CMAcceleration acceleration = accelerometerData.acceleration;
                    self.accelerometerXLabel.text = [NSString stringWithFormat:@"%@%f", @"x:",acceleration.x];
                    self.accelerometerYLabel.text = [NSString stringWithFormat:@"%@%f", @"y:",acceleration.y];
                    self.accelerometerZLabel.text = [NSString stringWithFormat:@"%@%f", @"z:",acceleration.z];
                }];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"加速计不可用！" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:NO completion:nil];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:cancel];
            }
            
            
            break;
        }
            case 2:
        {
            self.accelerometerXLabel.text = @"";
            self.accelerometerYLabel.text = @"";
            self.accelerometerZLabel.text = @"";
            self.tipsLabel.text = @"From CMSensorRecorder(only iWatch)";
            if (self.motionManager) {
                [self.motionManager stopAccelerometerUpdates];
                self.motionManager = nil;
            }
            if (self.accelerometer) {
                self.accelerometer.delegate = nil;
                self.accelerometer = nil;
            }
            
            if (![CMSensorRecorder isAuthorizedForRecording]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"加速计未许可(only iWatch use)！" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:NO completion:nil];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:cancel];
                
                return;
            } else {
                if ([CMSensorRecorder isAccelerometerRecordingAvailable]) {
                    self.recorder = [CMSensorRecorder new];
                    [self.recorder recordAccelerometerForDuration:5];
                    __weak typeof(self) weakSelf = self;
                    [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
                        //
                        CMSensorDataList *list = [self.recorder accelerometerDataFromDate:[NSDate dateWithTimeIntervalSinceNow:5] toDate:[NSDate date]];
                        for (CMRecordedAccelerometerData *data in list) {
                            CMAcceleration acceleration = data.acceleration;
                            weakSelf.accelerometerXLabel.text = [NSString stringWithFormat:@"%@%f", @"x:",acceleration.x];
                            weakSelf.accelerometerYLabel.text = [NSString stringWithFormat:@"%@%f", @"y:",acceleration.y];
                            weakSelf.accelerometerZLabel.text = [NSString stringWithFormat:@"%@%f", @"z:",acceleration.z];
                        }
                    }];
                } else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"加速计不可用！" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alert animated:NO completion:nil];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [alert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:cancel];
                }

            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIAccelerometerDelegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    self.accelerometerXLabel.text = [NSString stringWithFormat:@"%@%f", @"x:",acceleration.x];
    self.accelerometerYLabel.text = [NSString stringWithFormat:@"%@%f", @"y:",acceleration.y];
    self.accelerometerZLabel.text = [NSString stringWithFormat:@"%@%f", @"z:",acceleration.z];
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
