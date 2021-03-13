unit Controller.Customer;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFrameWork.ActiveRecord,
  MVCFramework.Serializer.Commons,
  MVCFramework.SQLGenerators.SQLite,
  Factory.DBConnection,
  Model.Customer;

type

  [MVCPath('/api')]
  TCustomerController = class(TMVCController)
  public
    constructor Create; override;
    destructor Destroy; override;

      [MVCPath('/customers')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCustomers;

    [MVCPath('/customers/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCustomer(id: Integer);

    [MVCPath('/customers')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateCustomer;

    [MVCPath('/customers/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateCustomer(id: Integer);

    [MVCPath('/customers/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteCustomer(id: Integer);
  end;

implementation

procedure TCustomerController.GetCustomers;
var
  LCustomerList: TObjectList<TCustomerModel>;
begin
  LCustomerList := TMVCActiveRecord.All<TCustomerModel>;

  try
    if LCustomerList.Count = 0 then
      Render(HTTP_STATUS.NoContent)
    else
      Render<TCustomerModel>(HTTP_STATUS.OK, LCustomerList, False);
  finally
    LCustomerList.Free;
  end;
end;

procedure TCustomerController.GetCustomer(id: Integer);
var
  LCustomer: TCustomerModel;
begin
  LCustomer := TMVCActiveRecord.GetByPK<TCustomerModel>(id);

  if Assigned(LCustomer) then
    Render(HTTP_STATUS.OK, LCustomer, True)
  else
    Render(HTTP_STATUS.NotFound);
end;

constructor TCustomerController.Create;
begin
  inherited;
  ActiveRecordConnectionsRegistry.AddDefaultConnection(TDBConnectionFactory.GetConnection, True);
end;

procedure TCustomerController.CreateCustomer;
var
  LCustomer: TCustomerModel;
begin
  try
    LCustomer := Context.Request.BodyAs<TCustomerModel>;
    LCustomer.Store;
    Render(HTTP_STATUS.Created, LCustomer, True);
  except
    Render(HTTP_STATUS.BadRequest);
  end;
end;

procedure TCustomerController.UpdateCustomer(id: Integer);
var
  LCustomer: TCustomerModel;
begin
  LCustomer := TMVCActiveRecord.GetByPK<TCustomerModel>(id);

  if Assigned(LCustomer) then
  begin
    FreeAndNil(LCustomer);
    LCustomer := Context.Request.BodyAs<TCustomerModel>;
    LCustomer.Id := id;
    Lcustomer.Update;
    Render(HTTP_STATUS.OK, LCustomer, True)
  end
  else
    Render(HTTP_STATUS.NotFound);
end;

procedure TCustomerController.DeleteCustomer(id: Integer);
var
  LCustomer: TCustomerModel;
begin
  LCustomer := TMVCActiveRecord.GetByPK<TCustomerModel>(id);

  if Assigned(LCustomer) then
  begin
    try
      LCustomer.Delete;
      Render(HTTP_STATUS.OK)
    finally
      LCustomer.Free;
    end;
  end
  else
    Render(HTTP_STATUS.NotFound);
end;

destructor TCustomerController.Destroy;
begin
  ActiveRecordConnectionsRegistry.RemoveDefaultConnection;
  inherited;
end;

end.
