----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:12:38 04/13/2021 
-- Design Name: 
-- Module Name:    alu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (7 downto 0));
end alu;

architecture Behavioral of alu is
	signal A9: STD_LOGIC_VECTOR(8 downto 0);
	signal B9: STD_LOGIC_VECTOR(8 downto 0);
	signal ADD: STD_LOGIC_VECTOR(8 downto 0);
	signal SUB: STD_LOGIC_VECTOR(8 downto 0);
	signal MUL: STD_LOGIC_VECTOR(15 downto 0);
	signal SBIS: STD_LOGIC_VECTOR(7 downto 0);
	
begin

		A9 <= "0"& A;
		B9 <= "0"& B;
		ADD <= A9 + B9;
		SUB <= A9 - B9;
		MUL <= A * B;
		
		SBIS <= ADD(7 downto 0) when Ctrl_Alu = "001" else
			  SUB(7 downto 0) when Ctrl_Alu = "010" else
			  MUL(7 downto 0) when Ctrl_Alu = "011" else
			  (others => '0');
		O <= '1' when MUL(15 downto 8) /= "00000000" and Ctrl_Alu = "011" else
			  '0';
		C <= '1' when ADD(8) = '1' and Ctrl_Alu = "001" else
			  '0';
		N <= '1' when SUB(8) = '1' and Ctrl_Alu = "010" else
			  '0';
		Z <= '1' when SBIS = "00000000" and Ctrl_Alu /= "000" else
			  '0';
		S <= SBIS;
end Behavioral;

