program PJCRedis;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  UClientes in 'UClientes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
