#import <Foundation/Foundation.h>

#ifdef ET_DEBUG
#define ETLog NSLog
#else
#define ETLog NullLog
#endif

#define	ET_EXPERIMENTAL_PERSISTENT_ID 0

void NullLog(NSString *format, ...);
