//
//  IntentViewController.m
//  SiriKitIntentDemoUI
//
//  Created by uwei on 9/8/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "IntentViewController.h"
#import <Intents/Intents.h>

// As an example, this extension's Info.plist has been configured to handle interactions for INStartWorkoutIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Start my workout using <myApp>"

@interface IntentViewController ()

@property (strong, nonatomic, nonnull) UILabel *nameLabel;
@property (strong, nonatomic, nonnull) UITextView *contentTextView;

@end

@implementation IntentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameLabel           = [UILabel new];
    self.nameLabel.backgroundColor = [UIColor yellowColor];
    self.nameLabel.textColor = [UIColor redColor];
    
    [self.view addSubview:self.nameLabel];
    
    
    self.contentTextView     = [UITextView new];
    self.contentTextView.backgroundColor = [UIColor brownColor];
    self.contentTextView.textColor = [UIColor blackColor];
    self.contentTextView.font      = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    
    [self.view addSubview:self.contentTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.nameLabel.frame = CGRectMake(50, 10, 100, 40);
//    self.nameLabel.center = CGPointMake(self.view.bounds.size.width/2, 0);
//    self.nameLabel.text = self.intent.
    
    self.contentTextView.frame = CGRectMake(50, 80, 50, 60);
//    self.contentTextView.center = CGPointMake(self.view.bounds.size.width/2, 20);
}

#pragma mark - INUIHostedViewControlling

// Prepare your view controller for the interaction to handle.
- (void)configureWithInteraction:(INInteraction *)interaction context:(INUIHostedViewContext)context completion:(void (^)(CGSize))completion {
    // Do configuration here, including preparing views and calculating a desired size for presentation.
    
    
    
    if (interaction.intent) {
        
        if ([interaction.intent isKindOfClass:[INSendMessageIntent class]]) {
            INSendMessageIntent *messageIntent = (INSendMessageIntent*)interaction.intent;
            NSMutableString *nameString = [NSMutableString new];
            for (INPerson *person in messageIntent.recipients) {
                [nameString appendString:person.displayName];
            }
            
            self.nameLabel.text = nameString;
            
            self.contentTextView.text = messageIntent.content;
        } else if ([interaction.intent isKindOfClass:[INStartVideoCallIntent class]]) {
            INStartVideoCallIntent *videoIntent = (INStartVideoCallIntent *)[interaction intent];
            NSString *name = videoIntent.contacts[0].displayName;
            self.nameLabel.text = name;
        } else if ([interaction.intent isKindOfClass:[INStartAudioCallIntent class]]) {
            INStartAudioCallIntent *videoIntent = (INStartAudioCallIntent *)[interaction intent];
            NSString *name = videoIntent.contacts[0].displayName;
            self.nameLabel.text = name;
        } else if ([interaction.intent isKindOfClass:[INSearchForPhotosIntent class]]) {
            INSearchForPhotosIntent *intent = (INSearchForPhotosIntent *)[interaction intent];
            self.nameLabel.text = intent.peopleInPhoto[0].displayName;
            self.contentTextView.text = intent.albumName;
        }
        
        
        
        [self.view setNeedsLayout];
    }
    
    
    
    
    
    
    if (completion) {
        completion([self desiredSize]);
    }
}

- (CGSize)desiredSize {
    return [self extensionContext].hostedViewMaximumAllowedSize;
}

@end
