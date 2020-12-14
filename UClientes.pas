unit UClientes;

interface

uses Classes, SysUtils, UObjectFile, Redis.Client, Redis.NetLib.INDY, Redis.Commons, REST.Json;

type
  TClientes = class
  private
    FNome:  String;
    FIdade: String;
    FNomeVariavel: String;
  public
    //[JSONMarshalled(True)] [JSonName('NomeField')]
    constructor Create(NomeVariavel: String);
    property NomeVariavel:  String read FNomeVariavel  write FNomeVariavel;
    property Nome:  String read FNome  write FNome;
    property Idade: String read FIdade write FIdade;
    function SaveFromRedis(RedisClient: IRedisClient):Boolean;
    function LoadFromRedis(NomeVariavel: String; RedisClient: IRedisClient): TClientes; Overload;
    function LoadFromRedis(RedisClient: IRedisClient):  System.TArray<TClientes>;  Overload;
  end;

implementation

constructor TClientes.Create(NomeVariavel: String);
begin
  Self.NomeVariavel := NomeVariavel;
end;

function TClientes.SaveFromRedis(RedisClient: IRedisClient): Boolean;
begin
  Result := False;
  Try
    RedisClient.&SET(NomeVariavel, TJson.ObjectToJsonString(Self));
    Result := True;
  Finally
  End;
end;

function TClientes.LoadFromRedis(NomeVariavel: String; RedisClient: IRedisClient): TClientes;
var
  Json: String;
begin
  Try
    Json := RedisClient.GET(NomeVariavel);
    Result := TJson.JsonToObject<TClientes>(JSon);
  Finally
  End;
end;

function TClientes.LoadFromRedis(RedisClient: IRedisClient): System.TArray<TClientes>;
begin
  Result := [Self];
end;

end.
