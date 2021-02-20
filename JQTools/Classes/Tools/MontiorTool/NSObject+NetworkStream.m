//
//  NSObject+NetworkStream.m
//  JQTools
//
//  Created by 无故事王国 on 2021/2/19.
//

#import "NSObject+NetworkStream.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

uint64_t _lastBytes_CheckNetWorkBytes;

uint64_t _lastBytes_o;
uint64_t _lastBytes_i;

@implementation NSObject (NetworkStream)
+ (void )initCheck {
    _lastBytes_CheckNetWorkBytes = 0;
    _lastBytes_i = 0;
    _lastBytes_o = 0;
}

+ (long long )getNetWorkBytesPerSecond {

    long newBytes = [NSObject getGprsWifiFlowIOBytes];
    long currentBytes = 0;
    if ( _lastBytes_CheckNetWorkBytes > 0) {
        currentBytes = newBytes - _lastBytes_CheckNetWorkBytes;
    }
    _lastBytes_CheckNetWorkBytes = newBytes;
    return currentBytes;
}

+ (long long )getNetWorkIBytesPerSecond {
    long newIbytes = [NSObject getGprsWifiFlowIBytes];
    long currentIBytes = 0;

    if (_lastBytes_i > 0) {
        currentIBytes = newIbytes - _lastBytes_i;
    }
    _lastBytes_i = newIbytes;

    return currentIBytes;
}

+ (long long )getNetWorkOBytesPerSecond {

    long newObytes = [NSObject getGprsWifiFlowOBytes];
    long currentOBytes = 0;

    if (_lastBytes_o > 0) {
        currentOBytes = newObytes - _lastBytes_o;
    }
    _lastBytes_o = newObytes;

    return currentOBytes;
}


+(long long)getGprsWifiFlowIBytes{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    uint64_t iBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        //Wifi
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
        }
        //3G或者GPRS
        if (!strcmp(ifa->ifa_name, "pdp_ip0")){
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
        }
    }
    freeifaddrs(ifa_list);
    uint64_t bytes = 0;
    bytes = iBytes;

    return bytes;
}

/*获取网络流量信息*/
+ (long long )getGprsWifiFlowOBytes{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    uint64_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        //Wifi
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            oBytes += if_data->ifi_obytes;
        }
        //3G或者GPRS
        if (!strcmp(ifa->ifa_name, "pdp_ip0")){
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    uint64_t bytes = 0;
    bytes = oBytes;

    return bytes;
}

/*获取网络流量信息*/
+ (long long )getGprsWifiFlowIOBytes{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    uint64_t iBytes = 0;
    uint64_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        //Wifi
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
        //3G或者GPRS
        if (!strcmp(ifa->ifa_name, "pdp_ip0")){
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    uint64_t bytes = 0;
    bytes = iBytes + oBytes;

    return bytes;
}

//将bytes单位转换
+ (NSString *)convertStringWithbyte:(long)bytes{
    if(bytes < 1024){ // B
        return [NSString stringWithFormat:@"%ldB", bytes];
    }else if(bytes >= 1024 && bytes < 1024 * 1024){// KB
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024){// MB
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }else{ // GB
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}
@end
