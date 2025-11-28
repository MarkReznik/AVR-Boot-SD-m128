#include "spi_sdcard.h"
#include <delay.h>



void SPI_init()
{
    // set CS, MOSI and SCK to output
    DDR_SPI = (1 << CS) | (1 << MOSI) | (1 << SCK);
    PORT_SPI|=(1 << CS);
    // enable pull up resistor in MISO
    DDR_SPI &= ~(1 << MISO);
    PORT_SPI &= ~(1 << MISO);
    //PORT_SPI |= (1 << MISO);

    // enable SPI, set as master, and clock to fosc/128
    SPCR = (1 << SPE) | (1 << MSTR) | (0 << SPR1) | (0 << SPR0);
}

unsigned char SPI_transfer(unsigned char data)
{
    // load data into register
    SPDR = data;
    // Wait for transmission complete
    while(!(SPSR & (1 << SPIF)))
    {
        #asm("wdr")
    };

    // return SPDR
    return SPDR;
}


void SD_powerUpSeq()
{
    unsigned char i;
    
    SPI_init();

    // make sure card is deselected
    CS_DISABLE();

    // give SD card time to power up
    delay_ms(1);

    // send 80 clock cycles to synchronize
    for(i = 0; i < 10; i++)
        SPI_transfer(0xFF);

    // deselect SD card
    CS_DISABLE();
    SPI_transfer(0xFF);
}

unsigned char SD_command(unsigned char cmd, unsigned long arg, unsigned char crc)
{
    unsigned char res,count;
    // transmit command to sd card
    SPI_transfer(cmd|0x40);

    // transmit argument
    SPI_transfer((unsigned char)(arg >> 24));
    SPI_transfer((unsigned char)(arg >> 16));
    SPI_transfer((unsigned char)(arg >> 8));
    SPI_transfer((unsigned char)(arg));

    // transmit crc
    SPI_transfer(crc|0x01);
    
    //wait response R1
    res = SD_readRes1();
    /*
    do {				
     res=SPI_transfer(0xFF);;
     count++; 
    } while ( ((res&0x80)!=0x00)&&(count<0xff) );
    */
    return res;
}


unsigned char SD_readRes1()
{
    unsigned char res1;
    unsigned int i = 0;

    // keep polling until actual data received
    //while((res1 = SPI_transfer(0xFF)) == 0xFF)
    while(((res1 = SPI_transfer(0xFF))&0x80) != 0x00)
    {
        i++;

        // if no data received for (254)8 bytes, break
        if(i > 0x1FF) break;
    }

    return res1;
}

unsigned char SD_goIdleState()
{
    unsigned char res1;
    // assert chip select
    SPI_transfer(0xFF);
    CS_ENABLE();
    //SPI_transfer(0xFF);

    // send CMD0
    res1 = SD_command(CMD0, CMD0_ARG, CMD0_CRC);

    // read response
    //res1 = SD_readRes1();

    // deassert chip select
    SPI_transfer(0xFF);
    CS_DISABLE();
    SPI_transfer(0xFF);

    return res1;
}

void SD_readRes7(unsigned char *res)
{
    // read response 1 in R7
    //res[0] = SD_readRes1();

    // if error reading R1, return
    if(res[0] > 1) return;

    // read remaining bytes
    res[1] = SPI_transfer(0xFF);
    res[2] = SPI_transfer(0xFF);
    res[3] = SPI_transfer(0xFF);
    res[4] = SPI_transfer(0xFF);
}

void SD_sendIfCond(unsigned char *res)
{
    // assert chip select
    SPI_transfer(0xFF);
    CS_ENABLE();
    //SPI_transfer(0xFF);

    // send CMD8
    res[0]=SD_command(CMD8, CMD8_ARG, CMD8_CRC);

    // read response
    SD_readRes7(res);

    // deassert chip select
    SPI_transfer(0xFF);
    CS_DISABLE();
    SPI_transfer(0xFF);
}

/*
void SD_readRes3_7(unsigned char *res)
{
    // read R1
    //res[0] = SD_readRes1();

    // if error reading R1, return
    if(res[0] > 1) return;

    // read remaining bytes
    res[1] = SPI_transfer(0xFF);
    res[2] = SPI_transfer(0xFF);
    res[3] = SPI_transfer(0xFF);
    res[4] = SPI_transfer(0xFF);
}
*/

void SD_readOCR(unsigned char *res)
{
    // assert chip select
    SPI_transfer(0xFF);
    CS_ENABLE();
    //SPI_transfer(0xFF);

    // send CMD58
    res[0] = SD_command(CMD58, CMD58_ARG, CMD58_CRC);

    // read response
    //SD_readRes3_7(res);
    SD_readRes7(res);

    // deassert chip select
    SPI_transfer(0xFF);
    CS_DISABLE();
    SPI_transfer(0xFF);
}

unsigned char SD_sendApp()
{
    unsigned char res1;
    // assert chip select
    SPI_transfer(0xFF);
    CS_ENABLE();
    //SPI_transfer(0xFF);

    // send CMD0
    res1 = SD_command(CMD55, CMD55_ARG, CMD55_CRC);

    // read response
    //res1 = SD_readRes1();

    // deassert chip select
    SPI_transfer(0xFF);
    CS_DISABLE();
    SPI_transfer(0xFF);

    return res1;
}

unsigned char SD_sendOpCond()
{
    unsigned char res1;
    // assert chip select
    SPI_transfer(0xFF);
    CS_ENABLE();
    //SPI_transfer(0xFF);

    // send CMD0
    res1 =  SD_command(ACMD41, ACMD41_ARG, ACMD41_CRC);

    // read response
    //res1 = SD_readRes1();

    // deassert chip select
    SPI_transfer(0xFF);
    CS_DISABLE();
    SPI_transfer(0xFF);

    return res1;
}

unsigned char SD_init()
{
    unsigned char res[5], cmdAttempts = 0;

    SD_powerUpSeq();

    // command card to idle
    while((res[0] = SD_goIdleState()) != 0x01)
    {
        cmdAttempts++;
        if(cmdAttempts > 100) return SD_ERROR;
    }

    // send interface conditions
    SD_sendIfCond(res);
    if(res[0] != 0x01)
    {
        return SD_ERROR;
    }

    // check echo pattern
    if(res[4] != 0xAA)
    {
        return SD_ERROR;
    }

    // attempt to initialize card
    cmdAttempts = 0;
    do
    {
        if(cmdAttempts > 100) return SD_ERROR;

        // send app cmd
        res[0] = SD_sendApp();

        // if no error in response
        if(res[0] < 2)
        {
            res[0] = SD_sendOpCond();
        }

        // wait
        if(res[0] != SD_READY)
            delay_ms(10);

        cmdAttempts++;
    }
    while(res[0] != SD_READY);

    // read OCR
    SD_readOCR(res);

    // check card is ready
    if(!(res[1] & 0x80)) return SD_ERROR;

    return SD_SUCCESS;
}

#define CMD17                   17
#define CMD17_CRC               0x00
#define SD_MAX_READ_ATTEMPTS    1563

/*******************************************************************************
 Read single 512 byte block
 token = 0xFE - Successful read
 token = 0x0X - Data error
 token = 0xFF - Timeout
*******************************************************************************/
unsigned char SD_readSingleBlock(unsigned long addr, unsigned char *buf, unsigned char *token)
{
    unsigned char res1, read;
    unsigned int i, readAttempts;
    #asm("wdr")
    addr*=512UL;
    // set token to none
    *token = 0xFF;

    // assert chip select
    SPI_transfer(0xFF);
    CS_ENABLE();
    //SPI_transfer(0xFF);

    // send CMD17
    res1 = SD_command(CMD17, addr, CMD17_CRC);

    // read R1
    //res1 = SD_readRes1();

    // if response received from card
    if(res1 != 0xFF)
    {
        // wait for a response token (timeout = 100ms)
        readAttempts = 0;
        while(++readAttempts != SD_MAX_READ_ATTEMPTS)
            if((read = SPI_transfer(0xFF)) != 0xFF) break;

        // if response token is 0xFE
        if(read == 0xFE)
        {
            // read 512 byte block
            for(i = 0; i < 512; i++) *buf++ = SPI_transfer(0xFF);

            // read 16-bit CRC
            SPI_transfer(0xFF);
            SPI_transfer(0xFF);
        }

        // set token to card response
        *token = read;
    }

    // deassert chip select
    SPI_transfer(0xFF);
    CS_DISABLE();
    SPI_transfer(0xFF);
    if(read==0xFE)
        return res1;
    else
        return SD_ERROR;
}

#define SD_BLOCK_LEN            512
#define SD_START_TOKEN          0xFE
#define CMD24_CRC           0x00
#define CMD24                   24
#define CMD24_ARG               0x00
#define SD_MAX_WRITE_ATTEMPTS   3907
/*******************************************************************************
 Write single 512 byte block
 token = 0x00 - busy timeout
 token = 0x05 - data accepted
 token = 0xFF - response timeout
*******************************************************************************/

unsigned char SD_writeSingleBlock(unsigned long addr, unsigned char *buf, unsigned char *token)
{
    unsigned char res1, read;
    unsigned int i, readAttempts;
    #asm("wdr")
    addr*=512UL;
    // set token to none
    *token = 0xFF;

    // assert chip select
    SPI_transfer(0xFF);
    CS_ENABLE();
    SPI_transfer(0xFF);

    // send CMD24
    res1=SD_command(CMD24, addr, CMD24_CRC);

    // read response
    //res1 = SD_readRes1();

    // if no error
    if(res1 == SD_READY)
    {
        // send start token
        SPI_transfer(SD_START_TOKEN);

        // write buffer to card
        for(i = 0; i < SD_BLOCK_LEN; i++) SPI_transfer(buf[i]);

        // wait for a response (timeout = 250ms)
        readAttempts = 0;
        while(++readAttempts != SD_MAX_WRITE_ATTEMPTS)
            if((read = SPI_transfer(0xFF)) != 0xFF) { *token = 0xFF; break; }

        // if data accepted
        if((read & 0x1F) == 0x05)
        {
            // set token to data accepted
            *token = 0x05;

            // wait for write to finish (timeout = 250ms)
            readAttempts = 0;
            while(SPI_transfer(0xFF) == 0x00){
                if(++readAttempts == SD_MAX_WRITE_ATTEMPTS){ 
                    *token = 0x00; 
                    break; 
                } 
            }
        }
    }

    // deassert chip select
    SPI_transfer(0xFF);
    CS_DISABLE();
    SPI_transfer(0xFF);

    return res1;
}
