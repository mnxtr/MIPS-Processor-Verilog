`timescale 1ns / 1ps

module MIPS_Testbench;

    // Inputs
    reg clk;
    reg reset;

    // Instantiate the MIPS CPU module
    MIPS_CPU uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Generate a clock with 10ns period
    end

    // Initialize inputs and load instructions
    initial begin
        // Initialize reset
        reset = 1;

        // Reset the CPU
        #10;
        reset = 0;

        // Load machine code into instruction memory
        $readmemb("instruction_memory.txt", uut.IMem.mem);

        // Initialize data memory if necessary
        $readmemh("data_memory.txt", uut.DMem.mem);

        // Run simulation for a specific time
        #200;

        // Display register values
        $display("Register File Contents:");
        $display("------------------------");
        for (int i = 0; i < 32; i = i + 1) begin
            $display("R%0d = %h", i, uut.RegFile.registers[i]);
        end

        // Check results in data memory
        $display("Data Memory Contents:");
        $display("---------------------");
        for (int i = 0; i < 16; i = i + 1) begin
            $display("DMem[%0d] = %h", i, uut.DMem.mem[i]);
        end

        // End simulation
        $finish;
    end

endmodule
