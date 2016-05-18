arch n64.cpu
endian msb
//output "", create

include "..\LIB\N64.inc"
include "..\LIB\functions.inc"
include "..\LIB\macros.inc"

origin 0x0
insert "..\LIB\Mario Kart 64 (U) [!].z64"

constant ModeSelection(0x800DC53C)
constant Options(0x80500000)

macro GetSetting(reg, setting) {
  lui {reg}, 0x8050
  lb {reg}, {setting} ({reg})
}

// DMA
origin 0x0029F0
base 0x80001DF0 // Disable resource display function
nop

origin 0x001E6C
base 0x8000126C
jal ResourceDisplay1
nop

origin 0x004704 // Replaces resource display function
base ResourceDisplay1
addiu sp, -0x18
sw ra, 0x14 (sp)
jal 0x800010CC
nop
la a0, 0x80400000 // RAM destination (0x80400000)
li a1, 0xBE9170 // ROM source (0xBE9170)
li a2, 0x16E90 // Size (0x16E90)
jal DmaCopy
nop

// Menu Init
lui t0, 0x8050
addiu t1, t0, 0x10
la t2, 0x01010101
MenuInitLoop:
  sw t2, 0 (t0)
  addiu t0, 0x04
  bne t0, t1, MenuInitLoop
  nop
lw ra, 0x14 (sp)
jr ra
addiu sp, 0x18

// Menu Strings
//
// 00000000                             Settings count
// 00000000                             Pointer to entry string
// 00000000 00000000 00000000 00000000  Pointers to settings strings
MenuStrings:
dd 0x00000002 // Tracks
dd MenuEntry1
dd MenuEntry1Setting1, MenuEntry1Setting2, 0x00000000

dd 0x00000003 // Scaling
dd MenuEntry2
dd MenuEntry2Setting1, MenuEntry2Setting2, MenuEntry2Setting3, 0x00000000

dd 0x00000002 // Widescreen
dd MenuEntry3
dd MenuEntry3Setting1, MenuEntry3Setting2, 0x00000000

dd 0x00000002 // Trophies
dd MenuEntry4
dd MenuEntry4Setting1, MenuEntry4Setting2, 0x00000000

dd 0x00000002 // Multiplayer Music
dd MenuEntry5
dd MenuEntry5Setting1, MenuEntry5Setting2, 0x00000000

dd 0x00000002 // Multiplayer KD Train
dd MenuEntry6
dd MenuEntry6Setting1, MenuEntry6Setting2, 0x00000000

dd 0x00000002 // Multiplayer DKJP Boat
dd MenuEntry7
dd MenuEntry7Setting1, MenuEntry7Setting2, 0x00000000

dd 0x00000002 // Versus Tracks
dd MenuEntry8
dd MenuEntry8Setting1, MenuEntry8Setting2, 0x00000000

dd 0x00000002 // Versus Timer
dd MenuEntry9
dd MenuEntry9Setting1, MenuEntry9Setting2, 0x00000000

dd 0x00000003 // Gold Mushroom
dd MenuEntry10
dd MenuEntry10Setting1, MenuEntry10Setting2, MenuEntry10Setting3, 0x00000000

dd 0x00000009 // Items
dd MenuEntry11
dd MenuEntry11Setting1, MenuEntry11Setting2, MenuEntry11Setting3, MenuEntry11Setting4
dd MenuEntry11Setting5, MenuEntry11Setting6, MenuEntry11Setting7, MenuEntry11Setting8
dd MenuEntry11Setting9, 0x00000000

dd 0x00000002 // Character Stats
dd MenuEntry12
dd MenuEntry12Setting1, MenuEntry12Setting2, 0x00000000

dd 0x00000000, 0x00000000

MenuEntry1:
Asciiz("tracks")
MenuEntry1Setting1:
Asciiz("default")
MenuEntry1Setting2:
Asciiz("random")

MenuEntry2:
Asciiz("scaling")
MenuEntry2Setting1:
Asciiz("default")
MenuEntry2Setting2:
Asciiz("30 fps")
MenuEntry2Setting3:
Asciiz("60 fps")

MenuEntry3:
Asciiz("widescreen")
MenuEntry3Setting1:
Asciiz("default")
MenuEntry3Setting2:
Asciiz("enabled")

MenuEntry4:
Asciiz("trophies")
MenuEntry4Setting1:
Asciiz("default")
MenuEntry4Setting2:
Asciiz("skip")

MenuEntry5:
Asciiz("mp music")
MenuEntry5Setting1:
Asciiz("default")
MenuEntry5Setting2:
Asciiz("enabled")

MenuEntry6:
Asciiz("mp train")
MenuEntry6Setting1:
Asciiz("default")
MenuEntry6Setting2:
Asciiz("full")

MenuEntry7:
Asciiz("mp boat")
MenuEntry7Setting1:
Asciiz("default")
MenuEntry7Setting2:
Asciiz("enabled")

MenuEntry8:
Asciiz("vs tracks")
MenuEntry8Setting1:
Asciiz("default")
MenuEntry8Setting2:
Asciiz("all cups")

MenuEntry9:
Asciiz("vs timer")
MenuEntry9Setting1:
Asciiz("default")
MenuEntry9Setting2:
Asciiz("enabled")

MenuEntry10:
Asciiz("gold shroom")
MenuEntry10Setting1:
Asciiz("default")
MenuEntry10Setting2:
Asciiz("feather small")
MenuEntry10Setting3:
Asciiz("feather big")

MenuEntry11:
Asciiz("items")
MenuEntry11Setting1:
Asciiz("default")
MenuEntry11Setting2:
Asciiz("player 1")
MenuEntry11Setting3:
Asciiz("player 2")
MenuEntry11Setting4:
Asciiz("player 3")
MenuEntry11Setting5:
Asciiz("player 4")
MenuEntry11Setting6:
Asciiz("player 5")
MenuEntry11Setting7:
Asciiz("player 6")
MenuEntry11Setting8:
Asciiz("player 7")
MenuEntry11Setting9:
Asciiz("player 8")

MenuEntry12:
Asciiz("stats")
MenuEntry12Setting1:
Asciiz("default")
MenuEntry12Setting2:
Asciiz("all yoshi")

fill 0x800040C0 - pc() // Zero fill remainder of resource display function

// Menu
origin 0x0957D0
base 0x80094BD0
jal 0x80400000
nop

origin 0xBE9170
base 0x80400000
addiu sp, -0x18
sw ra, 0x14 (sp)
jal 0x800A8230
nop
jal LoadDebugFont
nop
la t0, MenuStrings // Array start
addiu t1, r0, 0x01 // Entry number
addiu a1, r0, 0x5A // Y coordinate
MenuArrayLoop:
  lw t2, 0x04 (t0) // Entry character string
  beq t2, r0, MenuInput
  nop
  lui t3, 0x8050
  addu t3, t3, t1
  lb t3, 0 (t3)
  sll t3, 0x02
  addiu t3, 0x04
  addu t3, t0, t3 // Pointer to setting character string
  lw t3, 0 (t3) // Setting character string
  sw t0, 0x18 (sp) // Array position
  sw t1, 0x1C (sp) // Entry number
  sw a1, 0x20 (sp) // Y coordinate
  sw t2, 0x24 (sp) // Entry character string
  sw t3, 0x28 (sp) // Setting character string
  PrintCursor:
    lui t4, 0x8050
    lb t4, 0 (t4)
    bne t1, t4, PrintEntry
    nop
    addiu a0, r0, 0x46 // X coordinate
    la a2, 0x800F0B64
    jal DebugPrintStringCoord
    nop
    lw a1, 0x20 (sp) // Y coordinate
    lw t2, 0x24 (sp) // Entry character string
  PrintEntry:
    addiu a0, r0, 0x50 // X coordinate
    addu a2, t2, r0 // Entry character string
    jal DebugPrintStringCoord
    nop
  PrintSetting:
    addiu a0, r0, 0xAA // X coordinate
    lw a1, 0x20 (sp) // Y coordinate
    lw a2, 0x28 (sp) // Setting character string
    jal DebugPrintStringCoord
    nop
  lw t0, 0x18 (sp) // Array position
  MenuEntryLoop: // Find entry size
    lw t2, 0 (t0)
    addiu t0, 0x04
    beq t2, r0, MenuEntryLoopEnd
    nop
    b MenuEntryLoop
    nop
    MenuEntryLoopEnd:
  lw t1, 0x1C (sp) // Entry number
  addiu t1, 0x01
  lw a1, 0x20 (sp) // Y coordinate
  addiu a1, 0x0A
  b MenuArrayLoop
  nop
MenuInput:
  lui t0, 0x8050
  la t1, 0x800F6910 // Controller structs
  MenuInputLoop:
    lh t2, 0x06 (t1) // Current input
    lb t3, 0 (t0) // Cursor flag
    MenuInputUp:
      addiu t4, r0, 0x0800
      bne t2, t4, MenuInputDown
      nop
      addiu t3, -0x01
      beq t3, r0, MenuInputLoopEnd
      nop
      sb t3, 0 (t0)
    MenuInputDown:
      addiu t4, r0, 0x0400
      bne t2, t4, MenuInputLeft
      nop
      la t4, MenuStrings
      addu t5, r0, r0
      MenuInputDownLoop:
        lw t6, 0 (t4)
        beq t6, r0, MenuInputDownLoopEnd
        nop
        addiu t5, 0x01
        MenuInputDownLoopLoop: // Find entry size
          lw t8, 0 (t4)
          addiu t4, 0x04
          beq t8, r0, MenuInputDownLoopLoopEnd
          nop
          b MenuInputDownLoopLoop
          nop
          MenuInputDownLoopLoopEnd:
        b MenuInputDownLoop
        nop
        MenuInputDownLoopEnd:
      beq t3, t5, MenuInputLoopEnd
      nop
      addiu t3, 0x01
      sb t3, 0 (t0)
    MenuInputLeft:
      addiu t4, r0, 0x0200
      bne t2, t4, MenuInputRight
      nop
      addu t4, t0, t3
      lb t5, 0 (t4)
      addiu t5, -0x01
      beq t5, r0, MenuInputLoopEnd
      nop
      sb t5, 0 (t4)
    MenuInputRight:
      addiu t4, r0, 0x0100
      bne t2, t4, MenuInputLoopEnd
      nop
      addu t4, t0, t3
      lb t5, 0 (t4)
      addiu t6, r0, 0x01
      la t7, MenuStrings
      MenuInputRightLoop:
        beq t3, t6, MenuInputRightLoopEnd
        nop
        addiu t6, 0x01
        MenuInputRightLoopLoop: // Find entry size
          lw t8, 0 (t7)
          addiu t7, 0x04
          beq t8, r0, MenuInputRightLoopLoopEnd
          nop
          b MenuInputRightLoopLoop
          nop
          MenuInputRightLoopLoopEnd:
        b MenuInputRightLoop
        nop
        MenuInputRightLoopEnd:
      lw t7, 0 (t7)
      beq t7, t5, MenuInputLoopEnd
      nop
      addiu t5, 0x01
      sb t5, 0 (t4)
    MenuInputLoopEnd:
  la t4, 0x800F6940
  beq t1, t4, MenuEnd
  nop
  addiu t1, 0x10
  b MenuInputLoop
  nop
MenuEnd:
  lw ra, 0x14 (sp)
  jr ra
  addiu sp, 0x18

// Random Tracks
scope RandomTracks: {
  LuiLb(t0, Options+1)
  OriBne(t0, 0x02, t1, End) // Skip if option disabled
  LuiLw(t0, ModeSelection) // Determine the current mode
  Versus:
    OriBne(t0, 0x02, t1, Battle) // If mode == Versus
    jal Random // Call random function with range 0x00-0x10
    ori a0, r0, 0x10
    OriBne(v0, 0x0F, t1, Store) // Store the returned value if != 0x0F (BF)
    ori v0, r0, 0x12 // Swap 0x0F (BF) with 0x12 (DKJP)
    b Store
    nop
  Battle:
    OriBne(t0, 0x03, t1, End) // Else if mode == Battle
    jal Random // Call random function with range 0x00-0x03
    ori a0, r0, 0x04
    addiu v0, 0x10 // Add 0x10 to the returned value
    OriBne(v0, 0x12, t1, Store) // Store the result if != 0x12 (DKJP)
    ori v0, r0, 0x0F // Swap 0x12 (DKJP) with 0x0F (BF)
  Store:
    LuiSh(v0, 0x800DC5A0, t0)
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x28
}

// Scaling Fix
scope ScalingFix1p: { // Available registers: t5, at
  LuiLb(t5, Options+2)
  Disabled:
    OriBne(t5, 0x01, at, Fps30) // If option disabled
    LuiLw(t7, 0x80150114) // Original instructions
    b End
    nop
  Fps30:
    OriBne(t5, 0x02, at, Fps60) // Else if option set to 30 fps
    ori t7, r0, 0x02 // Return 2
    b End
    nop
  Fps60:
    OriBne(t5, 0x03, at, End) // Else if option set to 60 fps
    ori t7, r0, 0x01 // Return 1
  End:
    jr ra
    nop
}

scope ScalingFix2p: { // Available registers: t8, at
  LuiLb(t8, Options+2)
  Disabled:
    OriBne(t8, 0x01, at, Fps30) // If option disabled
    LuiLw(t1, 0x80150114) // Original instructions
    b End
    nop
  Fps30:
    OriBne(t8, 0x02, at, Fps60) // Else if option set to 30 fps
    ori t1, r0, 0x02 // Return 2
    b End
    nop
  Fps60:
    OriBne(t8, 0x03, at, End) // Else if option set to 60 fps
    ori t1, r0, 0x01 // Return 1
  End:
    jr ra
    nop
}

scope ScalingFix3p: { // Available registers: t9, at
  LuiLb(t9, Options+2)
  Disabled:
    OriBne(t9, 0x01, at, Fps30) // If option disabled
    LuiLw(t2, 0x80150114) // Original instructions
    b End
    nop
  Fps30:
    OriBne(t9, 0x02, at, Fps60) // Else if option set to 30 fps
    ori t2, r0, 0x02 // Return 2
    b End
    nop
  Fps60:
    OriBne(t9, 0x03, at, End) // Else if option set to 60 fps
    ori t2, r0, 0x01 // Return 1
  End:
    jr ra
    nop
}

// Widescreen
Widescreen:
lui t0, 0x800E
lw t0, 0xC538 (t0) // Check players
addiu t1, r0, 0x02
beq t0, t1, Widescreen2p
nop
Widescreen1p:
  GetSetting(t0, 3)
  addiu t1, r0, 0x02
  beq t0, t1, Widescreen1pEnabled
  nop
  li a3, 0x3FAAAAAB // Return 3FAAAAAB
  b WidescreenEnd
  nop
  Widescreen1pEnabled:
    li a3, 0x3FDFAAAB // Return 3FDFAAAB
    b WidescreenEnd
    nop
Widescreen2p:
  GetSetting(t0, 3)
  addiu t1, r0, 0x02
  beq t0, t1, Widescreen2pEnabled
  nop
  li a3, 0x402AAAAB // Return 402AAAAB
  b WidescreenEnd
  nop
  Widescreen2pEnabled:
    li a3, 0x4060AAAB // Return 4060AAAB
WidescreenEnd:
  jr ra
  nop

// Skip Trophy Ceremony
SkipTrophy:
GetSetting(t0, 4)
addiu t1, r0, 0x02
beq t0, t1, SkipTrophyEnabled
nop
addiu t7, r0, 0x05
b SkipTrophyEnd
nop
SkipTrophyEnabled:
  addiu t7, r0, 0x01
SkipTrophyEnd:
  j 0x8028E3DC
  nop

// Same Character
SameCharacter:
lui a0, 0x4900
beq v0, r0, SameCharacterEnd
sb s0, 0 (t9)
jal 0x800C8E10 // Play sound
ori a0, 0x8000 // Volume
SameCharacterEnd:
  j 0x800B3A50
  nop

// Multiplayer Music
MultiplayerMusic:
GetSetting(t0, 5)
addiu t1, r0, 0x02
beq t0, t1, MultiplayerMusicEnabled
nop
lui t6, 0x800E
lw t6, 0xC530 (t6)
b MultiplayerMusicEnd
nop
MultiplayerMusicEnabled:
  addiu t6, r0, 0x01
MultiplayerMusicEnd:
  j 0x8028ECA0
  nop

MultiplayerMusicL:
GetSetting(t2, 5)
addiu t1, r0, 0x02
beq t2, t1, MultiplayerMusicLEnabled
nop
lui t1, 0x800E
lw t1, 0xC52C (t1)
b MultiplayerMusicLEnd
nop
MultiplayerMusicLEnabled:
  addiu t1, r0, 0x01
MultiplayerMusicLEnd:
  j 0x8028F9C8
  nop

// Multiplayer KD Train
MultiplayerTrain:
GetSetting(t0, 6)
addiu t1, r0, 0x02
beq t0, t1, MultiplayerTrainEnabled
nop
lui v0, 0x800E
lw v0, 0xC530 (v0)
b MultiplayerTrainEnd
nop
MultiplayerTrainEnabled:
  addu v0, r0, r0
MultiplayerTrainEnd:
  j 0x80012954
  nop

// Multiplayer DKJP Boat
MultiplayerBoat:
GetSetting(a0, 7)
addiu at, r0, 0x02
beq a0, at, MultiplayerBoatEnabled
nop
slti at, t7, 0x03
b MultiplayerBoatEnd
nop
MultiplayerBoatEnabled:
  addiu at, r0, 0x01
MultiplayerBoatEnd:
  j 0x80013360
  nop

// Versus All Cups
VsAllCups:
addiu sp, -0x18
sw ra, 0x14 (sp)
jal 0x80290388
nop
GetSetting(a0, 8)
addiu at, r0, 0x02
bne a0, at, VsAllCupsEnd
nop
VsAllCupsMode:
  lui t0, 0x800E
  lw t0, 0xC53C (t0)
  addiu t1, r0, 0x02 // Versus
  bne t0, t1, VsAllCupsEnd
  nop
VsAllCupsRr: // Set cup and track to zero if track = RR
  lui t0, 0x8019
  lb t1, 0xEE09 (t0) // Load cup
  lb t2, 0xEE0B (t0) // Load track
  lui t3, 0x800E
  lb t3, 0xC5A1 (t3)
  addiu t4, r0, 0x0D
  bne t1, t4, VsAllCupsRrEnd // Check track
  nop
  sb r0, 0xEE09 (t0)
  sb r0, 0xEE0B (t0)
  b VsAllCupsEnd
  nop
  VsAllCupsRrEnd:
VsAllCupsCup: // Increment cup if track = 3
  addiu t3, r0, 0x03
  bne t2, t3, VsAllCupsCupEnd // Check track
  nop
  addiu t1, 0x01
  sb t1, 0xEE09 (t0)
  sb r0, 0xEE0B (t0)
  b VsAllCupsEnd
  nop
  VsAllCupsCupEnd:
VsAllCupsTrack: // Otherwise increment track
  addiu t2, 0x01
  sb t2, 0xEE0B (t0)
VsAllCupsEnd:
  lw ra, 0x14 (sp)
  jr ra
  addiu sp, 0x18

// Versus Timer
VsTimer:
GetSetting(t0, 9)
addiu t1, r0, 0x02
beq t0, t1, VsTimerEnabled
nop
addiu at, r0, 0x02
b VsTimerEnd
nop
VsTimerEnabled:
  addu at, r0, r0
VsTimerEnd:
  j 0x8004FA8C
  nop

// Gold Mushroom
GoldMushroom:
GetSetting(t0, 10)
addiu t1, r0, 0x02
beq t0, t1, GoldMushroomSmall
nop
addiu t1, r0, 0x03
beq t0, t1, GoldMushroomBig
nop
ori t8, t7, 0x0200
b GoldMushroomEnd
nop
GoldMushroomSmall:
  ori t8, t7, 0x1000
  b GoldMushroomEnd
  nop
GoldMushroomBig:
  lui t0, 0x02
  or t8, t8, t0
GoldMushroomEnd:
  j 0x802B30D4
  sw t8, 0x000C (a0)

// Items
Items:
GetSetting(t0, 11)
ori t1, r0, 0x0001
bne t0, t1, ItemsEnabled // If items option disabled
nop
b ItemsEnd // Skip
nop
ItemsEnabled: // Else set player value to option value - 2
addiu a0, t0, -0x02
ItemsEnd:
j 0x8007ADA8
nop

// Character Stats
scope CharacterStats: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x800010CC
  nop
  GetSetting(t0, 12)
  ori t1, r0, 0x0001
  bne t0, t1, Enabled
  nop
  Disabled: // If 0x80500000 != 0x00 DMA default stats
    la a0, 0x800E2360 // Destination
    li a1, 0x0E2F60 // Source
    li a2, 0x14B0 // Size
    jal DmaCopy
    nop
    b End
    nop
  Enabled: // Else DMA new stats
    la a0, 0x800E2360 // Destination
    li a1, StatsMain // Source
    li a2, 0x14B0 // Size
    jal DmaCopy
    nop
    la a0, 0x802B8790 // Destination
    li a1, StatsWeight // Source
    li a2, 0x20 // Size
    jal DmaCopy
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}


// Character Stats
include "stats_yoshi.asm"

fill 0xC00000 - origin() // Zero fill remainder of ROM

// Random Tracks
origin 0x0B4B64
base 0x800B3F64
nop
nop
j RandomTracks

// Scaling Fix
origin 0x0021C4
base 0x800015C4
jal ScalingFix1p
nop

origin 0x002638
base 0x80001A38
jal ScalingFix2p
nop

origin 0x002890
base 0x80001C90
jal ScalingFix3p
nop

// Widescreen
origin 0x10E07C
base 0x802A4A6C
jal Widescreen
nop

origin 0x10F048
base 0x802A5A38
jal Widescreen
nop

origin 0x10F330
base 0x802A5D20
jal Widescreen
nop

origin 0x10F628
base 0x802A6018
jal Widescreen
nop

origin 0x10F93C
base 0x802A632C
jal Widescreen
nop

origin 0x10FC50
base 0x802A6640
jal Widescreen
nop

origin 0x10FF54
base 0x802A6944
jal Widescreen
nop

origin 0x110238
base 0x802A6C28
jal Widescreen
nop

origin 0x11051C
base 0x802A6F0C
jal Widescreen
nop

origin 0x11084C
base 0x802A723C
jal Widescreen
nop

// Skip Trophy Ceremony
origin 0x0F79E4
base 0x8028E3D4
j SkipTrophy

// Same Character
origin 0x0B4524
base 0x800B3924
nop

origin 0x0B45A4
base 0x800B39A4
nop

origin 0x0B4638
base 0x800B3A38
j SameCharacter

// Multiplayer Music
origin 0x0F82A8
base 0x8028EC98
j MultiplayerMusic
nop

origin 0x0F8FD0
base 0x8028F9C0
j MultiplayerMusicL
nop

// Multiplayer KD Train
origin 0x01354C
base 0x8001294C
j MultiplayerTrain
nop

// Multiplayer DKJP Boat
origin 0x013F58
base 0x80013358
j MultiplayerBoat

// Versus All Cups
origin 0x09DBA4
base 0x8009CFA4
jal VsAllCups
nop

// Versus Timer
origin 0x050684
base 0x8004FA84
j VsTimer

// Gold Mushroom
origin 0x11C680
base 0x802B3070
j GoldMushroom
nop
nop

// Items
origin 0x07BB60
base 0x8007AF60
jal Items

// Character Stats
origin 0x003314
base 0x80002714
jal CharacterStats
nop
