update Vendors
set LocalFTPLoginName = 'DRG'
where Vendor_Nm = 'Discovery'

update Vendors
set LocalFTPLoginName = 'ISA'
where Vendor_Nm = 'ISA'

update tm
set ModuleName = 'TranslatorTABHorz',
    FileType = '*.TXT'
from Vendors vd, DL_TranslationModules tm
where vd.Vendor_ID = tm.Vendor_ID
  and vd.Vendor_Nm = 'ISA'
  