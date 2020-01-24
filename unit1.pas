unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, IdHTTP, IdAntiFreeze;

type

  { TForm1 }

  TForm1 = class(TForm)
    IdAntiFreeze1: TIdAntiFreeze;
    IdHTTP1: TIdHTTP;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  Stream: TMemoryStream;
begin
  if (FileExists('spw_update.exe') and FileExists('spw_mail.exe')) then
    CloseAction := caFree
  else
  begin
    if MessageDlg('Download addons?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      try
        try
          Stream := TMemoryStream.Create;
          IdHTTP1.Get('http://dww.no-ip.org/simplex/spw_update.exe', Stream);
          Stream.SaveToFile('spw_update.exe');
          IdHTTP1.Get('http://dww.no-ip.org/simplex/spw_mail.exe', Stream);
          Stream.SaveToFile('spw_mail.exe');
          IdHTTP1.Get('http://dww.no-ip.org/simplex/spw.ver', Stream);
          Stream.SaveToFile('spw.ver');
        finally
          Stream.Free;
          IdHTTP1.Disconnect;
          ShowMessage('File download completed');
        end;
      except
        ShowMessage('Unsuccessful attempt to receive files from the server');
      end;
    end
    else
      CloseAction := caFree;
  end;
end;

end.
