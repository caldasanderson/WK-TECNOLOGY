unit uModelPedidoDadosGerais;

interface

uses
  System.SysUtils,uModelClientes;

Type
  TPedidoDadosGerais = class
  private
    FNumero_Pedido: Integer;
    FCodigo_Clientes_FK: TClientes;
    FData_Emissao : TDateTime;
    FValor_Total : double;

    procedure SetNumero_Pedido(const Value: Integer);
    procedure SetCodigo_Clientes_FK(const Value: TClientes);
    procedure SetData_Emissao(const Value: TDateTime);
    procedure SetValor_Total(const Value: double);
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    property Numero_Pedido: Integer read FNumero_Pedido write SetNumero_Pedido;
    property Codigo_Clientes_FK: TClientes read FCodigo_Clientes_FK write SetCodigo_Clientes_FK;
    property Data_Emissao: TDateTime read FData_Emissao write SetData_Emissao;
    property Valor_Total: double read FValor_Total write SetValor_Total;
  published
    { published declarations }
  end;

implementation


{ TPedidoDadosGerais }

constructor TPedidoDadosGerais.Create;
begin
  FNumero_Pedido := 0;
  FCodigo_Clientes_FK := TClientes.Create;
  FData_Emissao   := EncodeDate(1900,1,1);
  FValor_Total := 0.00;
end;

procedure TPedidoDadosGerais.SetCodigo_Clientes_FK(const Value: TClientes);
begin
   FCodigo_Clientes_FK := Value;
end;

procedure TPedidoDadosGerais.SetData_Emissao(const Value: TDateTime);
begin
  FData_Emissao := Value;
end;

procedure TPedidoDadosGerais.SetNumero_Pedido(const Value: Integer);
begin
  FNumero_Pedido := Value;
end;

procedure TPedidoDadosGerais.SetValor_Total(const Value: double);
begin
  FValor_Total := Value;
end;

end.
