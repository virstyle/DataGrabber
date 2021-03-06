{
  Copyright (C) 2013-2016 Tim Sinaeve tim.sinaeve@gmail.com

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

unit ts.Connection.UNIConnectionAdapter;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB,

  UniProvider, DBAccess, UniDacVcl, Uni,

  AccessUniProvider,
  AdvantageUniProvider,
  ASEUniProvider,
  DB2UniProvider,
  InterBaseUniProvider,
  MySQLUniProvider,
  ODBCUniProvider,
  //OracleUniProvider,
  PostgreSQLUniProvider,
  //SQLiteUniProvider,
  SQLServerUniProvider,

  ts.Interfaces,

  ts.Connection.CustomConnectionAdapter;

type
  TUNIConnectionAdapter = class(TCustomConnectionAdapter, IConnection)
  private
    FConnection: TUniConnection;

  protected
    function GetConnectionType: string; override;
    function GetConnected: Boolean; override;
    procedure SetConnected(const Value: Boolean); override;
    function GetConnectionString: string; override;
    function GetConnection: TComponent; override;

    procedure AssignConnectionString(const AValue: string); override;
    procedure AssignConnectionSettings; override;

    function CreateNativeDataSet: INativeDataSet;
    function Execute(const ACommandText: string): Boolean; override;

  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

  end;

implementation

uses
  ts.Data.NativeUNI;

{$REGION 'construction and destruction'}
procedure TUNIConnectionAdapter.AfterConstruction;
begin
  inherited;
  FConnection := TUniConnection.Create(nil);
  UniProviders.GetProviderNames(Protocols);
end;

procedure TUNIConnectionAdapter.BeforeDestruction;
begin
  FConnection.Free;
  inherited;
end;
{$ENDREGION}

{$REGION 'property access methods'}
function TUNIConnectionAdapter.GetConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

procedure TUNIConnectionAdapter.SetConnected(const Value: Boolean);
begin
  if Value <> Connected then
  begin
    FConnection.Connected := Value;
  end;
end;

function TUNIConnectionAdapter.GetConnection: TComponent;
begin
  Result := FConnection;
end;

function TUNIConnectionAdapter.GetConnectionString: string;
begin
//
end;

function TUNIConnectionAdapter.GetConnectionType: string;
begin
  Result := 'UNI';
end;
{$ENDREGION}

{$REGION 'protected methods'}
procedure TUNIConnectionAdapter.AssignConnectionSettings;
var
  B: Boolean;
begin
  inherited;
  B := Connected;
  try
    if ConnectionSettings.Database <> '' then
    begin
      Connected := False;
      FConnection.Port         := ConnectionSettings.Port;
      FConnection.Database     := ConnectionSettings.Database;
      FConnection.Username     := ConnectionSettings.User;
      FConnection.Password     := ConnectionSettings.Password;
      FConnection.Server       := ConnectionSettings.HostName;
      FConnection.ProviderName := ConnectionSettings.Protocol;
      FConnection.Options.DisconnectedMode := ConnectionSettings.DisconnectedMode;
    end;
  finally
    Connected := B;
  end;
end;

procedure TUNIConnectionAdapter.AssignConnectionString(const AValue: string);
begin
  inherited;
// TODO
end;

function TUNIConnectionAdapter.CreateNativeDataSet: INativeDataSet;
begin
  Result := TNativeUNIDataSet.Create(Self);
end;

function TUNIConnectionAdapter.Execute(const ACommandText: string): Boolean;
begin
  Result := FConnection.ExecSQL(ACommandText, []);
end;
{$ENDREGION}

end.
