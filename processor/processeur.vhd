    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date:    12:52:06 05/04/2021 
    -- Design Name: 
    -- Module Name:    processeur - Behavioral 
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

    -- Uncomment the following library declaration if using
    -- arithmetic functions with Signed or Unsigned values
    --use IEEE.NUMERIC_STD.ALL;

    -- Uncomment the following library declaration if instantiating
    -- any Xilinx primitives in this code.
    --library UNISIM;
    --use UNISIM.VComponents.all;

    entity processeur is
        Port ( CLK: in  STD_LOGIC ;
    				RST : in STD_LOGIC);
    end processeur;

    architecture Behavioral of processeur is
    	COMPONENT bm_instr
        PORT(
             IN_addr : IN  std_logic_vector(7 downto 0);
             OUT_data : OUT  std_logic_vector(31 downto 0);
             CLK : IN  std_logic 
            );
        END COMPONENT;
    	 
    	 COMPONENT pipeline
        PORT( OP_IN : in  STD_LOGIC_VECTOR (7 downto 0);
               A_IN : in  STD_LOGIC_VECTOR (7 downto 0);
               B_IN : in  STD_LOGIC_VECTOR (7 downto 0);
               C_IN : in  STD_LOGIC_VECTOR (7 downto 0);
    			  CLK : IN  std_logic;
				  EN : in STD_LOGIC;
               OP_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
               A_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
               B_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
               C_OUT : out  STD_LOGIC_VECTOR (7 downto 0)
            );
        END COMPONENT;
    	 
    	 COMPONENT br
        PORT(
             A_addr : IN  std_logic_vector(3 downto 0);
             B_addr : IN  std_logic_vector(3 downto 0);
             W_addr : IN  std_logic_vector(3 downto 0);
             W : IN  std_logic;
             Data : IN  std_logic_vector(7 downto 0);
             RST : IN  std_logic;
             CLK : IN  std_logic;
             QA : OUT  std_logic_vector(7 downto 0);
             QB : OUT  std_logic_vector(7 downto 0)
            );
        END COMPONENT;
    	 
    	 COMPONENT alu
        PORT(
             A : IN  std_logic_vector(7 downto 0);
             B : IN  std_logic_vector(7 downto 0);
             Ctrl_Alu : IN  std_logic_vector(2 downto 0);
             N : OUT  std_logic;
             O : OUT  std_logic;
             Z : OUT  std_logic;
             C : OUT  std_logic;
             S : OUT  std_logic_vector(7 downto 0)
            );
        END COMPONENT;
    	 
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
       signal IP : std_logic_vector(7 downto 0) := (others => '0');
    	signal QA_IN_MUX : std_logic_vector(7 downto 0) := (others => '0');

    	signal B_DIEX_IN : std_logic_vector(7 downto 0) := (others => '0');
    	signal C_DIEX_IN : std_logic_vector(7 downto 0) := (others => '0');
    	
     	--Outputs
       signal OUT_data : std_logic_vector(31 downto 0);
    	
    	signal OP_LIDI_OUT : std_logic_vector(7 downto 0);
    	signal A_LIDI_OUT : std_logic_vector(7 downto 0);
    	signal B_LIDI_OUT : std_logic_vector(7 downto 0);
    	signal C_LIDI_OUT : std_logic_vector(7 downto 0);
    	
    	signal OP_DIEX_OUT : std_logic_vector(7 downto 0);
    	signal A_DIEX_OUT : std_logic_vector(7 downto 0);
    	signal B_DIEX_OUT : std_logic_vector(7 downto 0);
    	signal C_DIEX_OUT : std_logic_vector(7 downto 0);
    	
    	signal O_ALU_OUT : std_logic;
    	signal N_ALU_OUT : std_logic;
    	signal Z_ALU_OUT : std_logic;
    	signal C_ALU_OUT : std_logic;
    	
    	signal A_EXMem_OUT : std_logic_vector(7 downto 0);
    	signal B_EXMem_OUT : std_logic_vector(7 downto 0);
    	signal OP_EXMem_OUT : std_logic_vector(7 downto 0);
    	
    	signal A_MemRE_OUT : std_logic_vector(7 downto 0);
    	signal B_MemRE_OUT : std_logic_vector(7 downto 0);
    	signal OP_MemRE_OUT : std_logic_vector(7 downto 0);
    	
    	--AUX
    	
    	signal Ctr_ALU_LC : std_logic_vector(2 downto 0);
    	signal RW_LC : std_logic;
    	signal addr_dm_MUX : std_logic_vector(7 downto 0);
    	signal in_dm_MUX : std_logic_vector(7 downto 0);
    	signal out_dm_MUX : std_logic_vector(7 downto 0);
    	signal B_EXMem_IN : std_logic_vector(7 downto 0);
    	signal W_br_LC : std_logic;
    	signal S_IN_MUX : std_logic_vector(7 downto 0);
    	signal B_MemRE_IN : std_logic_vector(7 downto 0);
    	
		--alea
		signal li_di_r_b : std_logic;
		signal li_di_r_c : std_logic;
		signal di_ex_w_a : std_logic;
		signal ex_mem_w_a : std_logic;
		signal store_load : std_logic;
		signal alea : std_logic;
		
    begin
    	
    	-- Instantiate adresse des instructions 
       addr_instructions: bm_instr PORT MAP (
              IN_addr => IP,
              OUT_data => OUT_data,
              CLK => CLK
       	);

    	-- Instantiate pipeline LI_LD
    	LI_LD : pipeline PORT MAP (
    			OP_IN => OUT_data(31 downto 24),
               A_IN => OUT_data(23 downto 16),
               B_IN => OUT_data(15 downto 8),
               C_IN => OUT_data(7 downto 0),
    			  CLK => CLK,
				  EN => alea,
    			  A_OUT => A_LIDI_OUT,
    			  B_OUT => B_LIDI_OUT,
    			  C_OUT => C_LIDI_OUT,
    			  OP_OUT => OP_LIDI_OUT
               );
    	W_br_LC <= '1' when OP_MemRE_OUT = x"07" or OP_MemRE_OUT = x"05" or OP_MemRE_OUT = x"06" or OP_MemRE_OUT = x"01" or OP_MemRE_OUT = x"02" or OP_MemRE_OUT = x"03" or OP_MemRE_OUT = x"04" else
    					'0';
						
		--alea LI_DI
		li_di_r_b <= '1' when OUT_data(31 downto 24) = x"05" or OUT_data(31 downto 24) = x"01" or OUT_data(31 downto 24) = x"02" or OUT_data(31 downto 24) = x"03" or OUT_data(31 downto 24) = x"04" or OUT_data(31 downto 24) = x"08"
						else '0';
		li_di_r_c <= '1' when OUT_data(31 downto 24) = x"01" or OUT_data(31 downto 24) = x"02" or OUT_data(31 downto 24) = x"03" or OUT_data(31 downto 24) = x"04"
						else '0';
		store_load <= '1' when OUT_data(31 downto 24) = x"07" and OP_LIDI_OUT = x"08"
						else '0';
    	-- Instanciate banc de registre
       banc_registres : br PORT MAP (
              A_addr => B_LIDI_OUT(3 downto 0),
              B_addr => C_LIDI_OUT(3 downto 0),
              W_addr => A_MemRE_OUT(3 downto 0),
              W => W_br_LC, --ATTENTION LC
              Data => B_MemRE_OUT,
              RST => RST,
              CLK => CLK,
              QA => QA_IN_MUX,
              QB => C_DIEX_IN
            );
    			
    	B_DIEX_IN <= QA_IN_MUX when OP_LIDI_OUT = x"05" or OP_LIDI_OUT = x"01" or OP_LIDI_OUT = x"02" or OP_LIDI_OUT = x"03" or OP_LIDI_OUT = x"04" or OP_LIDI_OUT = x"08" else B_LIDI_OUT ;
    	--B_DIEX_IN <= QA_IN_MUX when OP_LIDI_OUT = x"05" or OP_LIDI_OUT = x"01" or OP_LIDI_OUT = x"02" or OP_LIDI_OUT = x"03" or OP_LIDI_OUT = x"04" else B_LIDI_OUT ;		
    			
    	-- Instantiate pipeline DI_EX
    	DI_EX : pipeline PORT MAP (
    			OP_IN => OP_LIDI_OUT,
    		  A_IN => A_LIDI_OUT,
    		  B_IN => B_DIEX_IN,
    		  C_IN => C_DIEX_IN,
    		  CLK => CLK,
			  EN => '1',
    		  A_OUT => A_DIEX_OUT,
    		  B_OUT => B_DIEX_OUT,
    		  C_OUT => C_DIEX_OUT,
    		  OP_OUT => OP_DIEX_OUT
    		  );
    		  
    	Ctr_ALU_LC <= "001" when OP_DIEX_OUT = x"01" else 
    						"010" when OP_DIEX_OUT = x"03" else
    						"011" when OP_DIEX_OUT = x"02" else
    						"000";	  
    	-- alea DI_EX
		di_ex_w_a <= '0' when OP_LIDI_OUT = x"08" or OP_LIDI_OUT = x"00"
					else '1';
    	-- Instantiate alu	  
    	 UAL : alu PORT MAP (
             A => B_DIEX_OUT,
             B => C_DIEX_OUT,
             Ctrl_Alu =>Ctr_AlU_LC,
             N => N_ALU_OUT,
             O => O_ALU_OUT,
             Z => Z_ALU_OUT,
             C => C_ALU_OUT,
             S => S_IN_MUX
            );
    	
    	B_EXMem_IN <= S_IN_MUX when OP_DIEX_OUT = x"01" or OP_DIEX_OUT = x"02" or OP_DIEX_OUT = x"03" else 
    						B_DIEX_OUT ;
    						
    						
    	-- Instantiate pipeline EX_Mem
    	EX_Mem : pipeline PORT MAP (
    			OP_IN => OP_DIEX_OUT,
               A_IN => A_DIEX_OUT,
               B_IN => B_EXMem_IN,
               C_IN => x"00",
    			  CLK => CLK,
				  EN => '1',
    			  A_OUT => A_EXMem_OUT,
    			  B_OUT => B_EXMem_OUT,
    			  C_OUT => open,
    			  OP_OUT => OP_EXMem_OUT
               );
    			
    	RW_LC <= '0' when OP_EXMem_OUT = x"08" else 
    						'1';
    	addr_dm_MUX <= B_EXMem_OUT when OP_EXMem_OUT = x"07" else
    						A_EXMem_OUT;
    	in_dm_MUX <= B_EXMem_OUT when OP_EXMem_OUT = x"08"; 
    	B_MemRE_IN <= out_dm_MUX when OP_EXMem_OUT = x"07" else
    						B_EXMem_OUT;
							
		-- alea ex_mem
		ex_mem_w_a <= '0' when OP_DIEX_OUT = x"08" or OP_DIEX_OUT = x"00"
				else '1';
    	-- Instantiate banc de données
       data_memory: bm_data PORT MAP (
              IN_addr => addr_dm_MUX,
              IN_data => B_EXMem_OUT,
              RW => RW_LC,
              RST => RST,
              CLK => CLK,
              OUT_data => out_dm_MUX 
            );
    	
    	-- Instantiate pipeline Mem_RE
    	Mem_RE : pipeline PORT MAP (
    			OP_IN => OP_EXMem_OUT,
               A_IN => A_EXMem_OUT,
               B_IN => B_MemRE_IN,
               C_IN => x"00",
    			  CLK => CLK,
				  EN => '1',
    			  A_OUT => A_MemRE_OUT,
    			  B_OUT => B_MemRE_OUT,
    			  C_OUT => open,
    			  OP_OUT => OP_MemRE_OUT
               );
					
		alea <= '0' when (li_di_r_b = '1' and di_ex_w_a = '1' and OUT_data(15 downto 8) = A_LIDI_OUT) or
						  (li_di_r_c = '1' and di_ex_w_a = '1' and OUT_data(7 downto 0) = A_LIDI_OUT) or
						  (li_di_r_b = '1' and ex_mem_w_a = '1' and OUT_data(15 downto 8) = A_DIEX_OUT) or
						  (li_di_r_c = '1' and ex_mem_w_a = '1' and OUT_data(7 downto 0) = A_DIEX_OUT) or
						   (store_load = '1' and  OUT_data(15 downto 8) = A_LIDI_OUT) else
						  '1';
	
    	process
		begin
			wait until rising_edge(CLK);
			if rst = '0' then
				IP <= x"00";
			else
				if alea = '1' then
					IP <= IP + "00000001";
				end if;
			end if;
		end process;
    	
    end Behavioral;
