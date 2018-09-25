with Ada.Strings.Unbounded;

package body Ordered_Maps_G is

   package ASU renames Ada.Strings.Unbounded;

   procedure Get (M       : Map;
                  Key     : in  Key_Type;
                  Value   : out Value_Type;
                  Success : out Boolean) is
      i : Natural := 1;
   begin
      Success := False;
      while not Success and i <= Max loop
         if M.P_Array(i).Key = Key then
            Value := M.P_Array(i).Value;
            Success := True;
         else
            i := i + 1;
         end if;
      end loop;
   end Get;

   function Free_Cell (C : Cell) return Boolean is
   begin
      if C.Full then
         return True;
      else
         return False;
      end if;
   end Free_Cell;

   function Free_Array (M : Cell_Array_A) return Boolean is
      i : Natural := 1;
      Free : Boolean := True;
   begin
      while i <= Max and Free loop
         if not M(i).Full then
            Free := False;
         else
            i := i + 1;
         end if;
      end loop;
      return Free;
   end Free_Array;

   function Set_Middle_Element (M : Map) return Cell is
      i : Natural := 1;
      Mid : Natural;
      C : Cell;
   begin
      Mid := M.Length / 2;
      while Mid > 0 and i <= Max loop
         if not M.P_Array(i).Full then
            i := i + 1;
         else
            i := i + 1;
            Mid := Mid - 1;
         end if;
      end loop;
      C := M.P_Array(i);
      return C;
   end Set_Middle_Element;

   procedure Search_Binary (M : Map) is
      Top : Natural;
      Bottom : Natural;
      Middle_Element : Cell;
   begin
      Top := Max;
      Bottom := 1;
      Middle_Element := Set_Middle_Element (M);
   end Search_Binary;

   procedure Put (M     : in out Map;
                  Key   : Key_Type;
                  Value : Value_Type) is
   begin
      null;
   end Put;

   procedure Delete (M      : in out Map;
                     Key     : in  Key_Type;
                     Success : out Boolean) is
      i : Natural := 1;
   begin
      Success := False;
      while not Success and i <= Max loop
         if M.P_Array(i).Key = Key then
            M.P_Array(i).Full := False;
            Success := True;
            M.Length := M.Length - 1;
         end if;
         i := i + 1;
      end loop;
   end Delete;

   function Map_Length (M : Map) return Natural is
   begin
      return M.Length;
   end Map_Length;

   function First (M : Map) return Cursor is
      i : Natural := 1;
      Found : Boolean := False;
   begin
      while i <= Max and not Found loop
         if M.P_Array(i).Full then
            Found := True;
         else
            i := i + 1;
         end if;
      end loop;
      if i > Max then
         i := 0;
      end if;
      return (M => M, Element => i);
   end First;

   procedure Next (C : in out Cursor) is
      Found : Boolean := False;
   begin
      C.Element := C.Element + 1;
      while not Found and C.Element <= Max loop
         if not C.M.P_Array(C.Element).Full and C.Element <= Max then
            C.Element := C.Element + 1;
         else
            Found := True;
         end if;
      end loop;
      if C.Element > Max then
         C.Element := 0;
      end if;
   end Next;

   function Has_Element (C : Cursor) return Boolean is
   begin
      if C.Element /= 0 then
         return True;
      else
         return False;
      end if;
   end Has_Element;

   function Element (C: Cursor) return Element_Type is
   begin
      if C.Element /= 0 then
         return (Key => C.M.P_Array(C.Element).Key,
                  Value => C.M.P_Array(C.Element).Value);
      else
         raise No_Element;
      end if;
   end Element;

end Ordered_Maps_G;
