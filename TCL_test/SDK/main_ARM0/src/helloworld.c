#include <stdio.h>
#include "platform.h"
#include "xscugic.h"
#include "xgpio.h"
#include "xparameters.h"

#include "lib_IP_PWM_Manager.h"

#define OFFSET_REG0						0X00
#define OFFSET_REG1						0x04
#define OFFSET_REG2						0x08
#define OFFSET_REG3						0x0C
#define OFFSET_REG4						0x10
#define OFFSET_REG5						0x14
#define OFFSET_REG6						0x18
#define OFFSET_REG7						0x1C
#define OFFSET_REG8						0x20
#define OFFSET_REG9						0x24
#define OFFSET_REG10					0x28
#define OFFSET_REG11					0x2C
#define OFFSET_REG12					0x30
#define OFFSET_REG13					0x34
#define OFFSET_REG14					0x38
#define OFFSET_REG15					0x3C
#define OFFSET_REG16					0x40
#define OFFSET_REG17					0x44
#define OFFSET_REG18					0x48
#define OFFSET_REG19					0x4C

#define CPU0_10HZ_0_IRQ_ID 				XPAR_FABRIC_ZYNQ_SYSTEMS_FIT_TIMER_10HZ_INTERRUPT_INTR
#define DIR_BASE_IP_PWM_MANAGER 		XPAR_PWM_MANAGER_0_S00_AXI_BASEADDR
#define DIR_BASE_IP_MODE_MANAGER		XPAR_MODEMANAGER_0_S00_AXI_BASEADDR

#ifdef DIR_BASE_IP_MODE_MANAGER
	#define r_PWM_Mode		DIR_BASE_IP_MODE_MANAGER + OFFSET_REG0
#endif



typedef union _registro
{
	u32 regbase;

	struct{
		u16 LSR;
		u16 MSR;
	}registros_u16;
}registro_u32;

void int_handler_0_10HZ(void *data, u8 TmrCtrNumber);
void init_GPIO(void);
void init_interrupt(void);

static XScuGic IntcInstance; // Instancia para manejador de interrupciones
static XGpio Gpio; /* The Instance of the GPIO Driver */
static handler_PWMManager CH01;

volatile u8 flag_TMR10Hz = 0;

int main()
{
    init_platform();
    init_interrupt();
    init_GPIO();

    registro_u32 PWM_MODE;
    PWM_MODE.registros_u16.LSR = 1100;
	PWM_MODE.registros_u16.MSR = 1940;
	Xil_Out32(r_PWM_Mode,PWM_MODE.regbase);

    init_IP_PWM_Manager(&CH01,  DIR_BASE_IP_PWM_MANAGER);
    set_Min_PWM(&CH01, 1000);
    set_Max_PWM(&CH01, 2000);

    set_Direct_Value(&CH01, ch_Right, 1005);
    set_Direct_Value(&CH01, ch_Left, 1015);

    set_Inversion(&CH01, ch_Right, channel_Inverted);
    set_Inversion(&CH01, ch_Left, channel_Inverted);

    set_Output_Type(&CH01, ch_Right, pwm_out_processed);
    set_Output_Type(&CH01, ch_Left, pwm_out_processed);

    set_ARM_Actuation(&CH01, 1750);

    printf("Main loop:\n\r");

    for(;;)
    {
		if(flag_TMR10Hz)
		{
			flag_TMR10Hz = 0;

			printf(" PWMC \t PWM_IN: %d \t PWM_INV: %d \t PWM_L: %d \t PWM_R: %d \n",
					get_RC_Input_Value(&CH01),
					get_Inverter_Value(&CH01),
					get_Output_Value(&CH01,ch_Left),
					get_Output_Value(&CH01,ch_Right));
		}
    }

    cleanup_platform();
    return 0;
}

void init_interrupt()
{
	// Inicializo gestor de interrupciones
	XScuGic_Config *IntcConfig;

	IntcConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);

	XScuGic_CfgInitialize(&IntcInstance, IntcConfig,IntcConfig->CpuBaseAddress);

	//Inicializo interrupción para timer

	XScuGic_SetPriorityTriggerType(&IntcInstance, CPU0_10HZ_0_IRQ_ID, 0xC0, 0x3);
	XScuGic_Connect(&IntcInstance,	CPU0_10HZ_0_IRQ_ID,(Xil_InterruptHandler) int_handler_0_10HZ, (void *) NULL);

	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,(Xil_ExceptionHandler) XScuGic_InterruptHandler, &IntcInstance);

	// Habilito interrupción de timer
	XScuGic_Enable(&IntcInstance, CPU0_10HZ_0_IRQ_ID);

	// Activo interrupciones
	Xil_ExceptionEnable();
}

void init_GPIO()
{
	XGpio_Initialize(&Gpio, XPAR_ZYNQ_SYSTEMS_AXI_GPIO_OUTS_DEVICE_ID);
	XGpio_DiscreteWrite(&Gpio, 1, 0xFF);
}

void int_handler_0_10HZ(void *data, u8 TmrCtrNumber)
{
	if(flag_TMR10Hz == 0)
	{
		flag_TMR10Hz = 1;
	}
}
