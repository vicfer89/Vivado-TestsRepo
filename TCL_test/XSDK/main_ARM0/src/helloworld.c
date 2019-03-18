#include <stdio.h>
#include "platform.h"
#include "xscugic.h"
#include "xgpio.h"
#include "xparameters.h"

#include "lib_IP_PWM_Manager.h"
#include "lib_IP_Mode_Manager.h"

#define CPU0_10HZ_0_IRQ_ID 				XPAR_FABRIC_ZYNQ_SYSTEMS_FIT_TIMER_10HZ_INTERRUPT_INTR
#define DIR_BASE_IP_PWM_MANAGER_CH01 	XPAR_PWM_MANAGER_CHANNEL_CH01_PWM_MANAGER_CH01_S00_AXI_BASEADDR
#define DIR_BASE_IP_PWM_MANAGER_CH02 	XPAR_PWM_MANAGER_CHANNEL_CH02_PWM_MANAGER_CH02_S00_AXI_BASEADDR
#define DIR_BASE_IP_MODE_MANAGER		XPAR_PWM_MANAGER_MODE_MANAGER_MODEMANAGER_0_S00_AXI_BASEADDR

/*#ifdef DIR_BASE_IP_MODE_MANAGER
	#define r_PWM_Mode		DIR_BASE_IP_MODE_MANAGER + 0x00
#endif

typedef union _registro
{
	u32 regbase;

	struct{
		u16 LSR;
		u16 MSR;
	}registros_u16;
}registro_u32;*/

void int_handler_0_10HZ(void *data, u8 TmrCtrNumber);
void init_GPIO(void);
void init_interrupt(void);

static XScuGic IntcInstance; // Instancia para manejador de interrupciones
static XGpio Gpio; /* The Instance of the GPIO Driver */
static handler_PWMManager CH01;
static handler_ModeManager Mode_Stick;

volatile u8 flag_TMR10Hz = 0;

int main()
{
    init_platform();
    init_interrupt();
    init_GPIO();

    /*registro_u32 PWM_MODE;
    PWM_MODE.registros_u16.LSR = 1100;
	PWM_MODE.registros_u16.MSR = 1940;
	Xil_Out32(r_PWM_Mode,PWM_MODE.regbase);*/
    init_IP_Mode_Manager(&Mode_Stick, DIR_BASE_IP_MODE_MANAGER);
    set_PWM_Manual(&Mode_Stick, 1100);
    set_PWM_Auto(&Mode_Stick, 1940);

    init_IP_PWM_Manager(&CH01,  DIR_BASE_IP_PWM_MANAGER_CH01);
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

			printf(" Valor de modo: 0x%x \t PWM Modo: %d \r\n",
					get_Mode_Stick(&Mode_Stick),
					get_Mode_PWM(&Mode_Stick));
			printf(" PWMC \t PWM_IN: %d \t PWM_INV: %d \t PWM_L: %d \t PWM_R: %d \n",
					get_RC_Input_Value(&CH01),
					get_Inverter_Value(&CH01),
					get_Output_Value(&CH01, ch_Left),
					get_Output_Value(&CH01, ch_Right));
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
