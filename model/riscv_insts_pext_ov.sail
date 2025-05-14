/* *****************************************************************/

/* where is subextension Zpsfoperand configured? */
/* pxsat register */

bitfield Vxsat : xlenbits = {
  OV    : 0
}

register pxsat : Vxsat

function havePExt()    -> bool = misa.P() == 0b1
//function haveVExt()    -> bool = misa.V() == 0b1

/* TODO: P sub-extensions */
function haveZpsfoperand() -> bool = true
function haveZprvsfextra() -> bool = true
function haveZpn()         -> bool = true

val pext_write_OV : bits(1) -> unit effect {rreg, wreg}
function pext_write_OV (b) =
  if extensionEnabled(Ext_V) then
    /* TODO: use pxsat from RVV */
    pxsat->OV() = b
  else
    pxsat->OV() = b

val pext_read_OV : unit -> xlenbits effect {rreg}
function pext_read_OV () =
  if extensionEnabled(Ext_V) then
    /* TODO: use pxsat from RVV */
    zero_extend (pxsat.OV ())
  else
    zero_extend (pxsat.OV())

mapping clause csr_name_map = 0x009 <-> "pxsat"

function clause is_CSR_defined(0x009) = havePExt()

function clause read_CSR(0x009) = (pext_read_OV ())

function clause write_CSR(0x009, value) = {
  pext_write_OV (0b0); (pxsat.bits())
}
