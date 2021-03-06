unit Utilitarios;

interface

uses
  System.SysUtils;

function StrToByte(const Value: String): TBytes;
function ByteToString(const Value: TBytes): String;

implementation


function StrToByte(const Value: String): TBytes;
var
    I: integer;
begin
    SetLength(Result, Length(Value));
    for I := 0 to Length(Value) - 1 do
        Result[I] := ord(Value[I + 1]) - 48;
end;

function ByteToString(const Value: TBytes): String;
var
    I: integer;
    S : String;
    Letra: char;
begin
    S := '';
    for I := Length(Value)-1 Downto 0 do
    begin
        letra := Chr(Value[I] + 48);
        S := letra + S;
    end;
    Result := S;
end;

end.
