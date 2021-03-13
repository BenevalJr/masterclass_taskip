unit Factory.DBConnection;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Phys.SQLite;

type
  TDBConnectionFactory = class
  private const
    DB_PATH = 'C:\development\20210313_Masterclass_Testes\data\customers_db.db'; //Substitua com o caminho do seu banco
  public
    class function GetConnection: TFDConnection;
  end;

implementation

{ TDBConnectionFactory }

class function TDBConnectionFactory.GetConnection: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.Params.Clear;
  Result.DriverName := 'SQLite';
  Result.Params.Database := DB_PATH;
  Result.Connected := True;
end;

end.
