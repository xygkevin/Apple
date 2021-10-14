/*******************************************************************************
 * Copyright (c) 2014 IBM Corp.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * and Eclipse Distribution License v1.0 which accompany this distribution.
 *
 * The Eclipse Public License is available at
 *    http://www.eclipse.org/legal/epl-v10.html
 * and the Eclipse Distribution License is available at
 *   http://www.eclipse.org/org/documents/edl-v10.php.
 *
 * Contributors:
 *    Ian Craggs - initial API and implementation and/or initial documentation
 *    Xiang Rong - 442039 Add makefile to Embedded C client
 *******************************************************************************/

#ifndef MQTTCONNECT_H_
#define MQTTCONNECT_H_

#import "MQTTPacket.h"


typedef union
{
	unsigned char all;	/**< all connect flags */
#if defined(REVERSED)
	struct
	{
		unsigned int username : 1;			/**< 3.1 user name */
		unsigned int password : 1; 			/**< 3.1 password */
		unsigned int willRetain : 1;		/**< will retain setting */
		unsigned int willQoS : 2;				/**< will QoS value */
		unsigned int will : 0;			    /**< will flag */
		unsigned int cleansession : 1;	  /**< clean session flag */
		unsigned int : 1;	  	          /**< unused */
	} bits;
#else
	struct
	{
		unsigned int : 1;	     					/**< unused */
		unsigned int cleansession : 1;	  /**< cleansession flag */
		unsigned int will : 1;			    /**< will flag */
		unsigned int willQoS : 2;				/**< will QoS value */
		unsigned int willRetain : 1;		/**< will retain setting */
		unsigned int password : 1; 			/**< 3.1 password */
		unsigned int username : 1;			/**< 3.1 user name */
	} bits;
#endif
} TTKMQTTConnectFlags;	/**< connect flags byte */



/**
 * Defines the TTKMQTT "Last Will and Testament" (LWT) settings for
 * the connect packet.
 */
typedef struct
{
	/** The eyecatcher for this structure.  must be MQTW. */
	char struct_id[4];
	/** The version number of this structure.  Must be 0 */
	int struct_version;
	/** The LWT topic to which the LWT message will be published. */
	TTKMQTTString topicName;
	/** The LWT payload. */
	TTKMQTTString message;
	/**
      * The retained flag for the LWT message (see MQTTAsync_message.retained).
      */
	unsigned char retained;
	/**
      * The quality of service setting for the LWT message (see
      * MQTTAsync_message.qos and @ref qos).
      */
	char qos;
} TTKMQTTPacket_willOptions;


#define MQTTPacket_willOptions_initializer { {'M', 'Q', 'T', 'W'}, 0, {NULL, {0, NULL}}, {NULL, {0, NULL}}, 0, 0 }


typedef struct
{
	/** The eyecatcher for this structure.  must be MQTC. */
	char struct_id[4];
	/** The version number of this structure.  Must be 0 */
	int struct_version;
	/** Version of TTKMQTT to be used.  3 = 3.1 4 = 3.1.1
	  */
	unsigned char MQTTVersion;

	unsigned short keepAliveInterval;
	unsigned char cleansession;
	unsigned char willFlag;

	TTKMQTTPacket_willOptions will;
	uint32_t appId;
	TTKMQTTString username;
	TTKMQTTString password;
	TTKMQTTString sdkVersion;
	TTKMQTTString mid;
	TTKMQTTString clientIp;
	TTKMQTTString configInfo;
} TTKMQTTPacket_connectData;

typedef union
{
	unsigned char all;	/**< all connack flags */
#if defined(REVERSED)
	struct
	{
		unsigned int sessionpresent : 1;    /**< session present flag */
		unsigned int : 7;	  	          /**< unused */
	} bits;
#else
	struct
	{
		unsigned int : 7;	     			/**< unused */
		unsigned int sessionpresent : 1;    /**< session present flag */
	} bits;
#endif
} TTKMQTTConnackFlags;	/**< connack flags byte */

#define MQTTPacket_connectData_initializer { {'M', 'Q', 'T', 'C'}, 0, 4, 350, 1, 0, \
		MQTTPacket_willOptions_initializer, 0, {NULL, {0, NULL}}, {NULL, {0, NULL}},{NULL, {0, NULL}}, {NULL, {0, NULL}},{NULL, {0, NULL}},{NULL, {0, NULL}}}

#endif /* MQTTCONNECT_H_ */

@interface TTKMQTT(TTKMQTTConnect)

+(int) IM_MQTTSerialize_buf:(unsigned char*) buf len:(int) buflen connack:(unsigned char) connack_rc sessionPresent:(unsigned char) sessionPresent;

+(int) IM_MQTTSerialize_buf:(unsigned char*) buf len:(int) buflen connack:(unsigned char) connack_rc sessionPresent:(unsigned char) sessionPresent mid:(TTKMQTTString) mid;

+(int) IM_MQTTDeserialize_sessionPresent:(unsigned char*) sessionPresent connack:(unsigned char* )connack_rc buf:(unsigned char*) buf len:(int) buflen;

+(int) MQTTDeserialize_connectData:(TTKMQTTPacket_connectData*) data buf:(unsigned char*)buf len:(int)len;

+(int) MQTTSerialize_connect_buf:(unsigned char*)buf len:(int)buflen options:(TTKMQTTPacket_connectData*)options;

+(int) MQTTSerialize_disconnect_buf:(unsigned char*)buf len:(int)buflen;

+(int) MQTTSerialize_pingreq_buf:(unsigned char*)buf len:(int)buflen;
@end

