module lineBuffer(
    input wire clk,
    input wire rst_n, // low to reset
    input wire we, // write enable
    input wire oe, // output enable
    input wire [7:0] wr_data,
    output wire [23:0] rd_data // output data consists of three consecutive values stored in memory
);

// line buffer with eight 8-bit locations
reg [7:0] buffer [7:0];

// counter register for writing
reg [2:0] w_ptr; // 0-7 

// counter register for reading
reg [2:0] r_ptr; // 0-7

/*
line buffer modeled like single-port RAM:
https://yosyshq.readthedocs.io/projects/yosys/en/latest/using_yosys/synthesis/memory.html#single-port-ram-memory-patterns
*/
// write logic
always @(posedge clk)
begin
    if (we)
        buffer[w_ptr] <= wr_data;
end

// read logic
assign rd_data = {buffer[rd_data], buffer[rd_data + 1], buffer[rd_data + 2]};

// write counter logic
always @(posedge clk)
begin
    if (!rst_n)
        w_ptr <= 3'b0;
    else if (we)
        w_ptr <= w_ptr + 1'b1;
    else
        w_ptr <= w_ptr; // done to prevent a latch from inferring
end

// read counter logic
always @(posedge clk)
begin
    if (!rst_n)
        r_ptr <= 3'b0;
    else if (oe)
        r_ptr <= r_ptr + 1'b1;
    else
        r_ptr <= r_ptr; // done to prevent a latch from inferring
end

endmodule