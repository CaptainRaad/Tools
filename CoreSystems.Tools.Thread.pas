unit CoreSystems.Tools.Thread;

interface

uses
  System.Classes,
  System.SysUtils,
  WinAPI.Windows;

type

  TUPSC = record
    UPS, UPSC, FQ, CPS, TS, PTS:Int64;
  end;

  TMiniThread = class(TThread)
  private
    UPSC : TUPSC;
    ThreadMethod  : procedure of Object;
    SleepInterval : Uint16;
  protected
    procedure Execute; override;
    procedure SyncMethod;
  public
    constructor Create;
    function GetUPS : Int64;
    procedure SetThreadMethod(Method : TMethod);
    procedure SetSleepInterval(Value : UInt16);
  end;

implementation

{ TMiniThread }

{
    LoopThread := TLoopThread.Create;
    LoopThread.SetSleepInterval(1);
    LoopThread.Priority := tpNormal;
    LoopThread.SetThreadMethod(Method);
}

{
    LoopThread.Terminate;
    LoopThread.WaitFor;
    LoopThread.Free;
}

constructor TMiniThread.Create;
  begin
    inherited;
    QUERYPERFORMANCEFREQUENCY(UPSC.FQ);
    QUERYPERFORMANCECOUNTER(UPSC.TS);
    UPSC.CPS := 8;  UPSC.PTS := 0;
    SleepInterval := 1;
  end;

procedure TMiniThread.Execute;
  begin
    inherited;
    repeat
      SyncMethod;
      inc(UPSC.UPSC);
      QUERYPERFORMANCECOUNTER(UPSC.TS);
      if UPSC.TS - UPSC.PTS > UPSC.FQ div UPSC.CPS then
        begin
          UPSC.UPS  := UPSC.UPSC * UPSC.CPS;
          UPSC.UPSC := 0;
          UPSC.PTS := UPSC.TS;
        end;
      Sleep(SleepInterval);
    until Terminated;
  end;

function TMiniThread.GetUPS: Int64;
  begin
    Result := UPSC.UPS;
  end;

procedure TMiniThread.SetSleepInterval(Value: UInt16);
  begin
    SleepInterval := Value;
  end;

procedure TMiniThread.SetThreadMethod(Method: TMethod);
  begin
    ThreadMethod := Method;
  end;

procedure TMiniThread.SyncMethod;
  begin
    Synchronize(ThreadMethod);
  end;

end.
