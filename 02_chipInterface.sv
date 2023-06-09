`default_nettype none
module chipInterface(
    input logic CLOCK_50,
    input logic [17:0] SW,
    input logic UART_RXD,
    input logic[3:0] KEY,
    output logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
    );
    // here we declare the output
    logic [511:0] m; // this should be connected to out
    logic [511:0] mm; // this should be connected to out

    logic [31:0] selected;
    logic reset;
    assign reset = ~KEY[0];
    logic isNew;

    // here we declare our receiver
    task2 R (.clock(CLOCK_50),
              .reset(reset),
              .serialIn(UART_RXD),
              .messageBytes(mm),
              .isNew(isNew));

    // here we declare the counter
    select s (.bits(mm),
              .addr({SW[7:0]}),
              .out(selected));

    logic [7:0] blank;
    assign blank = 8'd0;

    SevenSegmentDisplay s1 (.BCX0(selected[31:28]), .blank(blank), .HEX0(HEX7));
    SevenSegmentDisplay s2 (.BCX0(selected[27:24]), .blank(blank), .HEX0(HEX6));
    SevenSegmentDisplay s3 (.BCX0(selected[23:20]), .blank(blank), .HEX0(HEX5));
    SevenSegmentDisplay s4 (.BCX0(selected[19:16]), .blank(blank), .HEX0(HEX4));
    SevenSegmentDisplay s5 (.BCX0(selected[15:12]), .blank(blank), .HEX0(HEX3));
    SevenSegmentDisplay s6 (.BCX0(selected[11:8]), .blank(blank), .HEX0(HEX2));
    SevenSegmentDisplay s7 (.BCX0(selected[7:4]), .blank(blank), .HEX0(HEX1));
    SevenSegmentDisplay s8 (.BCX0(selected[3:0]), .blank(blank), .HEX0(HEX0));


endmodule : chipInterface


module select
 (input logic [511:0] bits,
  input logic [7:0] addr,
  output logic [31:0] out);
  
  logic [511:0] tmp;
  assign tmp = bits >> (addr * 32);
  assign out = tmp[31:0];

endmodule : select


module SevenSegmentDisplay
  (input  logic [3:0] BCX0,
   input  logic [7:0] blank,
   output logic [6:0] HEX0);

  always_comb begin
    HEX0 = 7'b0000000;
    if (~blank[0])
      case (BCX0)
        4'h0: HEX0 = 7'b0111111;
        4'h1: HEX0 = 7'b0000110;
        4'h2: HEX0 = 7'b1011011;
        4'h3: HEX0 = 7'b1001111;
        4'h4: HEX0 = 7'b1100110;
        4'h5: HEX0 = 7'b1101101;
        4'h6: HEX0 = 7'b1111101;
        4'h7: HEX0 = 7'b0000111;
        4'h8: HEX0 = 7'b1111111;
        4'h9: HEX0 = 7'b1100111;
        4'ha: HEX0 = 7'b1110111;
        4'hb: HEX0 = 7'b1111100;
        4'hc: HEX0 = 7'b0111001;
        4'hd: HEX0 = 7'b1011110;
        4'he: HEX0 = 7'b1111001;
        4'hf: HEX0 = 7'b1110001;
        default: HEX0 = 7'b0000000;
      endcase
    HEX0 = ~HEX0;
  end


endmodule : SevenSegmentDisplay

