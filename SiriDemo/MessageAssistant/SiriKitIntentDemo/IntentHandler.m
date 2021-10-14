//
//  IntentHandler.m
//  SiriKitIntentDemo
//
//  Created by uwei on 9/8/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "IntentHandler.h"

// As an example, this class is set up to handle the Workout intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Start my workout using <myApp>"
// "Pause my workout using <myApp>"
// "Resume my workout using <myApp>"
// "Cancel my workout using <myApp>"
// "End my workout using <myApp>"

@interface IntentHandler () <INStartWorkoutIntentHandling, INPauseWorkoutIntentHandling, INResumeWorkoutIntentHandling, INCancelWorkoutIntentHandling, INEndWorkoutIntentHandling, INSendMessageIntentHandling, INStartAudioCallIntentHandling, INStartVideoCallIntentHandling, INSearchCallHistoryIntentHandling, INCallsDomainHandling, INSearchForPhotosIntentHandling, INStartPhotoPlaybackIntentHandling, INRequestRideIntentHandling, INGetRideStatusIntentHandling, INListRideOptionsIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    id handler = nil;
    
    NSLog(@"Intent identifier:%@", intent.description);
    
    // You can substitute other objects for self based on the specific intent.
    if ([intent isKindOfClass:[INStartWorkoutIntent class]] ||
        [intent isKindOfClass:[INPauseWorkoutIntent class]] ||
        [intent isKindOfClass:[INResumeWorkoutIntent class]] ||
        [intent isKindOfClass:[INCancelWorkoutIntent class]] ||
        [intent isKindOfClass:[INEndWorkoutIntent class]] ||
        [intent isKindOfClass:[INSendMessageIntent class]] ||
        [intent isKindOfClass:[INStartVideoCallIntent class]]||
        [intent isKindOfClass:[INStartAudioCallIntent class]] ||
        [intent isKindOfClass:[INSearchCallHistoryIntent class]] ||
        [intent isKindOfClass:[INSearchForPhotosIntent class]]||
        [intent isKindOfClass:[INStartPhotoPlaybackIntent class]] ||
        [intent isKindOfClass:[INRequestRideIntent class]] ||
        [intent isKindOfClass:[INGetRideStatusIntent class]] ||
        [intent isKindOfClass:[INListRideOptionsIntent class]]
        ) {
        handler = self;
    }
    
    return handler;
}

#pragma mark - INStartWorkoutIntentHandling

// Implement resolution methods to provide additional information about your intent (optional).

- (void)resolveIsOpenEndedForStartWorkout:(INStartWorkoutIntent *)startWorkoutIntent withCompletion:(void (^)(INBooleanResolutionResult * _Nonnull))completion {
    INBooleanResolutionResult *resolutionResult = [INBooleanResolutionResult successWithResolvedValue:NO];
    completion(resolutionResult);
}

- (void)resolveGoalValueForStartWorkout:(INStartWorkoutIntent *)startWorkoutIntent withCompletion:(void (^)(INDoubleResolutionResult * _Nonnull))completion {
    INDoubleResolutionResult *resolutionResult = [INDoubleResolutionResult successWithResolvedValue:5];
    completion(resolutionResult);
}

- (void)resolveWorkoutGoalUnitTypeForStartWorkout:(INStartWorkoutIntent *)startWorkoutIntent withCompletion:(void (^)(INWorkoutGoalUnitTypeResolutionResult * _Nonnull))completion {
    INWorkoutGoalUnitTypeResolutionResult *resolutionResult = [INWorkoutGoalUnitTypeResolutionResult successWithResolvedValue:INWorkoutGoalUnitTypeMinute];
    completion(resolutionResult);
}

- (void)resolveWorkoutLocationTypeForStartWorkout:(INStartWorkoutIntent *)startWorkoutIntent withCompletion:(void (^)(INWorkoutLocationTypeResolutionResult * _Nonnull))completion {
    INWorkoutLocationTypeResolutionResult *resolutionResult = [INWorkoutLocationTypeResolutionResult successWithResolvedValue:INWorkoutLocationTypeIndoor];
    completion(resolutionResult);
}

- (void)resolveWorkoutNameForStartWorkout:(INStartWorkoutIntent *)startWorkoutIntent withCompletion:(void (^)(INSpeakableStringResolutionResult * _Nonnull))completion {
    // The INSpeakableString's identifier would match the Vocabulary item synced up in the AppIntentVocabulary.plist
    INSpeakableString *resolvedWorkoutName = [[INSpeakableString alloc] initWithIdentifier:@"latissimus_dorsi_pulldown" spokenPhrase:@"Lat Pulldown"  pronunciationHint:@"lat pull down"];
    INSpeakableStringResolutionResult *resolutionResult = [INSpeakableStringResolutionResult successWithResolvedString:resolvedWorkoutName];
    completion(resolutionResult);
}

// Once resolution is completed, perform validation on the intent and provide confirmation (optional).

- (void)confirmStartWorkout:(INStartWorkoutIntent *)startWorkoutIntent completion:(void (^)(INStartWorkoutIntentResponse * _Nonnull))completion {
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INStartWorkoutIntent class])];
    INStartWorkoutIntentResponse *response = [[INStartWorkoutIntentResponse alloc] initWithCode:INStartWorkoutIntentResponseCodeReady userActivity:userActivity];
    completion(response);
}

// Handle the completed intent (required).

- (void)handleStartWorkout:(INStartWorkoutIntent *)startWorkoutIntent completion:(void (^)(INStartWorkoutIntentResponse * _Nonnull))completion {
    // Implement your application logic to start a workout here.
    
    // Update application state by updating NSUserActivity.
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INStartWorkoutIntent class])];
    INStartWorkoutIntentResponse *response = [[INStartWorkoutIntentResponse alloc] initWithCode:INStartWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

// Implement handlers for each intent you wish to handle.  As an example for workouts, you may wish to handle pause, resume, cancel, and end.

#pragma mark - INPauseWorkoutIntentHandling

- (void)handlePauseWorkout:(INPauseWorkoutIntent *)pauseWorkoutIntent completion:(void (^)(INPauseWorkoutIntentResponse * _Nonnull))completion {
    // Implement your application logic to pause a workout here.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INPauseWorkoutIntent class])];
    INPauseWorkoutIntentResponse *response = [[INPauseWorkoutIntentResponse alloc] initWithCode:INPauseWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

#pragma mark - INResumeWorkoutIntentHandling

- (void)handleResumeWorkout:(INResumeWorkoutIntent *)resumeWorkoutIntent completion:(void (^)(INResumeWorkoutIntentResponse * _Nonnull))completion {
    // Implement your application logic to resume a workout here.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INResumeWorkoutIntent class])];
    INResumeWorkoutIntentResponse *response = [[INResumeWorkoutIntentResponse alloc] initWithCode:INResumeWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

#pragma mark - INCancelWorkoutIntentHandling

- (void)handleCancelWorkout:(INCancelWorkoutIntent *)cancelWorkoutIntent completion:(void (^)(INCancelWorkoutIntentResponse * _Nonnull))completion {
    // Implement your application logic to cancel a workout here.
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INCancelWorkoutIntent class])];
    INCancelWorkoutIntentResponse *response = [[INCancelWorkoutIntentResponse alloc] initWithCode:INCancelWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

#pragma mark - INEndWorkoutIntentHandling

- (void)handleEndWorkout:(INEndWorkoutIntent *)endWorkoutIntent completion:(void (^)(INEndWorkoutIntentResponse * _Nonnull))completion {
    // Implement your application logic to end a workout here.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INEndWorkoutIntent class])];
    INEndWorkoutIntentResponse *response = [[INEndWorkoutIntentResponse alloc] initWithCode:INEndWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

#pragma mark - INSendingMessageIntentHandling

- (void)resolveContentForSendMessage:(INSendMessageIntent *)intent withCompletion:(void (^)(INStringResolutionResult * _Nonnull))completion {
    INStringResolutionResult *result = nil;
    if (intent.content) {
        result = [INStringResolutionResult successWithResolvedString:intent.content];
    } else {
        // if without value please insult to user
        result = [INStringResolutionResult needsValue];
    }
    
    completion(result);
}

- (void)resolveRecipientsForSendMessage:(INSendMessageIntent *)intent withCompletion:(void (^)(NSArray<INPersonResolutionResult *> * _Nonnull))completion {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"count = %lu", intent.recipients.count);
//    completion(@[[INStringResolutionResult needsValue]]);
    if (intent.recipients.count <= 0) {
        completion(@[[INStringResolutionResult needsValue]]);
        return;
    }
    
    NSMutableArray<INPersonResolutionResult *> *resolutionResults = [[NSMutableArray alloc] init];
    
    for (INPerson *recipient in intent.recipients) {
        [resolutionResults addObject:[INPersonResolutionResult successWithResolvedPerson:recipient]];
    }
    
    completion(resolutionResults);
}


- (void)confirmSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse * _Nonnull))completion {
    INSendMessageIntentResponse *response = nil;
    NSUserActivity *activity = nil;
    if (intent.recipients.count <= 0 || !intent.content) { //check
        response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeFailure userActivity:activity];
    } else {
        response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeSuccess userActivity:activity];
    }
    
    completion(response);
}

- (void)handleSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse * _Nonnull))completion {
    INSendMessageIntentResponse *response = [[INSendMessageIntentResponse alloc] initWithCode:(INSendMessageIntentResponseCodeSuccess) userActivity:nil];
    completion(response);
    // 业务逻辑实现
}


#pragma mark - INStartVideoCallIntentHandling
- (void)resolveContactsForStartVideoCall:(INStartVideoCallIntent *)intent withCompletion:(void (^)(NSArray<INPersonResolutionResult *> * _Nonnull))completion {
    if (intent.contacts.count <= 0) {
        completion(@[[INPersonResolutionResult needsValue]]);
        return;
    }
    
    NSMutableArray<INPersonResolutionResult *> *results = [NSMutableArray new];
    for (INPerson *person in intent.contacts) {
        [results addObject:[INPersonResolutionResult successWithResolvedPerson:person]];
    }
    
    completion(results);
}

- (void)confirmStartVideoCall:(INStartVideoCallIntent *)intent completion:(void (^)(INStartVideoCallIntentResponse * _Nonnull))completion {
    INStartVideoCallIntentResponse *response = nil;
    NSUserActivity *activity = nil;
    if (intent.contacts.count > 0) {
        response = [[INStartVideoCallIntentResponse alloc] initWithCode:(INStartVideoCallIntentResponseCodeReady) userActivity:activity];
    } else {
        response = [[INStartVideoCallIntentResponse alloc] initWithCode:(INStartVideoCallIntentResponseCodeFailure) userActivity:activity];
    }
    
    completion(response);
}

- (void)handleStartVideoCall:(INStartVideoCallIntent *)intent completion:(void (^)(INStartVideoCallIntentResponse * _Nonnull))completion {
    INStartVideoCallIntentResponse *response = [[INStartVideoCallIntentResponse alloc] initWithCode:(INStartVideoCallIntentResponseCodeReady) userActivity:nil];
    completion(response);
    // 业务逻辑实现
}

#pragma mark - INStartAudioCallIntentHandling
- (void)resolveContactsForStartAudioCall:(INStartAudioCallIntent *)intent withCompletion:(void (^)(NSArray<INPersonResolutionResult *> * _Nonnull))completion {
    if (intent.contacts.count <= 0) {
        completion(@[[INPersonResolutionResult needsValue]]);
        return;
    }
    
    NSMutableArray<INPersonResolutionResult *> *results = [NSMutableArray new];
    for (INPerson *person in intent.contacts) {
        [results addObject:[INPersonResolutionResult successWithResolvedPerson:person]];
    }
    
    completion(results);
}

- (void)confirmStartAudioCall:(INStartAudioCallIntent *)intent completion:(void (^)(INStartAudioCallIntentResponse * _Nonnull))completion {
    INStartAudioCallIntentResponse *response = nil;
    NSUserActivity *activity = nil;
    if (intent.contacts.count > 0) {
        response = [[INStartAudioCallIntentResponse alloc] initWithCode:(INStartAudioCallIntentResponseCodeReady) userActivity:activity];
    } else {
        response = [[INStartAudioCallIntentResponse alloc] initWithCode:(INStartAudioCallIntentResponseCodeFailure) userActivity:activity];
    }
    
    completion(response);
}

- (void)handleStartAudioCall:(INStartAudioCallIntent *)intent completion:(void (^)(INStartAudioCallIntentResponse * _Nonnull))completion {
    INStartAudioCallIntentResponse *response = [[INStartAudioCallIntentResponse alloc] initWithCode:(INStartAudioCallIntentResponseCodeReady) userActivity:nil];
    completion(response);
    // 业务逻辑实现
}

#pragma mark - INSearchCallHistoryIntentHandling
- (void)resolveRecipientForSearchCallHistory:(INSearchCallHistoryIntent *)intent withCompletion:(void (^)(INPersonResolutionResult * _Nonnull))completion {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (!intent.recipient) {
        completion([INPersonResolutionResult needsValue]);
        return;
    }
    
    completion([INPersonResolutionResult successWithResolvedPerson:intent.recipient]);
    
}

- (void)resolveCallTypeForSearchCallHistory:(INSearchCallHistoryIntent *)intent withCompletion:(void (^)(INCallRecordTypeResolutionResult * _Nonnull))completion {
    if (!intent.recipient) {
        completion([INCallRecordTypeResolutionResult needsValue]);
        return;
    }
    
    INCallRecordTypeResolutionResult *result = [INCallRecordTypeResolutionResult successWithResolvedValue:intent.callType];
    completion(result);
}

- (void)confirmSearchCallHistory:(INSearchCallHistoryIntent *)intent completion:(void (^)(INSearchCallHistoryIntentResponse * _Nonnull))completion {
    INSearchCallHistoryIntentResponse *response = nil;
    if (intent.recipient) {
        response = [[INSearchCallHistoryIntentResponse alloc] initWithCode:(INSearchCallHistoryIntentResponseCodeReady) userActivity:nil];
    } else {
        response = [[INSearchCallHistoryIntentResponse alloc] initWithCode:(INSearchCallHistoryIntentResponseCodeFailure) userActivity:nil];
    }
    
    completion(response);
}

- (void)handleSearchCallHistory:(INSearchCallHistoryIntent *)intent completion:(void (^)(INSearchCallHistoryIntentResponse * _Nonnull))completion {
    INSearchCallHistoryIntentResponse *response = [[INSearchCallHistoryIntentResponse alloc] initWithCode:(INSearchCallHistoryIntentResponseCodeReady) userActivity:nil];
    completion(response);
}

#pragma mark - INSearchPhotoIntentHandling
- (void)resolveAlbumNameForSearchForPhotos:(INSearchForPhotosIntent *)intent withCompletion:(void (^)(INStringResolutionResult * _Nonnull))completion {
    if (!intent.albumName) {
        NSLog(@"album not find! %@", NSStringFromSelector(_cmd));
        completion([INStringResolutionResult needsValue]);
        return;
    }
    
    
    completion([INStringResolutionResult successWithResolvedString:intent.albumName]);
}
- (void)resolveLocationCreatedForSearchForPhotos:(INSearchForPhotosIntent *)intent withCompletion:(void (^)(INPlacemarkResolutionResult * _Nonnull))completion {
    if (!intent.locationCreated) {
        NSLog(@"album not find! %@", NSStringFromSelector(_cmd));
        completion([INPlacemarkResolutionResult needsValue]);
        return;
    }
    
    
    completion([INPlacemarkResolutionResult successWithResolvedPlacemark:intent.locationCreated]);
}
- (void)resolvePeopleInPhotoForSearchForPhotos:(INSearchForPhotosIntent *)intent withCompletion:(void (^)(NSArray<INPersonResolutionResult *> * _Nonnull))completion {
    if (intent.peopleInPhoto.count <= 0) {
        NSLog(@"album not find! %@", NSStringFromSelector(_cmd));
        completion(@[[INPersonResolutionResult needsValue]]);
        return;
    }
    
    
    
    
    completion(@[[INPersonResolutionResult needsValue]]);
}

- (void)resolveDateCreatedForSearchForPhotos:(INSearchForPhotosIntent *)intent withCompletion:(void (^)(INDateComponentsRangeResolutionResult * _Nonnull))completion {
    if (!intent.dateCreated) {
        NSLog(@"album not find! %@", NSStringFromSelector(_cmd));
        completion([INDateComponentsRangeResolutionResult needsValue]);
        return;
    }
    
    
    completion([INDateComponentsRangeResolutionResult successWithResolvedDateComponentsRange:intent.dateCreated]);
}

- (void)confirmSearchForPhotos:(INSearchForPhotosIntent *)intent completion:(void (^)(INSearchForPhotosIntentResponse * _Nonnull))completion {
    INSearchForPhotosIntentResponse *response = nil;
    if (intent.albumName) {
        response = [[INSearchForPhotosIntentResponse alloc] initWithCode:(INSearchForPhotosIntentResponseCodeReady) userActivity:nil];
    } else {
        response = [[INSearchForPhotosIntentResponse alloc] initWithCode:INSearchForPhotosIntentResponseCodeFailure userActivity:nil];
    }
    
    completion(response);
    
}

- (void)handleSearchForPhotos:(INSearchForPhotosIntent *)intent completion:(void (^)(INSearchForPhotosIntentResponse * _Nonnull))completion {
    INSearchForPhotosIntentResponse *response = [[INSearchForPhotosIntentResponse alloc] initWithCode:(INSearchForPhotosIntentResponseCodeReady) userActivity:nil];
    completion(response);
}

#pragma mark - RideHandling

- (void)resolvePickupLocationForRequestRide:(INRequestRideIntent *)intent withCompletion:(void (^)(INPlacemarkResolutionResult * _Nonnull))completion {
    
}

- (void)resolveDropOffLocationForRequestRide:(INRequestRideIntent *)intent withCompletion:(void (^)(INPlacemarkResolutionResult * _Nonnull))completion {
    
}

- (void)confirmRequestRide:(INRequestRideIntent *)intent completion:(void (^)(INRequestRideIntentResponse * _Nonnull))completion {
    
}

- (void)handleRequestRide:(INRequestRideIntent *)requestRideIntent
               completion:(void (^)(INRequestRideIntentResponse *requestRideIntentResponse))completion {
    INRideStatus* status = [[INRideStatus alloc] init];
    
    // Create the request in my app's ride booking software.
    // Get the resulting request ID to use for configuring the response.
//    status.rideIdentifier = [self createNewRideRequestWithStartingLocation:requestRideIntent.pickupLocation endingLocation:requestRideIntent.dropOffLocation partySize:requestRideIntent.partySize paymentMethod:requestRideIntent.paymentMethod];
    
    // Configure the pickup and dropoff information.
//    status.estimatedPickupDate = [self estimatedPickupDateForRideRequest:status.rideIdentifier];
    status.pickupLocation = requestRideIntent.pickupLocation;
    status.dropOffLocation = requestRideIntent.dropOffLocation;
    
    // Retrieve information about the assigned vehicle and driver (if any).
//    status.vehicle = [self vehicleForRideRequest:status.rideIdentifier];
//    status.driver = [self driverForRideRequest:status.rideIdentifier];
    
    // Configure the vehicle type and pricing.
//    status.rideOption = [self rideOptionForRideRequest:status.rideIdentifier];
    
    // Commit the request and get the current status.
//    status.phase = [self completeBookingForRideRequest:status.rideIdentifier];
    
    // Use the status to determine the success or failure of the request.
    INRequestRideIntentResponseCode responseCode;
    if (status.phase == INRidePhaseReceived)
        responseCode = INRequestRideIntentResponseCodeInProgress;
    else if (status.phase == INRidePhaseConfirmed)
        responseCode = INRequestRideIntentResponseCodeSuccess;
    else
        responseCode = INRequestRideIntentResponseCodeFailure;
    
    // Create the response object and fill it with the status information.
    INRequestRideIntentResponse* response = [[INRequestRideIntentResponse alloc]
                                             initWithCode:responseCode userActivity:nil];
    response.rideStatus = status;
    
    // Return the response to SiriKit.
    completion(response);
}



@end
