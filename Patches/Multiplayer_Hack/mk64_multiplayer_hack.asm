arch n64.cpu
endian msb
//output "", create

include "..\LIB\N64.inc"

constant DmaCopy(0x80001158)
constant Random(0x802B7E34)

origin 0x0
insert "..\LIB\Mario Kart 64 (U) [!].z64"

macro asciiz(string) {
  db {string}, 0x00
}

// DMA
origin 0x0029F0
base 0x80001DF0 // Disable resource display function
nop

origin 0x001E6C
base 0x8000126C
jal ResourceDisplay
nop

origin 0x004704 // Replaces resource display function
base 0x80003B04
ResourceDisplay:
addiu sp, sp, -0x0018
sw ra, 0x0014 (sp)
jal 0x800010CC
nop
la a0, 0x80400000 // RAM destination (0x80400000)
la a1, 0x00BE9170 // ROM source (0xBE9170)
lui a2, 0x0001
jal DmaCopy
ori a2, a2,0x6E90 // Size (0x16E90)

// Menu Init
lui t0, 0x8050
addiu t1, t0, 0x0010
la t2, 0x01010101
MenuInitLoop:
  sw t2, 0x0000 (t0)
  addiu t0, t0, 0x0004
  bne t0, t1, MenuInitLoop
  nop
lw ra, 0x0014 (sp)
jr ra
addiu sp, sp, 0x0018

// Menu Strings
//
// 00000000                             Settings count
// 00000000                             Pointer to entry string
// 00000000 00000000 00000000 00000000  Pointers to settings strings
MenuStrings:
dd 0x00000002 // Tracks
dd MenuEntry1
dd MenuEntry1Setting1, MenuEntry1Setting2, 0x00000000, 0x00000000

dd 0x00000003 // Scaling
dd MenuEntry2
dd MenuEntry2Setting1, MenuEntry2Setting2, MenuEntry2Setting3, 0x00000000

dd 0x00000002 // Widescreen
dd MenuEntry3
dd MenuEntry3Setting1, MenuEntry3Setting2, 0x00000000, 0x00000000

dd 0x00000002 // Trophies
dd MenuEntry4
dd MenuEntry4Setting1, MenuEntry4Setting2, 0x00000000, 0x00000000

dd 0x00000002 // Multiplayer Music
dd MenuEntry5
dd MenuEntry5Setting1, MenuEntry5Setting2, 0x00000000, 0x00000000

dd 0x00000002 // Multiplayer KD Train
dd MenuEntry6
dd MenuEntry6Setting1, MenuEntry6Setting2, 0x00000000, 0x00000000

dd 0x00000002 // Multiplayer DKJP Boat
dd MenuEntry7
dd MenuEntry7Setting1, MenuEntry7Setting2, 0x00000000, 0x00000000

dd 0x00000002 // Versus Tracks
dd MenuEntry8
dd MenuEntry8Setting1, MenuEntry8Setting2, 0x00000000, 0x00000000

dd 0x00000002 // Versus Timer
dd MenuEntry9
dd MenuEntry9Setting1, MenuEntry9Setting2, 0x00000000, 0x00000000

dd 0x00000003 // Gold Mushroom
dd MenuEntry10
dd MenuEntry10Setting1, MenuEntry10Setting2, MenuEntry10Setting3, 0x00000000

dd 0x00000000, 0x00000000

MenuEntry1:
asciiz("tracks")
MenuEntry1Setting1:
asciiz("default")
MenuEntry1Setting2:
asciiz("random")

MenuEntry2:
asciiz("scaling")
MenuEntry2Setting1:
asciiz("default")
MenuEntry2Setting2:
asciiz("30 fps")
MenuEntry2Setting3:
asciiz("60 fps")

MenuEntry3:
asciiz("widescreen")
MenuEntry3Setting1:
asciiz("default")
MenuEntry3Setting2:
asciiz("enabled")

MenuEntry4:
asciiz("trophies")
MenuEntry4Setting1:
asciiz("default")
MenuEntry4Setting2:
asciiz("skip")

MenuEntry5:
asciiz("mp music")
MenuEntry5Setting1:
asciiz("default")
MenuEntry5Setting2:
asciiz("enabled")

MenuEntry6:
asciiz("mp train")
MenuEntry6Setting1:
asciiz("default")
MenuEntry6Setting2:
asciiz("full")

MenuEntry7:
asciiz("mp boat")
MenuEntry7Setting1:
asciiz("default")
MenuEntry7Setting2:
asciiz("enabled")

MenuEntry8:
asciiz("vs tracks")
MenuEntry8Setting1:
asciiz("default")
MenuEntry8Setting2:
asciiz("all cups")

MenuEntry9:
asciiz("vs timer")
MenuEntry9Setting1:
asciiz("default")
MenuEntry9Setting2:
asciiz("enabled")

MenuEntry10:
asciiz("gold shroom")
MenuEntry10Setting1:
asciiz("default")
MenuEntry10Setting2:
asciiz("feather small")
MenuEntry10Setting3:
asciiz("feather big")

fill 0x800040C0 - pc() // Zero fill remainder of resource display function

// Menu
origin 0x0957D0
base 0x80094BD0
jal 0x80400000
nop

origin 0xBE9170
base 0x80400000
addiu sp, sp, -0x0018
sw ra, 0x0014 (sp)
jal 0x800A8230
nop
jal 0x80057710 // mk64_debug_text_preface
nop
la t0, MenuStrings // Array start
addiu t1, r0, 0x0001 // Entry number
addiu a1, r0, 0x0064 // Y coord
MenuArrayLoop:
  lw t2, 0x0004 (t0) // Entry character string
  beq t2, r0, MenuInput
  nop
  lui t3, 0x8050
  addu t3, t3, t1
  lb t3, 0x0000 (t3)
  sll t3, t3, 0x2
  addiu t3, t3, 0x0004
  addu t3, t0, t3 // Pointer to setting character string
  lw t3, 0x0000 (t3) // Setting character string
  sw t0, 0x0018 (sp) // Array position
  sw t1, 0x001C (sp) // Entry number
  sw a1, 0x0020 (sp) // Y coord
  sw t2, 0x0024 (sp) // Entry character string
  sw t3, 0x0028 (sp) // Setting character string
  PrintCursor:
    lui t4, 0x8050
    lb t4, 0x0000 (t4)
    bne t1, t4, PrintEntry
    nop
    addiu a0, r0, 0x0046 // X coord
    la a2, 0x800F0B64
    jal 0x800577A4 // mk64_draw_debug_text
    nop
    lw a1, 0x0020 (sp) // Y coord
    lw t2, 0x0024 (sp) // Entry character string
  PrintEntry:
    addiu a0, r0, 0x0050 // X coord
    addu a2, t2, r0 // Entry character string
    jal 0x800577A4 // mk64_draw_debug_text
    nop
  PrintSetting:
    addiu a0, r0, 0x00AA // X coord
    lw a1, 0x0020 (sp) // Y coord
    lw a2, 0x0028 (sp) // Setting character string
    jal 0x800577A4 // mk64_draw_debug_text
    nop
  lw t0, 0x0018 (sp) // Array position
  addiu t0, t0, 0x0018
  lw t1, 0x001C (sp) // Entry number
  addiu t1, 0x0001
  lw a1, 0x0020 (sp) // Y coord
  addiu a1, a1, 0x000A
  b MenuArrayLoop
  nop
MenuInput:
  lui t0, 0x8050
  lui t1, 0x800F
  addiu t1, t1, 0x6910 // Controller structs
  MenuInputLoop:
    lh t2, 0x0006 (t1) // Current input
    lb t3, 0x0000 (t0) // Cursor flag
    MenuInputUp:
      addiu t4, r0, 0x0800
      bne t2, t4, MenuInputDown
      nop
      addiu t3, t3, -0x0001
      beq t3, r0, MenuInputLoopEnd
      nop
      sb t3, 0x0000(t0)
    MenuInputDown:
      addiu t4, r0, 0x0400
      bne t2, t4, MenuInputLeft
      nop
      la t4, MenuStrings
      addu t5, r0, r0
      MenuInputDownLoop:
        lw t6, 0x0000 (t4)
        beq t6, r0, MenuInputDownLoopEnd
        nop
        addiu t5, t5, 0x0001
        addiu t4, t4, 0x0018
        b MenuInputDownLoop
        nop
        MenuInputDownLoopEnd:
      beq t3, t5, MenuInputLoopEnd
      nop
      addiu t3, t3, 0x0001
      sb t3, 0x0000 (t0)
    MenuInputLeft:
      addiu t4, r0, 0x0200
      bne t2, t4, MenuInputRight
      nop
      addu t4, t0, t3
      lb t5, 0x0000 (t4)
      addiu t5, t5, -0x0001
      beq t5, r0, MenuInputLoopEnd
      nop
      sb t5, 0x0000 (t4)
    MenuInputRight:
      addiu t4, r0, 0x0100
      bne t2, t4, MenuInputLoopEnd
      nop
      addu t4, t0, t3
      lb t5, 0x0000 (t4)
      addiu t6, r0, 0x0001
      la t7, MenuStrings
      addiu t7, t7, 0x0003
      MenuInputRightLoop:
        beq t3, t6, MenuInputRightLoopEnd
        nop
        addiu t6, t6, 0x0001
        addiu t7, t7, 0x0018
        b MenuInputRightLoop
        nop
        MenuInputRightLoopEnd:
      lb t7, 0x0000 (t7)
      beq t7, t5, MenuInputLoopEnd
      nop
      addiu t5, t5, 0x0001
      sb t5, 0x0000 (t4)
    MenuInputLoopEnd:
  la t4, 0x800F6940
  beq t1, t4, MenuEnd
  nop
  addiu t1, t1, 0x0010
  b MenuInputLoop
  nop
MenuEnd:
  lw ra, 0x0014 (sp)
  jr ra
  addiu sp, sp, 0x0018

// Random Tracks
RandomTracks:
addiu sp, sp, -0x0018
sw ra, 0x0014 (sp)
lui t0, 0x8050
lb t0, 0x0001 (t0)
addiu t1, r0, 0x0002
bne t0, t1, RandomTracksEnd
RandomTracksMode:
  lui t0, 0x8019
  lb t0, 0xEE09 (t0)
  addiu t1, r0, 0x0004 // Battle
  bne t0, t1, RandomTracksVs
  nop
RandomTracksBattle:
  jal Random
  addiu a0, r0, 0x0004 // Range 0x00-0x03
  addiu v0, v0, 0x0010 //
  addiu t0, r0, 0x0012
  bne v0, t0, RandomTracksStore
  nop
  addiu v0, r0, 0x000f // 0x12 = 0x0F (BF)
  b RandomTracksStore
  nop
RandomTracksVs:
  jal Random
  addiu a0, r0, 0x0010 // Range 0x00-0x0F
  addiu t0, r0, 0x000F
  bne v0, t0, RandomTracksStore
  nop
  addiu v0, r0, 0x0012 // 0x0F = 0x12 (DKJP)
RandomTracksStore:
  lui t0, 0x800E
  sh v0, 0xC5A0 (t0)
RandomTracksEnd:
  lw ra, 0x0014 (sp)
  jr ra
  addiu sp, sp, 0x0018

// Scaling Fix
ScalingFix1p:
lui t5, 0x8050
lb t5, 0x0002 (t5)
addiu t7, r0, 0x0002
beq t5, t7, ScalingFix1p30
nop
addiu t7, r0, 0x0003
beq t5, t7, ScalingFix1p60
nop
lui t7, 0x8015
lw t7, 0x0114 (t7)
b ScalingFix1pEnd
nop
ScalingFix1p30:
  addiu t7, r0, 0x0002
  b ScalingFix1pEnd
  nop
ScalingFix1p60:
  addiu t7, r0, 0x0001
ScalingFix1pEnd:
  jr ra
  nop

ScalingFix2p:
lui t8, 0x8050
lb t8, 0x0002 (t8)
addiu t1, r0, 0x0002
beq t8, t1, ScalingFix2p30
nop
addiu t1, r0, 0x0003
beq t8, t1, ScalingFix2p60
nop
lui t1, 0x8015
lw t1, 0x0114 (t1)
b ScalingFix2pEnd
nop
ScalingFix2p30:
  addiu t1, r0, 0x0002
  b ScalingFix2pEnd
  nop
ScalingFix2p60:
  addiu t1, r0, 0x0001
ScalingFix2pEnd:
  jr ra
  nop

ScalingFix3p:
lui t9, 0x8050
lb t9, 0x0002 (t9)
addiu t2, r0, 0x0002
beq t9, t2, ScalingFix3p30
nop
addiu t2, r0, 0x0003
beq t9, t2, ScalingFix3p60
nop
lui t2, 0x8015
lw t2, 0x0114 (t2)
b ScalingFix3pEnd
nop
ScalingFix3p30:
  addiu t2, r0, 0x0002
  b ScalingFix3pEnd
  nop
ScalingFix3p60:
  addiu t2, r0, 0x0001
ScalingFix3pEnd:
  jr ra
  nop

// Widescreen
Widescreen:
lui t0, 0x800E
lw t0, 0xC538 (t0) // Check players
addiu t1, r0, 0x0002
beq t0, t1, Widescreen2p
nop
Widescreen1p:
  lui t0, 0x8050
  lb t0, 0x0003 (t0)
  addiu t1, r0, 0x0002
  beq t0, t1, Widescreen1pEnabled
  nop
  la a3, 0x3FAAAAAB // Return 3FAAAAAB
  b WidescreenEnd
  nop
  Widescreen1pEnabled:
    la a3, 0x3FDFAAAB // Return 3FDFAAAB
    b WidescreenEnd
    nop
Widescreen2p:
  lui t0, 0x8050
  lb t0, 0x0003 (t0)
  addiu t1, r0, 0x0002
  beq t0, t1, Widescreen2pEnabled
  nop
  la a3, 0x402AAAAB // Return 402AAAAB
  b WidescreenEnd
  nop
  Widescreen2pEnabled:
    la a3, 0x4060AAAB // Return 4060AAAB
WidescreenEnd:
  jr ra
  nop

// Skip Trophy Ceremony
SkipTrophy:
lui t0, 0x8050
lb t0, 0x0004 (t0)
addiu t1, r0, 0x0002
beq t0, t1, SkipTrophyEnabled
nop
addiu t7, r0, 0x0005
b SkipTrophyEnd
nop
SkipTrophyEnabled:
  addiu t7, r0, 0x0001
SkipTrophyEnd:
  j 0x8028E3DC
  nop

// Same Character
SameCharacter:
lui a0, 0x4900
beq v0, r0, SameCharacterEnd
sb s0, 0x0000 (t9)
jal 0x800C8E10 // Play sound
ori a0, a0, 0x8000 // Volume
SameCharacterEnd:
  j 0x800B3A50
  nop

// Multiplayer Music
MultiplayerMusic:
lui t0, 0x8050
lb t0, 0x0005 (t0)
addiu t1, r0, 0x0002
beq t0, t1, MultiplayerMusicEnabled
nop
lui t6, 0x800E
lw t6, 0xC530 (t6)
b MultiplayerMusicEnd
nop
MultiplayerMusicEnabled:
  addiu t6, r0, 0x0001
MultiplayerMusicEnd:
  j 0x8028ECA0
  nop

MultiplayerMusicL:
lui t2, 0x8050
lb t2, 0x0005 (t2)
addiu t1, r0, 0x0002
beq t2, t1, MultiplayerMusicLEnabled
nop
lui t1, 0x800E
lw t1, 0xC52C (t1)
b MultiplayerMusicLEnd
nop
MultiplayerMusicLEnabled:
  addiu t1, r0, 0x0001
MultiplayerMusicLEnd:
  j 0x8028F9C8
  nop

// Multiplayer KD Train
MultiplayerTrain:
lui t0, 0x8050
lb t0, 0x0006 (t0)
addiu t1, r0, 0x0002
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
lui a0, 0x8050
lb a0, 0x0007 (a0)
addiu at, r0, 0x0002
beq a0, at, MultiplayerBoatEnabled
nop
slti at, t7, 0x0003
b MultiplayerBoatEnd
nop
MultiplayerBoatEnabled:
  addiu at, r0, 0x0001
MultiplayerBoatEnd:
  j 0x80013360
  nop

// Versus All Cups
VsAllCups:
addiu sp, sp, -0x0018
sw ra, 0x0014 (sp)
jal 0x80290388
nop
lui a0, 0x8050
lb a0, 0x0008 (a0)
addiu at, r0, 0x0002
bne a0, at, VsAllCupsEnd
nop
VsAllCupsMode:
  lui t0, 0x800E
  lw t0, 0xC53C (t0)
  addiu t1, r0, 0x0002 // Versus
  bne t0, t1, VsAllCupsEnd
  nop
VsAllCupsRr: // Set cup and track to zero if track = RR
  lui t0, 0x8019
  lb t1, 0xEE09 (t0) // Load cup
  lb t2, 0xEE0B (t0) // Load track
  lui t3, 0x800E
  lb t3, 0xC5A1 (t3)
  addiu t4, r0, 0x000D
  bne t1, t4, VsAllCupsRrEnd // Check track
  nop
  sb r0, 0xEE09 (t0)
  sb r0, 0xEE0B (t0)
  b VsAllCupsEnd
  nop
  VsAllCupsRrEnd:
VsAllCupsCup: // Increment cup if track = 3
  addiu t3, r0, 0x0003
  bne t2, t3, VsAllCupsCupEnd // Check track
  nop
  addiu t1, t1, 0x0001
  sb t1, 0xEE09 (t0)
  sb r0, 0xEE0B (t0)
  b VsAllCupsEnd
  nop
  VsAllCupsCupEnd:
VsAllCupsTrack: // Otherwise increment track
  addiu t2, t2, 0x0001
  sb t2, 0xEE0B (t0)
VsAllCupsEnd:
  lw ra, 0x0014 (sp)
  jr ra
  addiu sp, sp, 0x0018

// Versus Timer
VsTimer:
lui t0, 0x8050
lb t0, 0x0009 (t0)
addiu t1, r0, 0x0002
beq t0, t1, VsTimerEnabled
nop
addiu at, r0, 0x0002
b VsTimerEnd
nop
VsTimerEnabled:
  addu at, r0, r0
VsTimerEnd:
  j 0x8004FA8C
  nop

// Gold Mushroom
GoldMushroom:
lui t0, 0x8050
lb t0, 0x000A (t0)
addiu t1, r0, 0x0002
beq t0, t1, GoldMushroomSmall
nop
addiu t1, r0, 0x0003
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
  lui t0, 0x0002
  or t8, t8, t0
GoldMushroomEnd:
  j 0x802B30D4
  sw t8, 0x000C (a0)

fill 0xC00000 - origin() // Zero fill remainder of ROM

// Random Tracks
origin 0x0B4B6C
base 0x800B3F6C
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
