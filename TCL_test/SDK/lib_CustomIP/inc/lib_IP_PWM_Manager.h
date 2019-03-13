/**
 * lib_IP_PWM_Manager.h
 *
 *  Created on: 11/03/2019
 *      Author: VFF
 */

#ifndef LIB_IP_PWM_MANAGER_H_
#define LIB_IP_PWM_MANAGER_H_

#include "AXI_Types.h"

/** \var typedef enum inversion
    \brief Enumerated for inverted or not inverted selection.

    Choose betweeen inverted or not inverted output for process stage at PWM Manager IP.
*/
typedef enum _inversion{
	channel_NotInverted = 0, // Not inverted output
	channel_Inverted 		 // Inverted output
}inversion;

/** \var typedef enum inversion
    \brief Enumerated for inverted or not inverted selection.

    Choose betweeen inverted or not inverted output for process stage at PWM Manager IP.
*/
typedef enum _outputType{
	pwm_out_processed = 0, // PWM processed at IP
	pwm_out_direct		   // Direct PWM from ARM
}outputType;

/** \var typedef enum channel
    \brief Enumerated for channel selection.

    Allows to select a channel in order to configure itself or read its values
*/
typedef enum _channel{
	ch_Right = 0,	// Right channel
	ch_Left			// Left channel
}channel;

typedef struct _PWM_Manager_values
{
	u16 r_MinPWM;
	u16 r_MaxPWM;

	u16 r_PWM_ARM_L;
	u16 r_PWM_ARM_R;
}PWM_Manager_values;

typedef struct _PWM_Manager_configurations
{
	volatile u8 f_sel_L_inv;
	volatile u8 f_sel_R_inv;
	volatile u8 f_sel_L_direct;
	volatile u8 f_sel_R_direct;
}PWM_Manager_configurations;

typedef struct _PWM_Manager_inputs
{
	u16 v_PWM_RC;
	u16 v_PWM_INV;
}PWM_Manager_inputs;

typedef struct _PWM_Manager_outputs
{
	u16 v_PWM_L;
	u16 v_PWM_R;
}PWM_Manager_outputs;


/** \var typedef struct handler_PWMManager, *ptr_handler_PWMManager
    \brief handler structure for PWM_Manager IP.

    This structure contains slv_reg content which are read or write to AXI bus, and baseAddr for the peripheral.
    The function for these registers are as follows:

    	- slv_reg0: Configuration register
    		+ slv_reg0 bit0 -> f_sel_L_inv: Inversion flag for L channel.
    		+ slv_reg0 bit1 -> f_sel_R_inv: Inversion flag for R channel.
    		+ slv_reg0 bit2 -> f_sel_L_direct: Direct mode for L channel.
    		+ slv_reg0 bit3 -> f_sel_R_direct: Direct mode for R channel.

    	- slv_reg1: Maximum and minimum PWM ranges.
    		+ slv_reg1 Lower 2 bytes -> r_MinPWM: Minimum allowable PWM.
    		+ slv_reg1 Upper 2 bytes -> r_MaxPWM: Maximum allowable PWM.

    	- slv_reg2: Direct PWM values for servo testing.
    		+ slv_reg2 Lower 2 bytes -> r_PWM_ARM_L: Direct PWM from ARM to L channel.
    		+ slv_reg2 Upper 2 bytes -> r_PWM_ARM_R: Direct PWM from ARM to R channel.

    	- slv_reg3: Values from RC receiver and inverter stage.
    		+ slv_reg3 Lower 2 bytes -> v_PWM_RC: Value from RC receiver coded in uSec.
    		+ slv_reg3 Upper 2 bytes -> v_PWM_INV: Value from inverter stage coded in uSec.

    	- slv_reg4: Output values from peripheral.
    		+ slv_reg4 Lower 2 bytes -> Value which will be coded into PWM for L channel.
    		+ slv_reg4 Upper 2 bytes -> Value which will be coded into PWM for R channel.

    	- slv_reg5: Reserved for future use.
    	- slv_reg6: Reserved for future use.

    	- slv_reg7: PWM Value from ARM for Auto mode
    		+ slv_reg7 Lower 2 bytes -> Value of PWM coded in uSec from ARM to perform an actuation.
    		+ slv_reg7 Upper 2 bytes -> Reserved for future use.

*/
typedef struct _handler_PWMManager{
	u32 baseAddr;

	AXI_Register slv_reg0;
	AXI_Register slv_reg1;
	AXI_Register slv_reg2;
	AXI_Register slv_reg3;
	AXI_Register slv_reg4;
	AXI_Register slv_reg5;
	AXI_Register slv_reg6;
	AXI_Register slv_reg7;

}handler_PWMManager, *ptr_handler_PWMManager;

void init_IP_PWM_Manager(handler_PWMManager *handler, u32 baseAddr);

void set_Min_PWM(handler_PWMManager *handler, u16 PWM_Value);
void set_Max_PWM(handler_PWMManager *handler, u16 PWM_Value);

void set_Inversion(handler_PWMManager *handler, channel ch, inversion inv);

void set_Output_Type(handler_PWMManager *handler, channel ch, outputType outT);
void set_Direct_Value(handler_PWMManager *handler, channel ch, u16 PWM_Value);

void set_ARM_Actuation(handler_PWMManager *handler, u16 actuation);

u16 get_RC_Input_Value(handler_PWMManager *handler);
u16 get_Inverter_Value(handler_PWMManager *handler);
u16 get_Output_Value(handler_PWMManager *handler, channel ch);

u16 get_Min_PWM(handler_PWMManager *handler);
u16 get_Max_PWM(handler_PWMManager *handler);

inversion get_Inversion(handler_PWMManager *handler, channel ch);
outputType get_Output_Type(handler_PWMManager *handler, channel ch);

#endif /* LIB_IP_PWM_MANAGER_H_ */
