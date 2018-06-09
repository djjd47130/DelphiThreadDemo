unit DatabaseThread;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  DB, ADODB, ActiveX;

type
  //Mimics a dataset, but using strings only and extremely basic functionality.
  //  Just serves as a dirty way to carry data from one thread to another.
  //  Presumably, you would be populating your own properties of an object
  //  using the data returned in the dataset.
  TLightDataset = class(TObject)
  private
    FColDefs: TStringList;
    FRows: TObjectList<TStringList>;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromDataset(ADataset: TDataset);
  end;

  //Encapsulates a database connection inside of a thread.
  TDatabaseThread = class(TThread)
  private
    FDB: TADOConnection;
    procedure Init;
    procedure Uninit;
  protected
    procedure Execute; override;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
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
          R.Append('(ERROR)'); //TODO
        end;
      end;
    finally
      FRows.Add(R);
    end;
    ADataset.Next;
  end;

end;

{ TDatabaseThread }

constructor TDatabaseThread.Create;
begin
  inherited Create(True);

end;

destructor TDatabaseThread.Destroy;
begin

  inherited;
end;

procedure TDatabaseThread.Init;
begin
  CoInitialize(nil);
  FDB:= TADOConnection.Create(nil);
end;

procedure TDatabaseThread.Uninit;
begin
  FDB.Connected:= False;
  FreeAndNil(FDB);
end;

procedure TDatabaseThread.Execute;
begin
  Init;
  try

  finally
    Uninit;
  end;
end;

end.
