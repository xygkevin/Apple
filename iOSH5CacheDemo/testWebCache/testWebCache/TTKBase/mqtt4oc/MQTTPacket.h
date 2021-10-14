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

#ifndef MQTTPACKET_H_
#define MQTTPACKET_H_

#import <Foundation/Foundation.h>

#if defined(__cplusplus) /* If this is a C++ compiler, use C linkage */
extern "C" {
#endif

#if defined(WIN32_DLL) || defined(WIN64_DLL)
  #define DLLImport __declspec(dllimport)
  #define DLLExport __declspec(dllexport)
#elif defined(LINUX_SO)
  #define DLLImport extern
  #define DLLExport  __attribute__ ((visibility ("default")))
#else
  #define DLLImport
  #define DLLExport  
#endif
#include <inttypes.h>
#include <stdbool.h>
enum TTKerrors
{
	TTKMQTTPACKET_BUFFER_TOO_SHORT = -2,
	TTKMQTTPACKET_READ_ERROR = -1,
	TTKMQTTPACKET_READ_COMPLETE
};

enum TTKmsgTypes
{
	TTKCONNECT = 1, TTKCONNACK, TTKPUBLISH, TTKPUBACK, TTKPUBREC, TTKPUBREL,
	TTKPUBCOMP, TTKSUBSCRIBE, TTKSUBACK, TTKUNSUBSCRIBE, TTKUNSUBACK,
	TTKPINGREQ, TTKPINGRESP, TTKDISCONNECT, TTKEXPAND
};

/**
 * Bitfields for the TTKMQTT header byte.
 */
typedef union
{
	unsigned char byte;	                /**< the whole byte */
#if defined(REVERSED)
	struct
	{
		unsigned int type : 4;			/**< message type nibble */
		unsigned int dup : 1;				/**< DUP flag bit */
		unsigned int qos : 2;				/**< QoS value, 0, 1 or 2 */
		unsigned int retain : 1;		/**< retained flag bit */
	} bits;
#else
	struct
	{
		unsigned int retain : 1;		/**< retained flag bit */
		unsigned int qos : 2;				/**< QoS value, 0, 1 or 2 */
		unsigned int dup : 1;				/**< DUP flag bit */
		unsigned int type : 4;			/**< message type nibble */
	} bits;
#endif
} TTKMQTTHeader;


/**
 * Bitfields for the TTKMQTT TTKPing header byte.
 */
typedef union
{
	unsigned char byte;	                /**< the whole byte */
#if defined(REVERSED)
	struct
	{
		unsigned int type : 4;			/**< message type nibble */
		unsigned int reserved : 2;				/**< DUP flag bit */
		unsigned int appIdFlag : 1;				/**���瑙���ゆ�烽����ゆ�烽��锟�appId flag*/
		unsigned int activeFlag : 1;		/** ���瑙���ゆ�烽����ゆ�烽����ゆ�烽����ゆ�烽����ゆ�烽����ゆ�锋��*/
	} bits;
#else
	struct
	{
		unsigned int activeFlag : 1;		/**< retained flag bit */
		unsigned int appIdFlag : 1;				/**< QoS value, 0, 1 or 2 */
		unsigned int reserved : 2;			/**< DUP flag bit */
		unsigned int type : 4;			/**< message type nibble */
	} bits;
#endif
} TTKMQTTPingHeader;

typedef union
{
	unsigned char byte;	                /**< the whole byte */
#if defined(REVERSED)
	struct
	{
		unsigned int type : 4;			/**< message type nibble */
		unsigned int version : 2;				/**< DUP flag bit */
		unsigned int flag : 2;				/**< QoS value, 0, 1 or 2 */			} bits;
#else
	struct
	{
		unsigned int flag : 2;				/**< retained flag bit */
		unsigned int version : 2;			/**< QoS value, 0, 1 or 2 */
		unsigned int type : 4;		/**< type */
	} bits;
#endif
} TTKIM_MQTTHeader;

/**
 * Data for a connect packet.
 */
typedef struct
{
	TTKMQTTHeader header;	/**< TTKMQTT header byte */
	union
	{
		unsigned char all;	/**< all connect flags */
#if defined(REVERSED)
		struct
		{
			bool username : 1;			/**< 3.1 user name */
			boolean password : 1; 			/**< 3.1 password */
			bool willRetain : 1;		/**< will retain setting */
			unsigned int willQoS : 2;	/**< will QoS value */
			bool will : 1;			/**< will flag */
			bool cleanstart : 1;	/**< cleansession flag */
			int : 1;	/**< unused */
		} bits;
#else
		struct
		{
			int : 1;	/**< unused */
			bool cleanstart : 1;	/**< cleansession flag */
			bool will : 1;			/**< will flag */
			unsigned int willQoS : 2;	/**< will QoS value */
			bool willRetain : 1;		/**< will retain setting */
			bool password : 1; 			/**< 3.1 password */
			bool username : 1;			/**< 3.1 user name */
		} bits;
#endif
	} flags;	/**< connect flags byte */

	char *Protocol, /**< TTKMQTT protocol name */
		*clientID,	/**< string client id */
		*clientVersion, /** < string client version */
		*mid, /** < string mid*/
		*userName,
		*pwd,
        *willTopic,	/**< will topic */
        *willMsg;	/**< will payload */

	int keepAliveTimer;		/**< keepalive timeout value in seconds */
	unsigned char version;	/**< TTKMQTT version number */
} TTKConnect;


/**
 * Data for a connack packet.
 */
typedef struct
{
	TTKMQTTHeader header; /**< TTKMQTT header byte */
	char rc; /**< connack return code */
} TTKConnack;


/**
 * Data for a packet with header only.
 */
typedef struct
{
	TTKMQTTHeader header;	/**< TTKMQTT header byte */
} TTKMQTTPacket;


typedef struct
{
	int len;
	char* data;
} MQTTLenString;

typedef struct
{
	char* cstring;
	MQTTLenString lenstring;
} TTKMQTTString;

#define MQTTString_initializer {NULL, {0, NULL}}

int MQTTstrlen(TTKMQTTString mqttstring);


/**
 * Data for a ping packet.
 */
typedef struct
{
	TTKMQTTPingHeader header;	/**< TTKMQTT header byte */
	uint8_t activeFlag;
	uint32_t appId;

} TTKPing;

#define Ping_initializer {{0},0,0};
/**
 * Data for a subscribe packet.
 */
typedef struct
{
	TTKIM_MQTTHeader header;	/**< TTKMQTT header byte */
	uint64_t msgId;		/**< TTKMQTT message id */
	uint32_t appId;
	TTKMQTTString topics;
	int qoss;		/**< list of corresponding QoSs */
} TTKSubscribe;

#define Subscribe_initializer {{0}, 0, 0,{NULL, {0, NULL}},0};
/**
 * Data for a suback packet.
 */
typedef struct
{
	TTKMQTTHeader header;	/**< TTKMQTT header byte */
	uint64_t msgId;		/**< TTKMQTT message id */
	//List* qoss;		/**< list of granted QoSs */
} TTKSuback;


/**
 * Data for an unsubscribe packet.
 */
typedef struct
{
	TTKMQTTHeader header;	/**< TTKMQTT header byte */
	uint64_t msgId;		/**< TTKMQTT message id */
	//List* topics;	/**< list of topic strings */
	int noTopics;	/**< topic count */
} TTKUnsubscribe;


/**
 * Data for a publish packet.
 */


/**
 * Data for a payload in get-packet.
 */


/**
 * Data for a expand packet.
 */
typedef struct {
	TTKIM_MQTTHeader header;	/**< TTKMQTT header byte */
	uint64_t msgId;		/**< TTKMQTT message id */
	uint32_t appId;
	uint8_t ext_cmd;
	uint8_t code; // ��������ゆ��ack�����ゆ�锋�堕����ゆ�� code �����ゆ�烽����ゆ�烽����ゆ�烽����ゆ��
	unsigned char* payload;	/**< binary payload, length delimited */
	uint32_t payloadlen;

} TTKExpand;



#define Expand_initializer {{0},0,0,0,0,NULL,0}
/**
 * Data for one of the ack packets.
 */
typedef struct
{
	TTKIM_MQTTHeader header;	/**< TTKMQTT header byte */
	uint64_t msgId;		/**< TTKMQTT message id */
	uint32_t appId;
	uint8_t code;
} TTKAck;

#define Ack_initializer {{0},0,0,0}
typedef struct
{
	TTKMQTTHeader header;	/**< TTKMQTT header byte */
	TTKMQTTString topic;	/**< topic string */
	//int topiclen;
	uint8_t type;
	uint64_t msgId;		/**< TTKMQTT message id */
	uint32_t appId;
	TTKMQTTString useId;
	unsigned char* payload;	/**< binary payload, length delimited */
	uint16_t payloadlen;	/**< payload length */
	uint8_t qos;
	uint8_t dup;
	uint8_t retained;
} TTKPublish;

typedef struct
{
	TTKMQTTHeader header;	/**< TTKMQTT header byte */
	uint8_t type;
	uint64_t msgId;		/**< TTKMQTT message id */
	uint32_t appId;
	TTKMQTTString useId;
	uint8_t code;
	uint64_t ackId;
	uint64_t utime;

} TTKPublishAck;

#define PublishAck_initializer {{0},0, 0,0, {NULL, {0, NULL}},0, 0, 0}
#define Publish_initializer {{0}, {NULL, {0, NULL}}, 0, 0,0, {NULL, {0, NULL}}, NULL, 0,1,0,0}
#define MQTTPacket_initializer {0,0,0}
	
typedef struct {
	uint8_t type;
	int fixedHead;
	int len;

}TTKMQTTPacketHead;

#ifdef __cplusplus /* If this is a C++ compiler, use C linkage */
}
#endif

#endif /* MQTTPACKET_H_ */

typedef int (*TTKGETFN)(unsigned char*, int);

@interface TTKMQTT : NSObject


+(int) MQTTPacket_read_buf:(unsigned char*)buf len:(int) len getfn:(TTKGETFN) getfn;
+(uint64_t) generate_uuid;
+(int)MQTTPacket_encode_buf:(unsigned char *)buf len:(int) len;
+(int)MQTTPacket_read_packet_buf:(unsigned char *)buf len:(int) len packetHead:(TTKMQTTPacketHead *)trp;
+(int)IM_MQTTSerilize_ping_buf:(unsigned char *)buf len:(int) len ping:(TTKPing *)ack;
@end

