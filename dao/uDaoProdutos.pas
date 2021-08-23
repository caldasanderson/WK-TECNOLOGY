unit uDaoProdutos;

interface

uses uModelProdutos, classes, DB, SysUtils, generics.defaults,
     generics.collections, Dialogs, uDM_Conexao, uDaoBaseDados,
     OraCall, DBAccess, Ora;

type
  TDaoProdutos = class(TDaoBaseDados)
  private
    FListaProdutos: TObjectList<TProdutos>;
    procedure PopularLista(Ds: TOraQuery);
  public
    constructor Create;
    destructor Destroy; override;

    function Listar() : TObjectList<TProdutos>;
    function Listar_By_Codigo(codigo:integer) : TObjectList<TProdutos>;
  end;

implementation

{ TDaoProdutos }

constructor TDaoProdutos.Create;
begin
  inherited;
  FListaProdutos := TObjectList<TProdutos>.Create;
end;

destructor TDaoProdutos.Destroy;
begin
  try
    inherited;
    if Assigned(FListaProdutos) then
      FreeAndNil(FListaProdutos);
  except
    on e: exception do
      raise Exception.Create(E.Message);
  end;
end;


function TDaoProdutos.Listar: TObjectList<TProdutos>;
var
  Sql: String;
begin
  Result := Nil;
  Sql := ' SELECT P.CODIGO, P.DESCRICAO, P.PRECO_VENDA FROM PRODUTOS P';
   Sql := Sql + '  ORDER BY P.CODIGO ';
   FQryGeral := RetornarDS(Sql);

  if not (FQryGeral.IsEmpty) then
  begin
    PopularLista(FQryGeral);
    Result := FListaProdutos;
  end;
end;



function TDaoProdutos.Listar_By_Codigo(codigo: integer): TObjectList<TProdutos>;
var
  Sql: String;
begin
  Result := Nil;
  Sql := ' SELECT P.CODIGO, P.DESCRICAO, P.PRECO_VENDA FROM PRODUTOS P';
   Sql := Sql + '  WHERE P.CODIGO ='+ inttostr(codigo) + '';
   Sql := Sql + '  ORDER BY P.CODIGO ';
   FQryGeral := RetornarDS(Sql);

  if not (FQryGeral.IsEmpty) then
  begin
    PopularLista(FQryGeral);
    Result := FListaProdutos;
  end;
end;

procedure TDaoProdutos.PopularLista(Ds: TOraQuery);
var
 I : integer;
begin
  I := 0;
  FListaProdutos.Clear;
  while not Ds.eof do
  begin
    FListaProdutos.Add(TProdutos.Create);
    FListaProdutos[I].Codigo_Produto := Ds.FieldByName('CODIGO').AsInteger;
    FListaProdutos[I].Descricao_Produto   := Ds.FieldByName('DESCRICAO').AsString;
    FListaProdutos[I].Preco_Venda   := Ds.FieldByName('PRECO_VENDA').AsFloat;
    Ds.Next;
    Inc(I);
  end;
end;

end.
