----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:32:11 04/15/2021 
-- Design Name: 
-- Module Name:    bm_data - Behavioral 
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

entity bm_data is
    Port ( IN_addr : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_data : in  STD_LOGIC_VECTOR (7 downto 0);
           RW : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           OUT_data : out  STD_LOGIC_VECTOR (7 downto 0));
end bm_data;

architecture Behavioral of bm_data is

type mem is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
signal data_memory: mem;

begin
	process
		begin
			wait until rising_edge(CLK);
			if RW = '1' then
				OUT_data <= data_memory(to_integer(unsigned(IN_addr)));
			else
				data_memory(to_integer(unsigned(IN_addr))) <= IN_data;
			end if;
			if RST='0' then 
				data_memory <= (others => "00000000");
				OUT_data <= (others => '0');
			end if;	
	end process;


end Behavioral;

