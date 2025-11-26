unit CoreSystems.Tools.Config;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IniFiles,
  WinAPI.Windows;

type
  TIniConfig = class
    private
      Last, Default: String;
      mIni: TMemIniFile;
    public
      constructor Create;
      destructor Destroy; reintroduce;
      procedure Init(aFn: String);
      function RInteger(const aIdent: String; out aValue: Integer):Boolean;
      function RInt64(const aIdent: String; out aValue: Int64):Boolean;
      function RDouble(const aIdent: String; out aValue: Double):Boolean;
      function RString(const aIdent: String; out aValue: String):Boolean;
      function RBoolean(const aIdent: String; out aValue: Boolean):Boolean;
      function WInteger(const aIdent: String; aValue: Integer):Boolean;
      function WInt64(const aIdent: String; aValue: Int64):Boolean;
      function WDouble(const aIdent: String; aValue: Double):Boolean;
      function WString(const aIdent: String; aValue: String):Boolean;
      function WBoolean(const aIdent: String; aValue: Boolean):Boolean;
      procedure SetDefaults;
    end;

implementation

{ TIniConfig }

constructor TIniConfig.Create;
  begin
    Last    := 'Last';
    Default := 'Default';
  end;

destructor TIniConfig.Destroy;
  begin
    mIni.UpdateFile;
    mIni.Free;
    inherited;
  end;

procedure TIniConfig.Init(aFn: String);
  begin
    if aFn = '' then
      begin
        MessageBox(0, 'InitConfigFailed. FN is Empty.', 'Error', MB_OK or MB_ICONERROR);
        Exit;
      end;
    if not FileExists(aFn) then
      begin
        MessageBox(0, 'InitConfigFailed. File Not Found.', 'Warning', MB_OK or MB_ICONWARNING);
        mIni := TMemIniFile.Create(aFn);
        mIni.UpdateFile;
      end
    else
      mIni := TMemIniFile.Create(aFn);
  end;

function TIniConfig.RBoolean(const aIdent: String; out aValue: Boolean): Boolean;
  var
    Found:Boolean;
  begin
    Found := False;
    if mIni.ValueExists(Default, aIdent) then
      begin
        aValue := mIni.ReadBool(Default, aIdent, False);
        Found := True;
      end;
    if mIni.ValueExists(Last, aIdent) then
      begin
        aValue := mIni.ReadBool(Last, aIdent, False);
        Found := True;
      end;
    Result := Found;
  end;

function TIniConfig.RDouble(const aIdent: String; out aValue: Double): Boolean;
  var
    Found: Boolean;
  begin
    Found := False;
    if mIni.ValueExists(Default, aIdent) then
      begin
        aValue := mIni.ReadFloat(Default, aIdent, 0);
        Found := True;
      end;
    if mIni.ValueExists(Last, aIdent) then
      begin
        aValue := mIni.ReadFloat(Last, aIdent, 0);
        Found := True;
      end;
    Result := Found;
  end;

function TIniConfig.RInt64(const aIdent: String; out aValue: Int64): Boolean;
  var
    Found:Boolean;
  begin
    Found := False;
    if mIni.ValueExists(Default, aIdent) then
      begin
        aValue := mIni.ReadInt64(Default, aIdent, 0);
        Found := True;
      end;
    if mIni.ValueExists(Last, aIdent) then
      begin
        aValue := mIni.ReadInt64(Last, aIdent, 0);
        Found := True;
      end;
    Result := Found;
  end;

function TIniConfig.RInteger(const aIdent: String; out aValue: Integer): Boolean;
  var
    Found:Boolean;
  begin
    Found := False;
    if mIni.ValueExists(Default, aIdent) then
      begin
        aValue := mIni.ReadInteger(Default, aIdent, 0);
        Found := True;
      end;
    if mIni.ValueExists(Last, aIdent) then
      begin
        aValue := mIni.ReadInteger(Last, aIdent, 0);
        Found := True;
      end;
    Result := Found;
  end;

function TIniConfig.RString(const aIdent: String; out aValue: String): Boolean;
  var
    Found:Boolean;
  begin
    Found := False;
    if mIni.ValueExists(Default, aIdent) then
      begin
        aValue := mIni.ReadString(Default, aIdent, '');
        Found := True;
      end;
    if mIni.ValueExists(Last, aIdent) then
      begin
        aValue := mIni.ReadString(Last, aIdent, '');
        Found := True;
      end;
    Result := Found;
  end;

function TIniConfig.WBoolean(const aIdent: String; aValue: Boolean): Boolean;
  begin
    mIni.WriteBool(Last, aIdent, aValue);
    mIni.UpdateFile;
    Result := true;
  end;

function TIniConfig.WDouble(const aIdent: String; aValue: Double): Boolean;
  begin
    mIni.WriteFloat(Last, aIdent, aValue);
    mIni.UpdateFile;
    Result := true;
  end;

function TIniConfig.WInt64(const aIdent: String; aValue: Int64): Boolean;
  begin
    mIni.WriteInt64(Last, aIdent, aValue);
    mIni.UpdateFile;
    Result := true;
  end;

function TIniConfig.WInteger(const aIdent: String; aValue: Integer): Boolean;
  begin
    mIni.WriteInteger(Last, aIdent, aValue);
    mIni.UpdateFile;
    Result := true;
  end;

function TIniConfig.WString(const aIdent: String; aValue: String): Boolean;
  begin
    mIni.WriteString(Last, aIdent, aValue);
    mIni.UpdateFile;
    Result := true;
  end;

procedure TIniConfig.SetDefaults;
  var
    LastKeys, DefaultKeys: TStringList;
    I: Integer;
    Key, Value: string;
  begin
    LastKeys := TStringList.Create;
    DefaultKeys := TStringList.Create;
    try
      LastKeys.CaseSensitive := False;
      DefaultKeys.CaseSensitive := False;
      mIni.ReadSection(Last, LastKeys);
      mIni.ReadSection(Default, DefaultKeys);
      for I := 0 to LastKeys.Count - 1 do
        begin
          Key := LastKeys[I];
          Value := mIni.ReadString(Last, Key, '');
          mIni.WriteString(Default, Key, Value);
        end;
      mIni.UpdateFile;
    finally
      LastKeys.Free;
      DefaultKeys.Free;
    end;
  end;

end.
