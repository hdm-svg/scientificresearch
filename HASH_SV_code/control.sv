`timescale 1ns / 1ps
//ascon hash
`define k 0
`define r 64
`define a 12
`define a_b 0
`define h 256
`define l 256
`define msg 64'h6162636465666768

module control
    #(
        parameter msg = `msg,
        parameter k = `k,
        parameter r = `r,
        parameter a = `a,
        parameter a_b = `a_b,
        parameter h = `h,
        parameter l = `l
    )
    (
        input logic clk,
        input logic rst_n,
        output logic [h-1:0] H,
        
        
        output logic [63:0] xo0,
        output logic [63:0] xo1,
        output logic [63:0] xo2,
        output logic [63:0] xo3,
        output logic [63:0] xo4
    );
    logic [3:0] round;
    int i, i_nx = 1;
    logic en;
    logic [319:0] init_x;
    logic rst_permutation_loop;
    localparam b = `a-`a_b;
    localparam IV = {8'd`k, 8'd`r, 8'd`a, 8'd`a_b, 32'd`h};
//    localparam bits_msg = $bits(msg);
    localparam bits_msg = $size(msg);
    localparam s = (bits_msg-1)/64+1;
    
    
    typedef enum logic [2:0] {IDLE, initialization, absorb, squeeze, squeeze_take_data, finished} state;
    state cur_state, next_state;
    
    logic [63:0] x0_next, x1_next, x2_next, x3_next, x4_next;
    
    permutation_loop #() permutation_loop (
        .clk(clk),
        .rst_n(rst_permutation_loop),
        .en(en),
        .round(round),
        .init_x(init_x),

        .xo0(x0_next),
        .xo1(x1_next),
        .xo2(x2_next),
        .xo3(x3_next),
        .xo4(x4_next)
    );
    always_ff@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= IDLE;
        end
        else begin
            cur_state <= next_state;
            i <= i_nx;
        end
    end

    logic [63:0] M [1:s];
    logic [63:0] Hi [1:l/r];
    always_comb begin
        case (cur_state)
            IDLE: begin
                i_nx = 1;
                H = 0;
                
                
                for (int j = s-1; j >= 0; j--) begin
                    M[s-j] = {msg, 64'h8000000000000000}>>(64*j + (bits_msg%64));
                end
                if (bits_msg%64==0) begin
                   M[1] = msg;
                end
                
                //khoi tao chay a-vong hoan vi cho trang thai initialization
                rst_permutation_loop = 0;
                round = a;
                init_x = {256'h0, IV};
                next_state = initialization;
            end
            initialization: begin
                rst_permutation_loop = 1;
                if (en) begin
                    next_state = absorb;
                end
            end
            
            absorb: begin
                if (en) begin
                    {xo4, xo3, xo2, xo1, xo0} = {x4_next, x3_next, x2_next, x1_next, x0_next};
                    xo0 = xo0 ^ M[i];
                    init_x = {xo4, xo3, xo2, xo1, xo0};
                    if (i == s) begin
                        //khoi tao chay a-vong hoan vi cho trang thai squeeze
                        round = a;
                        rst_permutation_loop = 0;
                        i_nx = 1;
                        next_state = squeeze; 
                    end
                    else begin
                        round = b;
                        rst_permutation_loop = 0;
                        i_nx = i + 1;
                    end
                end
                else rst_permutation_loop = 1;
            end
            squeeze: begin
                rst_permutation_loop = 1;
                if (en) begin
                //khoi tao chay b-vong hoan vi cho trang thai squeeze_take_data
                    {xo4, xo3, xo2, xo1, xo0} = {x4_next, x3_next, x2_next, x1_next, x0_next};
                    init_x = {xo4, xo3, xo2, xo1, xo0};
                    round = b;
                    rst_permutation_loop = 0;
                    next_state = squeeze_take_data;
                end
            end
            squeeze_take_data: begin
                if (i==l/r) begin
                    i_nx = 1;
                    next_state = finished;
                end
                else 
                    rst_permutation_loop = 1;
                    Hi[i] = xo0;
                    H |= (xo0 << (h - 64*i));
                    if (en) begin
                        {xo4, xo3, xo2, xo1, xo0} = {x4_next, x3_next, x2_next, x1_next, x0_next};
                        init_x = {xo4, xo3, xo2, xo1, xo0};
                        round = b;
                        rst_permutation_loop = 0;
                        i_nx = i+1;
                    end
                end
            default: ;
        endcase
    end
    
endmodule
