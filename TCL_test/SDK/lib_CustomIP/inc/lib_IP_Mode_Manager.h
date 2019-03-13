/*
 * lib_IP_Mode_Manager.h
 *
 *  Created on: 12/03/2019
 *      Author: VFF
 */

#ifndef LIB_IP_MODE_MANAGER_H_
#define LIB_IP_MODE_MANAGER_H_

#include "AXI_Types.h"

typedef enum _Mode_Stick
{
	None = 0,
	Manual,
	Auto,
	Invalid
}mode_Stick;

/** \var typedef struct AXI_Registers
    \brief Enumerated where registers had been coded to provide access.

    Structure where slv_reg information are contained. The function for these registers are
    as follows:

    	- slv_reg0:
    		+ slv_reg0 Lower 2 bytes -> fromARM_PWM_man_value: value for MANUAL mode.
    		+ slv_reg0 Upper 2 bytes -> fromARM_PWM_auto_value: value for AUTO mode.
    	- slv_reg1:
    		+ slv_reg1 Lower 2 bytes -> valueModeRx: RC value from mode channel.
    		+ slv_reg1 [bit16 : bit17] -> ModeStick: Mode coded as two bits.
    		+ slv_reg1 [bit18 : MAX_SLVREG_BITS] -> Reserved for future use.
    	- slv_reg2: Reserved for future use.
    	- slv_reg3: Reserved for future use.

*/
typedef struct _handler_ModeManager
{
	u32 baseAddr;

	AXI_Register slv_reg0;
	AXI_Register slv_reg1;
	AXI_Register slv_reg2;
	AXI_Register slv_reg3;

}handler_ModeManager, *ptr_handler_ModeManager;

void init_IP_Mode_Manager(handler_ModeManager *handler, u32 baseAddr);

void set_PWM_Manual(handler_ModeManager *handler, u16 PWM_Value);
void set_PWM_Auto(handler_ModeManager *handler, u16 PWM_Value);

u16 get_Mode_PWM(handler_ModeManager *handler);
mode_Stick get_Mode_Stick(handler_ModeManager *handler);

#endif /* LIB_IP_MODE_MANAGER_H_ */
