#include <stdio.h>

char *do_cmd( const char *cmd, char *value );
int main()
{
    char cmd[1024] = "ls";
    char value[1024] = {0};
    do_cmd( cmd, value );
    printf( "%s", value );
    return 0;
}
