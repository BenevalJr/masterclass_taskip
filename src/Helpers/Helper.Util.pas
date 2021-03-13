unit Helper.Util;

interface
uses
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  System.Generics.Collections;

type
  Util = class
  public
    class function FormatName(const AText: string): string;
    class function GetAge(const AThen: TDateTime): Integer;
  end;

implementation

{ Util }

class function Util.FormatName(const AText: string): string;
const
  DELIMITER = ' ';
var
  LSplittedString: TArray<string>;
  LString: string;
begin
  Result := EmptyStr;
  LSplittedString := SplitString(AText, DELIMITER);

  for LString in LSplittedString do
    Result := Concat(Result, AnsiUppercase(Copy(LString, 1, 1)) + AnsiLowercase(Copy(LString, 2, Length(LString))), DELIMITER);

  Result := Trim(Result);
end;

class function Util.GetAge(const AThen: TDateTime): Integer;
begin
  Result := Round(YearSpan(Today, AThen));
end;

end.
