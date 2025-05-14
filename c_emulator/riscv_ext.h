#ifndef RISCV_EXT
#define RISCV_EXT

void ext_model_init(void);
void decode_insn(uint32_t zw);
bool print_insn(sail_string *s);
bool execute_insn(enum zRetired* zgaz36352);

#endif//RISCV_EXT
