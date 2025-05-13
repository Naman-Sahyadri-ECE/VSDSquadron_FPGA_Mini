## FPGA-Based UART-Controlled Actuator System
Overview:
Develop a system where the FPGA receives control commands via UART to operates LEDs. This project focuses on decoding serial commands and translating them into physical actions.

Working:
Three different leds are driven by uart commands.
Commands are sent from DOCKLIGHT software
When the data is transmitted to fpga through UART, different leds get turned ON in a order. when each command is given each led will ON.

Circuit:

![Data Out (2)](https://github.com/user-attachments/assets/9f2334ca-fffa-4e4a-bd76-b06a40756329)

Working Video:



