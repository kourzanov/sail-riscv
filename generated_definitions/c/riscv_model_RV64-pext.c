#include "sail.h"
#include "rts.h"
#include "elf.h"
extern void (*sail_rts_set_coverage_file)(const char *);
#include "riscv_platform.h"
#include "riscv_prelude.h"
#ifdef __cplusplus
extern "C" {
#endif

extern struct pexception *current_exception;
#include "riscv_model_RV64-pext.H"
#include "riscv_model_RV64-pext.C"

#ifdef __cplusplus
}
#endif
