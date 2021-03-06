{
  Copyright (C) 2013-2017 Tim Sinaeve tim.sinaeve@gmail.com

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

unit ts.Connection.DBXConnectionAdapter;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Data.SqlExpr,

  DBXMSSQL,
  Data.DBXMySQL,
  Data.DbxFirebird,
  Data.DbxInformix,
  Data.DBXInterbase,
  Data.DBXOdbc,
  Data.DbxOracle,
  Data.DbxSybaseASA,
  Data.DbxSybaseASE,

  ts.Interfaces,
  ts.Connection.CustomConnectionAdapter;

type
  TDBXConnectionAdapter = class(TCustomConnectionAdapter, IConnection)
  private
    FConnection: TSQLConnection;

  protected
    function GetConnectionType: string; override;
    function GetConnected: Boolean; override;
    procedure SetConnected(const Value: Boolean); override;
    function GetConnectionString: string; override;
    function GetConnection: TComponent; override;

    procedure AssignConnectionString(const AValue: string); override;
    procedure AssignConnectionSettings; override;

    function CreateNativeDataSet: INativeDataSet; override;
    function Execute(const ACommandText: string): Boolean; override;

  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

  end;

implementation

uses
  ts.Data.NativeDBX;

{$REGION 'construction and destruction'}
procedure TDBXConnectionAdapter.AfterConstruction;
begin
  inherited AfterConstruction;
  FConnection := TSQLConnection.Create(nil);
  GetDriverNames(Protocols);
end;

procedure TDBXConnectionAdapter.BeforeDestruction;
begin
  FConnection.Free;
  inherited BeforeDestruction;
end;
{$ENDREGION}

{$REGION 'property access methods'}
function TDBXConnectionAdapter.GetConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

procedure TDBXConnectionAdapter.SetConnected(const Value: Boolean);
begin
  if Value <> Connected then
  begin
    try
      FConnection.Connected := Value;
    except
      FConnection.Connected := False;
    end;
  end;
end;

function TDBXConnectionAdapter.GetConnection: TComponent;
begin
  Result := FConnection;
end;

function TDBXConnectionAdapter.GetConnectionString: string;
begin
  Result := FConnection.ConnectionData.Properties.Properties.Text;
end;

function TDBXConnectionAdapter.GetConnectionType: string;
begin
  Result := 'DBX';
end;
{$ENDREGION}

{$REGION 'protected methods'}
procedure TDBXConnectionAdapter.AssignConnectionSettings;
var
  B: Boolean;
begin
  inherited AssignConnectionSettings;
  B := Connected;
  try
    if ConnectionSettings.Protocol <> '' then
    begin
      Connected := False;
      FConnection.DriverName := ConnectionSettings.Protocol;
      FConnection.KeepConnection := not ConnectionSettings.DisconnectedMode;
      with FConnection.ConnectionData.Properties do
      begin
        Values['HostName']          := ConnectionSettings.HostName;
        Values['Port']              := IntToStr(ConnectionSettings.Port);
        Values['Database']          := ConnectionSettings.Database;
        Values['User_Name']         := ConnectionSettings.User;
        Values['Password']          := ConnectionSettings.Password;
        Values['OS Authentication'] := 'True';
      end;
    end;
  finally
    Connected := B;
  end;
end;

procedure TDBXConnectionAdapter.AssignConnectionString(const AValue: string);
begin
  FConnection.ConnectionData.Properties.Properties.Text := AValue;
end;

function TDBXConnectionAdapter.CreateNativeDataSet: INativeDataSet;
begin
  Result := TNativeDBXDataSet.Create(Self);
end;

function TDBXConnectionAdapter.Execute(const ACommandText: string): Boolean;
begin
  FConnection.ExecuteDirect(ACommandText);
  Result := True;
end;
{$ENDREGION}

end.
