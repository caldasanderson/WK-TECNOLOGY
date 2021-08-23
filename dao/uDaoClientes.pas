unit uDaoClientes;

interface

uses uModelClientes, classes, DB, SysUtils, generics.defaults,
     generics.collections, Dialogs, uDM_Conexao, uDaoBaseDados,
     OraCall, DBAccess, Ora;

type
  TDaoClientes = class(TDaoBaseDados)
  private
    FListaClientes: TObjectList<TClientes>;
    procedure PopularLista(Ds: TOraQuery);
  public
    constructor Create;
    destructor Destroy; override;

    function Listar() : TObjectList<TClientes>;
  end;

implementation

{ TDaoClientes }


constructor TDaoClientes.Create;
begin
inherited;
FListaClientes := TObjectList<TClientes>.Create;
end;

destructor TDaoClientes.Destroy;
begin
  try
    inherited;
    if Assigned(FListaClientes) then
      FreeAndNil(FListaClientes);
  except
    on e: exception do
      raise Exception.Create(E.Message);
  end;
end;

function TDaoClientes.Listar: TObjectList<TClientes>;
var
  Sql: String;
begin
  Result := Nil;
  Sql := ' SELECT C.CODIGO, C.NOME FROM CLIENTES C';


   Sql := Sql + '  ORDER BY C.codigo ';
   FQryGeral := RetornarDS(Sql);

  if not (FQryGeral.IsEmpty) then
  begin
    PopularLista(FQryGeral);
    Result := FListaClientes;
  end;
end;

procedure TDaoClientes.PopularLista(Ds: TOraQuery);
var
 I : integer;
begin
  I := 0;
  FListaClientes.Clear;
  while not Ds.eof do
  begin
    FListaClientes.Add(TClientes.Create);
    FListaClientes[I].Codigo_Cliente := Ds.FieldByName('CODIGO').AsInteger;
    FListaClientes[I].Nome_Cliente   := Ds.FieldByName('Nome').AsString;
    Ds.Next;
    Inc(I);
  end;
end;

end.
