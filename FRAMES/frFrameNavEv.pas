unit frFrameNavEv;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ControlList,
  Vcl.Themes, Vcl.Styles, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.WinXCtrls,  Vcl.ActnList, Vcl.Menus, Vcl.WinXPanels,
  SVGIconImage,
  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  uUtility, uDefines,

  dmIMG, dmSCM2, dmCORE, frFrameNavEvItem;

type
  TNavEvItemSelected = procedure(Sender: TObject; EventID: Integer; EvItem:
      TFrameNavEvItem) of object;

  TFrameNavEv = class(TFrame)
    rpnlBody: TRelativePanel;
    spbtnNavLeft: TSpeedButton;
    spbtnNavRight: TSpeedButton;
    scrBox: TScrollBox;
  private
    procedure SelectNone();
    procedure Select(EventID: integer);
    procedure UpdateSelect(EventID: integer);

  public
    FOnNavEvItemSelected: TNavEvItemSelected;

    procedure ClearNavEvItems;
    procedure FillNavEvItems;
    function LocateNavEvItem(EventID: integer): Integer;

  protected
    procedure Msg_SCM_Frame_Selected(var Msg: TMessage); message SCM_FRAME_SELECTED;
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_EVENT;
    procedure Msg_SCM_Frame_Reset(var Msg: TMessage); message SCM_FRAME_RESET;
  end;

implementation

{$R *.dfm}

uses
  uSession, uEvent;

{ TFrameNavEvent }


procedure TFrameNavEv.ClearNavEvItems;
begin
  while scrBox.ControlCount > 0 do  // Clear existing frames.
    scrBox.Controls[0].Free;
end;

procedure TFrameNavEv.FillNavEvItems;
var
  Frame: TFrameNavEvItem;
  Q: TFDQuery;
begin
  // exception traps.
  if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
  if not Assigned(CORE) or not CORE.IsActive then exit;

  // 1. Performance: Disable UI updates
  scrBox.DisableAlign;
  Q := CORE.qryEvent; // improves readability.
  Q.DisableControls;
  try
    // 2. Clear existing frames
    while scrBox.ControlCount > 0 do
      scrBox.Controls[0].Free;

    if Q.IsEmpty then exit;   // nothing to display

    // 3. Loop through FireDAC / MS SQL Query
    Q.First;
    while not Q.Eof do
    begin
      Frame := TFrameNavEvItem.Create(nil);
      Frame.Parent := scrBox;
      Frame.ParentFrame := Self;

      // 4. Horizontal Alignment
      Frame.Align := alLeft;
      Frame.Margins.Right := 10; // Space between items
      Frame.AlignWithMargins := True;

      // Force it to the end of the list (important for alLeft)
      Frame.Left := MaxInt;

      // 5. Fill Data
      Frame.FillFromQuery(Q);

      // 6. Handle Clicks (Optional)
      // Capture the PK so we know which record was clicked.
      Frame.Tag := Q.FieldByName('EventID').AsInteger;

      Q.Next;
    end;
  finally
    Q.EnableControls;
    scrBox.EnableAlign;
  end;
end;

function TFrameNavEv.LocateNavEvItem(EventID: integer): Integer;
var
  I: integer;
begin
  result := 0;
  for I := 0 to scrBox.ControlCount - 1 do
  begin
    // assigned Item's Selected param and paint colors
    if (scrBox.Controls[I].Tag = EventID) then
    begin
      result := i;
      break;
    end;
  end;
end;

procedure TFrameNavEv.Msg_SCM_Frame_Reset(var Msg: TMessage);
begin
  FillNavEvItems();
end;

procedure CenterControlInScrollBox(AScrollBox: TScrollBox; ACtrl: TControl);
var
  TargetX, TargetY, MaxX, MaxY: Integer;
begin
  AScrollBox.Realign; // ensure child positions are final
  TargetX := ACtrl.Left + (ACtrl.Width div 2) - (AScrollBox.ClientWidth div 2);
  TargetY := ACtrl.Top  + (ACtrl.Height div 2) - (AScrollBox.ClientHeight div 2);

  MaxX := AScrollBox.HorzScrollBar.Range - AScrollBox.ClientWidth;
  MaxY := AScrollBox.VertScrollBar.Range - AScrollBox.ClientHeight;
  if MaxX < 0 then MaxX := 0;
  if MaxY < 0 then MaxY := 0;

  if TargetX < 0 then TargetX := 0 else if TargetX > MaxX then TargetX := MaxX;
  if TargetY < 0 then TargetY := 0 else if TargetY > MaxY then TargetY := MaxY;

  AScrollBox.HorzScrollBar.Position := TargetX;
  AScrollBox.VertScrollBar.Position := TargetY;
end;

procedure TFrameNavEv.Msg_SCM_Frame_Selected(var Msg: TMessage);
var
  SenderItem: TFrameNavEvItem;
  EventID: Integer;
begin
  if Msg.LParam <> 0 then
  begin
    // UI fixups.
    SenderItem := TFrameNavEvItem(Msg.LParam);
    scrBox.ScrollInView(SenderItem); // doesn't center control...

    // Get MainForm to re-locate [dbo].[Event].[EventID]
    EventID := Integer(Msg.WParam);
    if Assigned(FOnNavEvItemSelected) then
      FOnNavEvItemSelected(TObject(Self), EventID, SenderItem);
  end;
end;

procedure TFrameNavEv.Msg_SCM_Scroll_Event(var Msg: TMessage);
var
  aEventID: integer;
begin
  if Msg.WParam <> 0 then
  begin
    aEventID := LocateNavEvItem(Msg.WParam);
    if aEventID <> 0 then
    begin
      // TODO: center evItem on screen.
      UpdateSelect(aEventID);
    end;
  end;
end;

procedure TFrameNavEv.Select(EventID: integer);
var
  I: integer;
begin
  for I := 0 to scrBox.ControlCount - 1 do
  begin
    if (scrBox.Controls[I].Tag = EventID) then
      TFrameNavEvItem(scrBox.Controls[I]).Select(true);
  end;
end;

procedure TFrameNavEv.SelectNone;
var
  I: integer;
begin
  for I := 0 to scrBox.ControlCount - 1 do
    TFrameNavEvItem(scrBox.Controls[I]).Select(false);
end;

procedure TFrameNavEv.UpdateSelect(EventID: integer);
var
  I: integer;
begin
  for I := 0 to scrBox.ControlCount - 1 do
  begin
    // assigned Item's Selected param and paint colors
    if (scrBox.Controls[I].Tag = EventID) then
      TFrameNavEvItem(scrBox.Controls[I]).Select(true)
    else
      TFrameNavEvItem(scrBox.Controls[I]).Select(false);
  end;
end;

end.
