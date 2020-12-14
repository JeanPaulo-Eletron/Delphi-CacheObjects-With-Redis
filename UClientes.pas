unit UClientes;

interface

uses Classes, SysUtils, UObjectFile, Redis.Client, Redis.NetLib.INDY, Redis.Commons, REST.Json, StrUtils;

type
  TClientes = class
  private
    FNome:  String;
    FIdade: String;
    FNomeVariavel: String;
  public
    constructor Create(NomeVariavel: String);overload;
    //Caso queira cadastrar um  cliente novo, ou seja que não existe ainda no Redis, já salvando ele no redis, sem precisar se preocupar com o nome
    constructor Create(RedisClient: IRedisClient);overload;
    property NomeVariavel:  String read FNomeVariavel  write FNomeVariavel;
    property Nome:  String read FNome  write FNome;
    property Idade: String read FIdade write FIdade;
    function SaveFromRedis(RedisClient: IRedisClient):Boolean;
    function LoadFromRedis(NomeVariavel: String; RedisClient: IRedisClient): TClientes; Overload;
    function LoadFromRedis(RedisClient: IRedisClient):  System.TArray<TClientes>;  Overload;
    function DiscardRedis(NomeVariavel: String; RedisClient: IRedisClient): Boolean;
  end;

implementation

constructor TClientes.Create(NomeVariavel: String);
begin
  Self.NomeVariavel := NomeVariavel;
end;

//Caso queira cadastrar um  cliente novo, ou seja que não existe ainda no Redis, já salvando ele no redis, sem precisar se preocupar com o nome
constructor TClientes.Create(RedisClient: IRedisClient);
begin
  if not RedisClient.EXISTS('QtdeOfClientes')
    then RedisClient.&SET('QtdeOfClientes','1')
    else RedisClient.&SET('QtdeOfClientes', IntToStr(StrToInt(RedisClient.GET('QtdeOfClientes'))+1) );
  Create('Cliente'+RedisClient.GET('QtdeOfClientes'));
  SaveFromRedis(RedisClient);
end;

function TClientes.SaveFromRedis(RedisClient: IRedisClient): Boolean;
var
  ListaDeClientes: String;
begin
  Result := False;
  Try
    RedisClient.&SET(NomeVariavel, TJson.ObjectToJsonString(Self));
    if RedisClient.EXISTS('ListOfClientes')
      then ListaDeClientes := StringReplace(RedisClient.GET('ListOfClientes'), NomeVariavel+';', '', []);
    ListaDeClientes := ListaDeClientes + NomeVariavel + ';';
    RedisClient.&SET('ListOfClientes', ListaDeClientes);
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
var NomesVariaveisClientes: System.TArray<System.string>;
    NomeVariavelCliente : System.string;
begin
  Result := [];
  NomesVariaveisClientes := SplitString(RedisClient.GET('ListOfClientes'), ';');
  SetLength(NomesVariaveisClientes, Length(NomesVariaveisClientes) - 1);
  for NomeVariavelCliente in NomesVariaveisClientes do begin
    Result := Result + [LoadFromRedis(NomeVariavelCliente, RedisClient)];
  end;
end;

function TClientes.DiscardRedis(NomeVariavel: String; RedisClient: IRedisClient): Boolean;
var
  ListaDeClientes: String;
begin
  Result := False;
  Try
    RedisClient.&SET(NomeVariavel, TJson.ObjectToJsonString(Self));
    if RedisClient.EXISTS('ListOfClientes')
      then ListaDeClientes := StringReplace(RedisClient.GET('ListOfClientes'), NomeVariavel+';', '', []);
    RedisClient.&SET('ListOfClientes', ListaDeClientes);
    Result := True;
  Finally
  End;
end;

end.
