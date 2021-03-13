unit Autenticacao.JWT;

interface

uses
  System.SysUtils,
  MVCFramework.Commons,
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Middleware.Authentication.RoleBasedAuthHandler,
  System.JSON;

type
  TAuthenticationLive = class(TRoleBasedAuthHandler)
  public
    procedure OnRequest(const AContext: TWebContext; const ControllerQualifiedClassName: String;
      const ActionName: string; var AuthenticationRequired: Boolean);
    procedure OnAuthentication(const AContext: TWebContext; const UserName: String; const Password: String;
      UserRoles: TList<System.String>;
      var IsValid: Boolean; const SessionData: TSessionData);override;
    procedure OnAuthorization(const AContext: TWebContext; UserRoles: TList<System.String>;
      const ControllerQualifiedClassName: String; const ActionName: string;
      var IsAuthorized: Boolean);
  end;

implementation

{ TAuthenticationLive }

procedure TAuthenticationLive.OnAuthentication(const AContext: TWebContext;
  const UserName, Password: String; UserRoles: TList<System.String>;
  var IsValid: Boolean; const SessionData: TSessionData);
begin

  IsValid := False;

  if UserName.Equals('admin') and Password.Equals('admin') then
  begin
    IsValid := True;
    UserRoles.Add('admin');
  end;

  if (UserName.Equals('gerente') and Password.Equals('gerente')) or IsValid then
  begin
    IsValid := True;
    UserRoles.Add('gerente');
  end;

  if (UserName.Equals('caixa') and Password.Equals('caixa')) or IsValid then
  begin
    IsValid := True;
    UserRoles.Add('caixa');
  end;

  SessionData.Add('CPF', '12345678909');

end;

procedure TAuthenticationLive.OnAuthorization(const AContext: TWebContext;
  UserRoles: TList<System.String>; const ControllerQualifiedClassName,
  ActionName: string; var IsAuthorized: Boolean);
begin
  inherited;

  if ActionName = 'GetTransferencia' then
  begin
    IsAuthorized :=  UserRoles.Contains('admin')
  end;


end;

procedure TAuthenticationLive.OnRequest(const AContext: TWebContext;
  const ControllerQualifiedClassName, ActionName: string;
  var AuthenticationRequired: Boolean);
begin
  AuthenticationRequired := True;
end;

end.
