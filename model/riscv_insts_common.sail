enum clause extension = Ext_C
function clause extensionEnabled(Ext_C) = misa[C] == 0b1

enum clause extension = Ext_Zbkb
function clause extensionEnabled(Ext_Zbkb) = true

enum clause extension = Ext_V
function clause extensionEnabled(Ext_V) = (misa[V] == 0b1) & (mstatus[VS] != 0b00)

enum clause extension = Ext_Zca
function clause extensionEnabled(Ext_Zca) = extensionEnabled(Ext_C)

val      fsplit_H : bits(16) -> (bits(1), bits(5), bits(10))
function fsplit_H   (xf16) = (xf16[15..15], xf16[14..10], xf16[9..0])

val      f_is_neg_inf_H : bits(16) -> bool
function f_is_neg_inf_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (sign == 0b1)
   & (exp  == ones())
   & (mant == zeros()))
}

val      f_is_neg_norm_H : bits(16) -> bool
function f_is_neg_norm_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (sign == 0b1)
   & (exp  != zeros())
   & (exp  != ones()))
}

val      f_is_neg_subnorm_H : bits(16) -> bool
function f_is_neg_subnorm_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (sign == 0b1)
   & (exp  == zeros())
   & (mant != zeros()))
}

val      f_is_pos_subnorm_H : bits(16) -> bool
function f_is_pos_subnorm_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (sign == zeros())
   & (exp  == zeros())
   & (mant != zeros()))
}

val      f_is_pos_norm_H : bits(16) -> bool
function f_is_pos_norm_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (sign == zeros())
   & (exp  != zeros())
   & (exp  != ones()))
}

val      f_is_pos_inf_H : bits(16) -> bool
function f_is_pos_inf_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (sign == zeros())
   & (exp  == ones())
   & (mant == zeros()))
}

val      f_is_neg_zero_H : bits(16) -> bool
function f_is_neg_zero_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (sign == ones())
   & (exp  == zeros())
   & (mant == zeros()))
}

val      f_is_pos_zero_H : bits(16) -> bool
function f_is_pos_zero_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (sign == zeros())
   & (exp  == zeros())
   & (mant == zeros()))
}

val      f_is_SNaN_H : bits(16) -> bool
function f_is_SNaN_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (exp == ones())
   & (mant [9] == bitzero)
   & (mant != zeros()))
}

val      f_is_QNaN_H : bits(16) -> bool
function f_is_QNaN_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (exp == ones())
   & (mant [9] == bitone))
}

/* Either QNaN or SNan */
val      f_is_NaN_H : bits(16) -> bool
function f_is_NaN_H   xf16 = {
  let (sign, exp, mant) = fsplit_H (xf16);
  (  (exp == ones())
   & (mant != zeros()))
}

val      fmake_H  : (bits(1), bits(5), bits(10)) -> bits(16)
function fmake_H (sign, exp, mant) = sign @ exp @ mant

val      negate_H : bits(16) -> bits(16)
function negate_H (xf16) = {
  let (sign, exp, mant) = fsplit_H (xf16);
  let new_sign = if (sign == 0b0) then 0b1 else 0b0;
  fmake_H (new_sign, exp, mant)
}


/* TODO: this should be a 'mapping' */
val      fsplit_S : bits(32) -> (bits(1), bits(8), bits(23))
function fsplit_S   x32 = (x32[31..31], x32[30..23], x32[22..0])

val      f_is_neg_inf_S : bits(32) -> bool
function f_is_neg_inf_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (sign == 0b1)
   & (exp  == ones())
   & (mant == zeros()))
}

val      f_is_neg_norm_S : bits(32) -> bool
function f_is_neg_norm_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (sign == 0b1)
   & (exp  != zeros())
   & (exp  != ones()))
}

val      f_is_neg_subnorm_S : bits(32) -> bool
function f_is_neg_subnorm_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (sign == 0b1)
   & (exp  == zeros())
   & (mant != zeros()))
}

val      f_is_neg_zero_S : bits(32) -> bool
function f_is_neg_zero_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (sign == ones())
   & (exp  == zeros())
   & (mant == zeros()))
}

val      f_is_pos_zero_S : bits(32) -> bool
function f_is_pos_zero_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (sign == zeros())
   & (exp  == zeros())
   & (mant == zeros()))
}

val      f_is_pos_subnorm_S : bits(32) -> bool
function f_is_pos_subnorm_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (sign == zeros())
   & (exp  == zeros())
   & (mant != zeros()))
}

val      f_is_pos_norm_S : bits(32) -> bool
function f_is_pos_norm_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (sign == zeros())
   & (exp  != zeros())
   & (exp  != ones()))
}

val      f_is_pos_inf_S : bits(32) -> bool
function f_is_pos_inf_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (sign == zeros())
   & (exp  == ones())
   & (mant == zeros()))
}

val      f_is_SNaN_S : bits(32) -> bool
function f_is_SNaN_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (exp == ones())
   & (mant [22] == bitzero)
   & (mant != zeros()))
}

val      f_is_QNaN_S : bits(32) -> bool
function f_is_QNaN_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (exp == ones())
   & (mant [22] == bitone))
}

/* Either QNaN or SNan */
val      f_is_NaN_S : bits(32) -> bool
function f_is_NaN_S   x32 = {
  let (sign, exp, mant) = fsplit_S (x32);
  (  (exp == ones())
   & (mant != zeros()))
}

val      fmake_S  : (bits(1), bits(8), bits(23)) -> bits(32)
function fmake_S (sign, exp, mant) = sign @ exp @ mant

val      negate_S : bits(32) -> bits(32)
function negate_S (x32) = {
  let (sign, exp, mant) = fsplit_S (x32);
  let new_sign = if (sign == 0b0) then 0b1 else 0b0;
  fmake_S (new_sign, exp, mant)
}

val      fsplit_D : bits(64) -> (bits(1), bits(11), bits(52))
function fsplit_D   x64 = (x64[63..63], x64[62..52], x64[51..0])

val      f_is_neg_inf_D : bits(64) -> bool
function f_is_neg_inf_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (sign == 0b1)
   & (exp  == ones())
   & (mant == zeros()))
}

val      f_is_neg_norm_D : bits(64) -> bool
function f_is_neg_norm_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (sign == 0b1)
   & (exp  != zeros())
   & (exp  != ones()))
}

val      f_is_neg_subnorm_D : bits(64) -> bool
function f_is_neg_subnorm_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (sign == 0b1)
   & (exp  == zeros())
   & (mant != zeros()))
}

val      f_is_neg_zero_D : bits(64) -> bool
function f_is_neg_zero_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (sign == ones())
   & (exp  == zeros())
   & (mant == zeros()))
}

val      f_is_pos_zero_D : bits(64) -> bool
function f_is_pos_zero_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (sign == zeros())
   & (exp  == zeros())
   & (mant == zeros()))
}

val      f_is_pos_subnorm_D : bits(64) -> bool
function f_is_pos_subnorm_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (sign == zeros())
   & (exp  == zeros())
   & (mant != zeros()))
}

val      f_is_pos_norm_D : bits(64) -> bool
function f_is_pos_norm_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (sign == zeros())
   & (exp  != zeros())
   & (exp  != ones()))
}

val      f_is_pos_inf_D : bits(64) -> bool
function f_is_pos_inf_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (sign == zeros())
   & (exp  == ones())
   & (mant == zeros()))
}

val      f_is_SNaN_D : bits(64) -> bool
function f_is_SNaN_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (exp == ones())
   & (mant [51] == bitzero)
   & (mant != zeros()))
}

val      f_is_QNaN_D : bits(64) -> bool
function f_is_QNaN_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (exp == ones())
   & (mant [51] == bitone))
}

/* Either QNaN or SNan */
val      f_is_NaN_D : bits(64) -> bool
function f_is_NaN_D   x64 = {
  let (sign, exp, mant) = fsplit_D (x64);
  (  (exp == ones())
   & (mant != zeros()))
}

val      fmake_D  : (bits(1), bits(11), bits(52)) -> bits(64)
function fmake_D (sign, exp, mant) = sign @ exp @ mant

val      negate_D : bits(64) -> bits(64)
function negate_D (x64) = {
  let (sign, exp, mant) = fsplit_D (x64);
  let new_sign = if (sign == 0b0) then 0b1 else 0b0;
  fmake_D (new_sign, exp, mant)
}

mapping encdec_rounding_mode : rounding_mode <-> bits(3) = {
  RM_RNE <-> 0b000,
  RM_RTZ <-> 0b001,
  RM_RDN <-> 0b010,
  RM_RUP <-> 0b011,
  RM_RMM <-> 0b100,
  RM_DYN <-> 0b111
}

/* **************************************************************** */
/* Floating point accrued exception flags                           */

function nxFlag() -> bits(5) = 0b_00001
function ufFlag() -> bits(5) = 0b_00010
function ofFlag() -> bits(5) = 0b_00100
function dzFlag() -> bits(5) = 0b_01000
function nvFlag() -> bits(5) = 0b_10000


function is_aligned(vaddr : xlenbits, width : word_width) -> bool =
  match width {
    BYTE   => true,
    HALF   => vaddr[0..0] == zeros(),
    WORD   => vaddr[1..0] == zeros(),
    DOUBLE => vaddr[2..0] == zeros(),
  }

// Return true if the address is misaligned and we don't support misaligned access.
function check_misaligned(vaddr : xlenbits, width : word_width) -> bool =
  not(plat_enable_misaligned_access()) & not(is_aligned(vaddr, width))

