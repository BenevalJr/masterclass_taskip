unit Test.Model.Customer;

interface
uses
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,
  DUnitX.TestFramework,
  FireDAC.Comp.Client,
  MVCFramework.ActiveRecord,
  MVCFramework.SQLGenerators.SQLite,
  Model.Customer,
  Factory.DBConnection;

type
  [TestFixture]
  TTestCustomerModel = class(TObject)
  private const
    TEST_NAME = 'Test Name';
    TEST_ADDRESS = 'Test Address';
    TEST_CITY = 'Test City';
    TEST_ZIPCODE = '1234567';
    TEST_COUNTRY_CODE = 'ZZ';
    TEST_PHONE = '9867583';
  private var
    FConnection: TFDConnection;
    FCurrentDate: TDateTime;
    FIdListToDelete: TList<Integer>;

    function _GetTestCustomerObject: TCustomerModel;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    // Unit Tests
    [Test]
    procedure TestCustomerNameIsFormattedWhenSet;
    [Test]
    procedure TestFutureBirthdayRaisesException;

    // Integration Tests
    [Test]
    procedure TestInsertCustomer;
    [Test]
    procedure TestUpdateCustomer;
    [Test]
    Procedure TestDeleteCustomer;
  end;

implementation

{ TTestCustomerModel }

procedure TTestCustomerModel.Setup;
begin
  FCurrentDate := Now;
  FIdListToDelete := TList<Integer>.Create;
  FConnection := TDBConnectionFactory.GetConnection;
  ActiveRecordConnectionsRegistry.AddDefaultConnection(FConnection, True);
end;

procedure TTestCustomerModel.TearDown;
var
  LCustomer: TCustomerModel;
  CustomerId: Integer;
begin
  try
    for CustomerId in FIdListToDelete do
    begin
      LCustomer := TMVCActiveRecord.GetByPK<TCustomerModel>(CustomerId, False);

      if Assigned(LCustomer) then
        LCustomer.Delete;
    end;
  finally
    FIdListToDelete.Free;
    ActiveRecordConnectionsRegistry.RemoveDefaultConnection;
  end;
end;

procedure TTestCustomerModel.TestCustomerNameIsFormattedWhenSet;
const
  MESSY_NAME = 'JaNe DOe sIlvA';
  CORRECT_NAME = 'Jane Doe Silva';
var
  LCustomer: TCustomerModel;
begin
  LCustomer := TCustomerModel.Create;

  try
    LCustomer.Name := MESSY_NAME;
    Assert.AreEqual(CORRECT_NAME, LCustomer.Name);
  finally
    LCustomer.Free;
  end;
end;

procedure TTestCustomerModel.TestDeleteCustomer;
var
  LCustomer: TCustomerModel;
  LCreatedCustomer: TCustomerModel;
  CustomerId: Integer;
begin
  LCustomer := nil;
  LCreatedCustomer := nil;

  try
    LCustomer := _GetTestCustomerObject;
    LCustomer.Store;
    CustomerId := LCustomer.Id;
    LCreatedCustomer := TMVCActiveRecord.GetByPK<TCustomerModel>(CustomerId);
    LCreatedCustomer.Delete;

    Assert.WillRaise(
      procedure
      begin
        TMVCActiveRecord.GetByPK<TCustomerModel>(CustomerId, True);
      end);
  finally
    LCustomer.Free;
    LCreatedCustomer.Free;
  end;
end;

procedure TTestCustomerModel.TestFutureBirthdayRaisesException;
var
  LCustomer: TCustomerModel;
begin
  LCustomer := TCustomerModel.Create;

  try
    Assert.WillRaise(
      procedure
      begin
        LCustomer.Birthday := IncDay(Now); // Data no futuro
      end);
  finally
    LCustomer.Free;
  end;
end;

procedure TTestCustomerModel.TestInsertCustomer;
var
  LCustomer: TCustomerModel;
  LCreatedCustomer: TCustomerModel;
  CustomerId: Integer;
begin
  LCustomer := nil;
  LCreatedCustomer := nil;

  try
    LCustomer := _GetTestCustomerObject;
    LCustomer.Store;
    CustomerId := LCustomer.Id;

    LCreatedCustomer := TMVCActiveRecord.GetByPK<TCustomerModel>(CustomerId);
    Assert.IsTrue(Assigned(LCreatedCustomer));
    FIdListToDelete.Add(CustomerId);
  finally
    LCustomer.Free;
    LCreatedCustomer.Free;
  end;
end;

procedure TTestCustomerModel.TestUpdateCustomer;
const
  NEW_NAME = 'Just another name';
var
  LCustomer: TCustomerModel;
  LCreatedCustomer: TCustomerModel;
  LUpdatedCustomer: TCustomerModel;
  CustomerId: Integer;
begin
  LCustomer := nil;
  LCreatedCustomer := nil;
  LUpdatedCustomer := nil;

  try
    LCustomer := _GetTestCustomerObject;
    LCustomer.Store;
    CustomerId := LCustomer.Id;

    LCreatedCustomer := TMVCActiveRecord.GetByPK<TCustomerModel>(CustomerId);
    LCreatedCustomer.Name := NEW_NAME;
    LCreatedCustomer.Update;

    LUpdatedCustomer := TMVCActiveRecord.GetByPK<TCustomerModel>(CustomerId);

    Assert.AreEqual(NEW_NAME, LUpdatedCustomer.Name);
    FIdListToDelete.Add(CustomerId);
  finally
    LCustomer.Free;
    LCreatedCustomer.Free;
    LUpdatedCustomer.Free;
  end;
end;

function TTestCustomerModel._GetTestCustomerObject: TCustomerModel;
begin
  Result := TCustomerModel.Create;
  Result.Name := TEST_NAME;
  Result.Address := TEST_ADDRESS;
  Result.City := TEST_CITY;
  Result.PostalCode := TEST_ZIPCODE;
  Result.CountryCode := TEST_COUNTRY_CODE;
  Result.Phone := TEST_PHONE;
  Result.Birthday := FCurrentDate;
end;

end.
