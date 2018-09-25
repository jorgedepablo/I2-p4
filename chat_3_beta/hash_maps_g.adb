with Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;

package body Hash_Maps_G is

   package ASU renames Ada.Strings.Unbounded;

   procedure Free is new Ada.Unchecked_Deallocation (Cell, Cell_A);

   procedure Get (M : in out Map; Key : in Key_Type; Value : out Value_Type;
                  Success : out Boolean) is
      P_Aux : Cell_A;
   begin
      P_Aux := M.H_Array (Hash(Key));
      Success := False;

      while not Success and P_Aux /= null loop
         if P_Aux.Key = Key then
            Value := P_Aux.Value;
            Success := True;
         end if;
         P_Aux := P_Aux.Next;
      end loop;
   end Get;

   procedure Put (M : in out Map; Key : Key_Type; Value : Value_Type) is
      P_Aux : Cell_A;
      Found : Boolean := False;
   begin
      P_Aux := M.H_Array (Hash(Key));

      while not Found and P_Aux /= null loop
         if P_Aux.Key = Key then
            P_Aux.Value := Value;
            Found := True;
         end if;
         P_Aux := P_Aux.Next;
      end loop;

      if not Found then
         if M.Length < Max then
            M.H_Array(Hash(Key)) := new Cell'(Key, Value, M.H_Array(Hash(Key)));
            M.Length := M.Length + 1;
         else
            raise Full_Map;
         end if;
      end if;
   end Put;

   procedure Delete (M : in out Map; Key : in Key_Type; Success : out Boolean) is
      P_Current : Cell_A;
      P_Previus : Cell_A;
   begin
      Success := False;
      P_Current := M.H_Array (Hash(Key));
      P_Previus := null;

      while not Success and P_Current /= null loop
         if P_Current.Key = Key then
            Success := True;
            if P_Previus /= null then
               P_Previus.Next := P_Current.Next;
            end if;
            if M.H_Array (Hash(Key)) = P_Current then
               M.H_Array (Hash(Key)) := P_Current.Next;
            end if;
            Free (P_Current);
            M.Length := M.Length - 1;
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
      C_Aux : Cursor;
   begin
      C_Aux.Element_A := null;
      C_Aux.Posicion := Hash_Range'First;

      while C_Aux.Element_A = null loop
         C_Aux.Element_A := M.H_Array (C_Aux.Posicion);
         C_Aux.Posicion := C_Aux.Posicion + 1;
      end loop;

      C_Aux.Posicion := C_Aux.Posicion - 1;
      C_Aux.Chain := M.H_Array;

      return (C_Aux);
   end First;

   procedure Next (C : in out Cursor) is
   begin
      if C.Element_A.Next /= null then
         C.Element_A := C.Element_A.Next;
      elsif C.Posicion < Hash_Range'Last then
         loop
            C.Posicion := C.Posicion + 1;
            C.Element_A := C.Chain (C.Posicion);
            exit when C.Element_A /= null or C.Posicion = Hash_Range'Last;
         end loop;
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
