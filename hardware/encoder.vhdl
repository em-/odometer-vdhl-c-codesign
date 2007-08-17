-- File: encoder.vhdl
-- Classe:
-- Autore: Emanuele Aina <em@nerd.ocracy.org>
-- Licenza: LGPL

library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity encoder is
    port (A, B, Z: out std_logic);
end encoder;

architecture behavioral of encoder is
   type STATE is (S_00, S_10, S_11, S_01);
   type MOVEMENT is (NONE, LEFT, RIGHT);
   signal current_state: STATE;
   signal direction: MOVEMENT;
   signal tick: boolean := true; -- used only to generate events
   signal delay: time:= 1 us;
   signal finish: boolean := false;
begin

process
begin
    direction <= LEFT;
    delay <= 1 us;
    wait for 4 us;
    direction <= RIGHT;
    delay <= 2 us;
    wait for 16 us;
    finish <= true;
    wait;
end process;

process
begin
   if finish then
      wait;
   else
      wait for delay;
      tick <= not tick;
   end if;
end process;

process(tick)
begin
   case current_state is
   when S_00 =>
      if    direction = LEFT  then current_state <= S_10;
      elsif direction = RIGHT then current_state <= S_01;
      end if;

   when S_10 =>
      if    direction = LEFT  then current_state <= S_11;
      elsif direction = RIGHT then current_state <= S_00;
      end if;

   when S_11 =>
      if    direction = LEFT  then current_state <= S_01;
      elsif direction = RIGHT then current_state <= S_10;
      end if;

   when S_01 =>
      if    direction = LEFT  then current_state <= S_00;
      elsif direction = RIGHT then current_state <= S_11;
      end if;

   when others =>
       current_state <= S_00;
   end case;
end process;

process(current_state)
begin
   case current_state is
   when S_00 => A<='0'; B<='0'; Z<='1';
   when S_01 => A<='0'; B<='1'; Z<='0';
   when S_11 => A<='1'; B<='1'; Z<='0';
   when S_10 => A<='1'; B<='0'; Z<='0';
   end case;
end process;

end behavioral;
