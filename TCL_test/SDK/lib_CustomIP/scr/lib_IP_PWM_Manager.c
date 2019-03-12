/*
 * lib_IP_PWM_Manager.c
 *
 *  Created on: 11/03/2019
 *      Author: VFF
 */
#include "lib_IP_PWM_Manager.h"
#include "string.h"
#include "xil_io.h"

static void update_AXI_Register(handler_PWMManager *handler, IP_registers reg)
{
	u32 address, regInfo;
	address =  handler->baseAddr;
	switch(reg)
	{
		case slv_reg0:
			regInfo = handler->AXI_Reg_Values.slv_reg0.AXI_X32_Register;
			break;

		case slv_reg1:
			regInfo = handler->AXI_Reg_Values.slv_reg1.AXI_X32_Register;
			break;

		case slv_reg2:
			regInfo = handler->AXI_Reg_Values.slv_reg2.AXI_X32_Register;
			break;

		case slv_reg3:
			regInfo = handler->AXI_Reg_Values.slv_reg3.AXI_X32_Register;
			break;

		case slv_reg4:
			regInfo = handler->AXI_Reg_Values.slv_reg4.AXI_X32_Register;
			break;

		case slv_reg5:
			regInfo = handler->AXI_Reg_Values.slv_reg5.AXI_X32_Register;
			break;

		case slv_reg6:
			regInfo = handler->AXI_Reg_Values.slv_reg6.AXI_X32_Register;
			break;

		case slv_reg7:
			regInfo = handler->AXI_Reg_Values.slv_reg7.AXI_X32_Register;
			break;

		default:
			return;
	}
	Xil_Out32(address + OFFSET_REG(reg),regInfo);
}

static u32 read_AXI_Register(u32 base_addr, IP_registers reg)
{
	return Xil_In32(base_addr + OFFSET_REG(reg));
}

void init_IP_PWM_Manager(handler_PWMManager *handler, u32 ip_base_addr)
{
	memset(handler,0,sizeof(handler_PWMManager));
	handler->baseAddr = ip_base_addr;
}

void set_Min_PWM(handler_PWMManager *handler, u16 PWM_Value)
{
	handler->AXI_Reg_Values.slv_reg1.AXI_Sub_Registers.LSR = PWM_Value;
	update_AXI_Register(handler, slv_reg1);
}

void set_Max_PWM(handler_PWMManager *handler, u16 PWM_Value)
{
	handler->AXI_Reg_Values.slv_reg1.AXI_Sub_Registers.MSR = PWM_Value;
	update_AXI_Register(handler, slv_reg1);
}

void set_Inversion(handler_PWMManager *handler, channel ch, inversion inv)
{
	switch(ch)
	{
		case ch_Right:
			handler->AXI_Reg_Values.slv_reg0.AXI_Bits.b1 = (inv == channel_Inverted) ? TRUE : FALSE;
			break;

		case ch_Left:
			handler->AXI_Reg_Values.slv_reg0.AXI_Bits.b0 = (inv == channel_Inverted) ? TRUE : FALSE;
			break;

		default:
			return;
	}
	update_AXI_Register(handler, slv_reg0);
}

void set_Direct_Value(handler_PWMManager *handler, channel ch, u16 PWM_Value)
{
	switch(ch)
	{
		case ch_Right:
			handler->AXI_Reg_Values.slv_reg2.AXI_Sub_Registers.MSR = PWM_Value;
			break;

		case ch_Left:
			handler->AXI_Reg_Values.slv_reg2.AXI_Sub_Registers.LSR = PWM_Value;
			break;

		default:
			return;
	}
	update_AXI_Register(handler,slv_reg2);
}

void set_Output_Type(handler_PWMManager *handler, channel ch, outputType outT)
{
	switch(ch)
	{
		case ch_Right:
			handler->AXI_Reg_Values.slv_reg0.AXI_Bits.b3 = (outT == pwm_out_direct) ? TRUE : FALSE;
			break;

		case ch_Left:
			handler->AXI_Reg_Values.slv_reg0.AXI_Bits.b2 = (outT == pwm_out_direct) ? TRUE : FALSE;
			break;

		default:
			return;
	}
	update_AXI_Register(handler, slv_reg0);
}

void set_ARM_Actuation(handler_PWMManager *handler, u16 actuation)
{
	handler->AXI_Reg_Values.slv_reg7.AXI_Sub_Registers.LSR = actuation;
	update_AXI_Register(handler, slv_reg7);
}

u16 get_RC_Input_Value(handler_PWMManager *handler)
{
	handler->AXI_Reg_Values.slv_reg3.AXI_X32_Register = read_AXI_Register(handler->baseAddr, slv_reg3);
	return handler->AXI_Reg_Values.slv_reg3.AXI_Sub_Registers.LSR;
}

u16 get_Inverter_Value(handler_PWMManager *handler)
{
	handler->AXI_Reg_Values.slv_reg3.AXI_X32_Register = read_AXI_Register(handler->baseAddr, slv_reg3);
	return handler->AXI_Reg_Values.slv_reg3.AXI_Sub_Registers.MSR;
}

u16 get_Output_Value(handler_PWMManager *handler, channel ch)
{
	u16 temp_value = 0;
	handler->AXI_Reg_Values.slv_reg4.AXI_X32_Register = read_AXI_Register(handler->baseAddr, slv_reg4);
	switch(ch)
	{
		case ch_Right:
			temp_value = handler->AXI_Reg_Values.slv_reg4.AXI_Sub_Registers.MSR;
			break;

		case ch_Left:
			temp_value = handler->AXI_Reg_Values.slv_reg4.AXI_Sub_Registers.LSR;
			break;

		default:
			break;
	}
	return temp_value;
}

u16 get_Min_PWM(handler_PWMManager *handler)
{
	return handler->AXI_Reg_Values.slv_reg1.AXI_Sub_Registers.LSR;
}

u16 get_Max_PWM(handler_PWMManager *handler)
{
	return handler->AXI_Reg_Values.slv_reg1.AXI_Sub_Registers.MSR;
}

inversion get_Inversion(handler_PWMManager *handler, channel ch)
{
	inversion temp_value;
	switch(ch)
	{
		case ch_Right:
			temp_value = (handler->AXI_Reg_Values.slv_reg0.AXI_Bits.b1 == TRUE) ? channel_Inverted : channel_NotInverted;
			break;

		case ch_Left:
			temp_value = (handler->AXI_Reg_Values.slv_reg0.AXI_Bits.b0 == TRUE) ? channel_Inverted : channel_NotInverted;
			break;

		default:
			break;
	}
	return temp_value;
}

outputType get_Output_Type(handler_PWMManager *handler, channel ch)
{
	outputType temp_value;
	switch(ch)
	{
		case ch_Right:
			temp_value = (handler->AXI_Reg_Values.slv_reg0.AXI_Bits.b3 == TRUE) ? pwm_out_direct : pwm_out_processed;
			break;

		case ch_Left:
			temp_value = (handler->AXI_Reg_Values.slv_reg0.AXI_Bits.b2 == TRUE) ? pwm_out_direct : pwm_out_processed;
			break;

		default:
			break;
	}
	return temp_value;
}

