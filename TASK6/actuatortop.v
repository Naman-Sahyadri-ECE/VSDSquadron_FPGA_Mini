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
