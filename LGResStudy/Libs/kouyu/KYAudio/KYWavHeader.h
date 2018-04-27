//
//  KYWavHeader.h
//  KouyuDemo
//
//  Created by Attu on 2017/12/29.
//  Copyright © 2017年 Attu. All rights reserved.
//

#ifndef _KYWAVHEAdER_H_
#define _KYWAVHEAdER_H_

#ifdef __cplusplus
extern "C" {
#endif
    
    typedef struct
    {
        char riff[4];
        int riff_length;
        char riff_type[4];
        char fmt[4];
        int fmt_size;
        short fmt_code;
        short fmt_channel;
        int fmt_sampleRate;
        int fmt_bytePerSec;
        short fmt_blockAlign;
        short fmt_bitPerSample;
        char data[4];
        int dataSize;
        
    } WavHeader;
    
    
#ifdef __cplusplus
}
#endif

#endif /* KYWavHeader_h */
