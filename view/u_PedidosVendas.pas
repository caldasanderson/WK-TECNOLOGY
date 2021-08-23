unit u_PedidosVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, OraCall, Data.DB, DBAccess, Ora, generics.defaults, generics.collections,
  uModelClientes, uDaoClientes, uDaoBaseDados,uModelProdutos,uDaoProdutos,uModelPedidoDadosGerais,UDaoPedidosDadosGerais,
  uModelPedidoProdutos,uDaoPedidosProdutos;

type
  Tfrm_Pedido_Venda = class(TForm)
    OraSession1: TOraSession;
    pnl_Cliente: TPanel;
    cmb_Clientes: TComboBox;
    lbl_Cliente: TLabel;
    pnl_Produtos: TPanel;
    lbl_Codigo_Produto: TLabel;
    edt_Codigo_Produto: TEdit;
    lbl_Descricao_Produto: TLabel;
    edt_Descricao_Produto: TEdit;
    lbl_Quantidade: TLabel;
    edt_Quantidade: TEdit;
    lbl_Preco_Unitario: TLabel;
    edt_Preco_Unitario: TEdit;
    btn_Up: TBitBtn;
    btn_Down: TBitBtn;
    btn_Adicionar: TBitBtn;
    ltvProduto: TListView;
    btn_Up_Item: TBitBtn;
    btn_Down_Item: TBitBtn;
    stb_Total_Pedido: TStatusBar;
    btn_Salvar: TBitBtn;
    BitBtn1: TBitBtn;
    lbl_Codigo_Pedido: TLabel;
    edt_Codigo_Pedido: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmb_ClientesChange(Sender: TObject);
    procedure edt_Codigo_ProdutoExit(Sender: TObject);
    procedure btn_UpClick(Sender: TObject);
    procedure btn_DownClick(Sender: TObject);
    procedure btn_AdicionarClick(Sender: TObject);
    procedure btn_Up_ItemClick(Sender: TObject);
    procedure btn_Down_ItemClick(Sender: TObject);
    procedure ltvProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure ltvProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_SalvarClick(Sender: TObject);
    procedure cmb_ClientesExit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure edt_Codigo_PedidoExit(Sender: TObject);
  private
    { Private declarations }
    DaoClientes : TDaoClientes;
    Clientes : TClientes;
    DaoProdutos: TDaoProdutos;
    Produtos: TProdutos;
    PedidoDadosGerais : TPedidoDadosGerais;
    DaoPedidosDadosGerais : TDaoPedidosDadosGerais;
    PedidosProdutos : TPedidoProdutos;
    DaoPedidosProdutos : TDaoPedidosProdutos;

    Total_Pedido : Double;
    Editando_Produto : boolean;
    consulta_Registro : boolean;
    procedure AtualizaComboClientes;
    procedure CarregaComboClientes(pListaClientes: TList<TClientes>);
    procedure VerificaCarregaPedido;
    procedure LimpaCamposProduto;
    procedure RegistroPedidoSalvo;
    

  public
    { Public declarations }
  end;

var
  frm_Pedido_Venda: Tfrm_Pedido_Venda;

implementation

{$R *.dfm}

uses uDM_Conexao;



procedure Tfrm_Pedido_Venda.AtualizaComboClientes;
begin
 try
  CarregaComboClientes(DaoClientes.Listar());
  except
    on e: exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure Tfrm_Pedido_Venda.BitBtn1Click(Sender: TObject);
begin
if (edt_Codigo_Pedido.Visible) and (edt_Codigo_Pedido.Text <> '') and (consulta_Registro) and (ltvProduto.Items.Count > 0) then
begin
    PedidoDadosGerais.Numero_Pedido := strtoint(edt_Codigo_Pedido.Text);
    PedidosProdutos.Numero_Pedido_FK.Numero_Pedido := strtoint(edt_Codigo_Pedido.Text);
    
    if DaoPedidosProdutos.Deletar(PedidosProdutos) then     
    begin
      if DaoPedidosDadosGerais.Deletar(PedidoDadosGerais) then
      begin
        ShowMessage('Registro excluido com sucesso');
        consulta_Registro := false;
        RegistroPedidoSalvo;                   
      end;
    end;

end;

end;

procedure Tfrm_Pedido_Venda.btn_AdicionarClick(Sender: TObject);
var
Valor_Total : Double;
tempItem: TListItem;
begin
    if cmb_Clientes.ItemIndex > 0 then
    begin
      if Editando_Produto then
      begin
        if(ltvProduto.Selected <> nil) and (ltvProduto.Items.Count > 0)  then
        begin
          Valor_Total := strtofloat(ltvProduto.Items[ltvProduto.Selected.Index].SubItems[3]);
          Total_Pedido :=  Total_Pedido - Valor_Total;
          Valor_Total := (StrToFloat(edt_Preco_Unitario.Text) * StrToInt(edt_Quantidade.Text));

          ltvProduto.Items[ltvProduto.Selected.Index].SubItems[1] := edt_Quantidade.Text;
          ltvProduto.Items[ltvProduto.Selected.Index].SubItems[2] :=  FloatToStrF(strtofloat(edt_Preco_Unitario.Text),ffFixed,10,2);
          ltvProduto.Items[ltvProduto.Selected.Index].SubItems[3] :=  FloatToStrF(Valor_Total,ffFixed,10,2);

          Total_Pedido :=  Total_Pedido + Valor_Total;
          stb_Total_Pedido.Panels[0].Text := 'TOTAL DO PEDIDO: R$'+ FloatToStrF(Total_Pedido,ffFixed,10,2);
          LimpaCamposProduto;
          Editando_Produto := false;
          ltvProduto.SetFocus;
        end;
      end
      else
      begin
        tempItem := ltvProduto.Items.Add;
        Valor_Total := 0.00;
        Valor_Total := (StrToFloat(edt_Preco_Unitario.Text) * StrToInt(edt_Quantidade.Text));
        Total_Pedido :=  Total_Pedido + Valor_Total;
        stb_Total_Pedido.Panels[0].Text := 'TOTAL DO PEDIDO: R$'+ FloatToStrF(Total_Pedido,ffFixed,10,2);
        tempItem.Caption := edt_Codigo_Produto.Text;
        tempItem.SubItems.Add(edt_Descricao_Produto.Text);
        tempItem.SubItems.Add(edt_Quantidade.Text);
        tempItem.SubItems.Add(edt_Preco_Unitario.Text);
        tempItem.SubItems.Add(FloatToStrF(Valor_Total,ffFixed,10,2));
        LimpaCamposProduto;
        ltvProduto.SetFocus;
      end;
    end
    else
    begin
      ShowMessage('Favor selecionar um cliente');
      cmb_Clientes.SetFocus;
    end;
   
  
end;

procedure Tfrm_Pedido_Venda.btn_DownClick(Sender: TObject);
begin
  edt_Quantidade.Text := inttostr(strtoint(edt_Quantidade.Text) - 1 );
end;

procedure Tfrm_Pedido_Venda.btn_Down_ItemClick(Sender: TObject);
begin
  if ltvProduto.Selected <> nil  then
  begin
      if ltvProduto.Selected.Index < ltvProduto.Items.Count - 1 then
      begin
        ltvProduto.Items[ltvProduto.Selected.Index + 1].Selected := true;
        ltvProduto.SetFocus;
      end;
  end
  else if ltvProduto.Items.Count > 0 then
  begin
      ltvProduto.Items[0].Selected := true;
      ltvProduto.SetFocus;
  end;
end;

procedure Tfrm_Pedido_Venda.btn_SalvarClick(Sender: TObject);
var
I :integer;
begin
if (edt_Codigo_Pedido.Visible = false) and (edt_Codigo_Pedido.Text = '') and (ltvProduto.Items.Count > 0) and (consulta_Registro = false)  then
begin
  PedidoDadosGerais.numero_pedido := DaoPedidosDadosGerais.MaxNumeroPedido + 1;
  PedidoDadosGerais.Codigo_Clientes_FK.Codigo_Cliente := StrtoInt(Copy(cmb_Clientes.Text,1,pos(' ',cmb_Clientes.Text)-1));
  PedidoDadosGerais.Data_Emissao := now;
  PedidoDadosGerais.Valor_Total := strtofloat(FloatToStrF(Total_Pedido,ffFixed,10,2));
  try DaoPedidosDadosGerais.Inserir(PedidoDadosGerais);
  except
    ShowMessage('Erro na Inserção do Pedido');
  end;
  for I := 0 to ltvProduto.Items.Count - 1 do
  begin
    PedidosProdutos.Numero_Pedido_FK.Numero_Pedido := PedidoDadosGerais.numero_pedido;
    PedidosProdutos.Codigo_Produto_FK.Codigo_Produto := strtoint(ltvProduto.Items[I].Caption);
    PedidosProdutos.Quantidade := strtoint(ltvProduto.Items[I].SubItems[1]);
    PedidosProdutos.Valor_Unitario := strtofloat(ltvProduto.Items[I].SubItems[2]);
    PedidosProdutos.Valor_Total := StrToFloat(ltvProduto.Items[I].SubItems[3]);
    try
      DaoPedidosProdutos.Inserir(PedidosProdutos);
    except
      ShowMessage('Erro na Inserção do Pedido');
    end;
  end;
  ShowMessage('Pedido Inserido com Sucesso! Numero do Pedido:'+ inttostr(PedidoDadosGerais.numero_pedido));
  RegistroPedidoSalvo;
end;

end;

procedure Tfrm_Pedido_Venda.btn_UpClick(Sender: TObject);
begin
  edt_Quantidade.Text := inttostr(strtoint(edt_Quantidade.Text) + 1 );
end;

procedure Tfrm_Pedido_Venda.btn_Up_ItemClick(Sender: TObject);
begin
  if ltvProduto.Selected <> nil  then
  begin
    if ltvProduto.Selected.Index >= 1 then
    begin
      ltvProduto.Items[ltvProduto.Selected.Index - 1].Selected := true;
      ltvProduto.SetFocus;
    end;
  end
  else if ltvProduto.Items.Count > 0 then
  begin
      ltvProduto.Items[0].Selected := true;
      ltvProduto.SetFocus;
  end;
end;

procedure Tfrm_Pedido_Venda.CarregaComboClientes(
  pListaClientes: TList<TClientes>);
var
  I: Integer;
begin
  if Assigned(pListaClientes) then
  begin
    cmb_Clientes.Clear;
    cmb_Clientes.Items.Add('<- CARREGAR PEDIDO ->');
    for I := 0 to pListaClientes.Count -1 do
    begin
      cmb_Clientes.Items.Add(inttostr(TClientes(pListaClientes[I]).Codigo_Cliente) + ' - ' + TClientes(pListaClientes[I]).Nome_Cliente);
    end;
  end
  else
    ShowMessage('Nenhuma Categoria Encontrada.');
end;

procedure Tfrm_Pedido_Venda.cmb_ClientesChange(Sender: TObject);
begin
  VerificaCarregaPedido; 
end;

procedure Tfrm_Pedido_Venda.cmb_ClientesExit(Sender: TObject);
begin
if cmb_Clientes.ItemIndex = -1 then
begin
  ShowMessage('Favor Selecionar uma opção');
  cmb_Clientes.SetFocus;
end;
end;

procedure Tfrm_Pedido_Venda.edt_Codigo_PedidoExit(Sender: TObject);
var
I: integer;
ListaPedidoDadosGerais : TList<TPedidoDadosGerais>;
ListaPedidosProdutos   : TList<TPedidoProdutos>;
tempItem: TListItem;
valor_unitario, valor_total:double;
begin
  try
    i := strtoint(edt_Codigo_Pedido.Text);
  except
    ShowMessage('Favor informar um código válido');
    edt_Codigo_Pedido.SetFocus;
    edt_Codigo_Pedido.Clear;
    exit;
  end;
  PedidoDadosGerais.Numero_Pedido := i;
  ListaPedidoDadosGerais := DaoPedidosDadosGerais.Listar_By_Codigo(i);
  if Assigned(ListaPedidoDadosGerais) then
  begin
       Total_Pedido := ListaPedidoDadosGerais[0].Valor_Total;
       stb_Total_Pedido.Panels[0].Text := 'TOTAL DO PEDIDO: R$'+ FloatToStrF(Total_Pedido,ffFixed,10,2);
       cmb_Clientes.ItemIndex := ListaPedidoDadosGerais[0].Codigo_Clientes_FK.Codigo_Cliente;
       ListaPedidosProdutos := DaoPedidosProdutos.Listar_By_Codigo(I);
       if Assigned(ListaPedidosProdutos) then
       begin
          ltvProduto.Clear;
          for I := 0 to ListaPedidosProdutos.Count -1 do
          begin
            valor_unitario := TPedidoProdutos(ListaPedidosProdutos[I]).Valor_Unitario;
            valor_total := TPedidoProdutos(ListaPedidosProdutos[I]).Valor_Total;
            tempItem := ltvProduto.Items.Add;
            tempItem.Caption := IntToStr(TPedidoProdutos(ListaPedidosProdutos[I]).Codigo_Produto_FK.Codigo_Produto);
            tempItem.SubItems.Add(TPedidoProdutos(ListaPedidosProdutos[I]).Codigo_Produto_FK.Descricao_Produto);
            tempItem.SubItems.Add(inttostr(TPedidoProdutos(ListaPedidosProdutos[I]).Quantidade));
            tempItem.SubItems.Add(FloatToStrF(valor_unitario,ffFixed,10,2));
            tempItem.SubItems.Add(FloatToStrF(valor_total,ffFixed,10,2)); 
          end;
          consulta_Registro := true;
          BitBtn1.SetFocus; 
       end
       else
       begin
         ShowMessage('Nenhum produto encontrado.');
         ltvProduto.Clear;
         edt_Codigo_Produto.SetFocus;
       end;
  end
  else
  begin
      ShowMessage('Nenhum Pedido encontrado.');
  end;
end;

procedure Tfrm_Pedido_Venda.edt_Codigo_ProdutoExit(Sender: TObject);
var
  i : integer;
  ListaProdutos : TList<TProdutos>;
begin
  try
  i := strtoint(edt_Codigo_Produto.Text);
  except
    ShowMessage('Favor informar um código válido');
    edt_Codigo_Produto.SetFocus;
    LimpaCamposProduto;
    exit;
  end;
  ListaProdutos := DaoProdutos.Listar_By_Codigo(strtoint(edt_Codigo_Produto.Text));
  try
    if Assigned(ListaProdutos) then
    begin
       edt_Codigo_Produto.Text := inttostr(ListaProdutos[0].Codigo_Produto);
       edt_Descricao_Produto.Text := ListaProdutos[0].Descricao_Produto;
       edt_Preco_Unitario.Text := FloatToStrF(ListaProdutos[0].Preco_Venda,ffFixed,10,2);
    end
    else
    begin
      ShowMessage('Nenhum produto encontrado.');
    end;
  except
    on e: exception do
      raise Exception.Create(E.Message);
  end;
end;
procedure Tfrm_Pedido_Venda.FormCreate(Sender: TObject);
begin
   dm_Conexao            := Tdm_Conexao.Create(Self);
   DaoClientes           := TDaoClientes.Create;
   DaoProdutos           := TDaoProdutos.Create;
   Produtos              := TProdutos.Create;
   PedidoDadosGerais     := TPedidoDadosGerais.Create;
   DaoPedidosDadosGerais := TDaoPedidosDadosGerais.Create;
   Clientes              := TClientes.create;
   PedidosProdutos       := TPedidoProdutos.Create;
   DaoPedidosProdutos    := TDaoPedidosProdutos.Create;
   Total_Pedido          :=  0.00;

end;

procedure Tfrm_Pedido_Venda.FormShow(Sender: TObject);
Begin
Try
  dm_Conexao  := Tdm_Conexao.Create(Self);
finally
  if not dm_Conexao.VerificaConexao then
  begin
    cmb_Clientes.Enabled := false;
    ShowMessage('Erro ao Conectar o Banco de dados. Verifique as configurações do sistema!' );
  end
  else
  Begin
    AtualizaComboClientes;
    Editando_Produto := false;
    consulta_Registro := false;
    stb_Total_Pedido.Panels[0].Text := 'TOTAL DO PEDIDO: R$'+ FloatToStrF(Total_Pedido,ffFixed,10,2)+'';
  End;

end;
end;

procedure Tfrm_Pedido_Venda.LimpaCamposProduto;
begin
edt_Codigo_Produto.Clear;
edt_Descricao_Produto.Clear;
edt_Preco_Unitario.Clear;
edt_Quantidade.Text := inttostr(1);
end;

procedure Tfrm_Pedido_Venda.ltvProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

var
  Valor_Total:double;
begin
if (Key = VK_DELETE) then
 begin
    if consulta_Registro then
    begin
      ShowMessage('Operação Inválida: Modo Consulta');
      BitBtn1.SetFocus;
      exit;
    end
    else
    if ltvProduto.Selected <> nil  then
    begin
      if messagedlg('Deseja excluir o produto da lista?',mtconfirmation,[mbyes,mbno],0)= mryes then
      begin
        Valor_Total := strtofloat(ltvProduto.Items[ltvProduto.Selected.Index].SubItems[3]);
        Total_Pedido :=  Total_Pedido - Valor_Total;
        stb_Total_Pedido.Panels[0].Text := 'TOTAL DO PEDIDO: R$'+ FloatToStrF(Total_Pedido,ffFixed,10,2);
        ltvProduto.Items[ltvProduto.Selected.Index].Delete;
      end;
    end;
 end;
end;

procedure Tfrm_Pedido_Venda.ltvProdutoKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #13 then
 begin
    if consulta_Registro then
    begin
      ShowMessage('Operação Inválida: Modo Consulta');
      BitBtn1.SetFocus;
      exit;
    end
    else
      if ltvProduto.Selected <> nil  then
      begin
      edt_Codigo_Produto.Text    := ltvProduto.Items[ltvProduto.Selected.Index].Caption;
      edt_Descricao_Produto.Text := ltvProduto.Items[ltvProduto.Selected.Index].SubItems[0];
      edt_Quantidade.Text        := ltvProduto.Items[ltvProduto.Selected.Index].SubItems[1];
      edt_Preco_Unitario.Text    := ltvProduto.Items[ltvProduto.Selected.Index].SubItems[2];
      Editando_Produto := true;
      end;
 end;
end;


procedure Tfrm_Pedido_Venda.RegistroPedidoSalvo;
begin
ltvProduto.Clear;
LimpaCamposProduto;
Total_Pedido := 0.00;
stb_Total_Pedido.Panels[0].Text := 'TOTAL DO PEDIDO: R$'+ FloatToStrF(Total_Pedido,ffFixed,10,2);
cmb_Clientes.ItemIndex := 0;
lbl_Codigo_Pedido.Visible := true;
edt_Codigo_Pedido.Visible := true;
edt_Codigo_Pedido.Clear;
cmb_Clientes.SetFocus;
end;

procedure Tfrm_Pedido_Venda.VerificaCarregaPedido;
begin
  if (cmb_Clientes.ItemIndex = 0) and (cmb_Clientes.Text = '<- CARREGAR PEDIDO ->') then
  begin
    lbl_Codigo_Pedido.Visible := True;
    edt_Codigo_Pedido.Visible := True;
    edt_Codigo_Pedido.Clear;
    edt_Codigo_Pedido.SetFocus;
  end
  else
  begin
    lbl_Codigo_Pedido.Visible := false;
    edt_Codigo_Pedido.Visible := false;
    edt_Codigo_Pedido.Clear;
  end;

end;

end.
