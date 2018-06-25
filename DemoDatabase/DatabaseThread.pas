unit DatabaseThread;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  DB, ADODB, ActiveX;

type
  TLightDataset = class;
  TDatabaseThread = class;

  TDatasetEvent = procedure(Sender: TObject; Dataset: TLightDataset) of object;

  TExceptionEvent = procedure(Sender: TObject; E: Exception) of object;

  //Mimics a dataset, but using strings only and extremely basic functionality.
  //  Just serves as a dirty way to carry data from one thread to another.
  //  Presumably, you would be populating your own properties of an object
  //  using the data returned in the dataset.
  TLightDataset = class(TObject)
  private
    FColDefs: TStringList;
    FRows: TObjectList<TStringList>;
    procedure Clear;
    function GetCol(const Index: Integer): String;
    function GetRow(const Index: Integer): TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromDataset(ADataset: TDataset);
  public
    function ColCount: Integer;
    function RowCount: Integer;
    property Cols[const Index: Integer]: String read GetCol;
    property Rows[const Index: Integer]: TStringList read GetRow;
  end;

  //Encapsulates a database connection inside of a thread.
  TDatabaseThread = class(TThread)
  private
    FDB: TADOConnection;
    FQry: TADOQuery;
    FSql: TStringList;
    FConnStr: String;
    FData: TLightDataset;
    FException: Exception;
    FOnData: TDatasetEvent;
    FOnException: TExceptionEvent;
    procedure Init;
    procedure Uninit;
    procedure SetSql(const Value: TStrings);
    function GetSql: TStrings;
    procedure SetConnStr(const Value: String);
  protected
    procedure Execute; override;
    procedure SYNC_OnData;
    procedure SYNC_OnException;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    property ConnStr: String read FConnStr write SetConnStr;
    property Sql: TStrings read GetSql write SetSql;
    property OnData: TDatasetEvent read FOnData write FOnData;
    property OnException: TExceptionEvent read FOnException write FOnException;
  end;

implementation

{ TLightDataset }

constructor TLightDataset.Create;
begin
  FColDefs:= TStringList.Create;
  FRows:= TObjectList<TStringList>.Create(True);
end;

destructor TLightDataset.Destroy;
begin
  FreeAndNil(FRows);
  FreeAndNil(FColDefs);
  inherited;
end;

procedure TLightDataset.Clear;
begin
  FColDefs.Clear;
  FRows.Clear;
end;

procedure TLightDataset.LoadFromDataset(ADataset: TDataset);
var
  X: Integer;
  R: TStringList;
begin
  //Populates object structure based on data in a dataset.

  //First, clear existing data...
  Clear;

  //Populate field (column) names...
  for X := 0 to ADataset.Fields.Count-1 do begin
    FColDefs.Append(ADataset.Fields[X].FieldName);
  end;

  //Populate rows and their data as strings...
  ADataset.First;
  while not ADataset.Eof do begin
    R:= TStringList.Create;
    try
      for X := 0 to ADataset.Fields.Count-1 do begin
        try
          R.Append(ADataset.Fields[X].AsString);
        except
          //In case there's a data type that can't be copied to a string...
          R.Append('(ERROR)');
        end;
      end;
    finally
      FRows.Add(R);
    end;
    ADataset.Next;
  end;

end;

function TLightDataset.ColCount: Integer;
begin
  Result:= Self.FColDefs.Count;
end;

function TLightDataset.RowCount: Integer;
begin
  Result:= Self.FRows.Count;
end;

function TLightDataset.GetCol(const Index: Integer): String;
begin
  Result:= Self.FColDefs[Index];
end;

function TLightDataset.GetRow(const Index: Integer): TStringList;
begin
  Result:= Self.FRows[Index];
end;

{ TDatabaseThread }

constructor TDatabaseThread.Create;
begin
  inherited Create(True); //Suspended, so it will need to be started manually.
  FSql:= TStringList.Create;
  //We can't create database components here, because they require COM.
  //  Instead, they get created within the thread context itself.
end;

destructor TDatabaseThread.Destroy;
begin
  FreeAndNil(FSql);
  inherited;
end;

function TDatabaseThread.GetSql: TStrings;
begin
  Result:= TStrings(FSql);
end;

procedure TDatabaseThread.SetSql(const Value: TStrings);
begin
  FSql.Assign(Value);
end;

procedure TDatabaseThread.SetConnStr(const Value: String);
begin
  FConnStr := Value;
end;

procedure TDatabaseThread.SYNC_OnData;
begin
  if Assigned(FOnData) then
    FOnData(Self, FData);
end;

procedure TDatabaseThread.SYNC_OnException;
begin
  if Assigned(FOnException) then
    FOnException(Self, FException);
end;

procedure TDatabaseThread.Init;
begin
  //Since ADO is based on COM, we have to initialize COM within this thread...
  CoInitialize(nil);
  //Now it's safe to use ADO...
  FDB:= TADOConnection.Create(nil);
  FDB.LoginPrompt:= False;
  FQry:= TADOQuery.Create(nil);
  FQry.Connection:= FDB;
  FData:= TLightDataset.Create;
end;

procedure TDatabaseThread.Uninit;
begin
  FreeAndNil(FData);
  FQry.Close;
  FDB.Connected:= False;
  FreeAndNil(FQry);
  FreeAndNil(FDB);
  //When we're done using COM...
  CoUninitialize;
end;

procedure TDatabaseThread.Execute;
begin
  Init;
  try
    try
      //Now we are actually using the database components...
      FDB.ConnectionString:= FConnStr;
      FDB.Connected:= True;
      FQry.SQL.Assign(FSql);
      FQry.Open;
      try
        //Copy data over to lightweight (thread safe) object...
        FData.LoadFromDataset(FQry);
      finally
        FQry.Close;
      end;
      //Once we have the data, we synchronize it back to the caller...
      Synchronize(SYNC_OnData);
    except
      on E: Exception do begin
        //If any exception happens, synchronize it back to the caller...
        FException:= E;
        Synchronize(SYNC_OnException);
      end;
    end;
  finally
    Uninit;
  end;
  Terminate;
end;

end.
