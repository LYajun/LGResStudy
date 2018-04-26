#ifndef _WAVEHDR_H_
#define _WAVEHDR_H_

#ifdef __cplusplus
extern "C" {
#endif
    
typedef struct
{
    char riff_id[4];                                           //"RIFF"
    int riff_datasize;                                         // RIFF chunk data size
        
    char riff_type[4];                                       // "WAVE"
    char fmt_id[4];                                          // "fmt "
    int fmt_datasize;                                        // fmt chunk data size
    short fmt_compression_code;                   // 1 for PCM
    short fmt_channels;                                   // 1 or 2
    int fmt_sample_rate;                                  // samples per second
    int fmt_avg_bytes_per_sec;                       // sample_rate*block_align
    short fmt_block_align;                               // number bytes per sample bit_per_sample*channels/8
    short fmt_bit_per_sample;                         // bits of each sample.
        
    char data_id[4];                                         // "data"
    int data_datasize;                                       // data chunk size.
} WaveHeader;
    
 
#ifdef __cplusplus
}
#endif
    
#endif