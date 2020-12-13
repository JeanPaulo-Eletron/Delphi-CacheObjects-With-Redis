unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Redis.Client, Redis.NetLib.INDY, Redis.Commons,
  Vcl.StdCtrls, Vcl.Buttons,  REST.Json.Types, // without this unit we get warning: W1025 Unsupported language feature: 'custom attribute'
  REST.Json, ShellAPI;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    RedisClient: IRedisClient;
    procedure CarregarClienteDeTeste;
    procedure CarregarRedis;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses UClientes, UObjectFile;

procedure TForm1.BitBtn1Click(Sender: TObject);
var Cliente1 : TClientes;
    JSon:      String;
begin
  JSon := RedisClient.GET('Clientes');
  Cliente1 := TJson.JsonToObject<TClientes>(Json);
  ShowMessage(Cliente1.Nome);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  CarregarRedis;
  CarregarClienteDeTeste;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ShellExecute(Application.Handle,
               PChar('open'),
               PChar('C:\Users\jeanp\Documents\Embarcadero\Studio\Projects\Redis\Redis\64bit\redis-server.exe'),
               PChar('C:\Users\jeanp\Documents\Embarcadero\Studio\Projects\Redis\Redis\64bit\redis.conf'),
               nil,
               SW_HIDE);
end;

procedure TForm1.CarregarClienteDeTeste;
var Cliente : TClientes;
begin
  Cliente      := TClientes.Create;
  Cliente.Nome := 'Jean Paulo Ath. De Mei';
  RedisClient.&SET('Clientes', TJson.ObjectToJsonString(Cliente));
end;

procedure TForm1.CarregarRedis;
var Cliente : TClientes;
begin
  //WinExec(PAnsiChar('C:\Users\jeanp\Documents\Embarcadero\Studio\Projects\Redis\Redis\64bit\redis-server.exe'{redis.conf}), SW_Hide);
  ShellExecute(Application.Handle,
               PChar('open'),
               PChar('C:\Users\jeanp\Documents\Embarcadero\Studio\Projects\Redis\Redis\64bit\redis-server.exe'),
               // Esse parametro serve para pegar a configura��o que salva o cache em disco
               PChar('C:\Users\jeanp\Documents\Embarcadero\Studio\Projects\Redis\Redis\64bit\redis.conf'),
               nil,
               SW_HIDE);
  RedisClient := NewRedisClient;
end;

end.