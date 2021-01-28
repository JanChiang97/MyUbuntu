#include <stdio.h>
#include "mytool.h"
#include <string.h>

int do_cmd( const char *cmd, char *tmp )
{
    FILE *fp;
    int ret = 0;

    if ( ( cmd == NULL ) || ( strlen( cmd ) < 1 ) )
    {
        printf( "cmd:[%s] err!\n", cmd );
        return ERR;
    }

    fp = popen( cmd, "r" );

    if ( NULL == fp )
    {
        perror( "popen do err\n" );
        return ERR;
    }

    if ( tmp )
    {
        ret = fread( tmp, 1, BUFFSIZE, fp );

        if ( 0 > ret )
        {
            pclose( fp );
            perror( "popen read\n" );
            return ERR;
        }
    }

    ret = pclose( fp );

    if ( -1 == ret )
    {
        perror( "popen close\n" );
        return ERR;
    }

    return ret;
}

