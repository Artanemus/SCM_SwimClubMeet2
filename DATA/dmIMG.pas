unit dmIMG;

interface

uses
  System.SysUtils, System.Classes, Vcl.BaseImageCollection,
	SVGIconImageCollection, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  SVGIconVirtualImageList, Vcl.ImageCollection, IconFontsImageCollection;

type
  TIMG = class(TDataModule)
    imglstEventStatus: TSVGIconVirtualImageList;
    CollectionCore: TSVGIconImageCollection;
    PNGCollection: TImageCollection;
    imglstHeatStatus: TSVGIconVirtualImageList;
    imglstHeatStroke: TSVGIconVirtualImageList;
    imglstHeatCntrl: TSVGIconVirtualImageList;
    imglstSessCntrl: TSVGIconVirtualImageList;
    imglstEventCntrl: TSVGIconVirtualImageList;
    imglstNomCntrl: TSVGIconVirtualImageList;
    imglstSessPopupMenu: TSVGIconVirtualImageList;
    imglstMiscButtons: TSVGIconVirtualImageList;
    imglstLaneCntrl: TSVGIconVirtualImageList;
    imglstNomCheckBox: TSVGIconVirtualImageList;
    imglstNomQualified: TSVGIconVirtualImageList;
    imglstNomStroke: TSVGIconVirtualImageList;
    imglstNomEventType: TSVGIconVirtualImageList;
    imglstSessGrid: TSVGIconVirtualImageList;
    imglstTitleBar: TSVGIconVirtualImageList;
    imglstSwimClubCntrl: TSVGIconVirtualImageList;
    imglstSwimClubArchived: TSVGIconVirtualImageList;
    imglstSwimClubGroup: TSVGIconVirtualImageList;
    imglstSwimClubCell: TSVGIconVirtualImageList;
    imglstClubGroup: TSVGIconVirtualImageList;
    imglstHeatStrokeEx: TSVGIconVirtualImageList;
    imglstStatusPanel: TSVGIconVirtualImageList;
    imglstMenuBar: TSVGIconVirtualImageList;
    imglstEventType: TSVGIconVirtualImageList;
    imglstEventCell: TSVGIconVirtualImageList;
    imglstEventPopupMenu: TSVGIconVirtualImageList;
  private
    { Private declarations }

  public
    { }

  end;

var
  IMG: TIMG;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
