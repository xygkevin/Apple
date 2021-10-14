//
//  PedometerViewController.m
//  iOSSensorDemo
//
//  Created by uwei on 02/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "PedometerViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface PedometerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;
@property (strong, nonatomic) CMPedometer *pedometer;
@end

@implementation PedometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.stepCountLabel.text = @"你走了 0 步";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startCounting:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Start"]) {
        if (![CMPedometer isStepCountingAvailable]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"计步器不可用" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:NO completion:nil];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:cancel];
            return;
        }
        
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        
        if (!self.pedometer) {
            self.pedometer = [CMPedometer new];
        }
        
        [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"计步器出错" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:NO completion:nil];
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stepCountLabel.text = [NSString stringWithFormat:@"%@%@%@", @"你走了 ", pedometerData.numberOfSteps, @" 步"];
            });
            
        }];
    }
    if ([sender.titleLabel.text isEqualToString:@"Stop"]) {
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [self.pedometer stopPedometerUpdates];
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
