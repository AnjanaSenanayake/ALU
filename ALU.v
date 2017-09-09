/***************************************************************************************
*    Title: Project - Phase 2: Verilog implementation of the ALU
*    Author: Anjana Senanayake
*    Date: March/2016 
*    Code version: v1.0
*    Availability: https://github.com/AnjanaSenanayake/ALU
*
*************************************************************************************/

// Top level stimulus module
// This module can be directly used in your design
module testbed;

	reg [2:0] A,B;
	reg load1,load2,run;
	//output C is taken as a 4 bit value.
	wire [3:0] C; 
	reg [3:0] op_code;


	//A and B are the two 3-bit inputs coming from switches
	//C is the 3-bit output that comes from the accumulator once run is set to high
	//load1 is the load signal for operand 1 register
	//load2 is the load signal for operand 2 register
	//op_code selects the operator
		// op_code=4'b0000 - Addition
		// op_code=4'b0001 - Bitwise XOR
		// op_code=4'b0010 - Multiplication
		// op_code=4'b0011 - Shift Left
		// op_code=4'b0100 - Shift Right
		// op_code=4'b0101 - Bitwise AND
		// op_code=4'b0110 - Bitwise OR
		// op_code=4'b0111 - Bitwise NAND
		// op_code=4'b1000 - Bitwise NOR
		// op_code=4'b1001 - One bit shift left
		// op_code=4'b1010 - One bit shift right

	//you don't have to model switches or the LEDs in Verilog

	// Instatiation of the ALU module
	ALU mu_alu(C,A,B,load1,load2,op_code,run);

	initial
	begin

		//generate files needed to plot the waveform
		//you can plot the waveform generated after running the simulator by using gtkwave
		$dumpfile("wavedata.vcd");
	    $dumpvars(0,testbed);

		//You should simulate the ALU for the given inputs
		// Input 1: A=5, B=2
		// Input 2: A=2, B=5
		//You should add another test case of your own as well
		//Out of the given op_codes and $display statements, you should select only those
		//corresponging to your implementation and erase others
	
		//A = 5 and B = 2
		#5 A=3'd5; B=3'd2; 
		#5 load1=1'b1;
		#5 load1=1'b0;
		#5 load2=1'b1;
		#5 load2=1'b0;

		#5 op_code=4'b0010;
		#5 run=1'b1;
		#5 run=1'b0; 
		//waited for 20 units
		#20 $display("%d * %d = %d",A,B,C);

		#5 op_code=4'b0110;
		#5 run=1'b1;
		#5 run=1'b0;
		//waited for 20 units
		#20 $display("%b | %b = %b",A,B,C);
		$display("");
		
		//A = 2 and B = 5
		#5 A=3'd2; B=3'd5; 
		#5 load1=1'b1;
		#5 load1=1'b0;
		#5 load2=1'b1;
		#5 load2=1'b0;

		#5 op_code=4'b0010; 
		#5 run=1'b1;
		#5 run=1'b0;
		//waited for 20 units
		#20 $display("%d * %d = %d",A,B,C);

		#5 op_code=4'b0110;
		#5 run=1'b1;
		#5 run=1'b0;
		//waited for 20 units
		#20 $display("%b | %b = %b",A,B,C);
		$display("");
		
		//Add your test case here.
		
		//A = 2 and B = 4
		#5 A=3'd2; B=3'd4; 
		#5 load1=1'b1;
		#5 load1=1'b0;
		#5 load2=1'b1;
		#5 load2=1'b0;

		#5 op_code=4'b0010; 
		#5 run=1'b1;
		#5 run=1'b0;
		//waited for 20 units
		#20 $display("%d * %d = %d",A,B,C);

		#5 op_code=4'b0110;
		#5 run=1'b1;
		#5 run=1'b0;
		//waited for 20 units
		#20 $display("%b | %b = %b",A,B,C);
		$display("");

		//A = 4 and B = 2
		#5 A=3'd4; B=3'd2; 
		#5 load1=1'b1;
		#5 load1=1'b0;
		#5 load2=1'b1;
		#5 load2=1'b0;

		#5 op_code=4'b0010; 
		#5 run=1'b1;
		#5 run=1'b0;
		//waited for 20 units
		#20 $display("%d * %d = %d",A,B,C);

		#5 op_code=4'b0110;
		#5 run=1'b1;
		#5 run=1'b0;
		//waited for 20 units
		#20 $display("%b | %b = %b",A,B,C);

		$finish;	
		
	end

endmodule

//your modules should go here
///////////////////////////////////////////////////////////////////////////


//SR latch
module srlatch(q,qcomp,s,r,set,reset);

	input s,r,set,reset;
	output q,qcomp;

	not not0(nreset,reset);
	not not1(nset,set); 
	nand nand1(q,r,qcomp,nset);
	nand nand2(qcomp,s,q,nreset);

endmodule

//D latch
module dlatch(q,qcomp,d,clk,set,reset);
	
	input d,clk,set,reset;
	output q,qcomp;
	wire t1,t2,dnot;

	not not2(dnot,d);
	nand nand3(t1,d,clk);
	nand nand4(t2,dnot,clk);
	srlatch sr(q,qcomp,t2,t1,set,reset);

endmodule

//D flipflop
module dflipflop(q,d,clk,set,reset);

	input d,clk,set,reset;
	output q;
	wire t3,clknot;

	not not3(clknot,clk);
	dlatch dlatch1(t3,,d,clknot,set,reset);
	dlatch dlatch2(q,,t3,clk,set,reset);

endmodule

//3 Bit Register
module register3bit(out,in,load);

	input [2:0] in;
	input load;
	output [2:0] out;
	wire loadout,nload;
		
	not not3(nload,load);
	dflipflop dflop1(out[0],in[0],nload,0,0);
	dflipflop dflop2(out[1],in[1],nload,0,0);
	dflipflop dflop3(out[2],in[2],nload,0,0); 
		
endmodule

//4 Bit Register
module register4bit(out,in,run);

	input [3:0] in;
	input run;
	output [3:0] out;
	wire runout,nrun;
	
	not not3(nrun,run);
	dflipflop dflop1(out[0],in[0],nrun,0,0);
	dflipflop dflop2(out[1],in[1],nrun,0,0);
	dflipflop dflop3(out[2],in[2],nrun,0,0);
	dflipflop dflop4(out[3],in[3],nrun,0,0);
	
endmodule

//Fulladder
module fulladder(s,cout,a,b,cin);

	input a,b,cin;
	output s,cout;
	wire t1,t2,t3,t4;
	
	xor xor1(t1,a,b);
	xor xor2(s,t1,cin);
	and and1(t2,t1,cin);
	and and2(t3,a,b);
	or or1(cout,t2,t3);

endmodule	

//2 Op ALU
module ALU(C,A,B,load1,load2,op_code,run);

	input [2:0] A,B;
	input [3:0] op_code;
	input clk,load1,load2,run;
	output [3:0] Creg,C;
	wire [2:0] Aout,Bout;
	wire [8:0] t;
	wire [7:0] s;
	wire [4:0] cout;
	wire [12:0] w;
	wire [3:0] nin;
	
	register3bit reg1(Aout,A,load1);
	register3bit reg2(Bout,B,load2);
	and and1(t[0],Aout[2],Bout[2]);
	and and2(t[1],Aout[2],Bout[1]);
	and and3(t[2],Aout[2],Bout[0]);
	and and4(t[3],Aout[1],Bout[2]);
	and and5(t[4],Aout[1],Bout[1]);
	and and6(t[5],Aout[1],Bout[0]);
	and and7(t[6],Aout[0],Bout[2]);
	and and8(t[7],Aout[0],Bout[1]);
	and and9(t[8],Aout[0],Bout[0]);
	or or1(s[5],Aout[0],Bout[0]);
	or or2(s[6],Aout[1],Bout[1]);
	or or3(s[7],Aout[2],Bout[2]);
	fulladder fa1(s[0],cout[0],t[5],t[7],0);
	fulladder fa2(s[1],cout[1],t[2],t[4],cout[0]);
	fulladder fa3(s[2],cout[2],t[6],s[1],0);
	fulladder fa4(s[3],cout[3],t[1],t[3],cout[1]);
	fulladder fa5(s[4],cout[4],s[3],0,cout[2]);
	
	not not1(nin[0],op_code[0]);
	not not2(nin[1],op_code[1]);
	not not3(nin[2],op_code[2]);
	not not4(nin[3],op_code[3]);
	
	and and10(w[7],nin[3],op_code[1]);
	and and11(w[8],w[7],nin[0]);
	and and12(w[9],w[8],nin[2]);
	
	and and13(w[0],t[8],nin[2]);
	and and14(w[1],s[5],op_code[2]);
	and and15(w[2],s[0],nin[2]);
	and and16(w[3],s[6],op_code[2]);
	and and17(w[4],s[7],op_code[2]);
	and and18(w[5],s[2],nin[2]);
	and and19(Creg[3],s[4],w[9]);
	
	or or4(w[10],w[0],w[1]);
	or or5(w[11],w[2],w[3]);
	or or6(w[12],w[4],w[5]);
	
	and and20(Creg[0],w[10],w[8]);
	and and21(Creg[1],w[11],w[8]);
	and and22(Creg[2],w[12],w[8]);
	
	register4bit reg3(C,Creg,run);
	
endmodule	
	
module sw(clk,load);
	
	input load;
	output clk;

endmodule
