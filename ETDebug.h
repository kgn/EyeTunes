#import <Foundation/Foundation.h>

#ifdef ET_DEBUG
#define ETLog NSLog
#else
#define ETLog NullLog
#endif

void NullLog(NSString *format, ...);
