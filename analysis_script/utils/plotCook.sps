* Encoding: UTF-8.
GGRAPH
    /GRAPHDATASET NAME="graphdataset" VARIABLES=VP COO_1 Substance_Group MISSING=LISTWISE
    REPORTMISSING=NO
    /GRAPHSPEC SOURCE=INLINE
    /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
    SOURCE: s=userSource(id("graphdataset"))
    DATA: VP=col(source(s), name("VP"))
    DATA: COO_1=col(source(s), name("COO_1"))
    DATA: Substance_Group=col(source(s), name("Substance_Group"), unit.category())
    GUIDE: axis(dim(1), label("VP"))
    GUIDE: axis(dim(2), label("Cook's Distance"))
    GUIDE: legend(aesthetic(aesthetic.color.interior), label("Substance Group"))
    GUIDE: text.title(label("Scatter Plot of Cook's Distance by VP by Substance Group"))
    SCALE: cat(aesthetic(aesthetic.color.interior), include(
    ".0", "1.0", "2.0"))
    ELEMENT: point(position(VP*COO_1), color.interior(Substance_Group))
END GPL.

