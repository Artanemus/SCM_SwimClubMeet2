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
    imgMenu: TVirtualImageList;
    imgList3: TVirtualImageList;
    imgNominate: TVirtualImageList;
    imgForm: TVirtualImageList;
    imglstHeatStatus: TSVGIconVirtualImageList;
    imglstHeatStroke: TSVGIconVirtualImageList;
    imglstHeatCntrl: TSVGIconVirtualImageList;
    imglstSessCntrl: TSVGIconVirtualImageList;
    imglstEventCntrl: TSVGIconVirtualImageList;
    imglstMemberCntrl: TSVGIconVirtualImageList;
    imglstSessPopupMenu: TSVGIconVirtualImageList;
    imglstMiscButtons: TSVGIconVirtualImageList;
    imglstLaneCntrl: TSVGIconVirtualImageList;
    imglstNomCheckBox: TSVGIconVirtualImageList;
    imglstNomQualified: TSVGIconVirtualImageList;
    imglstNomStroke: TSVGIconVirtualImageList;
    imglstNomEventType: TSVGIconVirtualImageList;
    imglstSessGrid: TSVGIconVirtualImageList;
    imglstTitleBar: TSVGIconVirtualImageList;
    CollectionTitleBar: TSVGIconImageCollection;
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  IMG: TIMG;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
