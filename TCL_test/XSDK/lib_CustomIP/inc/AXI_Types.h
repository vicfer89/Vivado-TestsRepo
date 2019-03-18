/*
 * AXI_Types.h
 *
 *  Created on: 11/03/2019
 *      Author: VFF
 */

#ifndef AXI_TYPES_H_
#define AXI_TYPES_H_

#include "xil_types.h"

/** \def OFFSET_REG(n)
    \brief Computes offset register value.

    Computes offset register value for AXI access.
*/
#define OFFSET_REG(n) 0x00 + 4*n

/** \def TRUE
    \brief Value for TRUE.

    Value for TRUE flag.
*/
#ifndef TRUE
	#define TRUE 1
#endif

/** \def FALSE
    \brief Value for FALSE.

    Value for FLASE flag.
*/
#ifndef FALSE
	#define FALSE 0
#endif

/** \var typedef union AXI_Register
    \brief Union for AXI_Register handling.

    Act as a handler between AXI u32 registers and its bytes, nibbles and u16 registers.
*/
typedef union _AXI_Register
{
	u32 AXI_X32_Register;

	struct{
		u16 LSR;
		u16 MSR;
	}AXI_Sub_Registers;

	struct{
		u8 by0;
		u8 by1;
		u8 by2;
		u8 by3;
	}AXI_Bytes;

	struct{
		u8 nB0 : 4;
		u8 nB1 : 4;

		u8 nB2 : 4;
		u8 nB3 : 4;

		u8 nB4 : 4;
		u8 nB5 : 4;

		u8 nB6 : 4;
		u8 nB7 : 4;
	}AXI_Nibbles;

	struct{
		u8 b0  : 1;
		u8 b1  : 1;
		u8 b2  : 1;
		u8 b3  : 1;

		u8 b4  : 1;
		u8 b5  : 1;
		u8 b6  : 1;
		u8 b7  : 1;

		u8 b8  : 1;
		u8 b9  : 1;
		u8 b10 : 1;
		u8 b11 : 1;

		u8 b12 : 1;
		u8 b13 : 1;
		u8 b14 : 1;
		u8 b15 : 1;

		u8 b16 : 1;
		u8 b17 : 1;
		u8 b18 : 1;
		u8 b19 : 1;

		u8 b20 : 1;
		u8 b21 : 1;
		u8 b22 : 1;
		u8 b23 : 1;

		u8 b24 : 1;
		u8 b25 : 1;
		u8 b26 : 1;
		u8 b27 : 1;

		u8 b28 : 1;
		u8 b29 : 1;
		u8 b30 : 1;
		u8 b31 : 1;
	}AXI_Bits;

}AXI_Register;

/** \var typedef enum IP_registers
    \brief Enumerated where registers had been coded to provide access.

    Codes slv_reg registers which are into the peripheral. For more information, see
    \var typedef struct AXI_Registers.
*/
typedef enum _IP_registers{
	slv_reg0 = 0,
	slv_reg1,
	slv_reg2,
	slv_reg3,
	slv_reg4,
	slv_reg5,
	slv_reg6,
	slv_reg7,
	slv_reg8,
	slv_reg9,
	slv_reg10,
	slv_reg11,
	slv_reg12,
	slv_reg13,
	slv_reg14,
	slv_reg15,
	slv_reg16,
	slv_reg17,
	slv_reg18,
	slv_reg19,
	slv_reg20,
	slv_reg21,
	slv_reg22,
	slv_reg23,
	slv_reg24,
	slv_reg25
}IP_registers;
#endif /* AXI_TYPES_H_ */
