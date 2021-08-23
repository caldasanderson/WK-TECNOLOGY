unit uDaoPedidosDadosGerais;

interface

uses uModelPedidoDadosGerais, classes, DB, SysUtils, generics.defaults,
     generics.collections, Dialogs, uDM_Conexao, uDaoBaseDados,uDaoClientes,
     uModelClientes,OraCall, DBAccess, Ora;

type
  TDaoPedidosDadosGerais = class(TDaoBaseDados)
  private
    FListaPedidosDadosGerais: TObjectList<TPedidoDadosGerais>;
    procedure PopularLista(Ds: TOraQuery);
  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(pProduto: TPedidoDadosGerais): Boolean;
    function Deletar(pProduto: TPedidoDadosGerais): Boolean;
    function Alterar(pProduto: TPedidoDadosGerais): Boolean;
    function Listar() : TObjectList<TPedidoDadosGerais>;
    function MaxNumeroPedido() : integer;
    function Listar_By_Codigo(codigo:integer) : TObjectList<TPedidoDadosGerais>;

  end;

implementation

{ TDaoPedidosDadosGerais }

function TDaoPedidosDadosGerais.Alterar(pProduto: TPedidoDadosGerais): Boolean;
begin

end;

constructor TDaoPedidosDadosGerais.Create;
begin
 inherited;
  FListaPedidosDadosGerais := TObjectList<TPedidoDadosGerais>.Create;
end;

function TDaoPedidosDadosGerais.Deletar(pProduto: TPedidoDadosGerais): Boolean;
var
  Sql: String;
begin
  Sql := ' DELETE                                '+
         '   FROM PEDIDO_DADOS_GERAIS                '+
         '  WHERE NUMERO_PEDIDO = ' + IntToStr(pProduto.Numero_Pedido);
  Result := ExecutarSql(Sql) > 0;
end;

destructor TDaoPedidosDadosGerais.Destroy;
begin
  try
    inherited;
    if Assigned(FListaPedidosDadosGerais) then
      FreeAndNil(FListaPedidosDadosGerais);
  except
    on e: exception do
      raise Exception.Create(E.Message);
  end;
end;

function TDaoPedidosDadosGerais.Inserir(pProduto: TPedidoDadosGerais): Boolean;
var
  Sql: String;
begin
  FQryGeral.sql.Text := ' INSERT INTO PEDIDO_DADOS_GERAIS (NUMERO_PEDIDO,DATA_EMISSAO, CODIGO_CLIENTE,VALOR_TOTAL) '+
         ' VALUES (' + inttostr(pProduto.Numero_Pedido) +' , '
                   + ':data , '
                   + inttostr(pProduto.Codigo_Clientes_FK.Codigo_Cliente) +' , '
                   + StringReplace(FloatToStrF(pProduto.Valor_Total,ffFixed,10,2),',','.',[rfReplaceAll])+
                   ')';

  FQryGeral.ParamByName('data').AsString := datetostr(now);
  FQryGeral.ExecSQL;
  FQryGeral.Close;

end;

function TDaoPedidosDadosGerais.Listar: TObjectList<TPedidoDadosGerais>;
begin

end;

function TDaoPedidosDadosGerais.Listar_By_Codigo(
  codigo: integer): TObjectList<TPedidoDadosGerais>;
var
  Sql: String;
begin
   Result := Nil;
   Sql := ' SELECT P.* FROM PEDIDO_DADOS_GERAIS P';
   Sql := Sql + '  WHERE P.NUMERO_PEDIDO = '+ inttostr(codigo) + '';
   Sql := Sql + '  ORDER BY P.NUMERO_PEDIDO ';
   FQryGeral := RetornarDS(Sql);

  if not (FQryGeral.IsEmpty) then
  begin
    PopularLista(FQryGeral);
    Result := FListaPedidosDadosGerais;
  end;
end;
function TDaoPedidosDadosGerais.MaxNumeroPedido: integer;
var
  Sql: String;
begin
  Result := 0;
  Sql := ' SELECT max(P.numero_pedido) as numero_pedido'+
           ' FROM '+
           ' PEDIDO_DADOS_GERAIS P ';

   Sql := Sql;
   FQryGeral := RetornarDS(Sql);

  if not (FQryGeral.IsEmpty) then
  begin
    Result := FQryGeral.FieldByName('numero_pedido').AsInteger;
  end;
end;

procedure TDaoPedidosDadosGerais.PopularLista(Ds: TOraQuery);
var
 I : integer;
begin
  I := 0;
  FListaPedidosDadosGerais.Clear;
  while not Ds.eof do
  begin
    FListaPedidosDadosGerais.Add(TPedidoDadosGerais.Create);
    FListaPedidosDadosGerais[I].Numero_Pedido := Ds.FieldByName('numero_pedido').AsInteger;
    FListaPedidosDadosGerais[I].Codigo_Clientes_FK.Codigo_Cliente   := Ds.FieldByName('codigo_cliente').AsInteger;
    FListaPedidosDadosGerais[I].Valor_Total   := Ds.FieldByName('Valor_TOTAL').AsFloat;
    Ds.Next;
    Inc(I);
  end;
end;

end.
