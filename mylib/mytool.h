#ifndef __MYTOOL_H
#define __MYTOOL_H

#ifndef ERR
#define ERR         (-1)
#endif

#ifndef BUFFSIZE
#define BUFFSIZE    (0x01 << 10)
#endif

int do_cmd( const char *cmd, char *tmp );

#endif
