unit uModelPedidoProdutos;

interface

uses
  System.SysUtils,uModelPedidoDadosGerais, UModelProdutos;

Type
  TPedidoProdutos = class
  private
    FCodigo : Integer;
    FNumero_Pedido_FK: TPedidoDadosGerais;
    FCodigo_Produto_FK: TProdutos;
    FQuantidade : Integer;
    FValor_Unitario : double;
    FValor_Total : double;

    procedure setCodigo(const value:integer);
    procedure SetNumero_Pedido_FK(const Value: TPedidoDadosGerais);
    procedure SetCodigo_Produto_FK(const Value: TProdutos);
    procedure setQuantidade(const value:integer);
    procedure SetValor_Unitario(const Value: double);
    procedure SetValor_Total(const Value: double);
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    property Codigo: Integer read FCodigo write SetCodigo;
    property Numero_Pedido_FK: TPedidoDadosGerais read FNumero_Pedido_FK write SetNumero_Pedido_FK;
    property Codigo_Produto_FK: TProdutos read FCodigo_Produto_FK write SetCodigo_Produto_FK;
    property Quantidade: integer read FQuantidade write SetQuantidade;
    property Valor_Unitario: double read FValor_Unitario write SetValor_Unitario;
    property Valor_Total: double read FValor_Total write SetValor_Total;
  published
    { published declarations }
  end;

implementation

{ TPedidoDadosGerais }

constructor TPedidoProdutos.Create;
begin
  FCodigo := 0;
  FNumero_Pedido_FK := TPedidoDadosGerais.Create;
  FCodigo_Produto_FK := TProdutos.Create;
  FQuantidade := 0;
  FValor_Unitario := 0.00;
  FValor_Total := 0.00;
end;

procedure TPedidoProdutos.setCodigo(const value: integer);
begin
  FCodigo := value;
end;

procedure TPedidoProdutos.SetCodigo_Produto_FK(const Value: TProdutos);
begin
  FCodigo_Produto_FK := value;
end;

procedure TPedidoProdutos.SetNumero_Pedido_FK(
  const Value: TPedidoDadosGerais);
begin
   FNumero_Pedido_FK := value;
end;

procedure TPedidoProdutos.setQuantidade(const value: integer);
begin
  FQuantidade := value;
end;

procedure TPedidoProdutos.SetValor_Total(const Value: double);
begin
  FValor_Total := value;
end;

procedure TPedidoProdutos.SetValor_Unitario(const Value: double);
begin
   FValor_Unitario := value;
end;

end.
