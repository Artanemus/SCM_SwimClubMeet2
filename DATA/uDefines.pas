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
   SCM_SCROLL_NOMINATE =WM_USER + 12;
   SCM_CONNECT = WM_USER + 13;

 type
 scmSendToFileType = (sftPDF, sftXLS, sftHTML, sftIMG, sftNA);
 scmSendToDevice = (stdSendToPrinter, stdSendToFile);
 scmRptType = (rptSession, rptEvent, rptHeat, rptLane, rptNominee,
   rptMarshall, rptTimeKeeper, rptTeam, rptWatchTime, rptSplitTime);


/// <Remarks>
///  smCircleSeeding
///     - TTimes source from TTB in dbo.Nominee.
///  smTimedFinalsSeeding, smCircleSeedingTimed, smDualSeeding, smMastersChampionSeeding
///     - Times used originate from events held in current session
/// </Remarks>
 seedMethod = (
    smSCMSeeding = 0, // default SCM style of seeding.
    smCircleSeeding, // circle seeds to 'depth' then switches to smSCMSeeding.
    smTimedFinalsSeeding,
    smCircleSeedingTimed, // dummy placeholder.
    smDualSeeding, // dummy placeholder.
    smMastersChampionSeeding // dummy placeholder.
  );

 scmEventFinalsType = (ftFinals, ftSemi, ftQuarter, ftPrelim);
 scmHRType = (hrCoach = 1 , hrContact = 2, hrSwimmer = 3, hrParent = 4);
 scmEventType = (etUnknown = 0, etINDV = 1, etTEAM = 2);

 var
 scmSendToFileTypes: scmSendToFileType;
 scmSendToDevices: scmSendToDevice;
 scmRptTypes: scmRptType;

implementation

end.
