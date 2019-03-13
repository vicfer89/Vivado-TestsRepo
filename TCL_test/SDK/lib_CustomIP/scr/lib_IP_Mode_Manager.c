/*
 * lib_IP_Mode_Manager.c
 *
 *  Created on: 12/03/2019
 *      Author: VFF
 */

#include "lib_IP_Mode_Manager.h"
#include "string.h"
#include "xil_io.h"

static void update_AXI_Register(handler_ModeManager *handler, IP_registers reg)
{
	u32 address, regInfo;
	address =  handler->baseAddr;
	switch(reg)
	{
		case slv_reg0:
			regInfo = handler->slv_reg0.AXI_X32_Register;
			break;

		case slv_reg1:
			regInfo = handler->slv_reg1.AXI_X32_Register;
			break;

		case slv_reg2:
			regInfo = handler->slv_reg2.AXI_X32_Register;
			break;

		case slv_reg3:
			regInfo = handler->slv_reg3.AXI_X32_Register;
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


void init_IP_Mode_Manager(handler_ModeManager *handler, u32 baseAddr)
{
	memset(handler,0,sizeof(handler_ModeManager));
	handler->baseAddr = baseAddr;
}

void set_PWM_Manual(handler_ModeManager *handler, u16 PWM_Value)
{
	handler->slv_reg0.AXI_Sub_Registers.LSR = PWM_Value;
	update_AXI_Register(handler, slv_reg0);

}

void set_PWM_Auto(handler_ModeManager *handler, u16 PWM_Value)
{
	handler->slv_reg0.AXI_Sub_Registers.MSR = PWM_Value;
	update_AXI_Register(handler, slv_reg0);
}

u16 get_Mode_PWM(handler_ModeManager *handler)
{
	handler->slv_reg1.AXI_X32_Register = read_AXI_Register(handler->baseAddr, slv_reg1);
	return handler->slv_reg1.AXI_Sub_Registers.LSR;
}

mode_Stick get_Mode_Stick(handler_ModeManager *handler)
{
	mode_Stick tempMode = None;
	handler->slv_reg1.AXI_X32_Register = read_AXI_Register(handler->baseAddr, slv_reg1);

	tempMode = (mode_Stick) (handler->slv_reg1.AXI_Bits.b17<<1) | handler->slv_reg1.AXI_Bits.b16;
	return tempMode;
}

