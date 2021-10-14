//
//  OCMQTTUnsubscribe.h
//  mqtt4oc
//
//  Created by tyzual on 6/29/15.
//
//

#ifndef MQTTUNSUBSCRIBE_H_
#define MQTTUNSUBSCRIBE_H_

#import <Foundation/Foundation.h>

#import "MQTTPacket.h"

#endif // MQTTUNSUBSCRIBE_H_

@interface TTKMQTT(TTKMQTTUnsubscribe)

+(int) IM_MQTTSerialize_unsubscribe_buf:(unsigned char*)buf len:(int)buflen sub:(TTKSubscribe *)sub;
+(int) IM_MQTTDeserialize_unsubscribe:(TTKSubscribe *)sub buf:(unsigned char*)buf len:(int)buflen;

+(int) IM_MQTTSerialize_unsuback_buf:(unsigned char*)buf len:(int)buflen ack:(TTKAck *)ack;
+(int) IM_MQTTDeserialize_unsuback:(TTKAck *)ack buf:(unsigned char*)buf len:(int)buflen;

@end
