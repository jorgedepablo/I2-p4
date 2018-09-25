with Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;

package body Hash_Maps_G is

   package ASU renames Ada.Strings.Unbounded;

   procedure Free is new Ada.Unchecked_Deallocation (Cell, Cell_A);

   procedure Get (M : in out Map; Key : in Key_Type; Value : out Value_Type;
                  Success : out Boolean) is
      i : Hash_Range := Hash_Range'Mod(0);
      P_Aux : Cell_A;
   begin
      i := Hash (Key);
      P_Aux := M.H_Array(i).P_First;
      Success := False;

      while not Success and P_Aux /= null loop
         if P_Aux.Key = Key then
            Value := P_Aux.Value;
            Success := True;
         else
            P_Aux := P_Aux.Next;
         end if;
      end loop;
   end Get;

   procedure Put (M : in out Map; Key : Key_Type; Value : Value_Type) is
      i : Hash_Range := Hash_Range'Mod(0);
      P_Aux : Cell_A;
      P_Last : Cell_A;
      Found : Boolean := False;
   begin
      i := Hash (Key);
      P_Aux := M.H_Array(i).P_First;

      while not Found and P_Aux /= null loop
         if M.H_Array(i).P_First.Key = Key then
            M.H_Array(i).P_First.Value := Value;
            Found := True;
         else
            P_Aux := P_Aux.Next;
         end if;
      end loop;

      if not Found then
         if M.H_Array(i).P_First = null then
            M.H_Array(i).P_First := new Cell'(Key, Value, null);
            M.H_Array(i).Length := M.H_Array(i).Length + 1;
         else
            P_Last := M.H_Array(i).P_First;
            while P_Last.Next /= null loop
               P_Last := P_Last.Next;
            end loop;

            P_Aux := new Cell'(Key, Value, null);
            P_Last.Next := P_Aux;
            M.H_Array(i).Length := M.H_Array(i).Length + 1;
         end if;
      else
         raise Full_Map;
      end if;
   end Put;

   procedure Delete (M : in out Map; Key : in Key_Type; Success : out Boolean) is
      i : Hash_Range := Hash_Range'Mod(0);
      P_Current : Cell_A;
      P_Previus : Cell_A;
   begin
      i := Hash (Key);
      Success := False;
      P_Current := M.H_Array(i).P_First;
      P_Previus := null;

      while not Success and P_Current /= null loop
         if P_Current.Key = Key then
            Success := True;
            if P_Previus /= null then
               P_Previus.Next := P_Current.Next;
            end if;
            if M.H_Array(i).P_First = P_Current then
               M.H_Array(i).P_First := M.H_Array(i).P_First.Next;
            end if;
            Free (P_Current);
            M.H_Array(i).Length := M.H_Array(i).Length - 1;
         else
            P_Previus := P_Current;
            P_Current := P_Current.Next;
         end if;
      end loop;
   end Delete;

   function Map_Length (M : Map) return Natural is
   begin
      return M.Length;
   end Map_Length;

   function First (M : Map) return Cursor is
      i : Hash_Range := Hash_Range'Mod(0);
      Found : Boolean := False;
   begin
      while not Found loop
         if M.H_Array(i).Length /= 0 then
            Found := True;
         else
            i := i + 1;
         end if;
      end loop;

      return (M => M , Element_A => M.H_Array(i).P_First);
   end First;

   procedure Next (C : in out Cursor) is
      i : Hash_Range := Hash_Range'Mod(0);
      P_Aux : Cell_A := C.Element_A;
      Found : Boolean := False;
   begin
      if C.Element_A = null then
         i := i + 1;
         while not Found loop
            if C.M.H_Array(i).Length = 0 then
               i := i + 1;
            else
               Found := True;
            end if;
         end loop;
         C.Element_A := C.M.H_Array(i).P_First;
      else
         C.Element_A := C.Element_A.Next;
      end if;
   end Next;

   function Has_Element (C : Cursor) return Boolean is
   begin
      if C.Element_A = null then
         return False;
      else
         return True;
      end if;
   end Has_Element;

   function Element (C : Cursor) return Element_Type is
   begin
      if C.Element_A /= null then
         return (Key => C.Element_A.Key, Value => C.Element_A.Value);
      else
         raise No_Element;
      end if;
   end Element;

end Hash_Maps_G;
