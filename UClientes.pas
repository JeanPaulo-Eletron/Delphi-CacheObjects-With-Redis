unit UClientes;

interface

uses Classes, SysUtils, UObjectFile;

type
  TClientes = class
  private
    FNome: String;
  public
    //[JSONMarshalled(True)] [JSonName('NomeField')]
    property Nome: String read FNome write FNome;
  end;

implementation

{ TClientes }

end.