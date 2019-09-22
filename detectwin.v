// DetectWinner
// Detects whether either ain or bin has three in a row 
// Inputs:
//   ain, bin - (9-bit) current positions of type a and b
// Out:
//   win_line - (8-bit) if A/B wins, one hot indicates along which row, col or diag
//   win_line(0) = 1 means a win in row 8 7 6 (i.e., either ain or bin has all ones in this row)
//   win_line(1) = 1 means a win in row 5 4 3
//   win_line(2) = 1 means a win in row 2 1 0
//   win_line(3) = 1 means a win in col 8 5 2
//   win_line(4) = 1 means a win in col 7 4 1
//   win_line(5) = 1 means a win in col 6 3 0
//   win_line(6) = 1 means a win along the downward diagonal 8 4 0
//   win_line(7) = 1 means a win along the upward diagonal 2 4 6

module DetectWinner( input [8:0] ain, bin, output [7:0] win_line );
  // CPEN 211 LAB 3, PART 1: your implementation goes here
  wire [7:0] xwin, owin;

  ThreeInArray winx(ain, xwin); //check if x won
  ThreeInArray wino(bin, owin); // check if o won
  SelectWinXO combxo(winx, wino, win_line); //prioritize x over o due to turn order structure
  
endmodule

module ThreeInArray(input [7:0] ain, output[7:0] win_line);

  wire [2:0] rowss, colss ;
  reg dodiag, updiag ;
  
  ThreeInRow botrow(ain[8:6],rowss[2]) ;
  ThreeInRow midrow(ain[5:3],rowss[1]) ;
  ThreeInRow toprow(ain[2:0],rowss[0]) ;
  ThreeInRow rightcolumn({ain[8],ain[5],ain[2]}, 
								{colss[2]})    ;
  ThreeInRow midcolumn({ain[7],ain[4],ain[1]}, 
								{colss[1]})    ;
  ThreeInRow leftcolumn({ain[6],ain[3],ain[0]}, 
								{colss[0]})    ;
  ThreeInRow downdiag({ain[8],ain[4],ain[0]},dodiag) ;
  ThreeInRow updiag({ain[6],ain[4],ain[2]},updiag)   ;
  
  assign win_line[0:2] = rowss[2:0] ; 
  assign win_line[3:5] = colss[2:0] ; 
  assign win_line[6]   = dodiag     ;
  assign win_line[7]   = updiag     ;
  
endmodule

module ThreeInRow(ain, cout);
  input [2:0] ain           ;
  output cout               ;

  assign cout = ain[0] & ain[1] & ain[2]; 
endmodule

module SelectWinXO(a,b,out);
  input [7:0] a, b ;
  output [7:0] out ;
  wire [15:0] x    ;
`	
  RArb #(15) ({a,b},x);
  
  assign out = x[15:8] | x[7:0];

endmodule
 

 