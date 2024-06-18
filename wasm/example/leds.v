module Switches_To_LEDs (
    input [3:0] i_Switch,
    output [3:0] o_LED
);

assign o_LED = i_Switch;

endmodule
