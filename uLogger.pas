unit uLogger;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, Vcl.StdCtrls;

type
  TProcLog = procedure(Sender: TObject; pLog: string; pDataHora: TDateTime) of object;

  TLogger = class(TComponent)
  private
    FSavePath: string;
    FArquivoLog: TextFile;
    FActive: Boolean;
    FOnLogin: TProcLog;
    FSaveInFile: Boolean;
    FMemo: TMemo;
    procedure SetSavePath(const Value: string);
    procedure SetActive(const Value: Boolean);
    procedure CriarArquivo;

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure RegistrarLogTxt(const pTexto: string);
  published
    destructor Destroy; override;
    property SavePath: string read FSavePath write SetSavePath;
    property Active: Boolean read FActive write SetActive;
    property OnLogin: TProcLog read FOnLogin write FOnLogin;
    property SaveInFile: Boolean read FSaveInFile write FSaveInFile;
    property Memo: TMemo read FMemo write FMemo;

  end;

var
  FInstancia: TLogger;

procedure Register;

implementation
{$R Loggercomponent.dcr}

procedure Register;
begin
  RegisterComponents('TLogger', [TLogger]);
end;

{ TLogger }

constructor TLogger.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TLogger.Destroy;
begin
  FInstancia.Free;
  inherited;
end;

procedure TLogger.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation = TOperation.opRemove) and (AComponent = FMemo) then
    FMemo := Nil;
end;

procedure TLogger.CriarArquivo;
begin
  AssignFile(FArquivoLog, FSavePath + 'Logger.txt');

  if not FileExists(FSavePath + 'Logger.txt') then
  begin
    Rewrite(FArquivoLog);
    CloseFile(FArquivoLog);
  end;
end;

procedure TLogger.RegistrarLogTxt(const pTexto: string);
var
  lDataHora: string;
begin
  if not FActive then
    Exit;

  if Assigned(FOnLogin) then
    FOnLogin(Self, pTexto, Now);

  if Assigned(FMemo) then
    FMemo.Lines.Add(pTexto + ' - ' + DateToStr(Now));

  if FSaveInFile then
  begin
    CriarArquivo;

    Append(FArquivoLog);

    lDataHora := FormatDateTime('[dd/mm/yyyy hh:nn:ss] ', Now);
    WriteLn(FArquivoLog, lDataHora + pTexto);

    CloseFile(FArquivoLog);
  end;
end;

procedure TLogger.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

procedure TLogger.SetSavePath(const Value: string);
begin
  FSavePath := Value;
end;

end.
