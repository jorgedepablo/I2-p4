package body Ordered_Maps_G is

   procedure Get (M : Map; Key : in  Key_Type; Value : out Value_Type;
                  Success : out Boolean) is
      P_Aux : Cell_Array := M.P_Array;
      I : Natural := M.Length/2;
   begin
      Success := False;
      if M.Length > 0 then

         if Key = P_Aux(I).Key then
            Success := True;
            Value := P_Aux(I).Value;
         end if;

         if Key < P_Aux(I).Key then
            while I > 1 or not Success loop
               if Key = P_Aux(I).Key then
                  Success := True;
                  Value := P_Aux(I).Value;
               end if;
               I := I - 1;
            end loop;
         else
            while I < M.Length or not Success loop
               if Key = P_Aux(I).Key then
                  Success := True;
                  Value := P_Aux(I).Value;
               end if;
               I := I + 1;
            end loop;
         end if;

      end if;
   end Get;

   procedure Put (M : in out Map; Key : Key_Type; Value : Value_Type) is
      P_Aux : Cell_Array := M.P_Array;
      I : Natural := (M.Length/2) + 1;
      K : Natural := M.Length;
   begin
      if M.Length = Max then
         raise Full_Map;
      elsif M.Length = 0 then
         P_Aux(1).Key := Key;
         P_Aux(1).Value := Value;
         M.Length := 1;
      else

         if Key = P_Aux(I).Key then
            M.P_Array(I).Value := P_Aux(I).Value;
         elsif Key < P_Aux(I).Key then
            while Key < P_Aux(I).Key and I >= 0 loop
               if P_Aux(I).Key = Key then
                  M.P_Array(I).Value := P_Aux(I).Value;
               end  if;
               I := I - 1;
            end loop;
         else
            while P_Aux(I).Key < Key and I <= M.Length loop
               if P_Aux(I).Key = Key then
                  M.P_Array(I).Value := P_Aux(I).Value;
               end if;
               I := I - 1;
            end loop;
         end if;

         while K > I loop
            P_Aux(K + 1).Key := P_Aux(K).Key;
            P_Aux(K + 1).Value := P_Aux(K).Value;
            K := K - 1;
         end loop;

         P_Aux(I + 1).Key := Key;
         P_Aux(I + 1).Value := Value;
         M.Length := M.Length + 1;

      end if;
   end Put;

   procedure Delete (M : in out Map; Key : in  Key_Type;
                      Success : out Boolean) is
      P_Aux : Cell_Array := M.P_Array;
      I : Natural := (M.Length/2) + 1;
   begin
      Success := False;
      if M.Length > 0 then
         if Key = P_Aux(I).Key then
            Success := True;
            I := I + 1;
         elsif Key < P_Aux(I).Key then
            while Key < P_Aux(I).Key and I >= 1 loop
               I := I - 1;
               if P_Aux(I).Key = Key then
                  Success := True;
               end if;
            end loop;
         else
            while P_Aux(I).Key < Key and I <= M.Length loop
               I := I + 1;
               if P_Aux(I).Key = Key then
                  Success := True;
               end if;
            end loop;
         end if;
      end if;

      if Success then
         while I <= M.Length loop
            P_Aux(I - 1).Key := P_Aux(I).Key;
            P_Aux(I - 1).Value := P_Aux(I).Value;
            I := I + 1;
         end loop;

         M.Length := M.Length - 1;
         M.P_Array := P_Aux;
      end if;
   end Delete;

   function Map_Length (M : Map) return Natural is
   begin
      return M.Length;
   end Map_Length;

   function First (M : Map) return Cursor is
   begin
      return (Pos => 1, M => M);
   end First;

   procedure Next (C : in out Cursor) is
   begin
       C.Pos := C.Pos + 1;
   end Next;

   function Has_Element (C : Cursor) return Boolean is
   begin
      return C.Pos <= C.M.Length;
   end Has_Element;

   function Element (C: Cursor) return Element_Type is
   begin
      if C.Pos > C.M.Length then
         raise No_Element;
      end if;

      return (Key => C.M.P_Array(C.Pos).Key,
               Value => C.M.P_Array(C.Pos).Value);
   end Element;

end Ordered_Maps_G;
