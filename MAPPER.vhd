----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:22:57 03/06/2023 
-- Design Name: 
-- Module Name:    MAPPER - RTL 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MAPPER is
	port(
		INPUT_CFG : in std_logic_vector(2 downto 0);
		INPUT_A15_A11 : in std_logic_vector(4 downto 0);
		INPUT_DATA : in std_logic_vector(6 downto 0);
		INPUT_SLT : in std_logic;
		INPUT_RD : in std_logic;
		INPUT_WR : in std_logic;
		INPUT_RST : in std_logic;
		OUTPUT_A19_A13 : out std_logic_vector(6 downto 0)
	);
	attribute pin_assign : string;
	attribute pin_assign of INPUT_CFG : signal is "43,42,40";
	attribute pin_assign of INPUT_A15_A11 : signal is "22,20,19,18,14";
	attribute pin_assign of INPUT_DATA : signal is "33,29,28,27,26,25,24";
	attribute pin_assign of INPUT_SLT : signal is "36";
	attribute pin_assign of INPUT_RD : signal is "37";
	attribute pin_assign of INPUT_WR : signal is "38";
	attribute pin_assign of INPUT_RST : signal is "39";
	attribute pin_assign of OUTPUT_A19_A13 : signal is "7,6,5,4,3,2,1";
end MAPPER;

architecture RTL of MAPPER is
	signal CLK_PAGE0 : std_logic := '0';
	signal CLK_PAGE1 : std_logic := '0';
	signal CLK_PAGE2 : std_logic := '0';
	signal CLK_PAGE3 : std_logic := '0';

	signal INI_PAGE0 : std_logic_vector(6 downto 0) := "0000000";
	signal INI_PAGE1 : std_logic_vector(6 downto 0) := "0000000";
	signal INI_PAGE2 : std_logic_vector(6 downto 0) := "0000000";
	signal INI_PAGE3 : std_logic_vector(6 downto 0) := "0000000";

	signal REG_PAGE0 : std_logic_vector(6 downto 0) := "0000000";
	signal REG_PAGE1 : std_logic_vector(6 downto 0) := "0000000";
	signal REG_PAGE2 : std_logic_vector(6 downto 0) := "0000000";
	signal REG_PAGE3 : std_logic_vector(6 downto 0) := "0000000";
begin
	process(INPUT_CFG, INPUT_A15_A11, INPUT_DATA, INPUT_SLT, INPUT_RD, INPUT_WR, INPUT_RST, REG_PAGE0, REG_PAGE1, REG_PAGE2, REG_PAGE3)
	begin
		case INPUT_CFG is
			when "000" => -- nomap
				INI_PAGE0 <= "XXXXXXX";
				INI_PAGE1 <= "XXXXXXX";
				INI_PAGE2 <= "XXXXXXX";
				INI_PAGE3 <= "XXXXXXX";

				CLK_PAGE0 <= '0';
				CLK_PAGE1 <= '0';
				CLK_PAGE2 <= '0';
				CLK_PAGE3 <= '0';

				OUTPUT_A19_A13 <= "0000" & INPUT_A15_A11(4 downto 2);
			when "001" => -- ASCII 8kB
				INI_PAGE0 <= "0000000";
				INI_PAGE1 <= "0000000";
				INI_PAGE2 <= "0000000";
				INI_PAGE3 <= "0000000";

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11="01100" then -- WR 6000-67ff
					CLK_PAGE0 <= '1';
				else
					CLK_PAGE0 <= '0';
				end if;

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11="01101" then -- WR 6800-6fff
					CLK_PAGE1 <= '1';
				else
					CLK_PAGE1 <= '0';
				end if;

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11="01110" then -- WR 7000-77ff
					CLK_PAGE2 <= '1';
				else
					CLK_PAGE2 <= '0';
				end if;

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11="01111" then -- WR 7800-7fff
					CLK_PAGE3 <= '1';
				else
					CLK_PAGE3 <= '0';
				end if;

				if INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 2)="010" then -- RD 4000-5fff
					OUTPUT_A19_A13 <= REG_PAGE0;
				elsif INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 2)="011" then -- RD 6000-7fff
					OUTPUT_A19_A13 <= REG_PAGE1;
				elsif INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 2)="100" then -- RD 8000-9fff
					OUTPUT_A19_A13 <= REG_PAGE2;
				elsif INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 2)="101" then -- RD a000-bfff
					OUTPUT_A19_A13 <= REG_PAGE3;
				else
					OUTPUT_A19_A13 <= "XXXXXXX";
				end if;
			when "010" => -- ASCII 16kB
				INI_PAGE0 <= "0000000";
				INI_PAGE1 <= "0000000";
				INI_PAGE2 <= "XXXXXXX";
				INI_PAGE3 <= "XXXXXXX";

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11="01100" then -- WR 6000-67ff
					CLK_PAGE0 <= '1';
				else
					CLK_PAGE0 <= '0';
				end if;

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11="01110" then -- WR 7000-77ff
					CLK_PAGE1 <= '1';
				else
					CLK_PAGE1 <= '0';
				end if;

				CLK_PAGE2 <= '0';
				CLK_PAGE3 <= '0';

				if INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 3)="01" then -- RD 4000-7fff
					OUTPUT_A19_A13(6 downto 1) <= REG_PAGE0(5 downto 0);
				elsif INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 3)="10" then -- RD 8000-bfff
					OUTPUT_A19_A13(6 downto 1) <= REG_PAGE1(5 downto 0);
				else
					OUTPUT_A19_A13(6 downto 1) <= "XXXXXX";
				end if;

				OUTPUT_A19_A13(0) <= INPUT_A15_A11(2);
			when "011" => -- KONAMI 8kB (without SCC)
				INI_PAGE0 <= "0000000";
				INI_PAGE1 <= "0000001";
				INI_PAGE2 <= "XXXXXXX";
				INI_PAGE3 <= "XXXXXXX";

				CLK_PAGE0 <= '0';

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11(4 downto 2)="011" then -- WR 6000-7fff
					CLK_PAGE1 <= '1';
				else
					CLK_PAGE1 <= '0';
				end if;

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11(4 downto 2)="100" then -- WR 8000-9fff
					CLK_PAGE2 <= '1';
				else
					CLK_PAGE2 <= '0';
				end if;

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11(4 downto 2)="101" then -- WR a000-bfff
					CLK_PAGE3 <= '1';
				else
					CLK_PAGE3 <= '0';
				end if;

				if INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 2)="010" then -- RD 4000-5fff
					OUTPUT_A19_A13 <= INI_PAGE0;
				elsif INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 2)="011" then -- RD 6000-7fff
					OUTPUT_A19_A13 <= REG_PAGE1;
				elsif INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 2)="100" then -- RD 8000-9fff
					OUTPUT_A19_A13 <= REG_PAGE2;
				elsif INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 2)="101" then -- RD a000-bfff
					OUTPUT_A19_A13 <= REG_PAGE3;
				else
					OUTPUT_A19_A13 <= "XXXXXXX";
				end if;
			when others => -- R-Type
				INI_PAGE0 <= "0010111"; -- 0x17
				INI_PAGE1 <= "0000000";
				INI_PAGE2 <= "XXXXXXX";
				INI_PAGE3 <= "XXXXXXX";

				CLK_PAGE0 <= '0';

				if INPUT_SLT='0' and INPUT_WR='0' and INPUT_A15_A11="01110" then -- WR 7000-77ff
					CLK_PAGE1 <= '1';
				else
					CLK_PAGE1 <= '0';
				end if;

				CLK_PAGE2 <= '0';
				CLK_PAGE3 <= '0';

				if INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 3)="01" then -- RD 4000-7fff
					OUTPUT_A19_A13(6 downto 1) <= REG_PAGE0(5 downto 0);
				elsif INPUT_SLT='0' and INPUT_RD='0' and INPUT_A15_A11(4 downto 3)="10" then -- RD 8000-bfff
					if REG_PAGE1(4)='1' then -- (value & 0x10) ?
						OUTPUT_A19_A13(6 downto 1) <= REG_PAGE1(5 downto 0) and "010111"; -- value & 0x17
					else
						OUTPUT_A19_A13(6 downto 1) <= REG_PAGE1(5 downto 0) and "001111"; -- value & 0x0f
					end if;
				else
					OUTPUT_A19_A13(6 downto 1) <= "XXXXXX";
				end if;

				OUTPUT_A19_A13(0) <= INPUT_A15_A11(2);
		end case;

		if INPUT_RST='0' then
			REG_PAGE0 <= INI_PAGE0;
		elsif CLK_PAGE0'event and CLK_PAGE0='1' then
			REG_PAGE0 <= INPUT_DATA;
		end if;

		if INPUT_RST='0' then
			REG_PAGE1 <= INI_PAGE1;
		elsif CLK_PAGE1'event and CLK_PAGE1='1' then
			REG_PAGE1 <= INPUT_DATA;
		end if;

		if INPUT_RST='0' then
			REG_PAGE2 <= INI_PAGE2;
		elsif CLK_PAGE2'event and CLK_PAGE2='1' then
			REG_PAGE2 <= INPUT_DATA;
		end if;

		if INPUT_RST='0' then
			REG_PAGE3 <= INI_PAGE3;
		elsif CLK_PAGE3'event and CLK_PAGE3='1' then
			REG_PAGE3 <= INPUT_DATA;
		end if;
	end process;
end RTL;
