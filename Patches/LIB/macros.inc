// Common macros

macro LuiLb(reg, addr) {
   if (({addr} & 0x8000) > 0) {
      lui {reg}, (1 + ({addr} >> 16))
   } else {
      lui {reg}, ({addr} >> 16)
   }
   lb {reg}, {addr} & 0xFFFF ({reg})
}

macro LuiLh(reg, addr) {
   if (({addr} & 0x8000) > 0) {
      lui {reg}, (1 + ({addr} >> 16))
   } else {
      lui {reg}, ({addr} >> 16)
   }
   lh {reg}, {addr} & 0xFFFF ({reg})
}

macro LuiLw(reg, addr) {
   if (({addr} & 0x8000) > 0) {
      lui {reg}, (1 + ({addr} >> 16))
   } else {
      lui {reg}, ({addr} >> 16)
   }
   lw {reg}, {addr} & 0xFFFF ({reg})
}

macro LuiSb(reg1, addr, reg2) {
   if (({addr} & 0x8000) > 0) {
      lui {reg2}, (1 + ({addr} >> 16))
   } else {
      lui {reg2}, ({addr} >> 16)
   }
   sb {reg1}, {addr} & 0xFFFF ({reg2})
}

macro LuiSh(reg1, addr, reg2) {
   if (({addr} & 0x8000) > 0) {
      lui {reg2}, (1 + ({addr} >> 16))
   } else {
      lui {reg2}, ({addr} >> 16)
   }
   sh {reg1}, {addr} & 0xFFFF ({reg2})
}

macro LuiSw(reg1, addr, reg2) {
   if (({addr} & 0x8000) > 0) {
      lui {reg2}, (1 + ({addr} >> 16))
   } else {
      lui {reg2}, ({addr} >> 16)
   }
   sw {reg1}, {addr} & 0xFFFF ({reg2})
}

macro OriBeq(reg1, i, reg2, label) {
  ori {reg2}, r0, {i}
  beq {reg1}, {reg2}, {label}
  nop
}

macro OriBne(reg1, i, reg2, label) {
  ori {reg2}, r0, {i}
  bne {reg1}, {reg2}, {label}
  nop
}