if(USART1_RX_STA&0x8000){
    if (USART1_RX_BUF[0]==0x31) {
        printf("begin test distance£\\r\n");
        GPIO_WriteBit(GPIOA,GPIO_Pin_1,0);
        LED1 = GPIO_ReadOutputDataBit  (GPIOA , GPIO_Pin_1);
        delay_us(10);
        GPIO_WriteBit(GPIOA,GPIO_Pin_1,1);
        LED1 = GPIO_ReadOutputDataBit  (GPIOA , GPIO_Pin_1);
        delay_us(20);
        GPIO_WriteBit(GPIOA,GPIO_Pin_1,0);
        LED1 = GPIO_ReadOutputDataBit  (GPIOA , GPIO_Pin_1);
    }
            }
USART1_RX_STA=0;