arch n64.cpu
endian msb
//output "", create

include "..\LIB\N64.inc"
include "..\LIB\functions.inc"
include "..\LIB\macros.inc"

origin 0x0
insert "..\LIB\Mario Kart 64 (U) [!].z64"

constant ModeSelection(0x800DC53C)
constant CourseSelection1(0x800DC5A0)
constant CupSelection(0x8018EE09)
constant CourseSelection2(0x8018EE0B)
constant Options(0x80500000)

// Init
origin 0x0029F0
base 0x80001DF0
nop // Disable resource display function

origin 0x001E6C
base 0x8000126C
jal ResourceDisplay1
nop

// Runs once at boot
// Available registers: all
// Replaces resource display function
origin 0x004704
base ResourceDisplay1
scope Init: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x800010CC // Original instruction
  nop
  DMA:
    la a0, 0x80400000 // RAM destination
    li a1, 0xBE9170 // ROM source
    li a2, 0x16E90 // Size
    jal DmaCopy // DMA copy end of ROM to Expansion Pak area
    nop
  Menu:
    la t0, Options
    addiu t1, t0, 0x10 // 15 menu options
    li t2, 0x01010101
    Loop:
      sw t2, 0 (t0) // Initialize cursor and options with 0x01
      addiu t0, 0x04
      bne t0, t1, Loop
      nop
    Default:
      la t0, Options
      ori t1, r0, 0x02
      sb t1, 8 (t0) // Versus Tracks
      sb t1, 12 (t0) // Character Stats
      sb t1, 13 (t0) // Versus Scores
  lw ra, 0x14 (sp)
  jr ra
  addiu sp, 0x18
}

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

dd 0x00000002 // Versus Scores
dd MenuEntry13
dd MenuEntry13Setting1, MenuEntry13Setting2, 0x00000000

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

MenuEntry13:
Asciiz("vs scores")
MenuEntry13Setting1:
Asciiz("default")
MenuEntry13Setting2:
Asciiz("enabled")

TitleString:
Asciiz("abitalive  weatherton  abney  sully")

fill 0x800040C0 - pc() // Zero fill remainder of resource display function

// Menu
origin 0x0957D0
base 0x80094BD0
jal 0x80400000
nop

origin 0xBE9170
base 0x80400000
addiu sp, -0x30
sw ra, 0x14 (sp)
jal 0x800A8230
nop
jal LoadDebugFont
nop
Title:
  ori a0, r0, 0x00
  ori a1, r0, -0x08
  la a2, TitleString
  jal DebugPrintStringCoord
  nop
la t0, MenuStrings // Array start
addiu t1, r0, 0x01 // Entry number
addiu a1, r0, 0x50 // Y coordinate
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
  addiu sp, 0x30

// Same Character
scope SameCharacter: {
  sb s0, 0 (t9) // Store menu position
  beq v0, r0, End
  nop
  li a0, 0x49008000 // Selection scroll
  jal PlaySound2 // Play sound
  nop
  End:
    j 0x800B3A50
    nop
}

// Random Tracks
scope RandomTracks: {
  LuiLb(t0, Options+1)
  OriBeq(t0, 0x01, t1, End) // Skip if option disabled
  LuiLw(t0, ModeSelection) // Determine the current mode
  Versus:
    OriBne(t0, 0x02, t1, Battle) // If mode == Versus
    jal RandomInt // Call random function with range 0x00-0x10
    ori a0, r0, 0x10
    OriBne(v0, 0x0F, t1, Store) // Store the returned value if != 0x0F (BF)
    ori v0, r0, 0x12 // Swap 0x0F (BF) with 0x12 (DKJP)
    b Store
    nop
  Battle:
    OriBne(t0, 0x03, t1, End) // Else if mode == Battle
    jal RandomInt // Call random function with range 0x00-0x03
    ori a0, r0, 0x04
    addiu v0, 0x10 // Add 0x10 to the returned value
    OriBne(v0, 0x12, t1, Store) // Store the result if != 0x12 (DKJP)
    ori v0, r0, 0x0F // Swap 0x12 (DKJP) with 0x0F (BF)
  Store:
    LuiSh(v0, CourseSelection1, t0)
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

scope ScalingFixPost: { // Available registers: t7, at
  LuiLb(t7, Options+2)
  Disabled:
    OriBne(t7, 0x01, at, Fps30) // If option disabled
    LuiLw(t9, 0x80150114) // Original instructions
    b End
    nop
  Fps30:
    OriBne(t7, 0x02, at, Fps60) // Else if option set to 30 fps
    ori t9, r0, 0x02 // Return 2
    b End
    nop
  Fps60:
    OriBne(t7, 0x03, at, End) // Else if option set to 60 fps
    ori t9, r0, 0x01 // Return 1
  End:
    jr ra
    nop
}

// Widescreen
scope Widescreen: {
  LuiLb(t0, Options+3)
  Disabled:
    OriBne(t0, 0x01, t1, Enabled) // If option disabled
    LuiLw(a3, 0x80150148) // Original instruction
    b End
    nop
  Enabled:
    OriBne(t0, 0x02, t1, End) // Else if option enabled
    Fullscreen:
      LuiLw(t0, 0x80150148)
      LiBne(t0, 0x3FAAAAAB, t1, Widescreen) // If AR == 1.33333
      li a3, 0x3FDFAAAB // Return 1.7474
      b End
      nop
    Widescreen:
      LuiLw(t0, 0x80150148)
      LiBne(t0, 0x402AAAAB, t1, Current) // Else if AR == 2.66667
      li a3, 0x4060AAAB // Return 3.51042
      b End
      nop
    Current:
      LuiLw(a3, 0x80150148) // Else return current value
  End:
    jr ra
    nop
}

// Skip Trophy Ceremony
scope SkipTrophy: {
  LuiLb(t0, Options+4)
  Disabled:
    OriBne(t0, 0x01, t1, Enabled) // If option disabled
    addiu t7, r0, 0x05 // Original instruction
    b End
    nop
  Enabled:
    OriBne(t0, 0x02, t1, End) // If option enabled
    ori t7, r0, 0x01 // Skip to main menu
  End:
    j 0x8028E3DC
    nop
}

// Multiplayer Music
scope MultiplayerMusic: {
  LuiLb(t0, Options+5)
  Disabled:
    OriBne(t0, 0x01, t1, Enabled) // If option disabled
    LuiLw(t6, 0x800DC530) // Original instructions
    b End
    nop
  Enabled:
    OriBne(t0, 0x02, t1, End) // If option enabled
    ori t6, r0, 0x01 // Return 1 player
  End:
    j 0x8028ECA0
    nop
}

scope MultiplayerMusicL: { // Available registers: t0, at
  LuiLb(t0, Options+5)
  Disabled:
    OriBne(t0, 0x01, at, Enabled) // If option disabled
    LuiLw(t1, 0x800DC52C) // Original instructions
    b End
    nop
  Enabled:
    OriBne(t0, 0x02, at, End) // If option enabled
    ori t1, r0, 0x01 // Return 1 player
  End:
    jr ra
    nop
}

// Multiplayer KD Train
scope MultiplayerTrain: { // Available registers: t5, a2
  LuiLb(t5, Options+6)
  Disabled:
    OriBne(t5, 0x01, a2, Enabled) // If option disabled
    LuiLw(v0, 0x800DC530) // Original instructions
    b End
    nop
  Enabled:
    OriBne(t5, 0x02, a2, End) // If option enabled
    ori v0, r0, r0 // Return 1 player
  End:
    jr ra
    nop
}

// Multiplayer DKJP Boat
scope MultiplayerBoat: { // Available registers: at, a0
  LuiLb(at, Options+7)
  Disabled:
    OriBne(at, 0x01, a0, Enabled) // If option disabled
    lb t7, 0 (t2) // Original instruction
    b End
    nop
  Enabled:
    OriBne(at, 0x02, a0, End) // Else if option enabled
    ori t7, r0, 0x01 // Return 1 player
  End:
    j 0x80013354
    nop
}

// Versus All Cups
scope VersusAllCups: { // Available registers: all
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x80290388 // Original instruction
  nop
  LuiLb(t0, Options+8)
  OriBeq(t0, 0x01, t1, End) // Skip if option disabled
  LuiLw(t0, ModeSelection)
  OriBne(t0, 0x02, t1, End) // Skip if mode != Versus
  RainbowRoad:
    LuiLh(t0, CourseSelection1)
    OriBne(t0, 0x0D, t1, IncrementCup) // If course == Rainbow Road
    LuiSb(r0, CupSelection, t1) // Reset cup
    LuiSb(r0, CourseSelection2, t1) // Reset course
    b End
    nop
  IncrementCup:
    LuiLb(t0, CourseSelection2)
    OriBne(t0, 0x03, t1, IncrementCourse) // Else if course == 3
    LuiLb(t0, CupSelection)
    addiu t0, 0x01 // Increment cup
    LuiSb(t0, CupSelection, t1)
    LuiSb(r0, CourseSelection2, t1) // Reset course
    b End
    nop
  IncrementCourse:
    LuiLb(t0, CourseSelection2)
    addiu t0, 0x01 // Else increment course
    LuiSb(t0, CourseSelection2, t1)
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

// Versus Timer
scope VersusTimer: { // Available registers: all
  LuiLb(t0, Options+9)
  Disabled:
    OriBne(t0, 0x01, t1, Enabled) // If option disabled
    LuiLw(v0, ModeSelection) // Original instructions
    b End
    nop
  Enabled:
    OriBne(t0, 0x02, t1, End) // Else if option enabled
    LuiLw(t0, ModeSelection)
    OriBne(t0, 0x02, t1, Current) // If mode == Versus
    Versus:
      ori v0, r0, r0 // Return GP mode
      b End
      nop
    Current:
      LuiLw(v0, ModeSelection) // Else return current mode
  End:
    j 0x8004FA84
    nop
}

// Gold Mushroom
// Available registers: all except t7
// Returns: t8
scope GoldMushroom: {
  LuiLb(t0, Options+10)
  Disabled:
    OriBne(t0, 0x01, t1, FeatherSmall) // If option disabled
    ori t8, t7, 0x0200 // Original instruction
    b End
    nop
  FeatherSmall:
    OriBne(t0, 0x02, t1, FeatherBig) // Else if option set to feather small
    ori t8, t7, 0x1000 // Activate small feather jump state
    b End
    nop
  FeatherBig:
    OriBne(t0, 0x03, t1, End) // Else if option set to feather big
    lui t0, 0x02
    or t8, t0 // Activate large feather jump state
  End:
    j 0x802B30D4
    sw t8, 0x000C (a0) // Store new state
}

// Player Items
// Runs once when players receive an item
// Available registers: all
// Returns: a0
scope PlayerItems: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  LuiLb(t0, Options+11)
  OriBeq(t0, 0x01, t1, End) // Skip if option disabled
  Enabled:
    SltiBeq(t0, 0x0A, t1, End) // If option enabled
    addiu a0, t0, -0x02 // Set player
  End:
    jal 0x8007ADA8 // Original instruction
    nop
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

// Character Stats
// Runs once before a race
// Available registers: all
scope CharacterStats: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x800010CC // Original instruction
  nop
  LuiLb(t0, Options+12)
  Disabled:
    OriBne(t0, 0x01, t1, Yoshi) // If option disabled
    la a0, 0x800E2360 // Destination
    li a1, 0x0E2F60 // Source
    li a2, 0x14B0 // Size
    jal DmaCopy // DMA copy default stats
    nop
    b End
    nop
  Yoshi:
    OriBne(t0, 0x02, t1, End) // Else if option set to all Yoshi
    li a0, YoshiMain // Source
    la a1, 0x800E2360 // Destination
    li a2, 0x14B0 // Size
    jal BCopy // Copy Yoshi main stats
    nop
    li a0, YoshiWeight // Source
    la a1, 0x802B8790 // Destination
    li a2, 0x20 // Size
    jal BCopy // Copy Yoshi weight stats
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

// Lap Fix
// Runs once when a racer crosses the finish line in the opposite direction
// Available registers: all except t3
// Returns: t4
scope LapFix: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  Lap3:
    OriBne(t3, 0x03, t0, DecrementLap) // If lap == 3
    b End // Skip
    nop
  DecrementLap:
    addiu t4, t3, -0x01 // Else decrement lap
    sw t4, 0 (v0)
  End:
    jal 0x80008F38 // Original instruction
    nop
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

// Versus Scores
// Runs every frame on the 3p/4p versus results screen
// Available registers: all
scope VersusScores: {
  addiu sp, -0x28
  sw ra, 0x1C (sp)
  sw a0, 0 (sp)
  sw a1, 0x04 (sp)
  sw a2, 0x08 (sp)
  jal 0x800A6E94 // Original instruction
  nop
  LuiLb(t0, Options+13)
  OriBeq(t0, 0x01, t1, End) // Skip if option disabled
  Enabled:
    ori a0, r0, 0x03 // Color = yellow
    jal SetTextColor
    nop
    lw t0, 0 (sp)
    lw t1, 0x04 (sp)
    lw t2, 0x08 (sp)
    sll t3, t1, 0x1
    addu t3, t1
    addu t2, t2, t3
    addiu a1, sp, 0x20 // Pointer to buffer
    ori a2, r0, 0x08 // Buffer size = 8
    Score3p:
      OriBne(t0, 0x03, t3, Score4p) // If players == 3
      lbu t3, 0 (t2)
      sll t4, t3, 0x1 // 2 points for first
      lbu t3, 0x01 (t2)
      addu a0, t4, t3 // 1 point for second
      jal IntToAscii
      nop
      lw t0, 0x04 (sp)
      ori t1, r0, 0x4E
      multu t0, t1
      mflo t1
      ori a0, r0, 0x34
      addu a0, a0, t1 // X coordinate
      b ScorePrint
      nop
    Score4p:
      OriBne(t0, 0x04, t3, End) // Else if players == 4
      lbu t3, 0 (t2)
      sll t4, t3, 0x1
      addu t5, t4, t3 // 3 points for first
      lbu t3, 0x01 (t2)
      sll t4, t3, 0x1 // 2 points for second
      addu t5, t4
      lbu t3, 0x02 (t2)
      addu a0, t5, t3 // 1 point for third
      jal IntToAscii
      nop
      lw t0, 0x04 (sp)
      ori t1, r0, 0x45
      multu t0, t1
      mflo t1
      ori a0, r0, 0x1A
      addu a0, a0, t1 // X coordinate
    ScorePrint:
      ori a1, r0, 0x20 // Y coordinate
      or a2, r0, v0 // Pointer to string
      or a3, r0, r0 // Spacing = 0
      li t0, 0x3F4CCCCD
      sw t0, 0x10 (sp) // X Scale = 0.8
      sw t0, 0x14 (sp) // Y Scale = 0.8
      jal PrintText2Cord
      nop
    End:
      lw ra, 0x1C (sp)
      jr ra
      addiu sp, 0x28
}

// a0 = Integer
// a1 = Pointer to buffer
// a2 = Buffer size
// v0 = Pointer to first digit in buffer
scope IntToAscii: {
  addiu a3, r0, 0xa
  addiu t8, a1, -0x01
  addu  t6, a1, a2
  addiu t6, -0x02
  sb    r0, 0x01 (t6)
  Loop:
    divu  a0, a3
    mfhi  t7
    mflo  a0
    addiu t7, t7, 0x30
    beq   a0, r0, End
    sb    t7, 0 (t6)
    addiu t6, t6, -0x01
    bne   t6, t8, Loop
    nop
  End:
    jr ra
    addu v0, t6, r0
}

// Versus All Cups Menu
// Runs every frame on the versus and battle results screens
// Available registers: all
// Returns: s2
scope VersusAllCupsMenu: {
  LuiLb(t0, Options+8)
  Enabled:
    OriBne(t0, 0x02, t1, Disabled) // If option enabled
    LuiLw(t0, ModeSelection)
    OriBne(t0, 0x02, t1, Disabled) // If mode == Versus
    LuiLb(t0, CupSelection)
    sll t0, t0, 0x02
    LuiLb(t1, CourseSelection2)
    addu t1, t0
    ori t2, r0, 0x14
    multu t1, t2
    mflo t1
    la t0, Option1
    addu t0, t1
    la t1, Strings
    sw t0, 4 (t1)
    la s2, Strings
    b End
    nop
  Disabled:
    addiu s2, 0x775C // Else original instruction
  End:
    jr ra
    nop

  Strings:
    dd 0x00000000
    dd 0x00000000
    dd Option2
    dd Option3
    dd Option4
  Option1:
    AsciizAlign("CONTINUE TO MMF", 0x14)
    AsciizAlign("CONTINUE TO KTB", 0x14)
    AsciizAlign("CONTINUE TO KD", 0x14)
    AsciizAlign("CONTINUE TO TT", 0x14)
    AsciizAlign("CONTINUE TO FS", 0x14)
    AsciizAlign("CONTINUE TO CM", 0x14)
    AsciizAlign("CONTINUE TO MR", 0x14)
    AsciizAlign("CONTINUE TO WS", 0x14)
    AsciizAlign("CONTINUE TO SL", 0x14)
    AsciizAlign("CONTINUE TO RRY", 0x14)
    AsciizAlign("CONTINUE TO BC", 0x14)
    AsciizAlign("CONTINUE TO DKJP", 0x14)
    AsciizAlign("CONTINUE TO YV", 0x14)
    AsciizAlign("CONTINUE TO BB", 0x14)
    AsciizAlign("CONTINUE TO RRD", 0x14)
    AsciizAlign("CONTINUE TO LR", 0x14)
  Option2:
    Asciiz("COURSE CHANGE")
  Option3:
    Asciiz("DRIVER CHANGE")
  Option4:
    Asciiz("RETRY")
  Align(4)
}

// Runs when an option is selected on the versus and battle results screens
// Available registers: all
scope VersusAllCupsMenu2: {
  LuiLb(t0, Options+8)
  Enabled:
    OriBne(t0, 0x02, t1, Disabled) // If option enabled
    LuiLw(t0, ModeSelection)
    OriBne(t0, 0x02, t1, Disabled) // If mode == Versus
    lw v1, 0x04 (v0)
    OriBeq(v1, 0x0A, at, Option1)
    OriBeq(v1, 0x0B, at, Option2)
    OriBeq(v1, 0x0C, at, Option3)
    OriBeq(v1, 0x0D, at, Option4)
    Option1:
      LuiLh(t0, CourseSelection1)
      RainbowRoad:
        OriBne(t0, 0x0D, t1, Lookup) // If course == Rainbow Road
        ori t0, r0, 0x08 // Course = Luigi Raceway
        LuiSh(t0, CourseSelection1, t1) // Reset course
        LuiSb(r0, CupSelection, t1) // Reset cup
        LuiSb(r0, CourseSelection2, t1) // Reset course
        j 0x8009CF94 // Retry
        nop
      Lookup:
        la t1, 0x800F2BB4 // Else increment course
        Loop:
          lh t2, 0 (t1)
          beq t0, t2, Increment
          nop
          addiu t1, 0x02
          b Loop
          nop
        Increment:
          lh t1, 0x02 (t1)
          LuiSh(t1, CourseSelection1, t0) // Increment course
          IncrementCup:
            LuiLb(t0, CourseSelection2)
            OriBne(t0, 0x03, t1, IncrementCourse) // If course == 3
            LuiLb(t0, CupSelection)
            addiu t0, 0x01 // Increment cup
            LuiSb(t0, CupSelection, t1)
            LuiSb(r0, CourseSelection2, t1) // Reset course
            j 0x8009CF94 // Retry
            nop
          IncrementCourse:
            LuiLb(t0, CourseSelection2)
            addiu t0, 0x01 // Else increment course
            LuiSb(t0, CourseSelection2, t1)
            j 0x8009CF94 // Retry
            nop
    Option2:
      j 0x8009CFA4 // Course change
      nop
    Option3:
      j 0x8009CFB4 // Driver change
      nop
    Option4:
      j 0x8009CF94 // Retry
      nop
  Disabled:
    lw v1, 0x04 (v0) // Else original instruction
  End:
    j 0x8009CF6C
    nop
}

// Character Stats
include "stats_yoshi.asm"

fill 0xC00000 - origin() // Zero fill remainder of ROM

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

origin 0x002490
base 0x80001890
jal ScalingFixPost
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

// Multiplayer Music
origin 0x0F82A8
base 0x8028EC98
j MultiplayerMusic
nop

origin 0x0F8FD0
base 0x8028F9C0
jal MultiplayerMusicL
nop

// Multiplayer KD Train
origin 0x01354C
base 0x8001294C
jal MultiplayerTrain
nop

// Multiplayer DKJP Boat
origin 0x013F4C
base 0x8001334C
j MultiplayerBoat

// Versus All Cups
origin 0x09DBA4
base 0x8009CFA4
jal VersusAllCups
nop

// Versus Timer
origin 0x05067C
base 0x8004FA7C
j VersusTimer
nop

// Gold Mushroom
origin 0x11C680
base 0x802B3070
nop
nop
j GoldMushroom

// Items
origin 0x07BB60
base 0x8007AF60
jal PlayerItems

// Character Stats
origin 0x003314
base 0x80002714
jal CharacterStats
nop

// Lap Fix
origin 0x00A2A8
base 0x800096A8
nop
jal LapFix
nop

// Versus Scores
origin 0xA7864
base 0x800A6C64
jal VersusScores

origin 0x0A7938
base 0x800A6D38
jal VersusScores

// Versus All Cups Menu
origin 0x0A7220
base 0x800A6620
jal VersusAllCupsMenu

origin 0x09DB64
base 0x8009CF64
j VersusAllCupsMenu2
