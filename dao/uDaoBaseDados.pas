unit uDaoBaseDados;

interface

uses FireDAC.Comp.Client, System.SysUtils, Data.DB, Vcl.Dialogs,
     System.Classes,FireDAC.ConsoleUI.Wait,FireDAC.DApt, OraCall, DBAccess, Ora;

type
  TDaoBaseDados = Class(TObject)
  private

  protected
    FQryGeral: TOraQuery;
    constructor Create;
    destructor Destroy; override;
    function RetornarDS(pSQL: String): TOraQuery;
    function ExecutarSql(pSQL: String): Integer;
  end;

implementation


{ TDaoBaseDados }

uses uDM_Conexao;

constructor TDaoBaseDados.Create;
begin
  inherited Create;
  FQryGeral            := TOraQuery.Create(Nil);
  FQryGeral.Session := dm_Conexao.CONEXAO;
end;

destructor TDaoBaseDados.Destroy;
begin
  try
    if Assigned(FQryGeral) then
      FreeAndNil(FQryGeral);
  except
    on e: exception do
      raise Exception.Create(E.Message);
  end;
end;

function TDaoBaseDados.ExecutarSql(pSQL: String): Integer;
var
id : TBytes;
begin
  //Result := 1;
  try
   // dm_Conexao.CONEXAO.InternalName := 'Transacao';
   // dm_Conexao.CONEXAO.StartTransaction;
    FQryGeral.SQL.Text := pSQL;
    FQryGeral.ExecSQL;
    Result := FQryGeral.RowsAffected;
    dm_Conexao.CONEXAO.Commit;
  except
  begin
    dm_Conexao.CONEXAO.Rollback;
    Result := 0;
  end;
  end;
end;

function TDaoBaseDados.RetornarDS(pSQL: String): TOraQuery;
begin
  FQryGeral.SQL.Text := pSQL;
  FQryGeral.Active   := True;
  Result             := FQryGeral;
end;

end.
