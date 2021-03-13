unit Controller.Customer;

interface

uses
  System.JSON,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.Middleware.Authentication.RoleBasedAuthHandler,
  MVCFramework.Swagger.Commons;

type

  [MVCPath('/api')]
  [MVCSwagAuthentication(atJsonWebToken)]
  TCustomerController = class(TMVCController) 
  public

  public
    [MVCPath('/saldo')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary('Conta Corrente', 'Retorna o Saldo')]
    [MVCRequiresRole('caixa;gerente;admin', MVCRoleEval.reOR)]
    procedure GetSaldo;

    [MVCPath('/extrato')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary('Conta Corrente', 'Retorna o Extrato')]
    [MVCRequiresRole('gerente;admin', MVCRoleEval.reOR)]
    procedure GetExtrato;

    [MVCPath('/transferencia/v1')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary('Conta Corrente', 'Realiza uma tranferência')]
    [MVCRequiresRole('admin', MVCRoleEval.reOR)]
    procedure GetTransferencia;

    [MVCPath('/transferencia/v2')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary('Conta Corrente', 'Retorna o Saldo')]
    [MVCRequiresRole('admin', MVCRoleEval.reOR)]
    procedure GetTransferenciaV2;

    [MVCPath('/cpf')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary('Dados Pessoais', 'Retorna o CPF do JWT')]
    procedure GetCPF;

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils;

procedure TCustomerController.GetSaldo;
begin
  Render('Retorno do saldo');
end;

procedure TCustomerController.GetCPF;
begin
  Render(Context.LoggedUser.CustomData['CPF']);
end;

procedure TCustomerController.GetExtrato;
begin
  Render('Retorno do extrato');
end;

procedure TCustomerController.GetTransferencia;
begin
  Render('Retorno da tranferência');
end;

procedure TCustomerController.GetTransferenciaV2;
begin
  Render('Retorno da tranferência V2');
end;

end.
