--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:17:22 04/16/2021
-- Design Name:   
-- Module Name:  
-- Project Name:  ALU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bm_data
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bm_data_test IS
END bm_data_test;
 
ARCHITECTURE behavior OF bm_data_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bm_data
    PORT(
         IN_addr : IN  std_logic_vector(7 downto 0);
         IN_data : IN  std_logic_vector(7 downto 0);
         RW : IN  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic;
         OUT_data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal IN_addr : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_data : std_logic_vector(7 downto 0) := (others => '0');
   signal RW : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal OUT_data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bm_data PORT MAP (
          IN_addr => IN_addr,
          IN_data => IN_data,
          RW => RW,
          RST => RST,
          CLK => CLK,
          OUT_data => OUT_data
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      wait for CLK_period*10;
		RST <= '1';
		IN_addr <= "00000001";
		IN_data <= "00000001";
		wait for 30 ns;
		IN_addr <= "00000010";
		IN_data <= "00000010";
		
		RW <= '1';
		wait for 30 ns;
		IN_addr <= "00000001";
		wait for 30 ns;
		IN_addr <= "00000000";
		
		wait for 30 ns;
		RST <= '0';
		
      wait;
   end process;

END;
