module tb;

    reg clk = 0;
    reg reset = 1;
    wire [7:0] acc_out;

    mini_cpu DUT (
        .clk(clk),
        .reset(reset),
        .acc_out(acc_out)
    );

    always #5 clk = ~clk;

    initial begin
        #10 reset = 0;
        #200 $finish;
    end

endmodule