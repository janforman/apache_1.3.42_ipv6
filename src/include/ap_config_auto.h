/*
 *  ap_config_auto.h -- Automatically determined configuration stuff
 *  THIS FILE WAS AUTOMATICALLY GENERATED - DO NOT EDIT!
 */

#ifndef AP_CONFIG_AUTO_H
#define AP_CONFIG_AUTO_H

/* check: #include <dlfcn.h> */
#ifndef HAVE_DLFCN_H
#define HAVE_DLFCN_H 1
#endif

/* check: #include <dl.h> */
#ifdef HAVE_DL_H
#undef HAVE_DL_H
#endif

/* check: #include <bstring.h> */
#ifdef HAVE_BSTRING_H
#undef HAVE_BSTRING_H
#endif

/* check: #include <crypt.h> */
#ifndef HAVE_CRYPT_H
#define HAVE_CRYPT_H 1
#endif

/* check: #include <unistd.h> */
#ifndef HAVE_UNISTD_H
#define HAVE_UNISTD_H 1
#endif

/* check: #include <sys/resource.h> */
#ifndef HAVE_SYS_RESOURCE_H
#define HAVE_SYS_RESOURCE_H 1
#endif

/* check: #include <sys/select.h> */
#ifndef HAVE_SYS_SELECT_H
#define HAVE_SYS_SELECT_H 1
#endif

/* check: #include <sys/processor.h> */
#ifdef HAVE_SYS_PROCESSOR_H
#undef HAVE_SYS_PROCESSOR_H
#endif

/* check: #include <sys/param.h> */
#ifndef HAVE_SYS_PARAM_H
#define HAVE_SYS_PARAM_H 1
#endif

/* determine: longest possible integer type */
#ifndef AP_LONGEST_LONG
#define AP_LONGEST_LONG long long
#endif

/* determine: use u_int32_t as 32bit unsigned int */
#ifndef ap_uint32_t
#define ap_uint32_t u_int32_t
#endif

/* determine: byte order of machine (12: little endian, 21: big endian) */
#ifndef AP_BYTE_ORDER
#define AP_BYTE_ORDER 12
#endif

/* determine: is off_t a quad */
#ifdef AP_OFF_T_IS_QUAD
#undef AP_OFF_T_IS_QUAD
#endif

/* determine: is void * a quad */
#ifndef AP_VOID_P_IS_QUAD
#define AP_VOID_P_IS_QUAD 1
#endif

/* build flag: -DLINUX=22 */
#ifndef LINUX
#define LINUX 22
#endif

/* build flag: -DHAVE_SET_DUMPABLE */
#ifndef HAVE_SET_DUMPABLE
#define HAVE_SET_DUMPABLE 1
#endif

/* build flag: -DINET6 */
#ifndef INET6
#define INET6 1
#endif

/* build flag: -Dss_family=__ss_family */
#ifndef ss_family
#define ss_family __ss_family
#endif

/* build flag: -Dss_len=__ss_len */
#ifndef ss_len
#define ss_len __ss_len
#endif

/* build flag: -DNO_DBM_REWRITEMAP */
#ifndef NO_DBM_REWRITEMAP
#define NO_DBM_REWRITEMAP 1
#endif

/* build flag: -DNO_DL_NEEDED */
#ifndef NO_DL_NEEDED
#define NO_DL_NEEDED 1
#endif

#endif /* AP_CONFIG_AUTO_H */
