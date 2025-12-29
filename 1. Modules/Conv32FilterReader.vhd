library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library STD;
use STD.TEXTIO.ALL;
use work.String_to_Vector.all;

entity Conv32FilterReader is
 port( 
                clk : in std_logic;
                reset : in std_logic;
                send_data : in std_logic;
                end_filter : out std_logic;
                Dataout : out std_logic_vector(20 downto 0)
            );
end Conv32FilterReader;

architecture Behavioral of Conv32FilterReader is

     file fptr : text;
	 
begin
        file_open(fptr,  "C:\\Users\\Mahyar\\Desktop\\project\\new106\\conv32_weights106binary.txt", read_mode);


    process (clk)
        variable line_buffer: LINE;
        variable pixel_data: string(21 downto 1);
    begin
       if (reset ='0') then
            if rising_edge(clk) then
                if (send_data ='1') then
                if not endfile(fptr) then
                    end_filter <= '0';
                   readline(fptr, line_buffer); 
                   read(line_buffer, pixel_data); 

                   Dataout<= Convert_String_to_Vector(pixel_data);
               else 
                    end_filter <= '1';
                    Dataout <=  (others => 'U');   
              end if; 
              else 
                    Dataout <=  (others => 'U');       
                end if;-- send data
             end if; -- clk
             end if;
        end process;
    

end Behavioral;
