unit uDM_Conexao;

interface

uses
  System.SysUtils, System.Classes, OraCall, Data.DB, DBAccess, Ora,
  OraTransaction, MemDS;

type
  Tdm_Conexao = class(TDataModule)
    CONEXAO: TOraSession;
    OraQuery1: TOraQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function VerificaConexao : boolean;
  end;

var
  dm_Conexao: Tdm_Conexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ Tdm_Conexao }

function Tdm_Conexao.VerificaConexao: boolean;
begin
result := true;
try
  Self.CONEXAO.Connected := true;
except
    on e: exception do
    begin
      Result := false;
    end;
end;
end;

end.
