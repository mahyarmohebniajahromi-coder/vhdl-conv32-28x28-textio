library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library STD;
use STD.TEXTIO.ALL;
use work.String_to_Vector.all;

entity Conv32File_read is
    port( 
                clk : in std_logic;
                 reset : in std_logic;
                send_data : in std_logic;
                data_over : out std_logic;
                Dataout : out std_logic_vector(7 downto 0)
            );
end Conv32File_read;

architecture Behavioral of Conv32File_read is
    
    file fptr : text;
begin
    process (clk,send_data,reset)
        variable line_buffer: LINE;
        variable pixel_data: string(8 downto 1);
    begin
    if rising_edge(clk) then
        if (reset ='1') then
             file_open(fptr, "C:\\Users\\Mahyar\\Desktop\\project\\Test\\Conv32\\image test2.txt", read_mode);
             data_over <= '0';        
        else
            if send_data ='1' then
                        if (not endfile(fptr)) then
                            readline(fptr, line_buffer);
                            read(line_buffer, pixel_data); 
                            Dataout<= Convert_String_to_Vector(pixel_data);
                            data_over <= '0';
                        else 
                            data_over <= '1';
                            Dataout <= (others =>'U');
                        end if; -- end file
                     else
                        Dataout <= (others =>'U');
                      end if;
                    end if; -- reset
                end if; --clk
    end process;

end Behavioral;

