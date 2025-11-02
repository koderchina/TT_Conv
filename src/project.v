/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_koderchina_conv (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  wire we = ui_in[0];       // use bit 0 as write enable
  wire oe = ui_in[1];       // use bit 1 as output enable
  wire [7:0] wr_data = ui_in[7:0]; // could use all 8 input bits as data
  assign uio_oe  = 8'hFF;  // all uio pins drive outputs

  wire[3:0] we_reg;
  wire[3:0] oe_reg;

  lineBuffer b0(
    .clk(clk),
    .rst_n(rst_n),
    .we(we_reg[0]),
    .oe(oe_reg[0]),
    .wr_data(data_in),
    .rd_data()
  );

  lineBuffer b1(
      .clk(clk),
      .rst_n(rst_n),
      .we(we_reg[1]),
      .oe(oe_reg[1]),
      .wr_data(data_in),
      .rd_data()
  );

  lineBuffer b2(
      .clk(clk),
      .rst_n(rst_n),
      .we(we_reg[2]),
      .oe(oe_reg[2]),
      .wr_data(data_in),
      .rd_data()
  );

  lineBuffer b3(
      .clk(clk),
      .rst_n(rst_n),
      .we(we_reg[3]),
      .oe(oe_reg[3]),
      .wr_data(data_in),
      .rd_data()
  );

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
