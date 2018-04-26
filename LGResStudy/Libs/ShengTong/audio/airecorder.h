//
//  hellostream
//
//  Created by shun zhang on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef AIRECORDER_H_
#define AIRECORDER_H_

struct airecorder;

typedef int (*airecorder_callback)(const void * usrdata, const void * data, int size);

/*
 * create a new recorder
 */
struct airecorder * airecorder_new();

/*
 * delete an existed recorder
 */
int airecorder_delete(struct airecorder * recorder);

/*
 * start recorder
 */
int airecorder_start(struct airecorder * recorder, const char* wav_path,
                            airecorder_callback callback, const void * usrdata, int callback_interval);

/*
 * stop recorder
 */
int airecorder_stop(struct airecorder *recorder);

/*
 * playback
 */
int airecorder_playback(struct airecorder *recorder);

#endif
