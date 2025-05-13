## FPGA-Based UART-Controlled Actuator System
Overview:

Develop a system where the FPGA receives control commands via UART to operates LEDs. This project focuses on decoding serial commands and translating them into physical actions.

Working:

- Three different leds are driven by uart commands.
- Commands are sent from DOCKLIGHT software
- When the data is transmitted to fpga through UART, different leds get turned ON in a order. when each command is given each led will ON.

Codes:
These are the top.v and uart_trx.v codes used:

`include "uart_trx.v"

module top (

    input clk,
    input uartrx,
    output [2:0] rgb
    
);

    wire [7:0] rxbyte;
    
    wire received;

    reg [2:0] rgb_reg = 3'b001; // Start with RED
    assign rgb = rgb_reg;

    uart_rx_8n1 uart_inst (
        .clk(clk),
        .rx(uartrx),
        .rxbyte(rxbyte),
        .received(received)
    );

    always @(posedge clk) begin
        if (received) begin
            // Cycle through RED → GREEN → BLUE → RED...
            case (rgb_reg)
                3'b001: rgb_reg <= 3'b010; // RED → GREEN
                3'b010: rgb_reg <= 3'b100; // GREEN → BLUE
                3'b100: rgb_reg <= 3'b001; // BLUE → RED
                default: rgb_reg <= 3'b001; // fallback to RED
            endcase
            end
            end
            endmodule

Circuit:

![Data Out (2)](https://github.com/user-attachments/assets/9f2334ca-fffa-4e4a-bd76-b06a40756329)

Working Video:

https://github.com/user-attachments/assets/765878e1-adbd-4526-91e3-368cbc57a2f8


## FPGA-Based UART-Controlled Display System
Overview:

Design a system where the FPGA receives data via UART and displays it on an output device, such as a 7-segment display or an LCD. This project emphasizes real-time data reception and visualization.

Working:
- A segment display is connected to the FPGA board.
- Commands are sent from DOCKLIGHT software to the FPGA.
- When the data is transmitted to fpga through UART, the numbers increment in the seven segment display for each command.

Circuit:

![Data Out (3)](https://github.com/user-attachments/assets/10dbaba1-864a-4b50-9745-d4ad6d34b44d)

Working Video:

https://github.com/user-attachments/assets/bce30ff7-64fd-4e4a-8977-a2be4b28ede3

