module chacha_qr(
                 input wire [31 : 0]  a,    //Defining Inputs
                 input wire [31 : 0]  b,
                 input wire [31 : 0]  c,
                 input wire [31 : 0]  d,

                 output wire [31 : 0] a_out,   //Defining Outputs
                 output wire [31 : 0] b_out,
                 output wire [31 : 0] c_out,
                 output wire [31 : 0] d_out
                );

  //----------------------------------------------------------------
  // Declaring wires for output
  //----------------------------------------------------------------
  reg [31 : 0] a_final;
  reg [31 : 0] b_final;
  reg [31 : 0] c_final;
  reg [31 : 0] d_final;


  //----------------------------------------------------------------
  // Concurrent connectivity of output ports.
  //----------------------------------------------------------------
  assign a_out = a_final;
  assign b_out = b_final;
  assign c_out = c_final;
  assign d_out = d_final;


  //----------------------------------------------------------------
  // qr
  // The actual quarterround function.
  //----------------------------------------------------------------
  always @*
    begin : qr
      reg [31 : 0] a_add_rot16;                  // Declaring registers for intermediate results
      reg [31 : 0] a_add_xor2;

      reg [31 : 0] b_xor1;
      reg [31 : 0] b_rot12;                  // Declaring registers for intermediate results
      reg [31 : 0] b_xor2;
      reg [31 : 0] b_rot7;

      reg [31 : 0] c_add_rot16;
      reg [31 : 0] c_add_xor2;                  // Declaring registers for intermediate results

      reg [31 : 0] d_xor1;
      reg [31 : 0] d_rot16;                  // Declaring registers for intermediate results
      reg [31 : 0] d_xor2;
      reg [31 : 0] d_rot8;

      a_add_rot16 = a + b;                       // First Step of Quarterround : 32 bit addition
      d_xor1 = d ^ a_add_rot16;                      // Second Step of Quarterround : 32 bit XOR Operation
      d_rot16 = {d_xor1[15 : 0], d_xor1[31 : 16]};   // Third Step of Quarterround : Left shifting the bits by 16 bit
      
      c_add_rot16 = c + d_rot16;                       // First Step of Quarterround : 32 bit addition
      b_xor1 = b ^ c_add_rot16;                       // Second Step of Quarterround : 32 bit XOR Operation
      b_rot12 = {b_xor1[19 : 0], b_xor1[31 : 20]};    // Third Step of Quarterround : Left shifting the bits by 12 bit
      
      a_add_xor2 = a_add_rot16 + b_rot12;                      // First Step of Quarterround : 32 bit addition
      d_xor2 = d_rot16 ^ a_add_xor2;                      // Second Step of Quarterround : 32 bit XOR Operation
      d_rot8 = {d_xor2[23 : 0], d_xor2[31 : 24]};;   // Third Step of Quarterround : Left shifting the bits by 8 bit
     
      c_add_xor2 = c_add_rot16 + d_rot8;                      // First Step of Quarterround : 32 bit addition
      b_xor2 = b_rot12 ^ c_add_xor2;                      // Second Step of Quarterround : 32 bit XOR Operation
      b_rot7 = {b_xor2[24 : 0], b_xor2[31 : 25]};    // Third Step of Quarterround : Left shifting the bits by 7 bit

      a_final = a_add_xor2;              // Sequentially connecting output port wires to the intermediate registers 
      b_final = b_rot7;
      c_final = c_add_xor2;
      d_final = d_rot8;
    end // qr
endmodule // chacha_qr

