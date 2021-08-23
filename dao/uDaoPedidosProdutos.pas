unit uDaoPedidosProdutos;

interface

uses uModelPedidoProdutos, classes, DB, SysUtils, generics.defaults,
     generics.collections, Dialogs, uDM_Conexao, uDaoBaseDados,uDaoPedidosDadosGerais, uDaoProdutos,
     uModelPedidoDadosGerais,UModelProdutos, OraCall, DBAccess, Ora;

type
  TDaoPedidosProdutos = class(TDaoBaseDados)
  private
    FListaPedidosProdutos: TObjectList<TPedidoProdutos>;
    procedure PopularLista(Ds: TOraQuery);
  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(pProduto: TPedidoProdutos): Boolean;
    function Deletar(pProduto: TPedidoProdutos): Boolean;
    function Alterar(pProduto: TPedidoProdutos): Boolean;
    function Listar() : TObjectList<TPedidoProdutos>;
    function Listar_By_Codigo(codigo:integer) : TObjectList<TPedidoProdutos>;


  end;

implementation

{ TDaoPedidosProdutos }

function TDaoPedidosProdutos.Alterar(pProduto: TPedidoProdutos): Boolean;
begin

end;

constructor TDaoPedidosProdutos.Create;
begin
  inherited;
  FListaPedidosProdutos := TObjectList<TPedidoProdutos>.Create;
end;

function TDaoPedidosProdutos.Deletar(pProduto: TPedidoProdutos): Boolean;
var
  Sql: String;
begin
  Sql := ' DELETE                                 '+
         '   FROM PEDIDO_PRODUTOS                '+
         '  WHERE NUMERO_PEDIDO = ' + IntToStr(pProduto.Numero_Pedido_FK.Numero_Pedido);
  Result := ExecutarSql(Sql) > 0;
end;

destructor TDaoPedidosProdutos.Destroy;
begin
  try
    inherited;
    if Assigned(FListaPedidosProdutos) then
      FreeAndNil(FListaPedidosProdutos);
  except
    on e: exception do
      raise Exception.Create(E.Message);
  end;
end;

function TDaoPedidosProdutos.Inserir(pProduto: TPedidoProdutos): Boolean;
var
  Sql: String;
begin
  dm_Conexao.OraQuery1.sql.Text := ' INSERT INTO PEDIDO_PRODUTOS (NUMERO_PEDIDO,CODIGO_PRODUTO,QUANTIDADE,VALOR_UNITARIO,VALOR_TOTAL) '+
         ' VALUES ( '+ inttostr(pProduto.Numero_Pedido_FK.Numero_Pedido) +' , '
                   + inttostr(pProduto.Codigo_Produto_FK.Codigo_Produto) + ' , '
                   + inttostr(pProduto.Quantidade) + ' , '
                   + StringReplace(FloatToStrF(pProduto.Valor_Unitario,ffFixed,10,2),',','.',[rfReplaceAll]) + ' , '
                   + StringReplace(FloatToStrF(pProduto.Valor_Total,ffFixed,10,2),',','.',[rfReplaceAll]) +
                   ')';
  dm_Conexao.OraQuery1.ExecSQL;
  Result := true;
end;
function TDaoPedidosProdutos.Listar: TObjectList<TPedidoProdutos>;
begin

end;

function TDaoPedidosProdutos.Listar_By_Codigo(
  codigo: integer): TObjectList<TPedidoProdutos>;
var
  Sql: String;
  I:integer;
begin
   Result := Nil;

   Sql := ' SELECT PP.*, P.DESCRICAO FROM PEDIDO_PRODUTOS PP , PRODUTOS P ';
   Sql := Sql + '  WHERE  PP.CODIGO_PRODUTO = P.CODIGO and '
                          +  'PP.NUMERO_PEDIDO = '+ inttostr(codigo) + '';
   Sql := Sql + '  ORDER BY PP.NUMERO_PEDIDO ';


  dm_Conexao.OraQuery1.SQL.Text := sql;
  dm_Conexao.OraQuery1.Active   := True;

  if not (dm_Conexao.OraQuery1.IsEmpty) then
  begin
    PopularLista(dm_Conexao.OraQuery1);
    Result := FListaPedidosProdutos;
  end;
end;

procedure TDaoPedidosProdutos.PopularLista(Ds: TOraQuery);
var
 I : integer;
begin
  I := 0;
  FListaPedidosProdutos.Clear;
  while not Ds.eof do
  begin
    FListaPedidosProdutos.Add(TPedidoProdutos.Create);
    FListaPedidosProdutos[I].Codigo := Ds.FieldByName('codigo').AsInteger;
    FListaPedidosProdutos[I].Numero_Pedido_FK.Numero_Pedido :=Ds.FieldByName('numero_pedido').AsInteger;
    FListaPedidosProdutos[I].Codigo_Produto_FK.Codigo_Produto   := Ds.FieldByName('codigo_produto').AsInteger;
    FListaPedidosProdutos[I].Codigo_Produto_FK.Descricao_Produto   := Ds.FieldByName('descricao').AsString;
    FListaPedidosProdutos[I].Quantidade   := Ds.FieldByName('quantidade').AsInteger;
    FListaPedidosProdutos[I].Valor_Unitario   := Ds.FieldByName('Valor_UNITARIO').AsFloat;
    FListaPedidosProdutos[I].Valor_Total   := Ds.FieldByName('Valor_TOTAL').AsFloat;
    Ds.Next;
    Inc(I);
  end;
end;


end.
