object frmDataInspector: TfrmDataInspector
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Datainspector'
  ClientHeight = 225
  ClientWidth = 233
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  ScreenSnap = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 233
    Height = 225
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object dscMain: TDataSource
    OnDataChange = dscMainDataChange
    Left = 16
    Top = 8
  end
  object aclMain: TActionList
    Left = 120
    Top = 8
    object actHideEmptyFields: TAction
      AutoCheck = True
      Caption = 'Hide empty fields'
      Checked = True
      OnExecute = actHideEmptyFieldsExecute
    end
  end
  object ppmMain: TPopupMenu
    Left = 64
    Top = 8
    object mniHideEmptyFields: TMenuItem
      Action = actHideEmptyFields
      AutoCheck = True
    end
  end
end
