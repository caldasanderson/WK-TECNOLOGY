unit uModelClientes;

interface

uses
  System.SysUtils;

Type
  TClientes = class
  private
    FCodigo_Cliente: Integer;
    FNome_Cliente: String;
    FCidade: String;
    FUf: String;


    procedure setCodigo_Cliente(const Value: Integer);
    procedure setNome_Cliente(const Value: String);
    procedure setCidade(const Value: String);
    procedure setUf(const Value: String);

    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    property Codigo_Cliente: Integer read FCodigo_Cliente write setCodigo_Cliente;
    property Nome_Cliente: String read FNome_Cliente write setNome_Cliente;
    property Cidade: String read FCidade write SetCidade;
    property Uf: String read FUf write SetUf;


  published
    { published declarations }
  end;

implementation

{ TClientes }

constructor TClientes.Create;
begin
  FCodigo_Cliente := 0;
  FNome_Cliente    := '';
  FCidade     := '';
  FUf := '';
end;



procedure TClientes.setCidade(const Value: String);
begin
  FCidade := Value;
end;

procedure TClientes.setCodigo_Cliente(const Value: Integer);
begin
  FCodigo_Cliente := Value;
end;

procedure TClientes.setNome_Cliente(const Value: String);
begin
  FNome_Cliente := Value;
end;

procedure TClientes.setUf(const Value: String);
begin
  FUf := Value;
end;

end.
