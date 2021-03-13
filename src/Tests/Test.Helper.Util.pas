unit Test.Helper.Util;

interface
uses
  System.DateUtils,
  System.SysUtils,
  DUnitX.TestFramework,
  Helper.Util;

type

  [TestFixture]
  TTestUtilHelper = class(TObject) 
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestNameCase;
    [Test]
    procedure TestGetAge;
  end;

implementation

procedure TTestUtilHelper.Setup;
begin
end;

procedure TTestUtilHelper.TearDown;
begin
end;


procedure TTestUtilHelper.TestGetAge;
var
  LAge: Integer;
  LPastDate: TDateTime;
begin
  LPastDate := IncYear(Today, -5);
  LAge := Util.GetAge(LPastDate);

  Assert.AreEqual(5, LAge);
end;

procedure TTestUtilHelper.TestNameCase;
const
  MESSY_NAME = 'JaNe DOe sIlvA';
  CORRECT_NAME = 'Jane Doe Silva';
var
  LCurrentName: string;
begin
  LCurrentName :=  Util.FormatName(MESSY_NAME);
  Assert.AreEqual(CORRECT_NAME, LCurrentName);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestUtilHelper);
end.
