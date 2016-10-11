library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;
library UNISIM;
use UNISIM.VComponents.all;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
entity CU is
    Port ( MCLK : in  STD_LOGIC_VECTOR (2 downto 0);--3个机器周期 001 010 100
           CLK : in  STD_LOGIC_VECTOR (2 downto 0);--每个机器周期的三个节拍 001 010 100
           OP : in  STD_LOGIC_VECTOR (9 downto 0);--10条指令的表
			  I : in  STD_LOGIC;--看书上的表，i,a0,INX输入变量
           A : in  STD_LOGIC;
           IND : in  STD_LOGIC;
           MICROS : out  STD_LOGIC_VECTOR (27 downto 0));--20个微操作
end CU;
architecture Behavioral of CU is
	signal OPTMP : std_logic_vector(9 downto 0);--对应10条指令
begin
	--CLA
	OPTMP(0)<=(not OP(9)) and not OP(8) and not OP(7) and not OP(6) and not OP(5) and not OP(4) and not OP(3) and not OP(2) and not OP(1) and  OP(0); 
	--COM
	OPTMP(1)<=not OP(9) and not OP(8) and not OP(7) and not OP(6) and not OP(5) and not OP(4) and not OP(3) and not OP(2) and OP(1) and not OP(0); 
	--SHR
	OPTMP(2)<=not OP(9) and not OP(8) and not OP(7) and not OP(6) and not OP(5) and not OP(4) and not OP(3) and  OP(2) and not OP(1) and not OP(0); 
	--CSL
	OPTMP(3)<=not OP(9) and not OP(8) and not OP(7) and not OP(6) and not OP(5) and not OP(4) and  OP(3) and not OP(2) and not OP(1) and not OP(0); 
	--STP
	OPTMP(4)<=not OP(9) and not OP(8) and not OP(7) and not OP(6) and not OP(5) and  OP(4) and not OP(3) and not OP(2) and not OP(1) and not OP(0); 
	--ADD
	OPTMP(5)<=not OP(9) and not OP(8) and not OP(7) and not OP(6) and  OP(5) and not OP(4) and not OP(3) and not OP(2) and not OP(1) and not OP(0); 
	--STA
	OPTMP(6)<=not OP(9) and not OP(8) and not OP(7) and  OP(6) and not OP(5) and not OP(4) and not OP(3) and not OP(2) and not OP(1) and not OP(0); 
	--LDA
	OPTMP(7)<=not OP(9) and not OP(8) and  OP(7) and not OP(6) and not OP(5) and not OP(4) and not OP(3) and not OP(2) and not OP(1) and not OP(0);
	--JMP
	OPTMP(8)<=not OP(9) and  OP(8) and not OP(7) and not OP(6) and not OP(5) and not OP(4) and not OP(3) and not  OP(2) and not OP(1) and not OP(0); 
	--BAN
	OPTMP(9)<= OP(9) and not OP(8) and not OP(7) and not OP(6) and not OP(5) and not OP(4) and not OP(3) and not OP(2) and not OP(1) and not OP(0);
	
	--指令系统,列出bool表达式求MICROS，每一时刻用对应的输入利用bool式求对应微操作，以微操作为输出
	--PC->MAR
	MICROS(0)<=MCLK(0) and CLK(0); 
	--1->R
	MICROS(1)<=CLK(0) and MCLK(0) ; 
	--M(MAR)->MDR
	MICROS(2)<=CLK(1) and MCLK(0); 
	--PC+1->PC
	MICROS(3)<=MCLK(0) and CLK(1); 
	--MDR->IR
	MICROS(4)<=CLK(2) and MCLK(0);
	--OP(IR)->ID
	MICROS(5)<=MCLK(0) and CLK(2); 
	--I->IND
	MICROS(6)<=i and MCLK(0) and CLK(2) and (OPTMP(5) or OPTMP(6) or OPTMP(7) or OPTMP(8) or OPTMP(9)); 
   --I->EX
	MICROS(7)<=not i and MCLK(0) and CLK(2); 
	--AD(IR)->MAR
	MICROS(8)<=CLK(0) and MCLK(1) and (OPTMP(5) or OPTMP(6) or OPTMP(7) or OPTMP(8) or OPTMP(9)); 
	--1->R
	MICROS(9)<=MCLK(1) AND CLK(0) AND (OPTMP(5) OR OPTMP(6) OR OPTMP(7) OR OPTMP(8) OR OPTMP(9));
	--M(MAR)->MDR
	MICROS(10)<=MCLK(1) AND CLK(1) AND (OPTMP(5) OR OPTMP(6) OR OPTMP(7) OR OPTMP(8) OR OPTMP(9));
	--MAR->AD(IR)
	MICROS(11)<=MCLK(1) AND CLK(2) AND (OPTMP(5) OR OPTMP(6) OR OPTMP(7) OR OPTMP(8) OR OPTMP(9));
	--I->EX
	MICROS(12)<=I AND MCLK(1) AND CLK(2) AND (OPTMP(5) OR OPTMP(6) OR OPTMP(7) OR OPTMP(8) OR OPTMP(9));
	--AD(IR)->MAR
	MICROS(13)<=MCLK(2) AND CLK(0) AND(OPTMP(5) OR OPTMP(6) OR OPTMP(7));
	--1->R
	MICROS(14)<=MCLK(2) AND CLK(0) AND(OPTMP(5) OR OPTMP(7));
	--1->W
	MICROS(15)<=MCLK(2) and CLK(0) and OPTMP(6);
	--M(MAR)->MDR
	MICROS(16)<=MCLK(2) AND CLK(1) AND (OPTMP(5) OR OPTMP(7));
	--ACC->MDR
	MICROS(17)<=MCLK(2) and CLK(1) and OPTMP(6);
	--(ACC)+(MDR)->ACC
	MICROS(18)<=MCLK(2) and CLK(2) and OPTMP(5);
	--MDR->M(MAR)
	MICROS(19)<=MCLK(2) and CLK(2) and OPTMP(6);
	--MDR->ACC
	MICROS(20)<=MCLK(2) and CLK(2) and OPTMP(7);
	--0->ACC
	MICROS(21)<=MCLK(2) and CLK(2) and OPTMP(0);
	--~ACC->ACC
	MICROS(22)<=MCLK(2) and CLK(2) and OPTMP(1);
	--L(ACC)->R(ACC)
	MICROS(23)<=MCLK(2) and CLK(2) and OPTMP(2);
	--P-1(ACC)
	MICROS(24)<=MCLK(2) and CLK(2) and OPTMP(3); 
	--AD(IR)->PC
	MICROS(25)<=MCLK(2) and CLK(2) and OPTMP(8);
	--AD(IR)->PC
	MICROS(26)<=a and MCLK(2) and CLK(2) and OPTMP(9);
	--0->G
	MICROS(27)<=MCLK(2) and CLK(2) and OPTMP(4);
end Behavioral;

