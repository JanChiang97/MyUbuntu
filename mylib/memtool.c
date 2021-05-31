#include<stdio.h>
#include <stdlib.h>

void usage( void )
{
    printf( "Usage:\n" );
    printf( "\tmemtool [address] [cnt]\n" );
    printf( "\tExample:\n" );
    printf( "\t\tmemtool 0xA0000000 20\n" );
}

void print( long int addr, unsigned int cnt )
{
    printf( "Reading %d count starting at addres 0x%.8lx\n\n", cnt, addr );
    printf( "0x%.8lx: 0x%.8x 0x%.8x 0x%.8x 0x%.8x\r\n", addr, ( ( int * )( addr ) )[0], ( ( int * )( addr ) )[1], ( ( int * )( addr ) )[2], ( ( int * )( addr ) )[3] );
}

int main( int argc, char **argv )
{
    unsigned int cnt;
    long int addr;

    if ( argc != 3 )
    {
        usage();
        return 1;
    }

    cnt = ( unsigned int )strtol( argv[2], 0, 16 );
    addr = ( long int )strtol( argv[1], 0, 16 );
    print( addr, cnt );
    return 0;
}
