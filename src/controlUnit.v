module controlUnit(
    // Signal kojim vanjski svijet dojavljuje da je spremna nova ul. znacajka
    input wire clk,
    input wire rst_n,
    input wire dataw_rdy, 
    output wire [3:0] oe_reg;
    output wire [3:0] we_reg;
);

// Counter for adressing the current line buffer being written to
reg [1:0] current_write_buff;
// Counts total number of lines loaded
reg [9:0] line_cnt; 
// Counter for the number of input features
reg [2:0] write_feature_cnt;

// Counter for multiplexing line buffer output enable ports
reg [1:0] current_read_buff;
// Read ready signal
wire datar_rdy;
// Counter for number of read features
reg [2:0] read_feature_cnt;

// ============ write controller ============
always @(posedge clk)
begin
    if (!rst_n)
        write_feature_cnt <= 3'b0;
    else if (dataw_rdy)
        write_feature_cnt <= write_feature_cnt + 1;
end

always @(posedge clk)
begin
    if (!rst_n)
    begin
        current_write_buff <= 2'b0;
        line_cnt <= 10'b0;
    end
    else if (write_feature_cnt == 7 & dataw_rdy)
    begin
        current_write_buff <= current_write_buff + 1;
        line_cnt <= line_cnt + 1;
    end
end

// Combo logic for write enable activation
always @(*)
begin
    we_reg = 3'b0;
    we_reg[current_write_buff] = 1;
end
// ============ end write controller ============

// ============ read controller =============
always @(posedge clk)
begin
    if (!rst_n)
        read_feature_cnt <= 3'b0;
    else if (datar_rdy)
        read_feature_cnt <= read_feature_cnt + 1;
end

always @(posedge clk)
begin
    if (!rst_n)
        current_read_buff <= 2'b0;
    else if (read_feature_cnt == 7 & datar_rdy)
        current_read_buff <= current_read_buff + 1;
end

// Combo logic for read enable activation
always @(*)
begin
    case (current_read_buff)
        0: begin
            oe_reg[0] = datar_rdy;
            oe_reg[1] = datar_rdy;
            oe_reg[2] = datar_rdy;
            oe_reg[3] = 1'b0;
        end
        1: begin
            oe_reg[0] = 1'b0;
            oe_reg[1] = datar_rdy;
            oe_reg[2] = datar_rdy;
            oe_reg[3] = datar_rdy;
        end
        2: begin
            oe_reg[0] = datar_rdy;
            oe_reg[1] = 1'b0;
            oe_reg[2] = datar_rdy;
            oe_reg[3] = datar_rdy;
        end
        3: begin
            oe_reg[0] = datar_rdy;
            oe_reg[1] = datar_rdy;
            oe_reg[2] = 1'b0;
            oe_reg[3] = datar_rdy;
        end
    endcase 
end
// ============ end read controller =============

endmodule