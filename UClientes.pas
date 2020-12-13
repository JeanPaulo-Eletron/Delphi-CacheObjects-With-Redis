unit UClientes;

interface

uses Classes, SysUtils, UObjectFile;

type
  TClientes = class
  private
    FNome:  String;
    FIdade: String;
  public
    //[JSONMarshalled(True)] [JSonName('NomeField')]
    property Nome:  String read FNome  write FNome;
    property Idade: String read FIdade write FIdade;
  end;

implementation

{ TClientes }

end.
