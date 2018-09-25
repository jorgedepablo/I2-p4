with Ada.Unchecked_Deallocation;
with Ada.Text_IO;

package body Hash_Maps_G is

	procedure Free is new Ada.Unchecked_Deallocation (Cell, P_Cell);

   	procedure Get (M       : Map;
                  Key     : in  Key_Type;
                  Value   : out Value_Type;
                  Success : out Boolean) is
		P_Aux: P_Cell;
	begin
		Success :=False;
		P_Aux:=M.List(Hash(Key));
		while P_Aux /= null loop
			if P_Aux.Key = Key then
				Value := P_Aux.Value;
				Success :=True;
				return;
			else
				P_Aux:=P_Aux.Next;
			end if;
		end loop;
	end Get;

   	procedure Put (M     : in out Map;
                  Key   : Key_Type;
                  Value : Value_Type) is
		P_Aux: P_Cell;
	begin
	
		P_Aux:=M.List(Hash(Key));
		while P_Aux /= null loop
			if P_Aux.Key = Key then
				P_Aux.Value := Value;
				return;
			else
				P_Aux:=P_Aux.Next;
			end if;
		end loop;
		
		
		if M.Length = Max then
			raise Full_Map;
		else
			M.List(Hash(Key)):= new Cell' (Key, Value, M.List(Hash(Key)));
			if M.Length < 0 then
				M.Length:=0;
			end if;
			M.Length:=M.Length+1;
		end if;
	end Put;

   	procedure Delete (M      : in out Map;
                     Key     : in  Key_Type;
                     Success : out Boolean) is
		P_Prev: P_Cell;
		P_Aux: P_Cell;
	begin
		P_Aux:=M.List(Hash(Key));
		P_Prev:=null;
		Success:=False;
		while P_Aux /= null loop
			if P_Aux.Key = Key then
				if P_Prev /= null then
					P_Prev.Next := P_Aux.Next;
				end if;
				if M.List(Hash(Key))= P_Aux then
					M.List(Hash(Key)):=P_Aux.Next;
				end if;
				Free(P_Aux);
				Success:=True;
				M.Length:=M.Length-1;
			else
				P_Prev:=P_Aux;
				P_Aux := P_Aux.Next;
			end if;
		end loop;
	end Delete;

   	function Map_Length (M : Map) return Natural is
	begin
		return M.Length;
	end Map_Length;


   	function First (M: Map) return Cursor is
   		Aux:Cursor;
	begin
		Aux.P:=null;
		Aux.Line := Hash_Range'First;
		while Aux.P = null loop
			Aux.P := M.List(Aux.Line);
			Aux.Line := Aux.Line+1;
		end loop;
		Aux.Line := Aux.Line-1;
		Aux.List := M.List;
		return Aux;
	end First;

   	procedure Next (C: in out Cursor) is
	begin
		if C.P.Next /= null or C.Line = Hash_Range'Last then
			C.P:=C.P.Next;			
		elsif C.Line < Hash_Range'Last then
			loop
				C.Line := C.Line +1;
				C.P := C.List(C.Line);
			exit when C.P /= null or C.Line = Hash_Range'Last;
			end loop;
		end if;
	end Next;
			
			
   	function Has_Element (C: Cursor) return Boolean is
	begin
		return C.P /= null;
	end Has_Element;


   	function Element (C: Cursor) return Element_Type is
	begin
		if C.P /= null then
         	return (Key   => C.P.Key,
                 	Value => C.P.Value);
     	else
        	raise No_Element;
      	end if;
	end Element;

end Hash_Maps_G;
