unit uDefines;

interface
uses
  Winapi.Messages;

const
   SCM_SWIMCLUB_UI = WM_USER + 1;
   SCM_SESSION_UI = WM_USER + 2;
   SCM_EVENT_UI = WM_USER + 3;
   SCM_HEAT_UI = WM_USER + 4;
   SCM_LANE_UI = WM_USER + 5;
   SCM_NOMINATE_UI = WM_USER + 6;
   SCM_SCROLL_SWIMCLUB  = WM_USER + 7;
   SCM_SCROLL_SESSION  = WM_USER + 8;
   SCM_SCROLL_EVENT  = WM_USER + 9;
   SCM_SCROLL_HEAT  = WM_USER + 10;
   SCM_SCROLL_LANE  = WM_USER + 11;
   SCM_SCROLL_NOMINATE = WM_USER + 12; // currently (2025.11.13) not in use.
   SCM_SCROLL_NOMINATE_FILTERMEMBER = WM_USER + 13;
   SCM_CONNECT = WM_USER + 14;
   SCM_DISCONNECT = WM_USER + 15;

  SCM_MEMBER_SCROLL = WM_USER + 100; { Manage Members datamodule. }
  SCM_MEMBER_LOCATE = WM_USER +101;
  SCM_MEMBER_UPDATE_DOB = WM_USER +102;
  SCM_MEMBER_UPDATE_ELECTEDON = WM_USER +103;
  SCM_MEMBER_UPDATE_RETIREDON = WM_USER +104;
  SCM_MEMBER_AFTERPOST = WM_USER +105;
  SCM_MEMBER_AFTERSCROLL = WM_USER +106;
  SCM_MEMBER_FILTER_CHANGED = WM_USER +108;


 type
 scmSendToFileType = (sftPDF, sftXLS, sftHTML, sftIMG, sftNA);
 scmSendToDevice = (stdSendToPrinter, stdSendToFile);
 scmRptType = (rptSession, rptEvent, rptHeat, rptLane, rptNominee,
   rptMarshall, rptTimeKeeper, rptTeam, rptWatchTime, rptSplitTime);
 scmSeedDateAuto = (sdaTodaysDate, sdaSessionDate, sdaStartOfSeason);


/// <Remarks>
///  smCircleSeeding
///     - TTimes source from TTB in dbo.Nominee.
///  smTimedFinalsSeeding, smCircleSeedingTimed, smDualSeeding, smMastersChampionSeeding
///     - Times used originate from events held in current session
/// </Remarks>
 seedMethod = (
    smSCMSeeding = 0, // default SCM2 style of seeding.
    smCircleSeeding, // circle seeds to 'depth' then switches to smSCMSeeding.
    smTimedFinalsSeeding,
    smCircleSeedingTimed, // dummy placeholder.
    smDualSeeding, // dummy placeholder.
    smMastersChampionSeeding // dummy placeholder.
  );

 scmEventFinalsType = (ftFinals, ftSemi, ftQuarter, ftPrelim);
 scmHRType = (hrCoach = 1 , hrContact = 2, hrSwimmer = 3, hrParent = 4);
 scmEventType = (etUnknown = 0, etINDV = 1, etTEAM = 2);
 scmMoveDirection = (mdUp = 1, mdDown = 2);

 var
 scmSendToFileTypes: scmSendToFileType;
 scmSendToDevices: scmSendToDevice;
 scmRptTypes: scmRptType;

implementation

end.
