#include <stdio.h>
#include "platform.h"
#include "xscugic.h"
#include "xgpio.h"
#include "xparameters.h"

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
//#define DIR_BASE_IP_CAPTURA_PWM			XPAR_PWM_CAPTURER_0_S00_AXI_BASEADDR
//#define DIR_BASE_IP_VECTOR				XPAR_VECTOR_TO_AXI_0_S00_AXI_BASEADDR
#define DIR_BASE_IP_PWM_MANAGER 		XPAR_PWM_MANAGER_0_S00_AXI_BASEADDR
#define DIR_BASE_IP_MODE_MANAGER		XPAR_MODEMANAGER_0_S00_AXI_BASEADDR
#ifdef DIR_BASE_IP_PWM_MANAGER
	#define v_PWM_IN    	DIR_BASE_IP_PWM_MANAGER + OFFSET_REG3
	#define v_PWM_OUT   	DIR_BASE_IP_PWM_MANAGER + OFFSET_REG4
	#define r_PWM_CONF  	DIR_BASE_IP_PWM_MANAGER + OFFSET_REG1
    #define r_CONF_GEST 	DIR_BASE_IP_PWM_MANAGER + OFFSET_REG0
	#define r_Direct_Values DIR_BASE_IP_PWM_MANAGER + OFFSET_REG2
	#define r_PWM_ARM	 	DIR_BASE_IP_PWM_MANAGER + OFFSET_REG7
#endif

#ifdef DIR_BASE_IP_MODE_MANAGER
	#define r_PWM_Mode		DIR_BASE_IP_MODE_MANAGER + OFFSET_REG0
#endif

#define TRUE  0x1
#define FALSE 0x0

typedef union _registro
{
	u32 regbase;

	struct{
		u16 LSR;
		u16 MSR;
	}registros_u16;
}registro_u32;

typedef union _registro_C
{
	u32 regbase;

	struct{
		u8 	reg0 : 1;
		u8 	reg1 : 1;
		u8 	reg2 : 1;
		u8 	reg3 : 1;
		u8 	reg4 : 1;
		u8 	reg5 : 1;
		u8 	reg6 : 1;
		u8 	reg7 : 1;
		u8 	byte;

		u16 MSR;
	}registros_u16;
}registro_C_u32;

//void print(char *str);
void int_handler_0_10HZ(void *data, u8 TmrCtrNumber);
void init_GPIO(void);

static XScuGic IntcInstance; // Instancia para manejador de interrupciones
static XGpio Gpio; /* The Instance of the GPIO Driver */

volatile u8 flag_TMR10Hz = 0;

int main()
{
    init_platform();
    init_interrupt();
    init_GPIO();

    //Xil_Out16(DIR_BASE_IP_CAPTURA_PWM + OFFSET_REG14,500);
    //Xil_Out16(DIR_BASE_IP_CAPTURA_PWM + OFFSET_REG15,4000);

    registro_u32 PWM_Config, PWM_IN, PWM_OUT, PWM_Direct, PWM_MODE, PWM_ARM;
    PWM_Config.registros_u16.LSR = 1000;
    PWM_Config.registros_u16.MSR = 2000;
    Xil_Out32(r_PWM_CONF,PWM_Config.regbase);

    PWM_Direct.registros_u16.LSR = 1500; // Canal L
    PWM_Direct.registros_u16.MSR = 1500; // Canal R
    Xil_Out32(r_Direct_Values, PWM_Direct.regbase);

    PWM_MODE.registros_u16.LSR = 1100;
    PWM_MODE.registros_u16.MSR = 1940;
    Xil_Out32(r_PWM_Mode,PWM_MODE.regbase);


    PWM_ARM.registros_u16.LSR = 1750; // Valor de PWM escrito desde ARM
    Xil_Out32(r_PWM_ARM,PWM_ARM.regbase);

    registro_C_u32 Config_Etapas;
    Config_Etapas.registros_u16.reg0 = FALSE; // Canal L invertido
    Config_Etapas.registros_u16.reg1 = TRUE; // Canal R invertido
    Config_Etapas.registros_u16.reg2 = FALSE; //Canal L directo
    Config_Etapas.registros_u16.reg3 = TRUE; //Canal R directo
    Xil_Out32(r_CONF_GEST,Config_Etapas.regbase);


    printf("Main loop:\n\r");

    for(;;)
    {
		if(flag_TMR10Hz)
		{
			flag_TMR10Hz = 0;

			//u16 CH0C = Xil_In16(DIR_BASE_IP_CAPTURA_PWM + OFFSET_REG0);
			//u16 CH0V = Xil_In16(DIR_BASE_IP_VECTOR + OFFSET_REG0);
			PWM_IN.regbase = Xil_In32(v_PWM_IN);
			PWM_OUT.regbase = Xil_In32(v_PWM_OUT);

			printf(" PWMC \t PWM_IN: %d \t PWM_INV: %d \t PWM_L: %d \t PWM_R: %d \n",PWM_IN.registros_u16.LSR,PWM_IN.registros_u16.MSR,PWM_OUT.registros_u16.LSR, PWM_OUT.registros_u16.MSR);
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
