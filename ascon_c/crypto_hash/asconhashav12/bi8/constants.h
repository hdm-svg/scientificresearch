#ifndef CONSTANTS_H_
#define CONSTANTS_H_

#include <stdint.h>

#define ASCON_128_KEYBYTES 16
#define ASCON_128A_KEYBYTES 16
#define ASCON_80PQ_KEYBYTES 20

#define ASCON_128_RATE 8
#define ASCON_128A_RATE 16
#define ASCON_HASH_RATE 8
#define ASCON_PRF_IN_RATE 32
#define ASCON_PRFA_IN_RATE 40
#define ASCON_PRF_OUT_RATE 16

#define ASCON_128_PA_ROUNDS 12
#define ASCON_128_PB_ROUNDS 6
#define ASCON_128A_PA_ROUNDS 12
#define ASCON_128A_PB_ROUNDS 8

#define ASCON_HASH_PA_ROUNDS 12
#define ASCON_HASH_PB_ROUNDS 12
#define ASCON_HASHA_PA_ROUNDS 12
#define ASCON_HASHA_PB_ROUNDS 8

#define ASCON_PRF_PA_ROUNDS 12
#define ASCON_PRF_PB_ROUNDS 12
#define ASCON_PRFA_PA_ROUNDS 12
#define ASCON_PRFA_PB_ROUNDS 8

#define ASCON_128_IV 0x8040000020301000ull
#define ASCON_128A_IV 0xc000000030200000ull
#define ASCON_80PQ_IV 0x8040800020301000ull
#define ASCON_HASH_IV 0x0040000020200002ull
#define ASCON_HASHA_IV 0x0040000020300002ull
#define ASCON_XOF_IV 0x0040000020200000ull
#define ASCON_XOFA_IV 0x0040000020300000ull

#define ASCON_HASH_IV0 0xfa8e976bb985dc4dull
#define ASCON_HASH_IV1 0xc8085072a40ccd94ull
#define ASCON_HASH_IV2 0xfe1781be5a847314ull
#define ASCON_HASH_IV3 0x2f871f6c6d0082b2ull
#define ASCON_HASH_IV4 0x7a1ba68850ec407eull

#define ASCON_HASHA_IV0 0x194c0f180a5d41e4ull
#define ASCON_HASHA_IV1 0x7faa87825647f3a7ull
#define ASCON_HASHA_IV2 0x606dbe06db8da430ull
#define ASCON_HASHA_IV3 0xe0dd6bcf19fbce3bull
#define ASCON_HASHA_IV4 0x9720dc4446473d8bull

#define ASCON_XOF_IV0 0x8a46f0d354e771b8ull
#define ASCON_XOF_IV1 0x04489f4084368cd0ull
#define ASCON_XOF_IV2 0x6c94f2150dbcf66cull
#define ASCON_XOF_IV3 0x48965294f143b44eull
#define ASCON_XOF_IV4 0x0788515fe0e5fb8aull

#define ASCON_XOFA_IV0 0x4ab43d4f16a80d2cull
#define ASCON_XOFA_IV1 0xd0ae310bf0f619ceull
#define ASCON_XOFA_IV2 0xc08cf3c801d89cf3ull
#define ASCON_XOFA_IV3 0x3859d2094dac0b35ull
#define ASCON_XOFA_IV4 0xd274992be52b5357ull

#define ASCON_MAC_IV 0xe100000020200000ull
#define ASCON_MACA_IV 0xe100000020300000ull
#define ASCON_PRF_IV 0xe000000020200000ull
#define ASCON_PRFA_IV 0xe000000020300000ull
#define ASCON_PRFS_IV 0x9020000020200000ull

#define RC0 0x0101010100000000ull
#define RC1 0x0101010000000001ull
#define RC2 0x0101000100000100ull
#define RC3 0x0101000000000101ull
#define RC4 0x0100010100010000ull
#define RC5 0x0100010000010001ull
#define RC6 0x0100000100010100ull
#define RC7 0x0100000000010101ull
#define RC8 0x0001010101000000ull
#define RC9 0x0001010001000001ull
#define RCa 0x0001000101000100ull
#define RCb 0x0001000001000101ull

#define RC(i) (constants[i])
#define START(n) (12 - (n))
#define INC 1
#define END 12

extern const uint64_t constants[];

#endif /* CONSTANTS_H_ */
