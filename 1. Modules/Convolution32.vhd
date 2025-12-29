library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

         
entity Convolution32 is
             generic (
                                 Filter_bit_number : integer :=20;
                                 colum_number : integer := 28;
                                 input_bit_data : integer :=8
                              );            
             Port (              
                         clk                     : in std_logic ;
                         reset                 : in std_logic; 
                         image_data     : in std_logic_vector((input_bit_data-1) downto 0); 
                         Filter_data       : in std_logic_vector(Filter_bit_number downto 0);
                         bias_data         : in std_logic_vector(Filter_bit_number downto 0);
                         send_data          : out std_logic;
                         process_over     : out std_logic;
                         processing         : out std_logic;
                         Filter_recieved  : out std_logic;
                         next_bias : in std_logic;
                         output_data       : out std_logic_vector((Filter_bit_number+4) downto 0));
                         
end Convolution32;    


architecture Behavioral of Convolution32 is

constant filter_number : integer :=Filter_bit_number;
constant colnum : integer := colum_number;
constant input_data : integer := input_bit_data;
 -----------------------------------------------MEMORY ----------------------------------------------- 
 
type filter_size is array (0 to 2,0 to 2) of std_logic_vector(filter_number downto 0);
type memory is array (0 to 2,0 to (colnum-1)) of std_logic_vector((input_bit_data-1) downto 0);
type bias_memory is array (0 to 31) of std_logic_vector(filter_number downto 0);

signal cache_memory  : memory := (others => (others => (others => 'U')));
signal bias : bias_memory;
signal filter : filter_size;
 -----------------------------------------------MEMORY ----------------------------------------------- 
 -----------------------------------------------Others ----------------------------------------------- 
signal filter_recieved_signal : std_logic :='0';
signal processing_signal : std_logic;
signal shift_data_signal : std_logic := '0';
signal process_over_signal : std_logic := '0';
signal output_data_signal : std_logic_vector ((Filter_bit_number+4) downto 0);
signal bias_pointer : integer := 0;
signal output_counter : integer :=0;

begin

processing <=processing_signal;
filter_recieved <= filter_recieved_signal;
process_over <= process_over_signal;
-----------------------------------------------------------------------------------------------------------------------------------------
Filterblock : block 
    signal satr_filter : integer :=0;
    signal sotoon_filter: integer :=0;
begin

Filter_controller : process (clk, reset,Filter_data,satr_filter,sotoon_filter) 
begin
        if (reset ='1') then
                filter_recieved_signal <='0';
                satr_filter <= 0;
                sotoon_filter <=0;
        else
            if rising_edge(clk) then
                if (Filter_data(1) /= 'U')then
                if ( satr_filter =2 and sotoon_filter =1) then
                    filter_recieved_signal <= '1';
                    sotoon_filter <= sotoon_filter +1;
                elsif ( satr_filter =2 and sotoon_filter =2) then
                    filter_recieved_signal <= '1';
                elsif ( sotoon_filter = 2) then
                            satr_filter <= satr_filter +1;
                            sotoon_filter <= 0;
                            filter_recieved_signal <= '0';
                 else 
                            sotoon_filter <= sotoon_filter +1; 
                            filter_recieved_signal <= '0';
                    
                end if; -- check position
                end if;
                end if; -- clk
        end if;     --reset   

end process;


recieving_filter :    process (clk, reset,Filter_data)   begin
                                    if (reset = '1') then
                                        filter <= (others => (others => (others => 'U')));
                                    else
                                           if rising_edge(clk) then
                                                if (Filter_data /= "UUUUUUUU") then
                                                  filter (satr_filter, sotoon_filter) <= Filter_data;
                                                end if; -- data empty
                                          end if; -- clk
                                      end if; -- reset
                                        
end process;
end block Filterblock;

recieve_bias : process (clk, bias_data)
    begin
            if rising_edge (clk) then
                if bias_data(1) /= 'U' then
                    bias(31) <= bias_data;
                    for i in 31 downto 1 loop
                        bias(i-1) <= bias(i);
                    end loop;
                end if;
            end if;
    end process;

Image : block
begin

image_to_cache : process (clk,reset,shift_data_signal) 
begin  
                           
   if (reset ='1' )then
       cache_memory <= (others => (others => (others => 'U')));
   else
        if (clk = '1' and clk'event) then 
        if image_data /= "UUUUUUUU" then
            if (shift_data_signal ='1') then
              for j in 2 downto 0 loop
                     for i in (colnum-1) downto 0 loop       
                              case i is 
                                        when (colnum-1) =>
                                                           if (j=2)then
                                                                 cache_memory(2,(colnum-1)) <=image_data;
                                                           else 
                                                                 cache_memory (j , i) <= cache_memory(j+1,0);
                                                           end if;
                                        when others =>
                                                             cache_memory (j , i) <= cache_memory(j,i+1); 
                                        end case;  
                    end loop;
               end loop;  
               end if;      -- shift                                                                 
      end if; -- image data
      end if; --reset
    end if; -- clk
end process;

end block Image;

image_processing : block
signal counter1 : integer := 1;
type mem9 is array(0 to 2, 0 to 2) of signed (59 downto 0);
signal cache : mem9;

signal sum : integer:=0;
signal processing_counter : integer :=0;

begin
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
processing_controller : process (clk, reset)
begin
        if (reset ='1') then
            processing_signal <= '0';
            shift_data_signal <= '0';
            processing_counter<= 0;
        else 
            if rising_edge(clk) then
                       if  (cache_memory(0,3) = "UUUUUUUU" or cache_memory(2,(colnum-1)) = "UUUUUUUU" ) then
          
                               send_data <='1';
                               processing_signal <='0';
                               processing_counter <=0;  
                               shift_data_signal <= '1';
                     elsif  (cache_memory(0,2) = "UUUUUUUU")then
                               send_data <='1';
                               processing_signal <='0';
                               processing_counter <=0;  
                               shift_data_signal <= '1';          
                    elsif  (cache_memory(0,1) = "UUUUUUUU")then
                               send_data <='0';
                               processing_signal <='0';
                               processing_counter <=0;  
                               shift_data_signal <= '1';
                       elsif  (cache_memory(0,0) = "UUUUUUUU")then
                               processing_signal <='1';
                               processing_counter <=0;  
                               shift_data_signal <= '0';
                               send_data <='0';
                       elsif ( processing_counter <(colnum-3))then
                                send_data <= '0';
                                processing_signal <= '1';
                                shift_data_signal <= '0';
                                processing_counter <= processing_counter+1;
                                
                       elsif (processing_counter =(colnum-3)) then    
                                processing_signal <= '0';
                                shift_data_signal <= '0';
                                processing_counter <= processing_counter+1;    
                                send_data <= '1';
                                
                       elsif (processing_counter > (colnum-3) and processing_counter <((2*colnum)-3)) then
                                shift_data_signal <= '1';
                                processing_signal <= '0';
                                processing_counter <= processing_counter+1;
                                send_data <= '1';
                       elsif( processing_counter =((2*colnum)-3)) then
                                send_data <= '0';
                                processing_counter <= 0;
                                shift_data_signal <= '1';
                                processing_signal <= '1';

                        end if;
            end if; -- clk
         end if; -- reset
end process;
                                   
start_to_process_Image :   process (processing_signal,clk) 
begin
  if rising_edge(clk)then
             if  (  processing_signal ='1' )then
                   
                  if (counter1 = (colnum-2)) then
                      counter1 <= 0;
                      for i in 0 to 2 loop
                             for j in 0 to 2 loop
                                      cache(i,j) <=TO_SIGNED ( (TO_INTEGER(unsigned(cache_memory(i,counter1+j-1))))*TO_INTEGER(signed(filter(i,j)))/255,60);
                             end loop;
                       end loop;
                       counter1 <= 1;
                 else
                          counter1 <= counter1 +1;
                          for i in 0 to 2 loop
                             for j in 0 to 2 loop
                                      cache(i,j) <=TO_SIGNED ( (TO_INTEGER(unsigned(cache_memory(i,counter1+j-1)))*TO_INTEGER(signed(filter(i,j))))/255,60);
                             end loop;
                       end loop;
                 end if;  
                   
               
        else
             for i in 2 downto 0 loop
                             for j in 2 downto 0 loop
                                   cache(i,j) <= (others => 'U');
                             end loop;
                       end loop; 
        end if;
   end if;
end process;   
output_data : process (clk, cache)
begin
    if rising_edge(clk) then
        if (cache(0,0)(0) /= 'U') then
             
         ------------------- relu activation ------------------
              output_data_signal <= std_logic_vector(TO_SIGNED(TO_INTEGER(cache(0,0)+cache(0,1)+cache(0,2)+cache(1,0)+cache(1,1)+cache(1,2)+cache(2,0)+cache(2,1)+cache(2,2)+(signed(bias(bias_pointer)))),25));
        else
            output_data_signal <= (others => 'U');
            sum <= 0;
         end if;
    end if;
 end process;
end block image_processing;


bias_controll : process ( clk ,next_bias)
begin

        if (rising_edge(next_bias)) then
            if bias_pointer <31 then
                bias_pointer <= bias_pointer+1;
           end if;
        end if;
end process;

 process_over_signal <= '0' when output_data_signal(1) = 'U' else '1'; 
 output_data <=(others => '0') when output_data_signal(24)='1' else output_data_signal;



end Behavioral;
