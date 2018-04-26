#ifndef AIPLAYER_H_ 
#define AIPLAYER_H_ 

/* typedef int (*aiplayer_callback)(const void *usrdata); */

struct aiplayer;

/*
 * create a new player
 */
struct aiplayer * aiplayer_new();

/*
 * delete an existed player
 */
int aiplayer_delete(struct aiplayer *player);

/*
 * start
 */
int aiplayer_start(struct aiplayer *player, const char *path);

/*
 * stop
 */
int aiplayer_stop(struct aiplayer *player);

#endif
