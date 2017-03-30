//
//  BreinCTools.h
//  Pods
//
//  Created by Marco on 24.03.17.
//
//

#ifndef BreinCTools_h
#define BreinCTools_h

#include <stdio.h>

struct ifaddrs {
    struct ifaddrs  *ifa_next;
    char            *ifa_name;
    unsigned int     ifa_flags;
    struct sockaddr *ifa_addr;
    struct sockaddr *ifa_netmask;
    struct sockaddr *ifa_dstaddr;
    void            *ifa_data;
};

extern int getifaddrs(struct ifaddrs **);
extern void freeifaddrs(struct ifaddrs *);


#endif /* BreinCTools_h */
