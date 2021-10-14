//
//  OCMQTTPublish.h
//  mqtt4oc
//
//  Created by tyzual on 6/29/15.
//
//

#ifndef MQTTPUBLISH_H_
#define MQTTPUBLISH_H_

#import <Foundation/Foundation.h>

#import "MQTTPacket.h"

#endif // MQTTPUBLISH_H_

@interface TTKMQTT(TTKMQTTPublish)

+(int) IM_MQTTSerialize_publish_buf:(unsigned char*)buf len:(int)buflen publisMsg:(TTKPublish*)publishMsg;

+(int) IM_MQTTDeserialize_publishMsg:(TTKPublish*)publishMsg buf:(unsigned char*)buf len:(unsigned int)buflen;

+(int) IM_MQTTSerialize_buf:(unsigned char*)buf len:(int)buflen ack:(TTKPublishAck*)ack;

+(int) IM_MQTTDeserialize_puback:(TTKPublishAck*)ack buf:(unsigned char*)buf len:(int)buflen;

+(int) MQTTSerialize_puback_buf:(unsigned char*)buf len:(int)buflen packetid:(unsigned short)packetid;

+(int) MQTTSerialize_pubrel_buf:(unsigned char*)buf len:(int)buflen dup:(unsigned char)dup packetid:(unsigned short)packetid;

+(int) MQTTSerialize_pubcomp_buf:(unsigned char*)buf len:(int)buflen packetid:(unsigned short)packetid;
@end
