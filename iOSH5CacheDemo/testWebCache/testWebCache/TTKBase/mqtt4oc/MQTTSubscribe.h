//
//  OCMQTTSubscribe.h
//  mqtt4oc
//
//  Created by tyzual on 6/29/15.
//
//

#ifndef MQTTSUBSCRIBE_H_
#define MQTTSUBSCRIBE_H_

#import <Foundation/Foundation.h>

#import "MQTTPacket.h"

#endif // MQTTSUBSCRIBE_H_

@interface TTKMQTT(TTKMQTTSubscribe)

+(int) IM_MQTTSerialize_subscribe_buf:(unsigned char*)buf len:(int) buflen sub:(TTKSubscribe *)sub;

+(int) IM_MQTTDeserialize_subscribe:(TTKSubscribe *)sub buf:(unsigned char*)buf len:(int)buflen;

+(int) IM_MQTTSerialize_suback_buf:(unsigned char*)buf len:(int)buflen ack:(TTKAck *)ack;

+(int) IM_MQTTDeserialize_suback:(TTKAck *)ack buf:(unsigned char*)buf len:(int)buflen;

@end
