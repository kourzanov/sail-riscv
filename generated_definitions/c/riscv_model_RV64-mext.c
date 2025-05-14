#include "sail.h"
#include "rts.h"
#include "elf.h"
extern void (*sail_rts_set_coverage_file)(const char *);
#include "riscv_platform.h"
#include "riscv_prelude.h"
#ifdef __cplusplus
extern "C" {
#endif

extern struct mexception *current_exception;
#include "riscv_model_RV64-mext.H"
#include "riscv_model_RV64-mext.C"

#ifdef __cplusplus
}
#endif
