unit CoreSystems.Tools.Log;

interface

uses
  System.Classes,
  System.SysUtils,
  WinAPI.Windows,
  Generics.Collections;

type
  TLog = class
    private type
      SStack = TStack<String>;
    private
      Stack:SStack;
      procedure Drop(const AArray: TArray<string>);
    public
      LogName:String;
      MaxLogLength:Int32;
      procedure Push(aMsg:String);
      constructor Create;
      procedure DropLog;
      destructor Destroy;  override;
    end;

implementation

{ TLog }

constructor TLog.Create;
  begin
    Stack := SStack.Create;
    MaxLogLength := 131072;
    Push('LogCreated');
  end;

destructor TLog.Destroy;
  begin
    Drop(Stack.ToArray);
    Stack.Free;
    inherited destroy;
  end;

procedure TLog.DropLog;
  begin
    Drop(Stack.ToArray);
  end;

procedure TLog.Push(aMsg: String);
  var
    TS:Int64;
  begin
    QUERYPERFORMANCECOUNTER(TS);
    Stack.Push(TS.ToString + ' ' + aMsg);
    if Stack.Count > MaxLogLength then
      Drop(Stack.ToArray);
  end;

procedure TLog.Drop(const AArray: TArray<string>);
  var
    List: TStringList;
    TS:Int64;
  begin
    QUERYPERFORMANCECOUNTER(TS);
    List := TStringList.Create;
    try
      List.AddStrings(AArray);
      List.SaveToFile(LogName + TS.ToString + '.log', TEncoding.UTF8);
      Stack.Clear;
    finally
      List.Free;
      Push('LogDropped');
    end;
  end;

end.
