generic
   type Key_Type is private;
   type Value_Type is private;
   with function "=" (K1, K2: Key_Type) return Boolean;
   type Hash_Range is mod <>;
   with function Hash (K:Key_Type) return Hash_Range;
	Max: in Natural;
	
package Hash_Maps_G is

   type Map is limited private;

   procedure Get (M       : Map;
                  Key     : in  Key_Type;
                  Value   : out Value_Type;
                  Success : out Boolean);


   Full_Map : exception;
   procedure Put (M     : in out Map;
                  Key   : Key_Type;
                  Value : Value_Type);

   procedure Delete (M      : in out Map;
                     Key     : in  Key_Type;
                     Success : out Boolean);


   function Map_Length (M : Map) return Natural;

   --
   -- Cursor Interface for iterating over Map elements
   --
   type Cursor is limited private;
   function First (M: Map) return Cursor;
   procedure Next (C: in out Cursor);
   function Has_Element (C: Cursor) return Boolean;
   type Element_Type is record
      Key:   Key_Type;
      Value: Value_Type;
   end record;
   No_Element: exception;

   -- Raises No_Element if Has_Element(C) = False;
   function Element (C: Cursor) return Element_Type;


private
	type Cell;
	type P_Cell is access Cell;

	type Cell is record
		Key: Key_Type;
	   	Value : Value_Type;
	    	Next  : P_Cell;
	end record;
	
	type List_Type is array (Hash_Range) of P_Cell;
	
	type Map is record
		List  : List_Type;
		Length: Natural;
	end record;
	
   	type Cursor is record
   		P   : P_Cell;
		Line : Hash_Range;
      		List	: List_Type;
   	end record;

end  Hash_Maps_G;
