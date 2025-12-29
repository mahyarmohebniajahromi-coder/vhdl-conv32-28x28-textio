library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library STD;
use STD.TEXTIO.ALL;

entity Conv32Writeout is
Port ( 
           clk : in STD_LOGIC;
           reset : in std_logic;
           end_file : in std_logic;
           write_address : in Integer;
           data_out : in STD_LOGIC_VECTOR(24 downto 0)
           );
end Conv32Writeout;

architecture Behavioral of Conv32Writeout is
signal data_write : bit_vector (24 downto 0);
file output_file : text;
	 type file_array is array (0 to 31) of string(1 to 64);
	 constant filenames : file_array := (
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata01.txt",
	                              "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata02.txt",
	                              "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata03.txt",
	                              "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata04.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata05.txt",
	                              "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata06.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata07.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata08.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata09.txt",
	                              "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata10.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata11.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata12.txt",
	                              "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata13.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata14.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata15.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata16.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata17.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata18.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata19.txt",
	                              "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata20.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata21.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata22.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata23.txt",
	                              "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata24.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata25.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata26.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata27.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata28.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata29.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata30.txt",
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata31.txt",	       
	                               "C:\\Users\\Mahyar\\Desktop\\CNN OutPut\\Conv32\\outputdata32.txt"
	                               
                                    );
                                    
Signal write_add : integer:=0;
                                    
begin

data_write <= to_bitvector(data_out);

write_add <= write_address;

file_open(output_file,filenames(write_add), write_mode);

Writing_process : process (clk,end_file)
        variable line : line;
    begin
    if reset = '1' then 
        file_open(output_file,filenames(write_add), write_mode);
    else 
        if end_file = '1' then
                file_close(output_file);
       else
             if rising_edge(clk) then
             if ( data_out(1) /= 'U') then
                write(line, data_write);
                writeline(output_file, line);
            end if;        
            end if;
        end if;
       end if;
    end process;

end Behavioral;
