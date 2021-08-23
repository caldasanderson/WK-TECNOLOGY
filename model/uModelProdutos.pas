unit uModelProdutos;

interface

uses
  System.SysUtils;

Type
  TProdutos = class
  private
    FCodigo_Produto: Integer;
    FDescricao_Produto: String;
    FPreco_Venda: Double;

    procedure setCodigo_Produto(const Value: Integer);
    procedure setDescricao_Produto(const Value: String);
    procedure setPreco_Venda(const Value: Double);

    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    property Codigo_Produto: Integer read FCodigo_Produto write setCodigo_Produto;
    property Descricao_Produto: String read FDescricao_Produto write setDescricao_Produto;
    property Preco_Venda: Double read FPreco_Venda write setPreco_Venda;

  published
    { published declarations }
  end;

implementation

{ TProdutos }

constructor TProdutos.Create;

 begin
  FCodigo_Produto := 0;
  FDescricao_Produto    := '';
  FPreco_Venda     := 0.00;
end;

procedure TProdutos.setCodigo_Produto(const Value: Integer);
begin
  FCodigo_Produto := Value;
end;

procedure TProdutos.setDescricao_Produto(const Value: String);
begin
  FDescricao_Produto := Value;
end;

procedure TProdutos.setPreco_Venda(const Value: Double);
begin
  FPreco_Venda := Value;
end;

end.
