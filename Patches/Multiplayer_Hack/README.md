# Mario Kart 64 Multiplayer ROM Hack
Mario Kart 64 ROM hack with configuration menu

## Features
### TITLE MENU Options
- Aspect Ratio: 4:3* / 16:9**
- Game Pacing: Original (15-30fps)* / 30fps** / 60fps
- MP Music: Disabled* / Enabled**
- VS Detail: Original* / High**
  - Multiplayer DKJP Boat: Enabled / Disabled
  - Multiplayer KD Train: Original / Full
- Track Selection: Original / Random
- Gold Mushroom: Original / Feather (Small) / Feather (Big)

### CHARACTER SELECT Options
- Character Stats: Original / All Yoshi

### GP MAP SELECT Options
- Trophy Ceremony: Enabled / Disabled

### VS MAP SELECT Screen
- Items: Original / P1 / P2 / P3 / P4 / P5 / P6 / P7 / P8
- VS Timer: Enabled / Disabled
- VS Track Order: Original / All Cups

### VS MATCH RANKING Screen
- Include total score by player as 2/1/0 (3P) or 3/2/1/0 (4P)

## TODO
### TITLE MENU Options
- Platform: N64* / Emulator**
	- Purpose: Automatically change multiple visual settings (indicated here with */**) to be appropriate for the platform
- VS Detail: Original / High
  - Multiplayer MR Pipe: Original / Full
  - Multiplayer MMF Trees: Enabled / Disabled
  - Multiplayer SL Penguin: Enabled / Disabled
  - Multiplayer FS Snow: Enabled / Disabled
  - Multiplayer TT Cars: Original / Full

### CHARACTER SELECT Options
- Characters: Menu / Random

### GAME SELECT Menu Options
- Race Laps: Min [3], Max[3]
	- Purpose: Each race randomly assigned a number of laps based on this range
- Course Z Scaler: Original / Minimum / Maximum
- Engine (150cc): 150cc / 200cc
- Engine (Extra): 100cc / 150cc / 200cc
- Backwards Courses: Enabled / Disabled
	- Note: This will take some serious work but SKELUX made a proof of concept is at https://www.youtube.com/watch?v=fZfZkFYkEBQ

### GP MAP SELECT Options
- GP Cups: Single / All Cups

### VS MAP SELECT Screen
- Items: Balanced / Aggressive / Random / None
- VS Timer: 3/4 Player
- VS Track Order: All Cups (Random Order)
- VS Bomb Karts: Enabled / Disabled
- VS CPUs: None / 1 / 2 / 3 / 4 / 5 / 6 / 7

### VS MATCH RANKING Screen
- Restore "Quit" menu option

### Battle MAP SELECT Options
- Battle Bomb Phase: Enabled / Disabled

## Building (Windows)
- Clone or download the repository
- Put "Mario Kart 64 (U) [!].z64" in the LIB directory
- Download and extract [these files](https://drive.google.com/file/d/0B1g_ALmgbOzxSDdWVVA4TXdwWlk/view?usp=sharing) to the Multiplayer_Hack directory
- Drag and drop mk64_multiplayer_hack.asm onto asm.cmd
