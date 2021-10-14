//
//  AltimeterViewController.m
//  iOSSensorDemo
//
//  Created by uwei on 02/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "AltimeterViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface AltimeterViewController ()
@property (strong, nonatomic) CMAltimeter *altimeter;
@property (weak, nonatomic) IBOutlet UILabel *altimeterLabel;

@end

@implementation AltimeterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.altimeterLabel.text = @"请点击开始测试";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startAltimeter:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Start"]) {
        if (![CMAltimeter isRelativeAltitudeAvailable]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"测高仪不可用" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:NO completion:nil];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:cancel];
            return;
        }
        
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        
        if (!self.altimeter) {
            self.altimeter = [CMAltimeter new];
        }
        
        [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"测高仪出错" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:NO completion:nil];
                return;
            }
            
            self.altimeterLabel.text = [NSString stringWithFormat:@"%@%@\n%@%@", @"当前高度是: ", altitudeData.relativeAltitude, @"压强是: ", altitudeData.pressure];
        }];
    }
    
    if ([sender.titleLabel.text isEqualToString:@"Stop"]) {
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [self.altimeter stopRelativeAltitudeUpdates];
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
