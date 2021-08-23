program TESTE_TECNICO_WK_TECNOLOGY;

uses
  Vcl.Forms,
  u_PedidosVendas in 'view\u_PedidosVendas.pas' {frm_Pedido_Venda},
  uDM_Conexao in 'dm\uDM_Conexao.pas' {dm_Conexao: TDataModule},
  uDaoBaseDados in 'dao\uDaoBaseDados.pas',
  uModelClientes in 'model\uModelClientes.pas',
  uDaoClientes in 'dao\uDaoClientes.pas',
  uModelProdutos in 'model\uModelProdutos.pas',
  uDaoProdutos in 'dao\uDaoProdutos.pas',
  uModelPedidoDadosGerais in 'model\uModelPedidoDadosGerais.pas',
  uModelPedidoProdutos in 'model\uModelPedidoProdutos.pas',
  uDaoPedidosDadosGerais in 'dao\uDaoPedidosDadosGerais.pas',
  uDaoPedidosProdutos in 'dao\uDaoPedidosProdutos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'TESTE_TECNICO_WK_TECNOLOGY';
  Application.CreateForm(Tfrm_Pedido_Venda, frm_Pedido_Venda);
  Application.CreateForm(Tdm_Conexao, dm_Conexao);
  Application.Run;
end.
