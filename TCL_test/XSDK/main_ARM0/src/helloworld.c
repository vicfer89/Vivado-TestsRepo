#include <stdio.h>
#include "platform.h"
#include "xscugic.h"
#include "xgpio.h"
#include "xparameters.h"

#include "lib_IP_PWM_Manager.h"
#include "lib_IP_Mode_Manager.h"

#define CPU0_10HZ_0_IRQ_ID 				XPAR_FABRIC_ZYNQ_SYSTEMS_FIT_TIMER_10HZ_INTERRUPT_INTR
#define DIR_BASE_IP_PWM_MANAGER_CH01	XPAR_PWM_MANAGER_CHANNEL_CH01_PWM_MANAGER_CH01_S00_AXI_BASEADDR
#define DIR_BASE_IP_PWM_MANAGER_CH02	XPAR_PWM_MANAGER_CHANNEL_CH02_PWM_MANAGER_CH02_S00_AXI_BASEADDR
#define DIR_BASE_IP_PWM_MANAGER_CH03	XPAR_PWM_MANAGER_CHANNEL_CH03_PWM_MANAGER_CH03_S00_AXI_BASEADDR
#define DIR_BASE_IP_PWM_MANAGER_CH04	XPAR_PWM_MANAGER_CHANNEL_CH04_PWM_MANAGER_CH04_S00_AXI_BASEADDR
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
static handler_PWMManager CH01, CH02, CH03, CH04, CH06;
static handler_ModeManager Mode_Stick;

volatile u8 flag_TMR10Hz = 0;

int main()
{
    init_platform();
    init_interrupt();
    init_GPIO();

    init_IP_Mode_Manager(&Mode_Stick, DIR_BASE_IP_MODE_MANAGER);
    set_PWM_Manual(&Mode_Stick, 1100);
    set_PWM_Auto(&Mode_Stick, 1940);

    init_IP_PWM_Manager(&CH01,  DIR_BASE_IP_PWM_MANAGER_CH01);
    set_Min_PWM(&CH01, 1061);
    set_Max_PWM(&CH01, 1991);

    init_IP_PWM_Manager(&CH02,  DIR_BASE_IP_PWM_MANAGER_CH02);
    set_Min_PWM(&CH02, 1000);
    set_Max_PWM(&CH02, 2000);

    init_IP_PWM_Manager(&CH03,  DIR_BASE_IP_PWM_MANAGER_CH03);
    set_Min_PWM(&CH03, 1000);
    set_Max_PWM(&CH03, 2000);

    init_IP_PWM_Manager(&CH04,  DIR_BASE_IP_PWM_MANAGER_CH04);
    set_Min_PWM(&CH04, 1000);
    set_Max_PWM(&CH04, 2000);

    /*init_IP_PWM_Manager(&CH06,  DIR_BASE_IP_PWM_MANAGER_CH06);
    set_Min_PWM(&CH06, 1000);
    set_Max_PWM(&CH06, 2000);*/

    set_Direct_Value(&CH01, ch_Right, 1005);
    set_Direct_Value(&CH01, ch_Left, 1015);

    set_Direct_Value(&CH02, ch_Right, 1005);
    set_Direct_Value(&CH02, ch_Left, 1015);

    set_Direct_Value(&CH03, ch_Right, 1005);
    set_Direct_Value(&CH03, ch_Left, 1015);

    set_Direct_Value(&CH04, ch_Right, 1005);
    set_Direct_Value(&CH04, ch_Left, 1015);

    /*set_Direct_Value(&CH06, ch_Right, 1005);
    set_Direct_Value(&CH06, ch_Left, 1015);*/

    set_Inversion(&CH01, ch_Right, channel_Inverted);
    set_Inversion(&CH01, ch_Left, channel_NotInverted);

    set_Inversion(&CH02, ch_Right, channel_Inverted);
    set_Inversion(&CH02, ch_Left, channel_NotInverted);

    set_Inversion(&CH03, ch_Right, channel_Inverted);
    set_Inversion(&CH03, ch_Left, channel_NotInverted);

    set_Inversion(&CH04, ch_Right, channel_Inverted);
    set_Inversion(&CH04, ch_Left, channel_NotInverted);

    set_Output_Type(&CH01, ch_Right, pwm_out_processed);
    set_Output_Type(&CH01, ch_Left, pwm_out_processed);

    set_Output_Type(&CH02, ch_Right, pwm_out_processed);
    set_Output_Type(&CH02, ch_Left, pwm_out_processed);

    set_Output_Type(&CH03, ch_Right, pwm_out_processed);
    set_Output_Type(&CH03, ch_Left, pwm_out_processed);

    set_Output_Type(&CH04, ch_Right, pwm_out_processed);
    set_Output_Type(&CH04, ch_Left, pwm_out_processed);

    /*set_Output_Type(&CH06, ch_Right, pwm_out_processed);
    set_Output_Type(&CH06, ch_Left, pwm_out_processed);*/

    set_ARM_Actuation(&CH01, 1750);
    set_ARM_Actuation(&CH02, 1751);
    set_ARM_Actuation(&CH03, 1752);
    set_ARM_Actuation(&CH04, 1753);

    printf("Main loop:\n\r");

    for(;;)
    {
		if(flag_TMR10Hz)
		{
			flag_TMR10Hz = 0;


			printf("************************************************************************* \n");
			printf(" Valor de modo: 0x%x \t PWM Modo: %d \n",
					get_Mode_Stick(&Mode_Stick),
					get_Mode_PWM(&Mode_Stick));
			printf(" PWMC_1 \t PWM_IN: %d \t PWM_INV: %d \t PWM_L: %d \t PWM_R: %d \n",
					get_RC_Input_Value(&CH01),
					get_Inverter_Value(&CH01),
					get_Output_Value(&CH01, ch_Left),
					get_Output_Value(&CH01, ch_Right));
			printf(" PWMC_2 \t PWM_IN: %d \t PWM_INV: %d \t PWM_L: %d \t PWM_R: %d \n",
					get_RC_Input_Value(&CH02),
					get_Inverter_Value(&CH02),
					get_Output_Value(&CH02, ch_Left),
					get_Output_Value(&CH02, ch_Right));
			printf(" PWMC_3 \t PWM_IN: %d \t PWM_INV: %d \t PWM_L: %d \t PWM_R: %d \n",
					get_RC_Input_Value(&CH03),
					get_Inverter_Value(&CH03),
					get_Output_Value(&CH03, ch_Left),
					get_Output_Value(&CH03, ch_Right));
			printf(" PWMC_4 \t PWM_IN: %d \t PWM_INV: %d \t PWM_L: %d \t PWM_R: %d \n",
					get_RC_Input_Value(&CH04),
					get_Inverter_Value(&CH04),
					get_Output_Value(&CH04, ch_Left),
					get_Output_Value(&CH04, ch_Right));
			/*printf(" PWMC_6 \t PWM_IN: %d \t PWM_INV: %d \t PWM_L: %d \t PWM_R: %d \n",
					get_RC_Input_Value(&CH06),
					get_Inverter_Value(&CH06),
					get_Output_Value(&CH06, ch_Left),
					get_Output_Value(&CH06, ch_Right));*/
			printf("************************************************************************* \n");
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
