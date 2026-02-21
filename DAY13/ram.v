module mini_cpu (
    input clk,
    input reset,
    output [7:0] acc_out
);

    // instruction fields
    reg [7:0] IR;
    reg [3:0] PC;

    wire [3:0] opcode = IR[7:4];
    wire [3:0] operand = IR[3:0];

    reg [7:0] ACC;

    // RAM signals
    reg ram_we;
    reg [7:0] ram_data_in;
    wire [7:0] ram_data_out;

    // ALU signals
    wire [7:0] alu_result;
    reg [2:0] alu_sel;

    // instruction opcodes
    parameter ADD   = 4'b0001;
    parameter SUB   = 4'b0010;
    parameter LOAD  = 4'b0011;
    parameter STORE = 4'b0100;

    // simple instruction memory (program)
    reg [7:0] program [0:15];

    initial begin
        program[0] = 8'b0011_0001; // LOAD 1
        program[1] = 8'b0001_0010; // ADD 2
        program[2] = 8'b0100_0011; // STORE 3
    end

    // ALU instance
    alu ALU1 (
        .a(ACC),
        .b({4'b0, operand}),
        .sel(alu_sel),
        .result(alu_result)
    );

    // RAM instance
    simple_ram RAM1 (
        .clk(clk),
        .we(ram_we),
        .addr(operand),
        .data_in(ram_data_in),
        .data_out(ram_data_out)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
            ACC <= 0;
            ram_we <= 0;
        end else begin
            IR <= program[PC];
            PC <= PC + 1;

            case(opcode)

                LOAD: begin
                    ram_we <= 0;
                    ACC <= ram_data_out;
                end

                STORE: begin
                    ram_we <= 1;
                    ram_data_in <= ACC;
                end

                ADD: begin
                    alu_sel <= 3'b000;
                    ACC <= alu_result;
                end

                SUB: begin
                    alu_sel <= 3'b001;
                    ACC <= alu_result;
                end

            endcase
        end
    end

    assign acc_out = ACC;

endmodule