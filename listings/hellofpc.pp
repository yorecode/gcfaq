(*-
  Author: Brian Tiffin
  Dedicated to the public domain

  Date started: February 2017
  Modified: 2017-02-07/16:36-0500 btiffin
+*)
(* HelloFpc, module called from GnuCOBOL *)
(* Tectonics: fpc -CD hellofpc.pp *)
library hellofpc;

function HelloFpc(DataIn: Integer): Integer; cdecl;

    begin
        WriteLn('Hello, world');
        WriteLn('DataIn: ', DataIn);
        HelloFpc := DataIn * 2;
    end;

    exports
        HelloFpc;
end.
