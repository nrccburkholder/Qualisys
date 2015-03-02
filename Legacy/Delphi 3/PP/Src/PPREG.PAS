unit Ppreg;

interface

uses Classes, dsgnintf, ppmain, ppdb, ppext;

procedure register;

implementation

procedure Register;
begin
  RegisterComponents('PowerPanels', [TGlobalAttributes,
                                TPowerPanel,
                                TPPCap,
                                TPPStatus,
                                TPPEdit,
                                TPPLabel,
                                TPPTabbedNB,
                                TPPTabsetAndNB,
                                TPPListBox,
                                TPPMemo,
                                TPPOutLine,
                                TPPStringGrid,
                                TPPDrawGrid,
                                TPPDirList,
                                TPPFileList,
                                TPPFileManager,
                                TPPDBGrid,
                                TPPDbGridAccess,
                                TPPDBNav,
                                TPPDBNavSplit]);

  RegisterClasses([TEditAligned,
                   TPPDBNavLeft,
                   TPPDBNavRight,
                   TFilterBoxAligned,
                   TDriveBoxAligned,
                   TPPFilter,
                   TPPDrive]);
  RegisterComponentEditor(TPowerPanel, TPowerPanelEditor);
  RegisterComponentEditor(TGlobalAttributes, TGlobalAttributesEditor);
  RegisterPropertyEditor(TypeInfo(TAboutPowerPanel), TPowerPanel, 'About', TAboutPowerPanel)

end;
end.
