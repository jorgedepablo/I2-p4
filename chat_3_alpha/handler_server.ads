with Lower_Layer_UDP;
with Hash_Maps_G;
with Ordered_Maps_G;
with Ada.Strings.Unbounded;
with Ada.Calendar;
with Gnat.Calendar;
with Gnat.Calendar.Time_IO;
with Ada.Command_Line;

package Handler_Server is

   package LLU renames Lower_Layer_UDP;
   package ASU renames Ada.Strings.Unbounded;
   package ACL renames Ada.Command_Line;

   type AC_Value is record
      EP : LLU.End_Point_Type;
      Hour : Ada.Calendar.Time;
   end record;

   use type Ada.Calendar.Time;

   package Old_Clients is new Ordered_Maps_G (Key_Type => ASU.Unbounded_String,
                                       Value_Type => Ada.Calendar.Time,
                                       "=" => ASU."=",
                                       "<" => ASU."<",
					                        Max => 150);
   package OC renames Old_Clients;

   Disconnected_Clients : Old_Clients.Map;

   procedure Server_Handler (From : in LLU.End_Point_Type;
                              To : in LLU.End_Point_Type;
                              P_Buffer: access LLU.Buffer_Type);
   procedure Show_Active_Clients;

   procedure Show_Old_Clients;

end Handler_Server;
