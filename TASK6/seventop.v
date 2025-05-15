`include "uart_trx.v"

module top (
    input clk,
    input uartrx,
    output [6:0] seg
);
    wire [7:0] rxbyte;
    wire received;

    reg [6:0] seg_reg;
    assign seg = seg_reg;

    uart_rx_8n1 uart_inst (
        .clk(clk),
        .rx(uartrx),
        .rxbyte(rxbyte),
        .received(received)
    );

    always @(posedge clk) begin
        if (received) begin
            case (rxbyte)
                "0": seg_reg <= 7'b1111110;
                "1": seg_reg <= 7'b0110000;
                "2": seg_reg <= 7'b1101101;
                "3": seg_reg <= 7'b1111001;
                "4": seg_reg <= 7'b0110011;
                "5": seg_reg <= 7'b1011011;
                "6": seg_reg <= 7'b1011111;
                "7": seg_reg <= 7'b1110000;
                "8": seg_reg <= 7'b1111111;
                "9": seg_reg <= 7'b1111011;
                default: seg_reg <= 7'b0000001; // Show '-' for invalid input
            endcase
        end
    end
endmodule
