`timescale 1ns/1ps
module Permutation(
//    input logic [4:0] in,
//    output logic [4:0] out
        input logic [3:0] round, 
        input logic [63:0] x0,
        input logic [63:0] x1,
        input logic [63:0] x2,
        input logic [63:0] x3,
        input logic [63:0] x4,
        
        output logic [63:0] xo0,
        output logic [63:0] xo1,
        output logic [63:0] xo2,
        output logic [63:0] xo3,
        output logic [63:0] xo4
    );
    
//----------------------------------Pc----------------------------------
    function automatic logic [63:0] pc (input logic [63:0] x_2, input logic [3:0] r);
    reg [7:0] xor_value;
        case (r)
            0: xor_value    = x_2[7:0] ^ 8'hf0;
            1: xor_value    = x_2[7:0] ^ 8'he1;
            2: xor_value    = x_2[7:0] ^ 8'hd2;
            3: xor_value    = x_2[7:0] ^ 8'hc3;
            4: xor_value    = x_2[7:0] ^ 8'hb4;
            5: xor_value    = x_2[7:0] ^ 8'ha5;
            6: xor_value    = x_2[7:0] ^ 8'h96;
            7: xor_value    = x_2[7:0] ^ 8'h87;
            8: xor_value    = x_2[7:0] ^ 8'h78;
            9: xor_value    = x_2[7:0] ^ 8'h69;
            10: xor_value   = x_2[7:0] ^ 8'h5a;
            11: xor_value   = x_2[7:0] ^ 8'h4b;
        endcase
        return {x_2[63:8], xor_value};
    endfunction
//----------------------------------------------------------------------



//----------------------------------Ps----------------------------------
    function automatic logic [4:0] ps (input logic [4:0] substitution_value);
    logic [4:0] x, t;
        x = {<<{substitution_value}};   //subs_value0 is the MSB and subs_value4 is the LSB
        x[0] ^= x[4];
        x[2] ^= x[1];
        x[4] ^= x[3]; 

        t    = ~x;

        t[0] &= x[1]; 
        t[1] &= x[2]; 
        t[2] &= x[3]; 
        t[3] &= x[4]; 
        t[4] &= x[0];

        x[0] ^= t[1]; 
        x[1] ^= t[2]; 
        x[2] ^= t[3]; 
        x[3] ^= t[4]; 
        x[4] ^= t[0];

        x[1] ^= x[0]; 
        x[0] ^= x[4];
        x[3] ^= x[2]; 
        x[2] = ~x[2];
        
        return {<<{x}};     //x0 is the MSB and x4 is the LSB
    endfunction
//----------------------------------------------------------------------
    
    
    
//----------------------------------Pl----------------------------------
    function automatic logic [63:0] rotate_right (input logic [63:0] x, input logic [5:0] num);
        return {x, x} >> num;
//        return (x >> num) | (x << (64-num));
    endfunction
    
    
    function automatic logic [319:0] pl (input logic [63:0] x0, x1, x2, x3, x4);
        reg [63:0] x_0, x_1, x_2, x_3, x_4;
        
        x_0 = x0 ^ rotate_right(x0, 19) ^ rotate_right(x0, 28);
        x_1 = x1 ^ rotate_right(x1, 61) ^ rotate_right(x1, 39);
        x_2 = x2 ^ rotate_right(x2, 1)  ^ rotate_right(x2, 6) ;
        x_3 = x3 ^ rotate_right(x3, 10) ^ rotate_right(x3, 17);
        x_4 = x4 ^ rotate_right(x4, 7)  ^ rotate_right(x4, 41);
        return {x_0, x_1, x_2, x_3, x_4};
    endfunction
//----------------------------------------------------------------------
    
    
    
    reg [4:0]   x;
    reg [63:0] x_0, x_1, x_2, x_3, x_4;
    always_comb
        begin
            {x_0, x_1, x_2, x_3, x_4} = {x0, x1, x2, x3, x4};
            
//            for (int j = 0; j < round; j++) begin
//                //Addition of Constants
//                x_2 = pc(x_2, j);   
//                //Substitution Layer
//                for (int i = 0; i < 64; i++) begin  
//                    x = {x_0[i], x_1[i], x_2[i], x_3[i], x_4[i]};
//                    {x_0[i], x_1[i], x_2[i], x_3[i], x_4[i]} = ps(x);
//                end
//                //Linear Diffusion Layer
//                {x_0, x_1, x_2, x_3, x_4} = pl(x_0, x_1, x_2, x_3, x_4);
//            end
            
//            {xo0, xo1, xo2, xo3, xo4} = {x_0, x_1, x_2, x_3, x_4};
            
            //Addition of Constants
            x_2 = pc(x_2, round);   
            //Substitution Layer
            for (int i = 0; i < 64; i++) begin  
                x = {x_0[i], x_1[i], x_2[i], x_3[i], x_4[i]};
                {x_0[i], x_1[i], x_2[i], x_3[i], x_4[i]} = ps(x);
            end
            //Linear Diffusion Layer
            {x_0, x_1, x_2, x_3, x_4} = pl(x_0, x_1, x_2, x_3, x_4);
            {xo0, xo1, xo2, xo3, xo4} = {x_0, x_1, x_2, x_3, x_4};
        end
endmodule
