#include<stdio.h>
#include <stdlib.h>

void usage( void )
{
    printf( "Usage:\n" );
    printf( "\tmemtool [address] [cnt]\n" );
    printf( "\tExample:\n" );
    printf( "\t\tmemtool 0xA0000000 20\n" );
}

void print( long int addr, long int cnt )
{
    printf( "Reading %.8x count starting at addres 0x%.8x\n\n", cnt, addr );
    printf( "0x%.8x: 0x%.8x 0x%.8x 0x%.8x 0x%.8x\r\n", addr, ( ( int * )( addr ) )[0], ( ( int * )( addr ) )[1], ( ( int * )( addr ) )[2], ( ( int * )( addr ) )[3] );
}

int main( int argc, char **argv )
{
    long int cnt;
    long int addr;

    if ( argc != 3 )
    {
        usage();
        return 1;
    }

    cnt = ( long int )strtol( argv[2], 0, 16 );
    addr = ( long int )strtol( argv[1], 0, 16 );
    printf( "Address: %s cnt:%d\n", argv[2], cnt );
    print( &addr, cnt );
    return 0;
}
