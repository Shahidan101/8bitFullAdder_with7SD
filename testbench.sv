// Code your testbench here
// or browse Examples  

module test_adder_8bit();
  
  integer i;
  reg [7:0] X;
  reg [7:0] Y;
  reg Carry_IN;
  wire Carry_OUT;
  wire [7:0] BIN_OUT;
  wire [3:0] BCD_HUND;
  wire [3:0] BCD_TEN;
  wire [3:0] BCD_ONE;
  wire [6:0] SEG_HUND;
  wire [6:0] SEG_TEN;
  wire [6:0] SEG_ONE;
  
  full_adder8 full_adder8_1(X, Y, Carry_IN, BIN_OUT, Carry_OUT);
  
  BIN2BCD B2B0(BIN_OUT, BCD_HUND, BCD_TEN, BCD_ONE);
  
  BCD27SD BCD27SD0(BCD_HUND[3], BCD_HUND[2], BCD_HUND[1], BCD_HUND[0], SEG_HUND[6], SEG_HUND[5], SEG_HUND[4], SEG_HUND[3], SEG_HUND[2], SEG_HUND[1], SEG_HUND[0]);
  
  BCD27SD BCD27SD1(BCD_TEN[3], BCD_TEN[2], BCD_TEN[1], BCD_TEN[0], SEG_TEN[6], SEG_TEN[5], SEG_TEN[4], SEG_TEN[3], SEG_TEN[2], SEG_TEN[1], SEG_TEN[0]);
  
  BCD27SD BCD27SD2(BCD_ONE[3], BCD_ONE[2], BCD_ONE[1], BCD_ONE[0], SEG_ONE[6], SEG_ONE[5], SEG_ONE[4], SEG_ONE[3], SEG_ONE[2], SEG_ONE[1], SEG_ONE[0]);
  
  initial begin
    //creating a file to store simulation waveform data
    $dumpfile("dump.vcd");
    //dump the waveform data to the file
    $dumpvars(1, test_adder_8bit);

    for (i = 0; i < 5; i = i + 1)
      begin
        X = $urandom%99;
        Y = $urandom%99;
        Carry_IN = 0;
        
        // Add a delay before the displays
    	// Cause the bits won't reach the module in time
    	// Brrrrrr
    	#1
        $display("============================");
        $display("LOOP %d", i);
        $display("============================");
        $display("A = %b or %d", X, X);
    	$display("B = %b or %d", Y, Y);
    	$display("CARRY_IN = %b", Carry_IN);    
    	$display("SUM = %b or %d", BIN_OUT, BIN_OUT);
    	$display("CARRY_OUT = %b", Carry_OUT);
    	$display("HUNDRED = %b or %d", BCD_HUND, BCD_HUND);
    	$display("TENS = %b or %d", BCD_TEN, BCD_TEN);
    	$display("ONES = %b or %d", BCD_ONE, BCD_ONE);
    	$display("HUNDRED IN 7SD = %b", SEG_HUND);
    	$display("TENS IN 7SD = %b", SEG_TEN);
    	$display("ONES IN 7SD = %b", SEG_ONE);
      end
  end
endmodule