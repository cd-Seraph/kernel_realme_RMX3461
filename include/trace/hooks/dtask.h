/* SPDX-License-Identifier: GPL-2.0 */
#undef TRACE_SYSTEM
#define TRACE_SYSTEM dtask
#define TRACE_INCLUDE_PATH trace/hooks

#if !defined(_TRACE_HOOK_DTASK_H) || defined(TRACE_HEADER_MULTI_READ)
#define _TRACE_HOOK_DTASK_H
#include <linux/tracepoint.h>
#include <trace/hooks/vendor_hooks.h>
/*
 * Following tracepoints are not exported in tracefs and provide a
 * mechanism for vendor modules to hook and extend functionality
 */
#if defined(CONFIG_TRACEPOINTS) && defined(CONFIG_ANDROID_VENDOR_HOOKS)
struct mutex;
DECLARE_HOOK(android_vh_mutex_wait_start,
	TP_PROTO(struct mutex *lock),
	TP_ARGS(lock));
DECLARE_HOOK(android_vh_mutex_wait_finish,
	TP_PROTO(struct mutex *lock),
	TP_ARGS(lock));

struct rw_semaphore;
DECLARE_HOOK(android_vh_rwsem_read_wait_start,
	TP_PROTO(struct rw_semaphore *sem),
	TP_ARGS(sem));
DECLARE_HOOK(android_vh_rwsem_read_wait_finish,
	TP_PROTO(struct rw_semaphore *sem),
	TP_ARGS(sem));
DECLARE_HOOK(android_vh_rwsem_write_wait_start,
	TP_PROTO(struct rw_semaphore *sem),
	TP_ARGS(sem));
DECLARE_HOOK(android_vh_rwsem_write_wait_finish,
	TP_PROTO(struct rw_semaphore *sem),
	TP_ARGS(sem));

struct task_struct;
DECLARE_HOOK(android_vh_sched_show_task,
	TP_PROTO(struct task_struct *task),
	TP_ARGS(task));
#else
#define trace_android_vh_mutex_wait_start(lock)
#define trace_android_vh_mutex_wait_finish(lock)
#define trace_android_vh_rwsem_read_wait_start(sem)
#define trace_android_vh_rwsem_read_wait_finish(sem)
#define trace_android_vh_rwsem_write_wait_start(sem)
#define trace_android_vh_rwsem_write_wait_finish(sem)
#define trace_android_vh_sched_show_task(task)
#endif

#endif /* _TRACE_HOOK_DTASK_H */
/* This part must be outside protection */
#include <trace/define_trace.h>