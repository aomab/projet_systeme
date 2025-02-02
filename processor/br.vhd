----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:29:59 04/13/2021 
-- Design Name: 
-- Module Name:    br - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

--use UNISIM.VComponents.all;

entity br is
    Port ( A_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           B_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           W_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           W : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0));
end br;

architecture Behavioral of br is

type reg is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
signal registres: reg;

begin
	process
		begin
			wait until rising_edge(CLK);
			if W = '1' then
				registres(to_integer(unsigned(W_addr))) <= Data;
			end if;
			if RST='0' then 
				registres <= (others => "00000000");
			end if;	
	end process;
	QA <= registres(to_integer(unsigned(A_addr))) when W ='0' or A_addr /= W_addr
			else Data;
	QB <= registres(to_integer(unsigned(B_addr))) when W ='0' or B_addr /= W_addr
			else Data;
end Behavioral;

