#ifndef SKEGN_H_
#define SKEGN_H_

#define SKEGN_VERSION "1.0.5"

#if (!(defined SKEGN_CALL) || !(defined SKEGN_IMPORT_OR_EXPORT))
#    if defined __WIN32__ || defined _WIN32 || defined _WIN64
#       define SKEGN_CALL __stdcall
#       ifdef  SKEGN_IMPLEMENTION
#           define SKEGN_IMPORT_OR_EXPORT __declspec(dllexport)
#       else
#           define SKEGN_IMPORT_OR_EXPORT __declspec(dllimport)
#       endif
#    elif defined __ANDROID__ && !defined USE_FRE
#       define SKEGN_CALL
#       define SKEGN_IMPORT_OR_EXPORT
#    else
#       define SKEGN_CALL
#       define SKEGN_IMPORT_OR_EXPORT __attribute ((visibility("default")))
#    endif
#endif

#ifdef __cplusplus
extern "C" {
#endif

enum {
    SKEGN_MESSAGE_TYPE_JSON = 1,
    SKEGN_MESSAGE_TYPE_BIN
};

enum {
    SKEGN_OPT_INVALID  = 0,
    SKEGN_OPT_GET_VERSION,
    SKEGN_OPT_GET_MODULES,
    SKEGN_OPT_GET_TRAFFIC,

#ifdef USE_PROVISION
    SKEGN_SET_WIFI_STATUS,
    SKEGN_OPT_GET_PROVISION,
    SKEGN_GET_SERIAL_NUMBER,
#endif
    SKEGN_OPT_MAX
};

struct skegn;

typedef int (SKEGN_CALL *skegn_callback)(const void *usrdata, const char *id, int type, const void *message, int size);
SKEGN_IMPORT_OR_EXPORT struct skegn * SKEGN_CALL skegn_new(const char *cfg);
SKEGN_IMPORT_OR_EXPORT int SKEGN_CALL skegn_delete(struct skegn *engine);
SKEGN_IMPORT_OR_EXPORT int SKEGN_CALL skegn_start(struct skegn *engine, const char *param, char id[64], skegn_callback callback, const void *usrdata);
SKEGN_IMPORT_OR_EXPORT int SKEGN_CALL skegn_feed(struct skegn *engine, const void *data, int size);
SKEGN_IMPORT_OR_EXPORT int SKEGN_CALL skegn_stop(struct skegn *engine);
SKEGN_IMPORT_OR_EXPORT int SKEGN_CALL skegn_log(struct skegn *engine, const char *log);
SKEGN_IMPORT_OR_EXPORT int SKEGN_CALL skegn_get_device_id(char device_id[64]);
SKEGN_IMPORT_OR_EXPORT int SKEGN_CALL skegn_cancel(struct skegn *engine);
SKEGN_IMPORT_OR_EXPORT int SKEGN_CALL skegn_opt(struct skegn *engine, int opt, char *data, int size);

#ifdef __cplusplus
}
#endif
#endif
