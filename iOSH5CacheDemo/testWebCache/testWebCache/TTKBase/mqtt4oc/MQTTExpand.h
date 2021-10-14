//
//  OCMQTTExpand.h
//  mqtt4oc
//
//  Created by tyzual on 6/29/15.
//
//

#ifndef MQTTEXPAND_H_
#define MQTTEXPAND_H_

#import <Foundation/Foundation.h>

#import "MQTTPacket.h"

#endif // MQTTEXPAND_H_

@interface TTKMQTT(TTKMQTTExpand)

+(int) IM_MQTTSerialize_buf:(unsigned char*) buf len:(int)buflen expand:(TTKExpand*)expandMsg;

+(int) IM_MQTTDeserialize_expand:(TTKExpand*) expandMsg buf:(unsigned char*)buf len:(int)buflen;

@end
