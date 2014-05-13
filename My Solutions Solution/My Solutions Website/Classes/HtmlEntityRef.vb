Public NotInheritable Class HtmlEntityRef

    Private Sub New()

    End Sub

    Private Shared ReadOnly mDecodeRef As New Dictionary(Of String, Char)
    Private Shared ReadOnly mEncodeRef As New Dictionary(Of Char, String)

    Shared Sub New()

        'Portions © International Organization for Standardization 1986
        'Permission to copy in any form is granted for use with
        'conforming SGML systems and applications as defined in
        'ISO 8879, provided this notice is included in all copies.

        AddEntity("&nbsp;", ChrW(160)) ' no-break space = non-breaking space, U+00A0 ISOnum
        AddEntity("&iexcl;", ChrW(161)) ' inverted exclamation mark, U+00A1 ISOnum
        AddEntity("&cent;", ChrW(162)) ' cent sign, U+00A2 ISOnum
        AddEntity("&pound;", ChrW(163)) ' pound sign, U+00A3 ISOnum
        AddEntity("&curren;", ChrW(164)) ' currency sign, U+00A4 ISOnum
        AddEntity("&yen;", ChrW(165)) ' yen sign = yuan sign, U+00A5 ISOnum
        AddEntity("&brvbar;", ChrW(166)) ' broken bar = broken vertical bar, U+00A6 ISOnum
        AddEntity("&sect;", ChrW(167)) ' section sign, U+00A7 ISOnum
        AddEntity("&uml;", ChrW(168)) ' diaeresis = spacing diaeresis, U+00A8 ISOdia
        AddEntity("&copy;", ChrW(169)) ' copyright sign, U+00A9 ISOnum
        AddEntity("&ordf;", ChrW(170)) ' feminine ordinal indicator, U+00AA ISOnum
        AddEntity("&laquo;", ChrW(171)) ' left-pointing double angle quotation mark = left pointing guillemet, U+00AB ISOnum
        AddEntity("&not;", ChrW(172)) ' not sign, U+00AC ISOnum
        AddEntity("&shy;", ChrW(173)) ' soft hyphen = discretionary hyphen, U+00AD ISOnum
        AddEntity("&reg;", ChrW(174)) ' registered sign = registered trade mark sign, U+00AE ISOnum
        AddEntity("&macr;", ChrW(175)) ' macron = spacing macron = overline = APL overbar, U+00AF ISOdia
        AddEntity("&deg;", ChrW(176)) ' degree sign, U+00B0 ISOnum
        AddEntity("&plusmn;", ChrW(177)) ' plus-minus sign = plus-or-minus sign, U+00B1 ISOnum
        AddEntity("&sup2;", ChrW(178)) ' superscript two = superscript digit two = squared, U+00B2 ISOnum
        AddEntity("&sup3;", ChrW(179)) ' superscript three = superscript digit three = cubed, U+00B3 ISOnum
        AddEntity("&acute;", ChrW(180)) ' acute accent = spacing acute, U+00B4 ISOdia
        AddEntity("&micro;", ChrW(181)) ' micro sign, U+00B5 ISOnum
        AddEntity("&para;", ChrW(182)) ' pilcrow sign = paragraph sign, U+00B6 ISOnum
        AddEntity("&middot;", ChrW(183)) ' middle dot = Georgian comma = Greek middle dot, U+00B7 ISOnum
        AddEntity("&cedil;", ChrW(184)) ' cedilla = spacing cedilla, U+00B8 ISOdia
        AddEntity("&sup1;", ChrW(185)) ' superscript one = superscript digit one, U+00B9 ISOnum
        AddEntity("&ordm;", ChrW(186)) ' masculine ordinal indicator, U+00BA ISOnum
        AddEntity("&raquo;", ChrW(187)) ' right-pointing double angle quotation mark = right pointing guillemet, U+00BB ISOnum
        AddEntity("&frac14;", ChrW(188)) ' vulgar fraction one quarter = fraction one quarter, U+00BC ISOnum
        AddEntity("&frac12;", ChrW(189)) ' vulgar fraction one half = fraction one half, U+00BD ISOnum
        AddEntity("&frac34;", ChrW(190)) ' vulgar fraction three quarters = fraction three quarters, U+00BE ISOnum
        AddEntity("&iquest;", ChrW(191)) ' inverted question mark = turned question mark, U+00BF ISOnum
        AddEntity("&Agrave;", ChrW(192)) ' latin capital letter A with grave = latin capital letter A grave, U+00C0 ISOlat1
        AddEntity("&Aacute;", ChrW(193)) ' latin capital letter A with acute, U+00C1 ISOlat1
        AddEntity("&Acirc;", ChrW(194)) ' latin capital letter A with circumflex, U+00C2 ISOlat1
        AddEntity("&Atilde;", ChrW(195)) ' latin capital letter A with tilde, U+00C3 ISOlat1
        AddEntity("&Auml;", ChrW(196)) ' latin capital letter A with diaeresis, U+00C4 ISOlat1
        AddEntity("&Aring;", ChrW(197)) ' latin capital letter A with ring above = latin capital letter A ring, U+00C5 ISOlat1
        AddEntity("&AElig;", ChrW(198)) ' latin capital letter AE = latin capital ligature AE, U+00C6 ISOlat1
        AddEntity("&Ccedil;", ChrW(199)) ' latin capital letter C with cedilla, U+00C7 ISOlat1
        AddEntity("&Egrave;", ChrW(200)) ' latin capital letter E with grave, U+00C8 ISOlat1
        AddEntity("&Eacute;", ChrW(201)) ' latin capital letter E with acute, U+00C9 ISOlat1
        AddEntity("&Ecirc;", ChrW(202)) ' latin capital letter E with circumflex, U+00CA ISOlat1
        AddEntity("&Euml;", ChrW(203)) ' latin capital letter E with diaeresis, U+00CB ISOlat1
        AddEntity("&Igrave;", ChrW(204)) ' latin capital letter I with grave, U+00CC ISOlat1
        AddEntity("&Iacute;", ChrW(205)) ' latin capital letter I with acute, U+00CD ISOlat1
        AddEntity("&Icirc;", ChrW(206)) ' latin capital letter I with circumflex, U+00CE ISOlat1
        AddEntity("&Iuml;", ChrW(207)) ' latin capital letter I with diaeresis, U+00CF ISOlat1
        AddEntity("&ETH;", ChrW(208)) ' latin capital letter ETH, U+00D0 ISOlat1
        AddEntity("&Ntilde;", ChrW(209)) ' latin capital letter N with tilde, U+00D1 ISOlat1
        AddEntity("&Ograve;", ChrW(210)) ' latin capital letter O with grave, U+00D2 ISOlat1
        AddEntity("&Oacute;", ChrW(211)) ' latin capital letter O with acute, U+00D3 ISOlat1
        AddEntity("&Ocirc;", ChrW(212)) ' latin capital letter O with circumflex, U+00D4 ISOlat1
        AddEntity("&Otilde;", ChrW(213)) ' latin capital letter O with tilde, U+00D5 ISOlat1
        AddEntity("&Ouml;", ChrW(214)) ' latin capital letter O with diaeresis, U+00D6 ISOlat1
        AddEntity("&times;", ChrW(215)) ' multiplication sign, U+00D7 ISOnum
        AddEntity("&Oslash;", ChrW(216)) ' latin capital letter O with stroke = latin capital letter O slash, U+00D8 ISOlat1
        AddEntity("&Ugrave;", ChrW(217)) ' latin capital letter U with grave, U+00D9 ISOlat1
        AddEntity("&Uacute;", ChrW(218)) ' latin capital letter U with acute, U+00DA ISOlat1
        AddEntity("&Ucirc;", ChrW(219)) ' latin capital letter U with circumflex, U+00DB ISOlat1
        AddEntity("&Uuml;", ChrW(220)) ' latin capital letter U with diaeresis, U+00DC ISOlat1
        AddEntity("&Yacute;", ChrW(221)) ' latin capital letter Y with acute, U+00DD ISOlat1
        AddEntity("&THORN;", ChrW(222)) ' latin capital letter THORN, U+00DE ISOlat1
        AddEntity("&szlig;", ChrW(223)) ' latin small letter sharp s = ess-zed, U+00DF ISOlat1
        AddEntity("&agrave;", ChrW(224)) ' latin small letter a with grave = latin small letter a grave, U+00E0 ISOlat1
        AddEntity("&aacute;", ChrW(225)) ' latin small letter a with acute, U+00E1 ISOlat1
        AddEntity("&acirc;", ChrW(226)) ' latin small letter a with circumflex, U+00E2 ISOlat1
        AddEntity("&atilde;", ChrW(227)) ' latin small letter a with tilde, U+00E3 ISOlat1
        AddEntity("&auml;", ChrW(228)) ' latin small letter a with diaeresis, U+00E4 ISOlat1
        AddEntity("&aring;", ChrW(229)) ' latin small letter a with ring above = latin small letter a ring, U+00E5 ISOlat1
        AddEntity("&aelig;", ChrW(230)) ' latin small letter ae = latin small ligature ae, U+00E6 ISOlat1
        AddEntity("&ccedil;", ChrW(231)) ' latin small letter c with cedilla, U+00E7 ISOlat1
        AddEntity("&egrave;", ChrW(232)) ' latin small letter e with grave, U+00E8 ISOlat1
        AddEntity("&eacute;", ChrW(233)) ' latin small letter e with acute, U+00E9 ISOlat1
        AddEntity("&ecirc;", ChrW(234)) ' latin small letter e with circumflex, U+00EA ISOlat1
        AddEntity("&euml;", ChrW(235)) ' latin small letter e with diaeresis, U+00EB ISOlat1
        AddEntity("&igrave;", ChrW(236)) ' latin small letter i with grave, U+00EC ISOlat1
        AddEntity("&iacute;", ChrW(237)) ' latin small letter i with acute, U+00ED ISOlat1
        AddEntity("&icirc;", ChrW(238)) ' latin small letter i with circumflex, U+00EE ISOlat1
        AddEntity("&iuml;", ChrW(239)) ' latin small letter i with diaeresis, U+00EF ISOlat1
        AddEntity("&eth;", ChrW(240)) ' latin small letter eth, U+00F0 ISOlat1
        AddEntity("&ntilde;", ChrW(241)) ' latin small letter n with tilde, U+00F1 ISOlat1
        AddEntity("&ograve;", ChrW(242)) ' latin small letter o with grave, U+00F2 ISOlat1
        AddEntity("&oacute;", ChrW(243)) ' latin small letter o with acute, U+00F3 ISOlat1
        AddEntity("&ocirc;", ChrW(244)) ' latin small letter o with circumflex, U+00F4 ISOlat1
        AddEntity("&otilde;", ChrW(245)) ' latin small letter o with tilde, U+00F5 ISOlat1
        AddEntity("&ouml;", ChrW(246)) ' latin small letter o with diaeresis, U+00F6 ISOlat1
        AddEntity("&divide;", ChrW(247)) ' division sign, U+00F7 ISOnum
        AddEntity("&oslash;", ChrW(248)) ' latin small letter o with stroke, = latin small letter o slash, U+00F8 ISOlat1
        AddEntity("&ugrave;", ChrW(249)) ' latin small letter u with grave, U+00F9 ISOlat1
        AddEntity("&uacute;", ChrW(250)) ' latin small letter u with acute, U+00FA ISOlat1
        AddEntity("&ucirc;", ChrW(251)) ' latin small letter u with circumflex, U+00FB ISOlat1
        AddEntity("&uuml;", ChrW(252)) ' latin small letter u with diaeresis, U+00FC ISOlat1
        AddEntity("&yacute;", ChrW(253)) ' latin small letter y with acute, U+00FD ISOlat1
        AddEntity("&thorn;", ChrW(254)) ' latin small letter thorn, U+00FE ISOlat1
        AddEntity("&yuml;", ChrW(255)) ' latin small letter y with diaeresis, U+00FF ISOlat1

        'Latin Extended-B
        AddEntity("&fnof;", ChrW(402)) ' latin small f with hook = function = florin, U+0192 ISOtech

        ' Greek
        AddEntity("&Alpha;", ChrW(913)) ' greek capital letter alpha, U+0391
        AddEntity("&Beta;", ChrW(914)) ' greek capital letter beta, U+0392
        AddEntity("&Gamma;", ChrW(915)) ' greek capital letter gamma, U+0393 ISOgrk3
        AddEntity("&Delta;", ChrW(916)) ' greek capital letter delta, U+0394 ISOgrk3
        AddEntity("&Epsilon;", ChrW(917)) ' greek capital letter epsilon, U+0395
        AddEntity("&Zeta;", ChrW(918)) ' greek capital letter zeta, U+0396
        AddEntity("&Eta;", ChrW(919)) ' greek capital letter eta, U+0397
        AddEntity("&Theta;", ChrW(920)) ' greek capital letter theta, U+0398 ISOgrk3
        AddEntity("&Iota;", ChrW(921)) ' greek capital letter iota, U+0399
        AddEntity("&Kappa;", ChrW(922)) ' greek capital letter kappa, U+039A
        AddEntity("&Lambda;", ChrW(923)) ' greek capital letter lambda, U+039B ISOgrk3
        AddEntity("&Mu;", ChrW(924)) ' greek capital letter mu, U+039C
        AddEntity("&Nu;", ChrW(925)) ' greek capital letter nu, U+039D
        AddEntity("&Xi;", ChrW(926)) ' greek capital letter xi, U+039E ISOgrk3
        AddEntity("&Omicron;", ChrW(927)) ' greek capital letter omicron, U+039F
        AddEntity("&Pi;", ChrW(928)) ' greek capital letter pi, U+03A0 ISOgrk3
        AddEntity("&Rho;", ChrW(929)) ' greek capital letter rho, U+03A1
        ' there is no Sigmaf, and no U+03A2 character either
        AddEntity("&Sigma;", ChrW(931)) ' greek capital letter sigma, U+03A3 ISOgrk3
        AddEntity("&Tau;", ChrW(932)) ' greek capital letter tau, U+03A4
        AddEntity("&Upsilon;", ChrW(933)) ' greek capital letter upsilon, U+03A5 ISOgrk3
        AddEntity("&Phi;", ChrW(934)) ' greek capital letter phi, U+03A6 ISOgrk3
        AddEntity("&Chi;", ChrW(935)) ' greek capital letter chi, U+03A7
        AddEntity("&Psi;", ChrW(936)) ' greek capital letter psi, U+03A8 ISOgrk3
        AddEntity("&Omega;", ChrW(937)) ' greek capital letter omega, U+03A9 ISOgrk3

        AddEntity("&alpha;", ChrW(945)) ' greek small letter alpha, U+03B1 ISOgrk3
        AddEntity("&beta;", ChrW(946)) ' greek small letter beta, U+03B2 ISOgrk3
        AddEntity("&gamma;", ChrW(947)) ' greek small letter gamma, U+03B3 ISOgrk3
        AddEntity("&delta;", ChrW(948)) ' greek small letter delta, U+03B4 ISOgrk3
        AddEntity("&epsilon;", ChrW(949)) ' greek small letter epsilon, U+03B5 ISOgrk3
        AddEntity("&zeta;", ChrW(950)) ' greek small letter zeta, U+03B6 ISOgrk3
        AddEntity("&eta;", ChrW(951)) ' greek small letter eta, U+03B7 ISOgrk3
        AddEntity("&theta;", ChrW(952)) ' greek small letter theta, U+03B8 ISOgrk3
        AddEntity("&iota;", ChrW(953)) ' greek small letter iota, U+03B9 ISOgrk3
        AddEntity("&kappa;", ChrW(954)) ' greek small letter kappa, U+03BA ISOgrk3
        AddEntity("&lambda;", ChrW(955)) ' greek small letter lambda, U+03BB ISOgrk3
        AddEntity("&mu;", ChrW(956)) ' greek small letter mu, U+03BC ISOgrk3
        AddEntity("&nu;", ChrW(957)) ' greek small letter nu, U+03BD ISOgrk3
        AddEntity("&xi;", ChrW(958)) ' greek small letter xi, U+03BE ISOgrk3
        AddEntity("&omicron;", ChrW(959)) ' greek small letter omicron, U+03BF NEW
        AddEntity("&pi;", ChrW(960)) ' greek small letter pi, U+03C0 ISOgrk3
        AddEntity("&rho;", ChrW(961)) ' greek small letter rho, U+03C1 ISOgrk3
        AddEntity("&sigmaf;", ChrW(962)) ' greek small letter final sigma, U+03C2 ISOgrk3
        AddEntity("&sigma;", ChrW(963)) ' greek small letter sigma, U+03C3 ISOgrk3
        AddEntity("&tau;", ChrW(964)) ' greek small letter tau, U+03C4 ISOgrk3
        AddEntity("&upsilon;", ChrW(965)) ' greek small letter upsilon, U+03C5 ISOgrk3
        AddEntity("&phi;", ChrW(966)) ' greek small letter phi, U+03C6 ISOgrk3
        AddEntity("&chi;", ChrW(967)) ' greek small letter chi, U+03C7 ISOgrk3
        AddEntity("&psi;", ChrW(968)) ' greek small letter psi, U+03C8 ISOgrk3
        AddEntity("&omega;", ChrW(969)) ' greek small letter omega, U+03C9 ISOgrk3
        AddEntity("&thetasym;", ChrW(977)) ' greek small letter theta symbol, U+03D1 NEW
        AddEntity("&upsih;", ChrW(978)) ' greek upsilon with hook symbol, U+03D2 NEW
        AddEntity("&piv;", ChrW(982)) ' greek pi symbol, U+03D6 ISOgrk3

        ' General Punctuation
        AddEntity("&bull;", ChrW(8226)) ' bullet = black small circle, U+2022 ISOpub 
        ' bullet is NOT the same as bullet operator, U+2219
        AddEntity("&hellip;", ChrW(8230)) ' horizontal ellipsis = three dot leader, U+2026 ISOpub 
        AddEntity("&prime;", ChrW(8242)) ' prime = minutes = feet, U+2032 ISOtech
        AddEntity("&Prime;", ChrW(8243)) ' double prime = seconds = inches, U+2033 ISOtech
        AddEntity("&oline;", ChrW(8254)) ' overline = spacing overscore, U+203E NEW
        AddEntity("&frasl;", ChrW(8260)) ' fraction slash, U+2044 NEW

        ' Letterlike Symbols
        AddEntity("&weierp;", ChrW(8472)) ' script capital P = power set = Weierstrass p, U+2118 ISOamso
        AddEntity("&image;", ChrW(8465)) ' blackletter capital I = imaginary part, U+2111 ISOamso
        AddEntity("&real;", ChrW(8476)) ' blackletter capital R = real part symbol, U+211C ISOamso
        AddEntity("&trade;", ChrW(8482)) ' trade mark sign, U+2122 ISOnum
        AddEntity("&alefsym;", ChrW(8501)) ' alef symbol = first transfinite cardinal, U+2135 NEW
        ' alef symbol is NOT the same as hebrew letter alef, U+05D0 although the same glyph could be used to depict both characters

        ' Arrows
        AddEntity("&larr;", ChrW(8592)) ' leftwards arrow, U+2190 ISOnum
        AddEntity("&uarr;", ChrW(8593)) ' upwards arrow, U+2191 ISOnum-->
        AddEntity("&rarr;", ChrW(8594)) ' rightwards arrow, U+2192 ISOnum
        AddEntity("&darr;", ChrW(8595)) ' downwards arrow, U+2193 ISOnum
        AddEntity("&harr;", ChrW(8596)) ' left right arrow, U+2194 ISOamsa
        AddEntity("&crarr;", ChrW(8629)) ' downwards arrow with corner leftwards = carriage return, U+21B5 NEW
        AddEntity("&lArr;", ChrW(8656)) ' leftwards double arrow, U+21D0 ISOtech
        ' ISO 10646 does not say that lArr is the same as the 'is implied by' arrow
        ' but also does not have any other character for that function. So ? lArr can
        ' be used for 'is implied by' as ISOtech suggests
        AddEntity("&uArr;", ChrW(8657)) ' upwards double arrow, U+21D1 ISOamsa
        AddEntity("&rArr;", ChrW(8658)) ' rightwards double arrow, U+21D2 ISOtech
        ' ISO 10646 does not say this is the 'implies' character but does not have 
        ' another character with this function so ?
        ' rArr can be used for 'implies' as ISOtech suggests
        AddEntity("&dArr;", ChrW(8659)) ' downwards double arrow, U+21D3 ISOamsa
        AddEntity("&hArr;", ChrW(8660)) ' left right double arrow, U+21D4 ISOamsa

        ' Mathematical Operators
        AddEntity("&forall;", ChrW(8704)) ' for all, U+2200 ISOtech
        AddEntity("&part;", ChrW(8706)) ' partial differential, U+2202 ISOtech 
        AddEntity("&exist;", ChrW(8707)) ' there exists, U+2203 ISOtech
        AddEntity("&empty;", ChrW(8709)) ' empty set = null set = diameter, U+2205 ISOamso
        AddEntity("&nabla;", ChrW(8711)) ' nabla = backward difference, U+2207 ISOtech
        AddEntity("&isin;", ChrW(8712)) ' element of, U+2208 ISOtech
        AddEntity("&notin;", ChrW(8713)) ' not an element of, U+2209 ISOtech
        AddEntity("&ni;", ChrW(8715)) ' contains as member, U+220B ISOtech
        ' should there be a more memorable name than 'ni'?
        AddEntity("&prod;", ChrW(8719)) ' n-ary product = product sign, U+220F ISOamsb
        ' prod is NOT the same character as U+03A0 'greek capital letter pi' though
        ' the same glyph might be used for both
        AddEntity("&sum;", ChrW(8721)) ' n-ary sumation, U+2211 ISOamsb
        ' sum is NOT the same character as U+03A3 'greek capital letter sigma'
        ' though the same glyph might be used for both
        AddEntity("&minus;", ChrW(8722)) ' minus sign, U+2212 ISOtech
        AddEntity("&lowast;", ChrW(8727)) ' asterisk operator, U+2217 ISOtech
        AddEntity("&radic;", ChrW(8730)) ' square root = radical sign, U+221A ISOtech
        AddEntity("&prop;", ChrW(8733)) ' proportional to, U+221D ISOtech
        AddEntity("&infin;", ChrW(8734)) ' infinity, U+221E ISOtech
        AddEntity("&ang;", ChrW(8736)) ' angle, U+2220 ISOamso
        AddEntity("&and;", ChrW(8743)) ' logical and = wedge, U+2227 ISOtech
        AddEntity("&or;", ChrW(8744)) ' logical or = vee, U+2228 ISOtech
        AddEntity("&cap;", ChrW(8745)) ' intersection = cap, U+2229 ISOtech
        AddEntity("&cup;", ChrW(8746)) ' union = cup, U+222A ISOtech
        AddEntity("&int;", ChrW(8747)) ' integral, U+222B ISOtech
        AddEntity("&there4;", ChrW(8756)) ' therefore, U+2234 ISOtech
        AddEntity("&sim;", ChrW(8764)) ' tilde operator = varies with = similar to, U+223C ISOtech
        ' tilde operator is NOT the same character as the tilde, U+007E,
        ' although the same glyph might be used to represent both 
        AddEntity("&cong;", ChrW(8773)) ' approximately equal to, U+2245 ISOtech
        AddEntity("&asymp;", ChrW(8776)) ' almost equal to = asymptotic to, U+2248 ISOamsr
        AddEntity("&ne;", ChrW(8800)) ' not equal to, U+2260 ISOtech
        AddEntity("&equiv;", ChrW(8801)) ' identical to, U+2261 ISOtech
        AddEntity("&le;", ChrW(8804)) ' less-than or equal to, U+2264 ISOtech
        AddEntity("&ge;", ChrW(8805)) ' greater-than or equal to, U+2265 ISOtech
        AddEntity("&sub;", ChrW(8834)) ' subset of, U+2282 ISOtech
        AddEntity("&sup;", ChrW(8835)) ' superset of, U+2283 ISOtech
        ' note that nsup, 'not a superset of, U+2283' is not covered by the Symbol 
        ' font encoding and is not included. Should it be, for symmetry?
        ' It is in ISOamsn  
        AddEntity("&nsub;", ChrW(8836)) ' not a subset of, U+2284 ISOamsn
        AddEntity("&sube;", ChrW(8838)) ' subset of or equal to, U+2286 ISOtech
        AddEntity("&supe;", ChrW(8839)) ' superset of or equal to, U+2287 ISOtech
        AddEntity("&oplus;", ChrW(8853)) ' circled plus = direct sum, U+2295 ISOamsb
        AddEntity("&otimes;", ChrW(8855)) ' circled times = vector product, U+2297 ISOamsb
        AddEntity("&perp;", ChrW(8869)) ' up tack = orthogonal to = perpendicular, U+22A5 ISOtech
        AddEntity("&sdot;", ChrW(8901)) ' dot operator, U+22C5 ISOamsb
        ' dot operator is NOT the same character as U+00B7 middle dot

        ' Miscellaneous Technical
        AddEntity("&lceil;", ChrW(8968)) ' left ceiling = apl upstile, U+2308 ISOamsc 
        AddEntity("&rceil;", ChrW(8969)) ' right ceiling, U+2309 ISOamsc 
        AddEntity("&lfloor;", ChrW(8970)) ' left floor = apl downstile, U+230A ISOamsc 
        AddEntity("&rfloor;", ChrW(8971)) ' right floor, U+230B ISOamsc 
        AddEntity("&lang;", ChrW(9001)) ' left-pointing angle bracket = bra, U+2329 ISOtech
        ' lang is NOT the same character as U+003C 'less than' 
        ' or U+2039 'single left-pointing angle quotation mark'
        AddEntity("&rang;", ChrW(9002)) ' right-pointing angle bracket = ket, U+232A ISOtech
        ' rang is NOT the same character as U+003E 'greater than' 
        ' or U+203A 'single right-pointing angle quotation mark'

        ' Geometric Shapes
        AddEntity("&loz;", ChrW(9674)) ' lozenge, U+25CA ISOpub

        ' Miscellaneous Symbols
        AddEntity("&spades;", ChrW(9824)) ' black spade suit, U+2660 ISOpub
        ' black here seems to mean filled as opposed to hollow
        AddEntity("&clubs;", ChrW(9827)) ' black club suit = shamrock, U+2663 ISOpub
        AddEntity("&hearts;", ChrW(9829)) ' black heart suit = valentine, U+2665 ISOpub
        AddEntity("&diams;", ChrW(9830)) ' black diamond suit, U+2666 ISOpub


        ' C0 Controls and Basic Latin
        'AddPair("&quot;", ChrW(34)) ' quotation mark = APL quote, U+0022 ISOnum
        'AddPair("&amp;", ChrW(38)) ' ampersand, U+0026 ISOnum
        'AddPair("&lt;", ChrW(60)) ' less-than sign, U+003C ISOnum
        'AddPair("&gt;", ChrW(62)) ' greater-than sign, U+003E ISOnum

        ' Latin Extended-A
        AddEntity("&OElig;", ChrW(338)) ' latin capital ligature OE, U+0152 ISOlat2
        AddEntity("&oelig;", ChrW(339)) ' latin small ligature oe, U+0153 ISOlat2
        ' ligature is a misnomer, this is a separate character in some languages
        AddEntity("&Scaron;", ChrW(352)) ' latin capital letter S with caron, U+0160 ISOlat2
        AddEntity("&scaron;", ChrW(353)) ' latin small letter s with caron, U+0161 ISOlat2
        AddEntity("&Yuml;", ChrW(376)) ' latin capital letter Y with diaeresis, U+0178 ISOlat2

        ' Spacing Modifier Letters
        AddEntity("&circ;", ChrW(710)) ' modifier letter circumflex accent, U+02C6 ISOpub
        AddEntity("&tilde;", ChrW(732)) ' small tilde, U+02DC ISOdia

        ' General Punctuation
        AddEntity("&ensp;", ChrW(8194)) ' en space, U+2002 ISOpub
        AddEntity("&emsp;", ChrW(8195)) ' em space, U+2003 ISOpub
        AddEntity("&thinsp;", ChrW(8201)) ' thin space, U+2009 ISOpub
        AddEntity("&zwnj;", ChrW(8204)) ' zero width non-joiner, U+200C NEW RFC 2070
        AddEntity("&zwj;", ChrW(8205)) ' zero width joiner, U+200D NEW RFC 2070
        AddEntity("&lrm;", ChrW(8206)) ' left-to-right mark, U+200E NEW RFC 2070
        AddEntity("&rlm;", ChrW(8207)) ' right-to-left mark, U+200F NEW RFC 2070
        AddEntity("&ndash;", ChrW(8211)) ' en dash, U+2013 ISOpub
        AddEntity("&mdash;", ChrW(8212)) ' em dash, U+2014 ISOpub
        AddEntity("&lsquo;", ChrW(8216)) ' left single quotation mark, U+2018 ISOnum
        AddEntity("&rsquo;", ChrW(8217)) ' right single quotation mark, U+2019 ISOnum
        AddEntity("&sbquo;", ChrW(8218)) ' single low-9 quotation mark, U+201A NEW
        AddEntity("&ldquo;", ChrW(8220)) ' left double quotation mark, U+201C ISOnum
        AddEntity("&rdquo;", ChrW(8221)) ' right double quotation mark, U+201D ISOnum
        AddEntity("&bdquo;", ChrW(8222)) ' double low-9 quotation mark, U+201E NEW
        AddEntity("&dagger;", ChrW(8224)) ' dagger, U+2020 ISOpub
        AddEntity("&Dagger;", ChrW(8225)) ' double dagger, U+2021 ISOpub
        AddEntity("&permil;", ChrW(8240)) ' per mille sign, U+2030 ISOtech
        AddEntity("&lsaquo;", ChrW(8249)) ' single left-pointing angle quotation mark, U+2039 ISO proposed
        ' lsaquo is proposed but not yet ISO standardized
        AddEntity("&rsaquo;", ChrW(8250)) ' single right-pointing angle quotation mark, U+203A ISO proposed
        ' rsaquo is proposed but not yet ISO standardized
        AddEntity("&euro;", ChrW(8364)) ' euro sign, U+20AC NEW

    End Sub

    Private Shared Sub AddEntity(ByVal entityRef As String, ByVal ch As Char)
        mDecodeRef.Add(entityRef, ch)
        mEncodeRef.Add(ch, entityRef)
    End Sub

    Public Shared Function HtmlEncodeEntity(ByVal value As String) As String
        Dim sb As New StringBuilder(value)
        For Each pair As KeyValuePair(Of Char, String) In mEncodeRef
            sb.Replace(pair.Key, pair.Value)
        Next
        Return sb.ToString()
    End Function

    Public Shared Function HtmlDecodeEntity(ByVal value As String) As String
        Dim sb As New StringBuilder(value)
        For Each pair As KeyValuePair(Of String, Char) In mDecodeRef
            sb.Replace(pair.Key, pair.Value)
        Next
        Return sb.ToString()
    End Function

End Class
