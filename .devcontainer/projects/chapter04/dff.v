module Clocked_Logic
    (input i_Clk,
    input i_Switch_1,
    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4);

    reg r_Switch_1 = 1'b0;
    reg r_LED_1 = 1'b0;

    always @(posedge i_Clk)
        begin
            r_Switch_1 <= i_Switch_1; // Creates a register

            if (i_Switch_1 == 1'b0 && r_Switch_1 == 1'b1)
                begin
                    r_LED_1 <= ~r_LED_1;
                end
        end

    assign o_LED_1 = r_LED_1;
    assign o_LED_2 = r_LED_1;
    assign o_LED_3 = r_LED_1;
    assign o_LED_4 = r_LED_1;
endmodule