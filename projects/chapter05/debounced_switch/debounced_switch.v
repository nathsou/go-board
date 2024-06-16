// Top level file for adding a Debounce filter to LED toggling
// Instantiates the Debounce Filter and the LED toggle modules
// Sets up a 10 ms debounce filter (input must be stable for 10 ms)

module debounced_switch (
    input  i_Clk,
    input  i_Switch_1,
    output o_LED_1
);

wire w_Debounced_Switch;

// Instantiate Debounce Filter
debounce_filter #(.DEBOUNCE_LIMIT(250000)) Debounce_Inst
(.i_Clk(i_Clk), 
.i_Bouncy(i_Switch_1),
.o_Debounced(w_Debounced_Switch));

// Instantiate LED Toggle Module (from Chapter 04)
toggle_led LED_Toggle_Inst 
(.i_Clk(i_Clk),
.i_Switch_1(w_Debounced_Switch),
.o_LED_1(o_LED_1));
   
endmodule
