unit WebModule.Main;

interface

uses 
  System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  MVCFramework,
  MVCFramework.Middleware.JWT,
  MVCFramework.JWT,
  System.DateUtils,
  MVCFramework.Swagger.Commons,
  MVCFramework.Middleware.Swagger;

type
  TWMMain = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWMMain;

implementation

{$R *.dfm}

uses 
  System.IOUtils,
  MVCFramework.Commons, 
  MVCFramework.Middleware.StaticFiles, 
  MVCFramework.Middleware.Compression, Controller.Customer, Autenticacao.JWT;

procedure TWMMain.WebModuleCreate(Sender: TObject);
var
  LClaimsSetup: TJWTClaimsSetup;
  LSwagInfo: TMVCSwaggerInfo;

begin
  LClaimsSetup := procedure(const JWT: TJWT)
    begin
      JWT.Claims.Issuer := 'API Live';
      JWT.Claims.ExpirationTime := Now + 12; // valid for 1 hour
      JWT.Claims.NotBefore := Now - OneMinute * 5; // valid since 5 minutes ago
      JWT.Claims.IssuedAt := Now;
//      JWT.CustomClaims['mycustomvalue'] := 'hello there';
    end;

  LSwagInfo.Title := 'Sample Swagger API';
  LSwagInfo.Version := 'v1';
  LSwagInfo.TermsOfService := 'http://www.apache.org/licenses/LICENSE-2.0.txt';
  LSwagInfo.Description := 'Swagger Documentation Example';
  LSwagInfo.ContactName := 'Angelo Sobreira';
  LSwagInfo.ContactEmail := 'angelo@taskip.com.br';
  LSwagInfo.ContactUrl := 'https://github.com/angelosobreira';
  LSwagInfo.LicenseName := 'Apache License - Version 2.0, January 2004';
  LSwagInfo.LicenseUrl := 'http://www.apache.org/licenses/LICENSE-2.0';


  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      // session timeout (0 means session cookie)
      Config[TMVCConfigKey.SessionTimeout] := '0';
      //default content-type
      Config[TMVCConfigKey.DefaultContentType] := TMVCConstants.DEFAULT_CONTENT_TYPE;
      //default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := TMVCConstants.DEFAULT_CONTENT_CHARSET;
      //unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := 'false';
      //enables or not system controllers loading (available only from localhost requests)
      Config[TMVCConfigKey.LoadSystemControllers] := 'true';
      //default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      //view path
      Config[TMVCConfigKey.ViewPath] := 'templates';
      //Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := '20';
      //Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      //Enable X-Powered-By Header in response
      Config[TMVCConfigKey.ExposeXPoweredBy] := 'true';
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE);
    end);


  FMVC.AddMiddleware(TMVCJWTAuthenticationMiddleware.Create(TAuthenticationLive.Create,
                                                            'CHAVE_JWT',
                                                            '/auth/login',
                                                            LClaimsSetup)) ;

  FMVC.AddMiddleware(TMVCSwaggerMiddleware.Create(FMVC, LSwagInfo, '/api/swagger.json',
    'Method for authentication using JSON Web Token (JWT)'));

  FMVC.AddController(TCustomerController);

  // Required to enable serving of static files 
  // Remove the following middleware declaration if you don't  
  // serve static files from this dmvcframework service.
  FMVC.AddMiddleware(TMVCStaticFilesMiddleware.Create(
    '/',         { StaticFilesPath }
    '.\www\swagger\',     { DocumentRoot }
    'index.html' { IndexDocument - Before it was named fallbackresource }
    ));

  // To enable compression (deflate, gzip) just add this middleware as the last one 
  FMVC.AddMiddleware(TMVCCompressionMiddleware.Create);
end;

procedure TWMMain.WebModuleDestroy(Sender: TObject);
begin
  FMVC.Free;
end;

end.
