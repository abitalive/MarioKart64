// Mario Kart 64 functions

constant DmaCopy(0x80001158)
// a0 = RAM destination
// a1 = ROM source
// a2 = Size

constant ResourceDisplay1(0x80003B04)

constant ResourceDisplay2(0x80003FD4)

constant PrintTimer(0x8004F7F4)
// a0 = X coordinate
// a1 = Y coordinate
// a2 = Time

constant DebugPrintString(0x80057484)
// a0 = Pointer to X coordinate
// a1 = Pointer to Y coordinate
// a2 = Pointer to string

constant LoadDebugFont(0x80057710)

constant DebugPrintStringCoord(0x800577A4)
// a0 = X coordinate
// a1 = Y coordinate
// a2 = Pointer to string

constant RandomItem(0x8007ADA8)
// a0 = Place
// a1 = Player type
//   00 = Human
//   01 = CPU
// v0 = Random item

constant SetTextColor(0x800930D8)
// a0 = Color
//   00 = Blue
//   01 = Green
//   02 = Red
//   03 = Yellow
//   04 = Transition
//   05 = Transition

constant PrintText2 (0x80093788)
// a0 = Pointer to X coordinate
// a1 = Pointer to Y coordinate
// a2 = Pointer to string
// a3 = Spacing between letters
// sp[10] = X scale (float)
// sp[14] = Y scale (float)

constant PrintText2Cord(0x800939FC)
// a0 = X coordinate
// a1 = Y coordinate
// a2 = Pointer to string
// a3 = Spacing between letters
// sp[10] = X scale (float)
// sp[14] = Y scale (float)

constant PlaySound2(0x800C8E10)
// a0 = Sound

constant BCopy(0x800D3520)
// a0 = Source
// a1 = Destination
// a2 = Size

constant GetItemTable(0x802A7BD4)
// a0 = Lookup offset
// v0 = Pointer to item table

constant RandomU16(0x802B7D94)
// v0 = Random number

constant RandomInt(0x802B7E34)
// a0 = Range
// v0 = Random number
