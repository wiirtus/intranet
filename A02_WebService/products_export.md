> **Verze dokumentu 1.0 – prioritní provozní katalog**  
> Rozsah vychází ze statistik CZ a SK; zahrnuje exporty s alespoň 30 requesty. Méně používané exporty jsou zachovány v `products_low_usage.md`.

---

# WebService – Product API

> **Účel dokumentu:** Kompletní popis SWS/I6 (CyberSoft) WebServisu pro účely předání a integrace
> pod ALSO. Dokument popisuje architekturu, autentizaci, formát požadavků
> a odpovědí, konvence pojmenování a prioritní katalog provozně používaných exportů.
>


---

## Obsah


    - [5.2.1 StoItemBase](#521-stoitembase)
    - [5.2.2 StoItemQtyFree](#522-stoitemqtyfree)
    - [5.2.3 StoItemSiv](#523-stoitemsiv)
    - [5.2.4 SPresentTree](#524-spresenttree)
    - [5.2.5 DocTrInv](#525-doctrinv)
    - [5.2.6 StoItemPriceOrd](#526-stoitempriceord)
    - [5.2.7 CpsStiVal](#527-cpsstival)
    - [5.2.8 AttSti](#528-attsti)
    - [5.2.9 CpsSti](#529-cpssti)
    - [5.2.10 SCategorySys](#5210-scategorysys)
    - [5.2.11 StoItemActive](#5211-stoitemactive)
    - [5.2.12 SPresentTreeType](#5212-spresenttreetype)
    - [5.2.13 DocTrExp](#5213-doctrexp)
    - [5.2.14 StoItemEAN](#5214-stoitemean)
    - [5.2.15 StoItemList](#5215-stoitemlist)
    - [5.2.16 StiPacking](#5216-stipacking)
    - [5.2.17 StiRelation](#5217-stirelation)
    - [5.2.18 StoItemNode](#5218-stoitemnode)
    - [5.2.19 StoItemHook](#5219-stoitemhook)
    - [5.2.20 StoItemPriceOrdCur](#5220-stoitempriceordcur)
    - [5.2.21 StoItemQtyFreeEx](#5221-stoitemqtyfreeex)
    - [5.2.22 StrStiSync](#5222-strstisync)
    - [5.2.23 DocTrDel](#5223-doctrdel)
    - [5.2.24 Order](#5224-order)
    - [5.2.25 StoItemShop_El](#5225-stoitemshopel)
    - [5.2.26 X-Cybex](#5226-x-cybex)
    - [5.2.27 ConetPriceOrd](#5227-conetpriceord)
    - [5.2.28 X-HPTRON](#5228-x-hptron)
    - [5.2.29 X-OrdTrack](#5229-x-ordtrack)
    - [5.2.30 X-StoItemPriceOrd](#5230-x-stoitempriceord)
    - [5.2.31 X-StoItemThin](#5231-x-stoitemthin)
    - [5.2.32 X-StiIcecat](#5232-x-stiicecat)
    - [5.2.33 X-StoItemQtyFree](#5233-x-stoitemqtyfree)
    - [5.2.34 X-SipPrcZMin](#5234-x-sipprczmin)
    - [5.2.35 X-StoItemKBProgres](#5235-x-stoitemkbprogres)
    - [5.2.36 X-ConetSipPrcZMin](#5236-x-conetsipprczmin)
    - [5.2.37 X-ConetStoItemQtyFreeEx](#5237-x-conetstoitemqtyfreeex)
    - [5.2.38 X-StoItemQtyFreeWithQtyOriBlock](#5238-x-stoitemqtyfreewithqtyoriblock)
    - [5.2.39 X-StoItemQtyFreeWithQtyOriBlockEx](#5239-x-stoitemqtyfreewithqtyoriblockex)
    - [5.2.40 X-StoItemQtyFreeBOHPT](#5240-x-stoitemqtyfreebohpt)
    - [5.2.41 X-DeletedStiCode](#5241-x-deletedsticode)
    - [5.2.42 X-StoItemQtyFreeRealX](#5242-x-stoitemqtyfreerealx)
    - [5.2.43 X-StoItemQtyFreeRealX2](#5243-x-stoitemqtyfreerealx2)
    - [5.2.44 X-StoItemBaseReal](#5244-x-stoitembasereal)
    - [5.2.45 X-StoItemBaseWithoutPriceStock](#5245-x-stoitembasewithoutpricestock)
    - [5.2.46 X-StoItemXXLDelivModePrc](#5246-x-stoitemxxldelivmodeprc)
    - [5.2.47 X-StoItemQtyFreeShip](#5247-x-stoitemqtyfreeship)
    - [5.2.48 StoItemGPSR](#5248-stoitemgpsr)

---



### 5.1 Rozsah podle provozního využití

Statistika je součtem listů `CZ All requests` a `SK All requests` ze souboru `websevice_statistics.xlsx`. Do hlavního katalogu je zařazena sekce, pokud alespoň jeden její přesný `resultType` dosáhl 30 requestů. Počty jsou počty volání, nikoli počty firem.

| Sekce | Requestů celkem | Země | Metody | Použité varianty |
| --- | ---: | --- | --- | --- |
| `StoItemBase` | 179795 | CZ 160524, SK 19271 | `GetResult` 8252, `GetResultByCode` 171300, `GetResultByFromTo` 243 | `StoItemBase` (178307), `StoItemBase_El` (1484), `StoItemBase_Schema` (4) |
| `X-OrdTrack` | 58687 | CZ 58687 | `GetResultByCode` 58687 | `X-OrdTrack` (58687) |
| `StoItemQtyFree` | 54662 | CZ 45521, SK 9141 | `GetResult` 51442, `GetResultByCode` 3220 | `StoItemQtyFree` (48060), `StoItemQtyFree_El` (6598), `StoItemQtyFree_Schema` (4) |
| `StrStiSync` | 53248 | CZ 22010, SK 31238 | `GetResult` 1, `GetResultByCode` 53247 | `StrStiSync` (53248) |
| `StoItemQtyFreeEx` | 36191 | CZ 36191 | `GetResult` 3192, `GetResultByCode` 32999 | `StoItemQtyFreeEx` (36191) |
| `DocTrInv` | 29861 | CZ 28892, SK 969 | `GetResult` 32, `GetResultByCode` 17163, `GetResultByFromTo` 12666 | `DocTrInv` (29861) |
| `Order` | 28310 | CZ 28281, SK 29 | `GetResult` 2082, `GetResultByCode` 17566, `GetResultByFromTo` 8662 | `Order` (28310) |
| `StoItemPriceOrd` | 6062 | CZ 4928, SK 1134 | `GetResult` 3821, `GetResultByCode` 2241 | `StoItemPriceOrd` (5820), `StoItemPriceOrd_El` (240), `StoItemPriceOrd_Schema` (2) |
| `SPresentTree` | 4169 | CZ 3146, SK 1023 | `GetResult` 4049, `GetResultByCode` 120 | `SPresentTree` (3030), `SPresentTree_El` (1136), `SPresentTree_Schema` (3) |
| `StoItemSiv` | 3745 | CZ 3514, SK 231 | `GetResult` 2433, `GetResultByCode` 1312 | `StoItemSiv` (3683), `StoItemSiv_El` (60), `StoItemSiv_Schema` (2) |
| `CpsStiVal` | 3083 | CZ 2734, SK 349 | `GetResult` 3025, `GetResultByFromTo` 58 | `CpsStiVal_El` (1775), `CpsStiVal` (1308) |
| `AttSti` | 2376 | CZ 2203, SK 173 | `GetResult` 1899, `GetResultByCode` 477 | `AttSti` (2375), `AttSti_Schema` (1) |
| `DocTrExp` | 1814 | CZ 1393, SK 421 | `GetResultByFromTo` 1814 | `DocTrExp` (1814) |
| `StiRelation` | 1275 | CZ 949, SK 326 | `GetResult` 1215, `GetResultByCode` 60 | `StiRelation_El` (647), `StiRelation` (628) |
| `X-ConetStoItemQtyFreeEx` | 1141 | CZ 1141 | `GetResult` 959, `GetResultByCode` 182 | `X-ConetStoItemQtyFreeEx` (1141) |
| `X-ConetSipPrcZMin` | 707 | CZ 707 | `GetResult` 707 | `X-ConetSipPrcZMin` (707) |
| `StoItemList` | 648 | CZ 648 | `GetResult` 87, `GetResultByCode` 561 | `StoItemList` (648) |
| `DocTrDel` | 616 | CZ 616 | `GetResultByFromTo` 616 | `DocTrDel` (616) |
| `X-StoItemQtyFreeWithQtyOriBlock` | 501 | CZ 501 | `GetResult` 501 | `X-StoItemQtyFreeWithQtyOriBlock` (501) |
| `CpsSti` | 354 | CZ 326, SK 28 | `GetResult` 354 | `CpsSti` (354) |
| `StiPacking` | 341 | CZ 311, SK 30 | `GetResult` 333, `GetResultByCode` 8 | `StiPacking_El` (215), `StiPacking` (126) |
| `StoItemShop_El` | 288 | CZ 288 | `GetResult` 288 | `StoItemShop_El` (288) |
| `StoItemEAN` | 246 | CZ 246 | `GetResult` 177, `GetResultByCode` 69 | `StoItemEAN` (244), `StoItemEAN_Schema` (2) |
| `StoItemNode` | 227 | CZ 194, SK 33 | `GetResult` 227 | `StoItemNode` (197), `StoItemNode_El` (30) |
| `X-Cybex` | 204 | CZ 204 | `GetResult` 30, `GetResultByFromTo` 174 | `X-Cybex` (204) |
| `X-StoItemQtyFreeBOHPT` | 188 | CZ 188 | `GetResult` 188 | `X-StoItemQtyFreeBOHPT` (188) |
| `StoItemActive` | 183 | CZ 182, SK 1 | `GetResult` 182, `GetResultByCode` 1 | `StoItemActive` (183) |
| `X-StoItemQtyFreeRealX2` | 170 | CZ 170 | `GetResult` 170 | `X-StoItemQtyFreeRealX2` (170) |
| `X-StoItemQtyFreeRealX` | 167 | CZ 167 | `GetResult` 167 | `X-StoItemQtyFreeRealX` (167) |
| `StoItemPriceOrdCur` | 165 | CZ 118, SK 47 | `GetResult` 148, `GetResultByCode` 17 | `StoItemPriceOrdCur` (165) |
| `X-StoItemQtyFreeShip` | 163 | CZ 163 | `GetResult` 124, `GetResultByCode` 39 | `X-StoItemQtyFreeShip` (163) |
| `X-StoItemThin` | 159 | CZ 159 | `GetResultByCode` 159 | `X-StoItemThin` (159) |
| `StoItemHook` | 150 | CZ 150 | `GetResult` 150 | `StoItemHook` (150) |
| `ConetPriceOrd` | 128 | CZ 128 | `GetResultByCode` 128 | `ConetPriceOrd` (128) |
| `X-StoItemQtyFreeWithQtyOriBlockEx` | 120 | CZ 120 | `GetResult` 120 | `X-StoItemQtyFreeWithQtyOriBlockEx` (120) |
| `X-StoItemQtyFree` | 107 | CZ 107 | `GetResult` 107 | `X-StoItemQtyFree` (107) |
| `X-StiIcecat` | 90 | CZ 90 | `GetResult` 90 | `X-StiIcecat` (90) |
| `X-SipPrcZMin` | 89 | CZ 89 | `GetResult` 89 | `X-SipPrcZMin` (89) |
| `X-StoItemBaseReal` | 81 | CZ 81 | `GetResult` 75, `GetResultByCode` 6 | `X-StoItemBaseReal` (80), `X-StoItemBaseReal_Schema` (1) |
| `X-StoItemXXLDelivModePrc` | 72 | CZ 72 | `GetResult` 72 | `X-StoItemXXLDelivModePrc` (72) |
| `StoItemGPSR` | 72 | CZ 72 | `GetResult` 72 | `StoItemGPSR` (72) |
| `X-StoItemPriceOrd` | 62 | CZ 62 | `GetResult` 60, `GetResultByCode` 2 | `X-StoItemPriceOrd` (62) |
| `X-DeletedStiCode` | 33 | CZ 33 | `GetResult` 33 | `X-DeletedStiCode` (33) |
| `SCategorySys` | 30 | CZ 30 | `GetResult` 30 | `SCategorySys` (30) |
| `SPresentTreeType` | 30 | CZ 30 | `GetResult` 30 | `SPresentTreeType` (30) |
| `X-HPTRON` | 30 | CZ 30 | `GetResult` 30 | `X-HPTRON` (30) |
| `X-StoItemKBProgres` | 30 | CZ 30 | `GetResult` 30 | `X-StoItemKBProgres` (30) |
| `X-StoItemBaseWithoutPriceStock` | 30 | CZ 30 | `GetResult` 30 | `X-StoItemBaseWithoutPriceStock` (30) |

---

### 5.2 Prioritní exporty

#### 5.2.1 StoItemBase

V jednom volání vrací popis produktů,  ceny, DPH,
skladovou dostupnost, logistické údaje i informace o obrázcích. Odpovídá metodě `AllProducts`
(příp. `ProductFullInfo`) z ALSO Product API.

**`resultType`:** `StoItemBase` · `StoItemBase_El` · `StoItemBase_Schema`

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemBase&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 179795 requestů pro varianty popsané v této sekci.

```xml
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseThumbnail="https://terminal.sws.cz/img.asp?attname=thumbnail&amp;attpedid=52&amp;attsrcid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=" UrlBaseEnlargement="https://terminal.sws.cz/img.asp?attname=enlargement&amp;attpedid=52&amp;attsrcid=" UrlBaseImgGalery="https://terminal.sws.cz/img.asp?attid=" CouCode="CZ" TaxRateLow="12" TaxRateHigh="21">
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" NameE="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" ManName="Lenovo" CouCode="CN" UrlExt="https://psref.lenovo.com/accessory/40BF0100EU" PriceEU="4597.8200" PriceB2CMin="4597.8200" PriceDea="3889.0000" PriceOrd="3889.0000" PriceRef="0.7600" RefProName="ASEKOL" RefCode="5.55." PriceRef2="0.0000" RefProName2="Autorský fond CZ" RefCode2="9.99" WeightRef="0.54750" TaxRate="21.0000" CutCode="84718000" QtyFreeIs="1" WarDur="1116" WarDurEU="1116" SNTrack="1" Weight="0.64000" ScaId="53" ThumbnailIs="1" ThumbnailSize="1322" ImgIs="1" ImgSize="14400" EnlargementIs="1" EnlargementSize="19826" SisName="Novinka" NoteShort="Popis produktu&#13;&#10;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstr" Note="Popis produktu&#13;&#10;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstream konektivitou o propustnosti 40 Gb/s, což umožňuje rozšířit konfiguraci monitorů o více pixelů a vyšší obnovovací frekvence.&#13;&#10;Dokovací stanice může dodávat 65 W napájení notebooku při použití 100W napájecího adaptéru, nebo lze použít 135W adaptér, který zvýší nabíjecí výkon až na 100 W pro notebook.&#13;&#10;&#13;&#10;Hlavní vlastnosti&#13;&#10;&#13;&#10;Dokovací stanice ThinkPad® USB4 Dock 5000 s nejnovější technologií USB4 nabízí až čtyřnásobný výkon konektivity oproti USB-C 3.2 Gen 2. Díky propustnosti až 40 Gb/s můžete připojit buď jeden monitor s ultravysokým rozlišením 8K při 60 Hz, nebo dva monitory 4K s obnovovací frekvencí 144 Hz. Snadno tak rozšíříte svůj notebook Lenovo na plnohodnotnou pracovní platformu s různými periferními zařízeními.&#13;&#10;Dok podporuje Power Delivery 3.1 a poskytuje až 100 W pro rychlé nabíjení notebooku, takže můžete jednoduše rozšířit možnosti svého pracovního prostoru.&#13;&#10;&#13;&#10;Dokovací stanice je navíc univerzálně kompatibilní s různými operačními systémy.">
    <ImgGal />
  </StoItem>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemBase.xml`](examples/priority/StoItemBase.xml)

**Legenda typů:** `i2`/`i4`/`i8` = celé číslo (16/32/64 bit) · `ui1` = byte (0–255) ·
`fixed.14.4` / `number` = desetinné číslo · `string` = text · `boolean` = 0/1.

##### Atributy elementu `Result` (obálka, jednou na dokument)

| Pole                | Typ    | Popis                                                                 |
|---------------------|--------|-----------------------------------------------------------------------|
| `UrlBase`           | string | Základ URL eshopu/webu                                                |
| `UrlBaseThumbnail`  | string | Základ URL pro náhledy (thumbnail) — výsledná URL = `UrlBaseThumbnail` + `StoItem.Id` |
| `UrlBaseImg`        | string | Základ URL pro obrázky — výsledná URL = `UrlBaseImg` + `StoItem.Id`   |
| `UrlBaseEnlargement`| string | Základ URL pro zvětšeniny                                             |
| `UrlBaseImgGalery`  | string | Základ URL pro obrázky galerie — kombinuje se s `ImgGal.Id`           |
| `CouCode`           | string | Výchozí kód země                                                      |
| `TaxRateLow`        | ui1    | Nízká sazba DPH (%)                                                    |
| `TaxRateHigh`       | ui1    | Základní/vysoká sazba DPH (%)                                         |
| `Void`              | string | Technický prázdný sloupec použitý pro sestavení vazby `Result`–`StoItem`; běžně se do XML nevypíše |

##### Atributy elementu `StoItem`

| Pole            | Typ         | Popis                                                                      |
|-----------------|-------------|----------------------------------------------------------------------------|
| `Id`            | i4          | Interní ID produktu v i6       |
| `Code`          | string      | Hlavní skladový kód SWS (např. `ASC00511`)                                 |
| `Code2`         | string      | Alternativní interní kód skladové položky                                  |
| `PartNo`        | string      | Katalogové (výrobní) číslo výrobce                                         |
| `PartNo2`       | string      | Druhé výrobní/objednací číslo výrobce                                      |
| `EAN`           | string      | EAN                                                            |
| `EAN2`          | string      | Druhý EAN                                                                  |
| `Name`          | string      | Název produktu                                                            |
| `NameAdd`       | string      | Rozšířený název zboží v hlavním ceníku                                     |
| `NameE`         | string      | Název v angličtině                                                        |
| `NameDoc`       | string      | Název používaný na dokladech                                              |
| `NameShort`     | string      | Zkrácený název                                                            |
| `NameSeo`       | string      | SEO název (pro URL / vyhledávače)                                         |
| `ManName`       | string      | Název výrobce (Manufacturer)                                             |
| `CouCode`       | string      | Kód země původu                                                          |
| `UrlExt`        | string      | Externí WWW adresa produktu (`StoItem.StiWww`)                              |
| `PriceEU`       | fixed.14.4  |  MSRP, list price                           |
| `PriceB2CMin`   | fixed.14.4  | Minimální B2C prodejní cena (MAP)                                        |
| `PriceDea`      | fixed.14.4  | Dealerská cena                                                            |
| `PriceOrd`      | fixed.14.4  | Objednací (nákupní) cena                                                  |
| `PriceRef`      | fixed.14.4  | První referenční poplatek; konkrétní druh určuje `RefProName`/`RefCode` |
| `PriceRefInfo`  | fixed.14.4  | Informativní hodnota prvního referenčního poplatku                         |
| `RefProName`    | string      | Název produktu nebo systému prvního referenčního poplatku                  |
| `RefCode`       | string      | Kód prvního referenčního poplatku                                         |
| `PriceRef2`     | fixed.14.4  | Druhý referenční poplatek; konkrétní druh určuje `RefProName2`/`RefCode2` |
| `PriceRef2Info` | fixed.14.4  | Informativní hodnota druhého referenčního poplatku                         |
| `RefProName2`   | string      | Název produktu nebo systému druhého referenčního poplatku                  |
| `RefCode2`      | string      | Kód druhého referenčního poplatku                                         |
| `WeightRef`     | number      | Hmotnost elektroodpadu používaná při výpočtu referenčního poplatku         |
| `MeasureRef2`   | number      | Referenční množství používané při výpočtu druhého poplatku                 |
| `TaxRate`       | fixed.14.4  | Sazba DPH produktu (%)                                                    |
| `TatCodeE`      | string      | Externí kód druhu daňového plnění (`StiXTatId`, `UsrDes.UsdKind = 14`)    |
| `CutCode`       | string      | Kód položky celního sazebníku                                              |
| `QtyFreeIs`     | boolean     | Příznak, zda je dostupné množství evidováno/platné                       |
| `QtyFree`       | i4          | Volné (dostupné) množství skladem                                        |
| `QtyPack`       | number      | Množství v balení (karton)                                              |
| `WarDur`        | i4          | Délka záruky (měsíce)                                                    |
| `WarDurEU`      | i4          | Délka záruky pro koncového zákazníka bez IČA                              |
| `SNTrack`       | ui1         | Evidence sériových čísel (0 = ne / typ sledování)                        |
| `NonDivQty`     | number      | Nedělitelné objednací množství; hodnota `1` se jako výchozí nevrací       |
| `Weight`        | number      | Hmotnost (kg)                                                            |
| `XXL`           | boolean     | Nadrozměrné zboží                                                        |
| `XXS`           | boolean     | Produkt v režimu dopravy XXS; lze jej párovat se způsoby dopravy podporujícími `DemXXS` |
| `ScaId`         | i4          | ID systémové kategorie produktu (`StoItem.StiScaId`)                       |
| `ThumbnailIs`   | boolean     | Existuje náhled                                                          |
| `ThumbnailSize` | i8          | Velikost náhledu (B)                                                     |
| `ImgIs`         | boolean     | Existuje hlavní obrázek                                                  |
| `ImgSize`       | i8          | Velikost hlavního obrázku (B)                                            |
| `EnlargementIs` | boolean     | Existuje zvětšenina                                                      |
| `EnlargementSize`| i8         | Velikost zvětšeniny (B)                                                  |
| `SisName`       | string      | Název stavu produktu, například `Novinka`, `Výprodej` nebo `Doprodej`     |
| `SitId`         | ui1         | Typ skladové položky: `0 = zboží`, `1 = služba`; nula se nevrací         |
| `NonMater`      | ui1         | Příznak nehmotného produktu                                               |
| `SttId`         | ui1         | Režim sestavy/bundlu produktu; `1` běžný bundle, `2` a `3` sestavy z háku |
| `NoteShort`     | string      | Krátká poznámka                                                          |
| `StiDemIdDis`   | string      | Čárkami oddělená ID způsobů dopravy zakázaných pro produkt                 |
| `EprelId`       | i4          | ID záznamu v EU databázi EPREL (energetické štítky)                     |
| `Note`          | string      | Poznámka (delší text)                                                    |

##### Vnořené elementy `ImgGal` (galerie obrázků, 0..N na produkt)

| Pole    | Typ  | Popis                                                          |
|---------|------|----------------------------------------------------------------|
| `Id`    | i4   | ID obrázku galerie; URL = `UrlBaseImgGalery` + `Id`            |
| `Name`  | string | Název/soubor obrázku                                         |
| `Tag`   | string | Typ/štítek obrázku (rozlišení druhu obrázku)                 |
| `Sort`  | i2   | Pořadí zobrazení                                              |
| `Size`  | i8   | Velikost obrázku (B)                                          |

#### 5.2.2 StoItemQtyFree

Vrací pouze identifikaci produktu
a volné množství — bez cen, názvů a obrázků. Vhodný pro časté dotazování na sklad (menší objem
dat než `StoItemBase`). Odpovídá metodě `AllProductsNow` / `ProductNow` z ALSO Product API.

**`resultType`:** `StoItemQtyFree` · `StoItemQtyFree_El` · `StoItemQtyFree_Schema`

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemQtyFree&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 54662 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" EAN2="" QtyFreeIs="1" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemQtyFree.xml`](examples/priority/StoItemQtyFree.xml)
##### Atributy elementu `StoItem`

| Pole        | Typ     | Popis                                                        |
|-------------|---------|--------------------------------------------------------------|
| `Id`        | i4      | Interní ID produktu v i6                                     |
| `Code`      | string  | Hlavní skladový kód SWS (např. `ASC00511`)                  |
| `Code2`     | string  | Alternativní interní kód skladové položky                    |
| `PartNo`    | string  | Katalogové (výrobní) číslo výrobce                          |
| `PartNo2`   | string  | Druhé výrobní/objednací číslo výrobce                       |
| `EAN`       | string  | EAN                                |
| `EAN2`      | string  | Druhý EAN                                                   |
| `QtyFreeIs` | boolean | Příznak         |
| `QtyFree`   | i4      | Volné (dostupné) množství skladem                          |

**Příklad volání a odpovědi** — viz sekce [Katalog exportů](#5-katalog-exportů) výše
(`StoItemQtyFree` je použit jako ukázka všech tří variant).

#### 5.2.3 StoItemSiv

Kombinovaný export dostupnosti a ceny — vrací sklad, objednací cenu a základní identifikaci
i logistické údaje v jednom volání, bez galerie obrázků a rozšířených názvů. Kompromis mezi
odlehčeným `StoItemQtyFree` a plným `StoItemBase`. Odpovídá metodě `ProductNow` (přes
`GetResultByCode`) resp. `AllProductsNow` (přes `GetResult`) z ALSO Product API — pokrývá
dostupnost i cenu jedním exportem.

**`resultType`:** `StoItemSiv` · `StoItemSiv_El` · `StoItemSiv_Schema`

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemSiv&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 3745 requestů pro varianty popsané v této sekci.

```xml
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=">
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" ManName="Lenovo" SisName="Novinka" SiuCode="ks" UrlSuffix="695888" UrlExt="https://psref.lenovo.com/accessory/40BF0100EU" QtyFreeIs="1" PriceEU="4597.8200" PriceOrd="3889.0000" PriceRef="0.7600" PriceRef2="0.0000" WarDur="1116" ImgSize="14400" CutCode="84718000" Weight="0.64000" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemSiv.xml`](examples/priority/StoItemSiv.xml)
##### Atributy elementu `Result` (obálka)

| Pole         | Typ    | Popis                                                              |
|--------------|--------|--------------------------------------------------------------------|
| `UrlBase`    | string | Základ URL eshopu/webu                                            |
| `UrlBaseImg` | string | Základ URL pro hlavní obrázek — výsledná URL = `UrlBaseImg` + `StoItem.Id` |
| `Void`       | string | Technický prázdný sloupec pro sestavení XML; běžně se nevypíše |

##### Atributy elementu `StoItem`

| Pole            | Typ         | Popis                                                            |
|-----------------|-------------|------------------------------------------------------------------|
| `Id`            | i4          | Interní ID produktu v i6; slouží k sestavení URL obrázku         |
| `Code`          | string      | Hlavní skladový kód SWS                                          |
| `Code2`         | string      | Alternativní interní kód skladové položky                        |
| `PartNo`        | string      | Katalogové (výrobní) číslo výrobce                              |
| `PartNo2`       | string      | Druhé výrobní/objednací číslo výrobce                           |
| `EAN`           | string      | EAN (čárový kód)                                                |
| `EAN2`          | string      | Druhý EAN                                                       |
| `Name`          | string      | Název produktu                                                 |
| `ManName`       | string      | Název výrobce (Manufacturer)                                   |
| `SisName`       | string      | Název stavu produktu                                             |
| `SiuCode`       | string      | Kód měrné jednotky, například `ks`, `m`, `kg` nebo `l`          |
| `UrlSuffix`     | string      | Textové `StiId` připojované k `Result.UrlBase`                   |
| `UrlExt`        | string      | Externí WWW adresa produktu (`StoItem.StiWww`)                   |
| `QtyFreeIs`     | boolean     | Příznak, zda je dostupné množství evidováno/platné              |
| `QtyFree`       | i4          | Volné (dostupné) množství skladem                              |
| `PriceEU`       | fixed.14.4  | Koncová ceníková cena, případně přepočtená do měny partnera     |
| `PriceOrd`      | fixed.14.4  | Objednací (nákupní) cena                                        |
| `PriceRef`      | fixed.14.4  | První referenční poplatek                                       |
| `PriceRefInfo`  | fixed.14.4  | Informativní hodnota prvního referenčního poplatku              |
| `PriceRef2`     | fixed.14.4  | Druhý referenční poplatek                                       |
| `PriceRef2Info` | fixed.14.4  | Informativní hodnota druhého referenčního poplatku              |
| `WarDur`        | i4          | Délka záruky (měsíce)                                          |
| `ImgSize`       | i8          | Velikost hlavního obrázku (B); 0 = obrázek není                |
| `SitId`         | ui1         | Typ položky: `0 = zboží`, `1 = služba`; nula se nevrací       |
| `NonMater`      | ui1         | Příznak nehmotného produktu                                     |
| `CutCode`       | string      | Kód položky celního sazebníku                                   |
| `Weight`        | number      | Hmotnost (kg)                                                  |
| `XXL`           | boolean     | Nadrozměrné zboží                                              |
| `XXS`           | boolean     | Produkt v režimu dopravy XXS                                    |

#### 5.2.4 SPresentTree

Export prezentačního (kategorického) stromu. Vrací **plochý seznam uzlů** stromu, kde se
hierarchie rekonstruuje na straně klienta ze sort klíče — **každá úroveň má vyhrazené 3 znaky**
(`AAA` = 1. úroveň, `AAABBB` = 2. úroveň atd.). Vazbu na rodiče nese `IdP` (prázdné = kořenový
uzel). Top-level uzly odpovídají *typům stromu* (ceníkové stromy), jejich `Id` je odvozené jako
záporná hodnota (`-2147483648 + typ`). Odpovídá metodě `Categories` z ALSO Product API.

Díky `FOR XML AUTO` je struktura **dvouúrovňová**: uzel `SPresentTree` obsahuje 0..N vnořených
elementů `StoItem` — tj. produkty zařazené přímo do daného uzlu. Kategorie bez produktů, které
zároveň nemají pod sebou žádný produkt (na žádné podúrovni), jsou z výstupu odstraněny.

**`resultType`:** `SPresentTree` · `SPresentTree_El` · `SPresentTree_Schema`



**Filtrování přes `GetResultByCode`:** parametr `code` = `IdP` (ID uzlu) — vrátí danou podvětev
stromu. Záporné `code` filtruje podle *typu stromu*.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=SPresentTree&code=4039`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 4169 requestů pro varianty popsané v této sekci.

```xml
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=spresenttrees&amp;strid=" UrlBaseImg="https://terminal.sws.cz/img.asp?strid=">
  <SPresentTree Id="4039" IdP="107" Sort="0008NC0RRLXR" Name="Port replikátory a dokovací stanice">
    <StoItem Code="238064" Id="568062" />
    <StoItem Code="238066" Id="568064" />
    <StoItem Code="238068" Id="568066" />
    <StoItem Code="452928" Id="568593" />
    <StoItem Code="DL3173" Id="574747" />
    <StoItem Code="845204" Id="602577" />
    <StoItem Code="645759" Id="622642" />
    <StoItem Code="DL4546" Id="635228" />
    <StoItem Code="AXG00007" Id="653319" />
    <StoItem Code="AXG00008" Id="654127" />
    <StoItem Code="AXG00015" Id="657228" />
    <StoItem Code="AXG00016" Id="657232" />
    <StoItem Code="AXG00019" Id="660611" />
    <StoItem Code="AXG00024" Id="663649" />
    <StoItem Code="AXG00025" Id="663657" />
    <StoItem Code="AXG00048" Id="670613" />
    <StoItem Code="LNM00669" Id="672792" />
    <StoItem Code="BKN00136" Id="675528" />
    <StoItem Code="BKN00137" Id="675529" />
    <StoItem Code="BKN00138" Id="675530" />
    <StoItem Code="AXG00058" Id="681067" />
    <StoItem Code="LNM01047" Id="683815" />
    <StoItem Code="LNM01049" Id="683817" />
    <StoItem Code="LNM01050" Id="683819" />
    <StoItem Code="LNM01051" Id="683822" />
    <StoItem Code="LNM01052" Id="683824" />
    <StoItem Code="LNM01353" Id="695888" />
    <StoItem Code="DLS01701" Id="696193" />
    <StoItem Code="PMC00325" Id="697218" />
    <StoItem Code="ACO00045" Id="680039" />
    <StoItem Code="ACO00048" Id="681124" />
    <StoItem Code="189342" Id="581548" />
    <StoItem Code="192485" Id="598094" />
    <StoItem Code="537819" Id="642639" />
    <StoItem Code="CNI00053" Id="665594" />
    <StoItem Code="KST00080" Id="676719" />
    <StoItem Code="ITC00025" Id="678069" />
    <StoItem Code="ITC00029" Id="679515" />
    <StoItem Code="ITC00038" Id="685058" />
    <StoItem Code="AXG00000" Id="651082" />
    <StoItem Code="AXG00062" Id="692848" />
    <StoItem Code="AXG00063" Id="692850" />
    <StoItem Code="521402" Id="506441" />
    <StoItem Code="517425" Id="589271" />
    <StoItem Code="546594" Id="591515" />
    <StoItem Code="543018" Id="607727" />
    <StoItem Code="KST00006" Id="655918" />
    <StoItem Code="KST00007" Id="655919" />
    <StoItem Code="KST00043" Id="666901" />
    <StoItem Code="KST00044" Id="666902" />
    <StoItem Code="KST00140" Id="695665" />
    <StoItem Code="DLM03265" Id="676361" />
    <StoItem Code="DLM03266" Id="676362" />
    <StoItem Code="DLS01702" Id="696194" />
    <StoItem Code="DLM03264" Id="676360" />
    <StoItem Code="DLS00372" Id="682085" />
    <StoItem Code="444102" Id="647035" />
    <StoItem Code="HPR01417" Id="675029" />
    <StoItem Code="HPC00939" Id="700413" />
    <StoItem Code="89741725" Id="583834" />
    <StoItem Code="89742153" Id="621916" />
    <StoItem Code="89742461" Id="642642" />
    <StoItem Code="HPC00035" Id="656167" />
    <StoItem Code="HPC00773" Id="697983" />
    <StoItem Code="HPR01414" Id="675025" />
    <StoItem Code="HPR01415" Id="675027" />
    <StoItem Code="HPR01416" Id="675028" />
    <StoItem Code="537720" Id="538356" />
    <StoItem Code="537744" Id="565808" />
    <StoItem Code="537750" Id="570179" />
    <StoItem Code="537751" Id="570182" />
    <StoItem Code="537752" Id="570183" />
    <StoItem Code="537758" Id="603682" />
    <StoItem Code="537760" Id="603698" />
    <StoItem Code="537815" Id="635090" />
    <StoItem Code="537816" Id="635091" />
    <StoItem Code="537818" Id="636814" />
    <StoItem Code="537823" Id="645042" />
    <StoItem Code="537824" Id="645043" />
    <StoItem Code="ITC00000" Id="650731" />
    <StoItem Code="ITC00002" Id="653825" />
    <StoItem Code="ITC00010" Id="663092" />
    <StoItem Code="ITC00011" Id="664213" />
    <StoItem Code="ITC00032" Id="680549" />
    <StoItem Code="ITC00033" Id="680550" />
    <StoItem Code="ITC00034" Id="680552" />
    <StoItem Code="ITC00035" Id="680556" />
    <StoItem Code="ITC00051" Id="698891" />
    <StoItem Code="493295" Id="521754" />
    <StoItem Code="452105" Id="547452" />
    <StoItem Code="452107" Id="547454" />
    <StoItem Code="398533" Id="563491" />
    <StoItem Code="399108" Id="627808" />
    <StoItem Code="DGT00135" Id="683064" />
    <StoItem Code="DGT00136" Id="683065" />
    <StoItem Code="DGT00137" Id="683066" />
    <StoItem Code="DGT00138" Id="683067" />
    <StoItem Code="DGT00139" Id="683068" />
    <StoItem Code="645660" Id="586389" />
    <StoItem Code="645740" Id="611812" />
    <StoItem Code="BKN00035" Id="658439" />
    <StoItem Code="BKN00135" Id="675527" />
    <StoItem Code="GMB00230" Id="677014" />
    <StoItem Code="GMB00258" Id="677279" />
    <StoItem Code="DL1610" Id="484729" />
    <StoItem Code="DL4335" Id="616739" />
    <StoItem Code="DLK00570" Id="664379" />
    <StoItem Code="675632" Id="467969" />
  </SPresentTree>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/SPresentTree.xml`](examples/priority/SPresentTree.xml)
##### Atributy elementu `Result` (obálka)

| Pole         | Typ    | Popis                                                                       |
|--------------|--------|-----------------------------------------------------------------------------|
| `UrlBase`    | string | Základ URL kategorie; výsledná URL = `UrlBase` + `SPresentTree.Id` (odkaz `…default.asp?cls=spresenttrees&strid=`) |
| `UrlBaseImg` | string | Základ URL obrázku produktu; výsledná URL = `UrlBaseImg` + `StoItem.Id` (příp. `Code`) |
| `Void`       | string | Rezervovaný prázdný atribut (vždy NULL)                                     |

##### Element `SPresentTree` (uzel stromu / kategorie)

| Pole      | Typ    | Popis                                                                        |
|-----------|--------|------------------------------------------------------------------------------|
| `Id`      | i4     | ID uzlu (`StrId`). U top-level typů stromu je odvozené jako `-2147483648 + typ` |
| `IdP`     | i4     | ID rodičovského uzlu; prázdné/NULL = kořenová úroveň                          |
| `Sort`    | string | Sort klíč pro řazení i rekonstrukci hierarchie — 3 znaky na každou úroveň zanoření |
| `Name`    | string | Název kategorie (lokalizovaný — aplikuje se jazyk dle přihlášeného partnera)  |
| `Tag`     | string | Volitelný štítek/značka uzlu (jen je-li vyplněn)                             |
| `ImgSize` | i8     | Velikost obrázku kategorie v B (jen je-li obrázek přítomen)                  |
| `NameSEO` | string | SEO název kategorie (pro URL / vyhledávače)                                  |
| `Note`    | string | Poznámka k uzlu                                                              |
| `NameAdd` | string | Doplňkový název / rozšiřující text                                           |
| `StrWWW`  | string | Vlastní WWW odkaz kategorie (je-li nastaven)                                 |

##### Vnořený element `StoItem` (produkty v uzlu, 0..N)

| Pole   | Typ    | Popis                                                    |
|--------|--------|----------------------------------------------------------|
| `Id`   | i4     | Interní ID produktu (`StiId`); pro sestavení URL obrázku |
| `Code` | string | Skladový kód produktu (`StiCode`)                        |

> **Poznámka k obsahu:** Do výstupu vstupují pouze produkty, které projdou standardními
> filtry viditelnosti pro WebService (skladová/prodejní příznaky produktu, řádková oprávnění
> partnera). Množina produktů se tedy může u různých partnerů lišit podle jejich oprávnění.

#### 5.2.5 DocTrInv


Přenosový formát faktury — **„Document Transfer – Invoice"**, dle definice exportu určený
pro **import do jiné instance I6** (mezisystémová výměna dokladů). Vrací kompletní fakturu
včetně rekapitulace DPH, položek, sériových čísel (záruk), navázaných dodacích listů
a objednávky včetně údajů o koncovém zákazníkovi u dropshipmentu.

Na rozdíl od produktových exportů využívá **`FOR XML EXPLICIT`** — výstup je proto pevně
**hierarchický** (vnořené elementy s atributy), ne plochý seznam:

```
Result
└── Invoice (faktura – hlavička)
    ├── DocTaxSum   (rekapitulace DPH – 0..N)
    ├── InvItem     (položky faktury – 0..N)
    ├── Warranty    (sériová čísla / záruky – 0..N)
    ├── Delivery    (dodací listy – 0..N)
    └── Order       (objednávka + koncový zákazník dropshipmentu – 0..N)
```

**`resultType`:** `DocTrInv`

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=DocTrInv&code=FV18141399`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 29861 requestů pro varianty popsané v této sekci. Identifikační, adresní, sériové a trackingové hodnoty jsou anonymizované.

```xml
<Result>
  <Invoice Id="5211856" Code="FV18141399" CodeO="18141399" SymCon="0008" Tag="AUTO" OrdId="4092610" OrdCode="OP18189186" OrdC="2018-08-15T12:09:00" Type="73" DateAcc="2018-08-15T00:00:00" DateDue="2018-08-29T00:00:00" CurCode="CZK" Val="6195.0000" ValCur="6195.0000" ValRnd="0.0000" ValRndCur="0.0000" ValPaid="6195.0000" ValPaidCur="6195.0000" C="2018-08-15T12:24:00">
    <DocTaxSum Id="14043438" TaxRate="21.0000" Base="29500.0000" ValTax="6195.0000" BaseCur="29500.0000" ValTaxCur="6195.0000" />
    <InvItem Id="29138480" StiId="496446" StiCode="183534" StiEAN="" StiEAN2="" StiName="Dell Latitude 5480/i7-7820HQ/8GB/512GB SSD/FHD/Win 10" OrdId="4092610" OrdCode="OP18189186" OriC="2018-08-15T12:09:00" Qty="1.000" TaxRate="21.0000" Prc="29500.0000" PrcTax="6195.0000" CurCode="CZK" PrcCur="29500.0000" PrcTaxCur="6195.0000" PrcRefCur="0.0000" PrcRefCur2="0.0000" RefCode2="9.99" RefProCode2="AFcz" />
    <Warranty Id="52590869" Qty="1.000" SerialNo="ANONYMIZED" StiId="496446" StiCode="183534" Dur="1095" />
    <Delivery Id="6204263" Code="DV18254712" OrdId="4092610" OrdCode="OP18189186" CstId="ANONYMIZED" CstName="ANONYMIZED" CstStreet="ANONYMIZED" CstCity="ANONYMIZED" CstPostCode="ANONYMIZED" CstCouName="Česká republika" />
    <Order Id="4092610" Code="OP18189186" C="2018-08-15T12:09:00" OrwName="E-mailem" CstId="ANONYMIZED" CstName="ANONYMIZED" CstStreet="ANONYMIZED" CstCity="ANONYMIZED" CstPostCode="ANONYMIZED" CstCouName="Česká republika" />
  </Invoice>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/DocTrInv.xml`](examples/priority/DocTrInv.xml)

Příkaz používá vlastní hierarchii `FOR XML EXPLICIT`. Statistiky potvrzují provozní použití základní
varianty; `_El` a `_Schema` proto nejsou uváděny jako podporovaný kontrakt.

**Filtrování a rozsah:**

| Volání                | Chování                                                                                  |
|-----------------------|-------------------------------------------------------------------------------------------|
| `GetResultByCode`     | `code` = číslo faktury (`InvCode`, např. `CRDC120009`)                                    |
| `GetResultByFromTo`   | `from`/`to` filtruje dle data pořízení faktury (`InvC`) i dle posledního potvrzeného DL (`DelDateConf`) |
| `GetResult` (bez param.) | Vrací pouze faktury pořízené za **poslední ~1–2 dny** (`InvC >= dnes − 1`)             |

> Export je vždy **omezen na firmu přihlášeného partnera** (`InvComId`) a vrací jen
> **dokončené, neinterní** faktury (`InvState = 1`, `InvInt = 0`). Partner tak vidí jen své doklady.

##### Element `Invoice` (hlavička faktury)

| Atribut       | Typ         | Popis                                                                     |
|---------------|-------------|---------------------------------------------------------------------------|
| `Id`          | i4          | Interní ID faktury (`InvId`)                                              |
| `Code`        | string      | Číslo faktury                                                             |
| `ZCode`       | string      | B2C kód faktury (`Invoice.InvZCode`), pokud je vyplněn                     |
| `CodeO`       | string      | Externí číslo faktury (číslo u odběratele, jen je-li)                     |
| `SymCon`      | string      | Konstantní symbol faktury (`Invoice.InvSymCon`)                            |
| `Tag`         | string      | Štítek/příznak faktury (jen je-li)                                        |
| `OrdId`       | i4          | ID navázané objednávky                                                    |
| `OrdCode`     | string      | Číslo navázané objednávky                                                 |
| `OrdCodeO`    | string      | Externí číslo objednávky                                                  |
| `OrdC`        | datetime    | Datum pořízení objednávky                                                 |
| `Type`        | ui1         | Typ dokladu: `73` faktura, `67` dobropis, `89` penále, `80` zálohová faktura; typy `106` až `108` označují zákaznické a reverse-charge doklady |
| `DateAcc`     | dateTime    | Účetní datum faktury (`Invoice.InvDateAcc`)                                |
| `DateDue`     | date        | Datum splatnosti                                                          |
| `CurCode`     | string      | Kód měny (ISO, `UsdCodeE`)                                                |
| `Val`         | fixed.14.4  | Celková hodnota v domácí měně                                            |
| `ValCur`      | fixed.14.4  | Celková hodnota v měně faktury                                          |
| `ValRnd`      | fixed.14.4  | Zaokrouhlení (domácí měna)                                               |
| `ValRndCur`   | fixed.14.4  | Zaokrouhlení (měna faktury)                                              |
| `ValPaid`     | fixed.14.4  | Uhrazeno (domácí měna)                                                   |
| `ValPaidCur`  | fixed.14.4  | Uhrazeno (měna faktury)                                                  |
| `ZVal`        | fixed.14.4  | B2C hodnota faktury (`Invoice.InvZVal`)                                    |
| `C`           | datetime    | Datum pořízení faktury (created)                                          |
| `IdC`         | i4          | ID související faktury (u dobropisu původní faktura)                      |
| `CodeC`       | string      | Číslo související faktury (u dobropisu původní faktura)                   |

##### Element `DocTaxSum` (rekapitulace DPH, 0..N)

| Atribut     | Typ         | Popis                                        |
|-------------|-------------|----------------------------------------------|
| `Id`        | i4          | ID řádku rekapitulace (`DtsId`)              |
| `TaxRate`   | fixed.14.4  | Sazba DPH (%)                                |
| `Base`      | fixed.14.4  | Základ daně (domácí měna)                   |
| `ValTax`    | fixed.14.4  | Výše daně (domácí měna)                     |
| `BaseCur`   | fixed.14.4  | Základ daně (měna faktury)                  |
| `ValTaxCur` | fixed.14.4  | Výše daně (měna faktury)                    |

##### Element `InvItem` (položky faktury, 0..N)

| Atribut       | Typ         | Popis                                                                  |
|---------------|-------------|------------------------------------------------------------------------|
| `Id`          | i4          | ID položky faktury (`IniId`)                                           |
| `StiId`       | i4          | ID produktu                                                           |
| `StiCode`     | string      | Skladový kód produktu                                                 |
| `StiCode2`    | string      | Alternativní kód produktu                                            |
| `StiPartNo`   | string      | Výrobní číslo                                                        |
| `StiPartNo2`  | string      | Druhé výrobní číslo                                                  |
| `StiEAN`      | string      | EAN (doplněn dle parametru `WsEAN` partnera, jinak prázdné)          |
| `StiEAN2`     | string      | Druhý EAN                                                            |
| `StiName`     | string      | Název produktu (skladový)                                           |
| `Name`        | string      | Název na položce faktury (vlastní text položky, jen je-li)          |
| `OrdId`       | i4          | ID objednávky položky                                               |
| `OrdCode`     | string      | Číslo objednávky položky                                            |
| `OrdCodeO`    | string      | Externí číslo objednávky položky                                   |
| `OriC`        | datetime    | Datum pořízení položky objednávky                                  |
| `Qty`         | number      | Množství                                                            |
| `TaxRate`     | fixed.14.4  | Sazba DPH položky (%)                                               |
| `Prc`         | fixed.14.4  | Jednotková cena bez DPH (domácí měna)                              |
| `PrcTax`      | fixed.14.4  | Jednotková cena s DPH (domácí měna)                                |
| `CurCode`     | string      | Kód měny položky                                                    |
| `PrcCur`      | fixed.14.4  | Cena bez DPH (měna faktury)                                        |
| `PrcTaxCur`   | fixed.14.4  | Cena s DPH (měna faktury)                                          |
| `PrcRefCur`   | fixed.14.4  | Recyklační poplatek (měna faktury)                                 |
| `RefCode`     | string      | Kód recyklačního poplatku                                          |
| `RefProCode`  | string      | Kód produktu recyklačního poplatku                                 |
| `PrcRefCur2`  | fixed.14.4  | Druhý recyklační poplatek (měna faktury)                          |
| `RefCode2`    | string      | Kód druhého recyklačního poplatku                                 |
| `RefProCode2` | string      | Kód produktu druhého poplatku                                     |
| `ZPrc`        | fixed.14.4  | Cena bez DPH pro koncového zákazníka (dropship)                   |
| `ZPrcTax`     | fixed.14.4  | Cena s DPH pro koncového zákazníka                                |
| `ZPrcRef`     | fixed.14.4  | Recyklační poplatek – dropship                                    |
| `ZPrcRef2`    | fixed.14.4  | Druhý recyklační poplatek – dropship                              |
| `RefIs`       | boolean     | Příznak, že řádek **je** recyklační poplatek (nikoli produkt)     |

##### Element `Warranty` (sériová čísla / záruky, 0..N)

| Atribut    | Typ    | Popis                                                       |
|------------|--------|-------------------------------------------------------------|
| `Id`       | i4     | ID záruky (`WarId`)                                         |
| `Qty`      | number | Množství pro dané sériové číslo                            |
| `SerialNo` | string | Sériové číslo (jen u produktů se sledováním SN)            |
| `StiId`    | i4     | ID produktu                                                |
| `StiCode`  | string | Skladový kód produktu                                     |
| `Dur`      | i4     | Délka záruky (dny; `NULL` = neuvedeno)                    |

##### Element `Delivery` (dodací listy, 0..N)

| Atribut       | Typ    | Popis                                                            |
|---------------|--------|------------------------------------------------------------------|
| `Id`          | i4     | ID dodacího listu (`DelId`)                                      |
| `Code`        | string | Číslo dodacího listu                                            |
| `ZCode`       | string | Číslo DL pro dropship (jen je-li)                               |
| `OrdId`       | i4     | ID objednávky                                                   |
| `OrdCode`     | string | Číslo objednávky                                                |
| `CstId`       | i4     | ID dodací adresy; je-li dodávka na sídlo firmy = `-ComId`       |
| `CstName`     | string | Název dodací adresy (jinak název firmy odběratele)             |
| `CstNameAdd`  | string | Doplněk názvu                                                   |
| `CstNameAdd2` | string | Druhý doplněk názvu                                             |
| `CstStreet`   | string | Ulice                                                          |
| `CstCity`     | string | Město                                                          |
| `CstPostCode` | string | PSČ                                                            |
| `CstCouName`  | string | Země                                                          |

##### Element `Order` (objednávka + koncový zákazník dropshipmentu, 0..N)

Adresa `Cst*` = dodací adresa objednávky. Prefix **`ZCm*` / `ZCst*`** = údaje **koncového
zákazníka** u přímého dropshipmentu (kam se zboží doručuje jménem partnera).

| Atribut        | Typ    | Popis                                                             |
|----------------|--------|-------------------------------------------------------------------|
| `Id`           | i4     | ID objednávky (`OrdId`)                                           |
| `Code`         | string | Číslo objednávky                                                 |
| `CodeO`        | string | Externí číslo objednávky (od odběratele)                        |
| `Tag`          | string | Štítek objednávky                                               |
| `NoteExt`      | string | Externí poznámka k objednávce                                  |
| `C`            | datetime | Datum pořízení objednávky                                     |
| `OrwName`      | string | Název způsobu objednání (`Orders.OrdXOrwId`)                    |
| `CstId`        | i4     | ID dodací adresy objednávky (`-ComId` = sídlo firmy)           |
| `CstName`      | string | Název dodací adresy                                            |
| `CstNameAdd`   | string | Doplněk názvu                                                 |
| `CstNameAdd2`  | string | Druhý doplněk názvu                                           |
| `CstStreet`    | string | Ulice                                                        |
| `CstCity`      | string | Město                                                        |
| `CstPostCode`  | string | PSČ                                                          |
| `CstCouName`   | string | Země                                                        |
| `ZDirect`      | —      | Příznak přímého dropshipmentu (zásilka přímo koncovému zák.)   |
| `ZIPrn`        | ui1    | Režim tisku B2C faktury: `0 = nikdy`, `1 = jen direct`, `2 = vždy` |
| `ZDPrn`        | ui1    | Režim tisku B2C dodacího listu: `1 = jen direct`, `2 = vždy`  |
| `ZCmId`        | i4     | ID koncového zákazníka (dropship)                             |
| `ZCmRegId`     | string | IČO koncového zákazníka                                      |
| `ZCmTaxNum`    | string | DIČ koncového zákazníka                                      |
| `ZCmName`      | string | Název / jméno koncového zákazníka                           |
| `ZCmNameAdd`   | string | Doplněk názvu                                               |
| `ZCmStreet`    | string | Ulice                                                       |
| `ZCmCity`      | string | Město                                                       |
| `ZCmPostCode`  | string | PSČ                                                         |
| `ZCmTitle`     | string | Oslovení / titul                                           |
| `ZCmFName`     | string | Jméno                                                      |
| `ZCmLName`     | string | Příjmení                                                  |
| `ZCmTel`       | string | Telefon                                                   |
| `ZCmTelMob`    | string | Mobil                                                     |
| `ZCmFax`       | string | Fax                                                       |
| `ZCmEMail`     | string | E-mail                                                    |
| `ZCstName`     | string | Dropship dodací adresa – název (liší-li se od `ZCm*`)      |
| `ZCstNameAdd`  | string | Doplněk názvu                                              |
| `ZCstNameAdd2` | string | Druhý doplněk názvu                                        |
| `ZCstStreet`   | string | Ulice                                                     |
| `ZCstCity`     | string | Město                                                     |
| `ZCstPostCode` | string | PSČ                                                       |
| `ZCstCouName`  | string | Země                                                     |

#### 5.2.6 StoItemPriceOrd

Cenový export — **objednací (nákupní) ceny** partnera. Vrací cenu pro objednání, referenční
(recyklační a autorské) poplatky, sazbu DPH. Dle definice exportu.

Pokrývá cenovou část metod `ProductNow` / `AllProductsNow` z ALSO Product API
(dostupnost řeší `StoItemQtyFree`).

**`resultType`:** `StoItemPriceOrd` · `StoItemPriceOrd_El` · `StoItemPriceOrd_Schema`




##### Filtrování přes `GetResultByCode` — prefixy `code`

Tento export podporuje **rozšířené vyhledávání** podle typu kódu. Prefix na začátku parametru
`code` určuje, podle jakého pole se filtruje (bez prefixu = hlavní kód `StiCode`):

| Prefix       | Filtruje podle                                             | Příklad                          |
|--------------|-----------------------------------------------------------|----------------------------------|
| *(žádný)*    | Hlavní skladový kód (`StiCode`)                           | `code=0320663`                   |
| `{StiId}`    | Interní ID produktu                                       | `code={StiId}685699`             |
| `{PartNo}`   | Výrobní číslo                                             | `code={PartNo}GU605CX-QR149`     |
| `{PartNo2}`  | Druhé výrobní číslo                                       | `code={PartNo2}90NR0M65-M007X0`  |
| `{CodeEAN}`  | EAN                                                       | `code={CodeEAN}4711636262347`    |
| `{ManName}`  | Název výrobce (kategorie typu `MAN`)                     | `code={ManName}ASUS`             |
| `{CodeAll}`  | Libovolný evidovaný kód produktu (`StoItemCode`)          | `code={CodeAll}...`              |

> **Hromadný dotaz:** Do `code` lze vložit **více hodnot oddělených tabulátorem** (`\t`) —
> vrátí se záznamy pro všechny. Prefix se uvede jednou na začátku a platí pro celou dávku.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemPriceOrd&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 6062 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" PriceOrd="3889.0000" PriceEU="4597.8200" PriceRef="0.7600" PriceRef2="0.0000" TaxRate="21.0000" PriceB2CMin="4597.8200" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemPriceOrd.xml`](examples/priority/StoItemPriceOrd.xml)
##### Atributy elementu `StoItem`

| Pole           | Typ    | Popis                                                                            |
|----------------|--------|----------------------------------------------------------------------------------|
| `Id`           | i4     | Interní ID produktu (`StiId`)                                                    |
| `Code`         | string | Hlavní skladový kód SWS                                                          |
| `Code2`        | string | Alternativní/druhý kód                                                           |
| `PartNo`       | string | Výrobní (katalogové) číslo                                                       |
| `PartNo2`      | string | Druhé výrobní číslo                                                              |
| `EAN`          | string | EAN                                                                             |
| `EAN2`         | string | Druhý EAN                                                                       |
| `PriceOrd`     | money  | **Objednací (nákupní) cena** partnera — hlavní cena tohoto exportu               |
| `PriceEU`      | money  | Koncová ceníková cena, přepočtená do měny partnera, je-li nastaveno |
| `PriceRef`     | money  | Recyklační poplatek navázaný na produkt                                          |
| `PriceRefInfo` | money  | Informativní hodnota recyklačního poplatku                                       |
| `PriceRef2`    | money  | Druhý recyklační poplatek                                                        |
| `PriceRef2Info`| money  | Informativní hodnota druhého poplatku                                            |
| `TaxRate`      | fixed.14.4 | Sazba DPH (%); u přeshraničního režimu přepočtena dle cílové země (`TaxMeCouId`) |
| `PriceFullIs`  | boolean | Příznak, že partner má oprávnění vidět kompletní sadu fixních cen (`Price*`)     |
| `PriceList`    | money  | Ceníková (fixní) cena — **jen se speciálním oprávněním**, jinak prázdné          |
| `Price0`       | money  | Fixní cenová hladina 0 — jen se speciálním oprávněním                            |
| `Price1`       | money  | Fixní cenová hladina 1 — jen se speciálním oprávněním                            |
| `Price2`       | money  | Fixní cenová hladina 2 — jen se speciálním oprávněním                            |
| `Price3`       | money  | Fixní cenová hladina 3 — jen se speciálním oprávněním                            |
| `Price4`       | money  | Fixní cenová hladina 4 — jen se speciálním oprávněním                            |
| `Price5`       | money  | Fixní cenová hladina 5 — jen se speciálním oprávněním                            |
| `PriceB2CMin`  | money  | Minimální B2C prodejní cena (MAP), přepočtená do měny partnera                   |

##### Poznámky k cenám

- Ceny se vrací pouze pro produkty s **kladnou objednací cenou** (`PriceOrd > 0`).
- Podle nastavení partnera (`WsPriceCur`) mohou být ceny přepočteny do jeho **měny** aktuálním kurzem;
  `PriceEU` a `PriceB2CMin` se v takovém případě přepočítávají do stejné měny.
- `PriceFullIs = 1` signalizuje, že jsou (dle oprávnění) k dispozici i pole `PriceList`/`Price0–5`.
  Bez oprávnění jsou tato pole prázdná i při `PriceFullIs = 0`.

> **Pozn. pro ALSO:** Standardní partner dostává `PriceOrd`, `PriceRef*`, `TaxRate` a `PriceB2CMin`;
> sada `PriceList`/`Price0–5` je nadstavba vázaná na zvláštní oprávnění.

#### 5.2.7 CpsStiVal

Export **parametrů (atributů) produktů** — technické specifikace ve formátu **název × hodnota**.
Dle definice exportu: *„Export parameters of StoItems – Name × Value only (filtered by Code of
StoItem)."* Každý element odpovídá jednomu parametru jednoho produktu; produkt s N parametry
vrátí N elementů. Spolu se `StoItemBase` pokrývá metodu `ProductFullInfo` z ALSO Product API
(atributová část).

**`resultType`:** `CpsStiVal` · `CpsStiVal_El` · `CpsStiVal_Schema`

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=CpsStiVal&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 3083 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <Row Id="25006425" StiId="695888" StiCode="LNM01353" StiPartNo="40BF0100EU" StiPartNo2="40BF0100EU" StiEAN="0195892132486" StiEAN2="" CpaId="1207" Code="GSR" Name="GPSR" Single="1" Value="Lenovo (Slovakia);Landererova 12,811 09,Bratislava,Slovakia;compliance@lenovo.com" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/CpsStiVal.xml`](examples/priority/CpsStiVal.xml)

> **Doporučení k použití:** Export je primárně určen k **filtrování podle kódu produktu**
> (`GetResultByCode`). Přes `GetResult` vrací parametry všech produktů — může jít o velký objem dat.



##### Atributy elementu `Row` (jeden parametr produktu)

| Pole         | Typ    | Popis                                                                          |
|--------------|--------|--------------------------------------------------------------------------------|
| `Id`         | i4     | ID konkrétní hodnoty parametru u produktu (`CpsId`) — jednoznačný klíč řádku    |
| `StiId`      | i4     | Interní ID produktu                                                            |
| `StiCode`    | string | Hlavní skladový kód produktu                                                   |
| `StiCode2`   | string | Alternativní kód produktu                                                      |
| `StiPartNo`  | string | Výrobní číslo                                                                  |
| `StiPartNo2` | string | Druhé výrobní číslo                                                            |
| `StiEAN`     | string | EAN (doplněn dle parametru `WsEAN` partnera, jinak prázdné)                    |
| `StiEAN2`    | string | Druhý EAN                                                                      |
| `CpaId`      | i4     | ID definice parametru (společné pro všechny produkty se stejným parametrem)     |
| `Code`       | string | Kód parametru (`CpaCode`) — strojový identifikátor parametru                    |
| `Grp`        | string | Skupina parametru (`CpaGrp`) pro seskupení do sekcí (jen je-li vyplněna)        |
| `Name`       | string | Název parametru (lokalizovaný) — např. „Úhlopříčka", „Hmotnost"               |
| `NameAdd`    | string | Doplňkový popis parametru (jen je-li)                                          |
| `Single`     | ui1    | Příznak, že lze parametr jednomu produktu přiřadit jen jednou                   |
| `Ord`        | i4     | Pořadí parametru pro řazení ve výpisu (jen je-li nenulové)                     |
| `Value`      | string | **Hodnota parametru** — buď z číselníku (`CpvValue`), nebo volný text (`CpsTag`) |
| `ValueAdd`   | string | Doplňková hodnota / poznámka k hodnotě (jen je-li)                             |
| `Measure`    | money  | Číselná míra přiřazené hodnoty (`ConParSet.CpsMeasure`); nula se nevrací        |
| `CprOrd`     | i4     | Pořadí hodnoty v rámci číselníku parametru (jen je-li nenulové)                |

#### 5.2.8 AttSti

Export **příloh produktů** — obrázky, datasheety, dokumentace a další soubory navázané na produkt.
Každý element = jedna příloha; produkt
s N přílohami vrátí N elementů. Pokrývá metodu `ProductImages` z ALSO Product API (a obecně
i nemedia přílohy, pokud jsou u produktu evidovány).

**`resultType`:** `AttSti` · `AttSti_El` · `AttSti_Schema`

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=AttSti&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 2376 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <AttSti Id="59751269" StiId="695888" StiCode="LNM01353" StiPartNo="40BF0100EU" StiPartNo2="40BF0100EU" StiEAN="0195892132486" StiEAN2="" Name="Thumbnail" Tag="sys-thu" File="LNM01353.jpg" Url="https://terminal.sws.cz/img.asp?attid=59751269" Size="1322" />
  <AttSti Id="59751303" StiId="695888" StiCode="LNM01353" StiPartNo="40BF0100EU" StiPartNo2="40BF0100EU" StiEAN="0195892132486" StiEAN2="" Tag="sys-thu-big" File="LNM01353.jpg" Url="https://terminal.sws.cz/img.asp?attid=59751303" Size="5723" />
  <AttSti Id="59765449" StiId="695888" StiCode="LNM01353" StiPartNo="40BF0100EU" StiPartNo2="40BF0100EU" StiEAN="0195892132486" StiEAN2="" Name="Enlargement" Tag="sys-enl" File="LNM01353.jpg" Url="https://terminal.sws.cz/img.asp?attid=59765449" Size="19826" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/AttSti.xml`](examples/priority/AttSti.xml)

Podporuje stejnou sadu prefixů jako `StoItemPriceOrd` (viz [Formát požadavku](#3-formát-požadavku)):
bez prefixu `StiCode`, dále `{StiId}`, `{PartNo}`, `{PartNo2}`, `{CodeEAN}`, `{ManName}`, `{CodeAll}`.
Více hodnot lze oddělit tabulátorem (`\t`).

```
GetResultByCode?resultType=AttSti&code={ManName}DATAWAY
```

##### Sestavení URL přílohy

Pole `Url` je vráceno **hotové**, ale vzniká dvěma způsoby podle typu přílohy:

- **Externí příloha** (`AttUrl` obsahuje `://`) → `Url` = přímo externí odkaz.
- **Interní příloha** (soubor v i6) → `Url` = `UrlBaseImgGalery` + `Id`
  (tj. `…/img.asp?attid=‹Id›`). Klient tedy může použít `Url` přímo bez skládání.


##### Atributy elementu `AttSti` (jedna příloha)

| Pole         | Typ    | Popis                                                                       |
|--------------|--------|-----------------------------------------------------------------------------|
| `Id`         | i4     | ID přílohy (`AttId`); použito i pro sestavení `Url` u interních příloh        |
| `StiId`      | i4     | Interní ID produktu                                                          |
| `StiCode`    | string | Hlavní skladový kód produktu                                                 |
| `StiCode2`   | string | Alternativní kód produktu                                                    |
| `StiPartNo`  | string | Výrobní číslo                                                                |
| `StiPartNo2` | string | Druhé výrobní číslo                                                          |
| `StiEAN`     | string | EAN (doplněn dle parametru `WsEAN` partnera, jinak prázdné)                  |
| `StiEAN2`    | string | Druhý EAN                                                                    |
| `Name`       | string | Název přílohy (jen je-li vyplněn) — např. „Thumbnail", „Enlargement", popisek |
| `Tag`        | string | Volný interní štítek přílohy; například `sys-thu`, `sys-thu-big` nebo `sys-enl` |
| `File`       | string | Název souboru přílohy (bez cesty; z `AttUrl` odříznut adresář)               |
| `Url`        | string | **Hotová URL přílohy** — externí odkaz, nebo interní `…/img.asp?attid=‹Id›`   |
| `Size`       | i8     | Velikost přílohy v bajtech (u externích může být prázdná)                    |
| `Sort`       | i2     | Pořadí přílohy pro řazení (jen je-li nenulové)                               |

#### 5.2.9 CpsSti

Export **parametrů produktů včetně jejich definic** — normalizovaná (relační) varianta `CpsStiVal`.
Dle definice exportu: *„Export parameters of StoItems include parameter's definition."* Na rozdíl
od `CpsStiVal`, který u každého řádku opakuje název i hodnotu, `CpsSti` vrací **definice parametrů
a číselník hodnot samostatně** a přiřazení k produktům na ně jen odkazuje přes ID. Vhodné, když si
klient chce postavit vlastní parametrickou databázi (definice stáhne jednou, produkty referencují).
Spolu se `StoItemBase` pokrývá atributovou část metody `ProductFullInfo` z ALSO Product API.

**`resultType`:** `CpsSti`

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResult?resultType=CpsSti`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 354 requestů pro varianty popsané v této sekci. Níže je zkrácený, ale dobře formovaný výřez; úplný výstup je v odkazovaném souboru.

```xml
<Result>
  <ConPar>
    <Row Id="74" Type="0" Single="1" Code="Bch" Grp="NTB" Ord="1000" Name="TPM chip (NTB)" AddName="Funkce" />
    <Row Id="75" Type="0" Single="1" Code="Sop" Grp="NTB" Ord="1000" Name="Snímač otisku prstu (NTB)" AddName="Funkce" />
  </ConPar>
  <ConParValue>
    <Row Id="291" Measure="0.0000" Code="THD" Value="SSD" />
    <Row Id="293" Measure="0.0000" Code="Pza" Value="Touchpad" />
  </ConParValue>
  <ConParRange>
    <Row Id="191" CpaId="10018" CpvId="10116" />
    <Row Id="196" CpaId="10018" CpvId="10710" />
  </ConParRange>
  <ConParSet>
    <Row Id="201505" StiId="44661" CpaId="10037" CpvId="10216" StiCode="501217" Value="Epson" />
    <Row Id="201506" StiId="44661" CpaId="10040" CpvId="10251" StiCode="501217" Value="Jehličková" />
  </ConParSet>
  <ConParStr>
    <Row Id="39" StrId="11055" CpaId="99" StrSort="0008NFVIRW6A110" />
    <Row Id="42" StrId="11055" CpaId="102" StrSort="0008NFVIRW6A110" />
  </ConParStr>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/CpsSti.xml`](examples/priority/CpsSti.xml)

> ⚠️ **`CpsStiVal` vs. `CpsSti`:** Pokud ti stačí prostý seznam „produkt → parametr → hodnota",
> použij **`CpsStiVal`** (jednodušší, plochý). `CpsSti` použij, jen když potřebuješ i **metadata
> definic** (typy, číselníky, jazykové mutace, vazby na kategorie).

##### Struktura výstupu

Výstup je **hierarchický** (`FOR XML EXPLICIT`). Pod kořenem `Result` je pět samostatných
kolekcí, každá s elementy `Row` odlišenými podle úrovně:

```
Result
├── ConPar        → Row (definice parametrů)          [úroveň 7]
├── ConParValue   → Row (číselník hodnot)             [úroveň 8]
├── ConParRange   → Row (přípustné hodnoty parametru) [úroveň 9]
├── ConParSet     → Row (přiřazení hodnot produktům)  [úroveň 10]
└── ConParStr     → Row (vazba parametrů na kategorie)[úroveň 11]
```

Provázání na straně klienta: `ConParSet.CpaId` → `ConPar.Id`, `ConParSet.CpvId` →
`ConParValue.Id`; `ConParRange` omezuje, které hodnoty (`CpvId`) patří ke kterému parametru
(`CpaId`); `ConParStr` mapuje parametr na uzel prezentačního stromu (viz `SPresentTree`).

##### `ConPar` → `Row` — definice parametru

| Pole      | Typ    | Popis                                                             |
|-----------|--------|-------------------------------------------------------------------|
| `Id`      | i4     | ID parametru (`CpaId`)                                            |
| `Type`    | ui1    | Typ parametru: `0 = seznam`, `1 = katalog`, `2 = volná ruční hodnota`; export vrací typy `0` a `2` |
| `Single`  | ui1    | Příznak, že lze parametr jednomu produktu přiřadit jen jednou     |
| `Code`    | string | Strojový kód parametru                                           |
| `Grp`     | string | Skupina parametru (pro seskupení do sekcí)                      |
| `Ord`     | i4     | Pořadí parametru pro řazení                                     |
| `Name`    | string | Název parametru (lokalizovaný)                                  |
| `AddName` | string | Doplňkový název (pozn.: v atributu `Row!7!AddName` = `CpaNameAdd`) |
| `NameE`   | string | Název anglicky                                                  |
| `NameAddE`| string | Doplňkový název anglicky                                        |
| `Note`    | string | Poznámka k parametru                                            |

##### `ConParValue` → `Row` — číselníková hodnota

| Pole       | Typ    | Popis                                                    |
|------------|--------|----------------------------------------------------------|
| `Id`       | i4     | ID hodnoty (`CpvId`)                                     |
| `Measure`  | money | Číselná míra definovaná u hodnoty parametru                |
| `Code`     | string | Strojový kód hodnoty                                     |
| `Value`    | string | Hodnota (lokalizovaná)                                   |
| `ValueAdd` | string | Doplněk hodnoty                                          |
| `ValueE`   | string | Hodnota anglicky                                         |
| `ValueAddE`| string | Doplněk hodnoty anglicky                                 |

##### `ConParRange` → `Row` — přípustná hodnota parametru

| Pole    | Typ | Popis                                             |
|---------|-----|---------------------------------------------------|
| `Id`    | i4  | ID vazby (`CprId`)                                |
| `CpaId` | i4  | ID parametru (`ConPar.Id`)                        |
| `CpvId` | i4  | ID přípustné hodnoty (`ConParValue.Id`)           |

##### `ConParSet` → `Row` — přiřazení hodnoty produktu

| Pole      | Typ    | Popis                                                                    |
|-----------|--------|--------------------------------------------------------------------------|
| `Id`      | i4     | ID přiřazení (`CpsId`)                                                    |
| `StiId`   | i4     | ID produktu                                                              |
| `CpaId`   | i4     | ID parametru (`ConPar.Id`)                                               |
| `CpvId`   | i4     | ID hodnoty z číselníku (`ConParValue.Id`); prázdné = hodnota je volný text |
| `StiCode` | string | Skladový kód produktu                                                    |
| `Value`   | string | Hodnota — číselníková (`CpvValue`), nebo volný text (`CpsTag`)           |
| `Measure` | money | Číselná míra přiřazení (`ConParSet.CpsMeasure`); nula se nevrací         |

##### `ConParStr` → `Row` — vazba parametru na kategorii

| Pole      | Typ    | Popis                                                                       |
|-----------|--------|-----------------------------------------------------------------------------|
| `Id`      | i4     | ID vazby (`CosId`)                                                          |
| `StrId`   | i4     | ID uzlu prezentačního stromu (`SPresentTree.Id`)                            |
| `CpaId`   | i4     | ID parametru (`ConPar.Id`)                                                  |
| `StrSort` | string | Sort klíč uzlu (3 znaky/úroveň) — určuje, u které kategorie se parametr používá |

##### Poznámky

- Vrací se pouze **publikované** parametry pro web (`CpaPublishWS`/`CpaPublish = 1`, `CpaHide = 0`)
  s neprázdnou hodnotou; typy parametru `CpaType IN (0, 2)`.
- Množina produktů (`ConParSet`) respektuje **řádková oprávnění** partnera — jiný partner může
  vidět jiné produkty.
- `ConParStr` (vazba na kategorie) vrací jen uzly z **viditelných** větví prezentačního stromu.

#### 5.2.10 SCategorySys

Vrací katalog systémových kategorií z I6. Jde o plochý kategorický export určený pro získání
interního ID, kódu, názvu a případné poznámky kategorie; nevrací hierarchii prezentačního stromu.

**`resultType`:** `SCategorySys` · `SCategorySys_El` · `SCategorySys_Schema`

##### Filtrování a parametry

- `GetResult` vrací všechny kategorie, jejichž typ má příznak `SctSystem = 1`.
- `GetResultByCode` filtruje podle přesného kódu kategorie `SCategory.ScaCode`.
- Parametr `code` má maximální délku 30 znaků; zdrojový sloupec `ScaCode` je `char(4)`.
- `GetResultByFromTo` není podporováno, protože `Command` nemá parametry `ParamFrom` ani `ParamTo`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResult?resultType=SCategorySys`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 30 requestů pro varianty popsané v této sekci. Níže je zkrácený, ale dobře formovaný výřez; úplný výstup je v odkazovaném souboru.

```xml
<Result>
  <SCategory Id="0" Name="- režie 2" />
  <SCategory Id="1" Code="100" Name="3COM" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/SCategorySys.xml`](examples/priority/SCategorySys.xml)
##### Struktura elementů

- `Result` je kořenový element dokumentu.
- `SCategory` je opakovaný element systémové kategorie (`0..N`).
- Prázdné hodnoty `Code` a `Note` se díky `NULLIF` v XML nevytvoří.

##### Atributy elementu `SCategory`

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | Interní ID kategorie (`SCategory.ScaId`) |
| `Code` | string | Kód kategorie (`SCategory.ScaCode`), pokud je vyplněn |
| `Name` | string | Název kategorie (`SCategory.ScaName`) |
| `Note` | string | Poznámka produktového listu (`SCategorySys.ScsPLNote`), pokud je vyplněna |

##### Omezení a poznámky

- `ResultListUser.config` pro `SCategorySys` neobsahuje žádnou `Restriction`, `Modification` ani `Visibility`.
- Databázový sloupec `ScsPLNote` má typ `varchar(5000)`. V aktuální databázi nebyla u systémových
  kategorií nalezena neprázdná hodnota, proto atribut `Note` v uloženém příkladu není.

#### 5.2.11 StoItemActive

Vrací stručný seznam aktivních a pro přihlášeného uživatele dostupných produktů. Obsahuje pouze
identifikaci produktu a EAN, bez cen, skladových množství, popisů a obrázků. Jde o produktový export.

**`resultType`:** `StoItemActive` · `StoItemActive_El` · `StoItemActive_Schema`

##### Filtrování a parametry

- `GetResult` vrací všechny produkty splňující podmínky viditelnosti, objednatelnosti, publikace
  a kladné ceny v cenové hladině firmy přihlášeného uživatele.
- `GetResultByCode` bez prefixu filtruje podle přesného `StoItem.StiCode`.
- Prefixy `{StiId}`, `{PartNo}`, `{PartNo2}`, `{CodeEAN}`, `{ManName}` a `{CodeAll}` mění pole,
  podle kterého se hledá. Více hodnot lze předat oddělených tabulátorem.
- `GetResultByFromTo` není podporováno, protože `Command` nemá parametry `ParamFrom` ani `ParamTo`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemActive&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 183 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" EAN2="" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemActive.xml`](examples/priority/StoItemActive.xml)
##### Struktura elementů

- `Result` je kořenový element dokumentu.
- `StoItem` je opakovaný element produktu (`0..N`).
- `StiCode2`, `PartNo` a `PartNo2` jsou volitelné. EAN se doplňují podle nastavení `WsEAN`
  platného pro přihlášeného uživatele.

##### Atributy elementu `StoItem`

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | Interní ID produktu (`StoItem.StiId`) |
| `Code` | string | Hlavní kód produktu (`StoItem.StiCode`) |
| `StiCode2` | string | Druhý kód produktu (`StoItem.StiCode2`), pokud je vyplněn |
| `PartNo` | string | Výrobní číslo (`StoItem.StiPartNo`), pokud je vyplněno |
| `PartNo2` | string | Druhé výrobní číslo (`StoItem.StiPartNo2`), pokud je vyplněno |
| `EAN` | string | EAN získaný podle nastavení `WsEAN`, pokud je dostupný |
| `EAN2` | string | Druhý EAN získaný podle nastavení `WsEAN`, pokud je dostupný |

##### Omezení a poznámky

- `ResultListUser.config` pro `StoItemActive` neobsahuje žádnou `Restriction`, `Modification` ani `Visibility`.
- Výběr respektuje vlastní `I6WSCONDITION`, případně standardní příznaky skrytí, objednatelnosti
  a publikace produktu, a následně řádková oprávnění přihlášeného uživatele.
- Přítomnost a hodnota EAN mohou záviset na uživatelském nastavení `WsEAN`.

#### 5.2.12 SPresentTreeType

Vrací číselník typů prezentačních stromů. Hodnota `Id` se používá jako parametr `code` exportu
`SPresentTree`, pokud je potřeba načíst kompletní strom určitého typu.

**`resultType`:** `SPresentTreeType` · `SPresentTreeType_El` · `SPresentTreeType_Schema`

##### Filtrování a parametry

- Podporováno je pouze `GetResult`; `Command` nemá runtime parametry.
- Vrací viditelné záznamy `UsrDes` druhu `UsdKind = 29`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResult?resultType=SPresentTreeType`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 30 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <Item Type="0" Id="-2147483648" Name="Druhy" NameE="Categories" />
  <Item Type="1" Id="-2147483647" Name="Značky" NameE="Vendors" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/SPresentTreeType.xml`](examples/priority/SPresentTreeType.xml)
##### Atributy elementu `Item`

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Type` | i4 | Interní tabulková hodnota typu (`UsrDes.UsdTabId`) |
| `Id` | i4 | ID typu předávané exportu `SPresentTree`; počítá se jako `Type - 2147483648` |
| `Name` | string | Český název typu stromu |
| `NameE` | string | Anglický název typu stromu |

`ResultListUser.config` pro tento export neobsahuje zvláštní omezení.

#### 5.2.13 DocTrExp

Vrací expedice firmy přihlášeného uživatele, jejich sledovací URL a vazby na související objednávky,
dodací listy a faktury. Jde o dokladový export.

**`resultType`:** `DocTrExp` · `DocTrExp_El` · `DocTrExp_Schema`

##### Filtrování a parametry

- `GetResultByCode` filtruje podle přesného čísla expedice `Expedition.ExpCode`.
- `GetResultByFromTo` filtruje datum odeslání `Expedition.ExpDateS` včetně obou hranic.
- `GetResult` bez parametrů vrací expedice odeslané od začátku předchozího dne.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=DocTrExp&code=E260146377`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 1814 requestů pro varianty popsané v této sekci. Identifikační, adresní, sériové a trackingové hodnoty jsou anonymizované.

```xml
<Result>
  <Expedition Id="8718076" Code="E260146377" CodeO="%002509123755045124775101203" CodeS="ANONYMIZED" DateS="2026-08-05T12:04:00" C="2026-08-05T11:42:00" ExpTrackUrl="ANONYMIZED" DemName="DPD">
    <ExpDocument />
  </Expedition>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/DocTrExp.xml`](examples/priority/DocTrExp.xml)
##### Atributy elementu `Expedition`

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | Interní ID expedice |
| `Code` | string | Číslo expedice |
| `CodeO` | string | Externí kód expedice |
| `CodeS` | string | Kód zásilky dopravce |
| `DateS` | dateTime | Datum odeslání |
| `C` | dateTime | Datum vytvoření expedice |
| `ExpTrackUrl` | string | URL pro sledování zásilky sestavená funkcí `dbo.fGetParcelURL` |
| `DemName` | string | Název způsobu dopravy |

##### Vnořený element `ExpDocument` (`0..N`)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `ExpId` | i4 | ID nadřazené expedice |
| `Id` | i4 | ID vazby na doklad |
| `SrtId` | ui1 | Typ zdrojového dokladu expedice: `68` dodací list, `69` expedice, `73` faktura, `76` zápůjčka, `77` přesun, `82` reklamace |
| `DelCode` | string | Číslo dodacího listu |
| `InvCode` | string | Číslo faktury |
| `OrdCode` | string | Číslo objednávky v I6 |
| `OrdCodeO` | string | Externí nebo zákaznické číslo objednávky |

Obecná `Restriction` povoluje volání v hodinách 08–20; firmy `0` a `6336` mají časové omezení
zrušené modifikací. Zakomentovaná `Visibility` se neuplatňuje.

#### 5.2.14 StoItemEAN

Vrací identifikaci produktů a EAN podle nastavení `WsEAN` platného pro přihlášeného uživatele.

**`resultType`:** `StoItemEAN` · `StoItemEAN_El` · `StoItemEAN_Schema`

##### Filtrování a parametry

- `GetResultByCode` podporuje prefixy `{StiId}`, `{PartNo}`, `{PartNo2}`, `{CodeEAN}`, `{ManName}`
  a `{CodeAll}`; bez prefixu filtruje podle `StiCode`.
- Více hodnot lze předat oddělených tabulátorem. `GetResultByFromTo` není podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemEAN&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 246 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemEAN.xml`](examples/priority/StoItemEAN.xml)
##### Atributy elementu `StoItem`

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | Interní ID produktu |
| `Code` | string | Kód produktu |
| `Code2` | string | Druhý kód produktu |
| `PartNo` | string | Výrobní číslo |
| `PartNo2` | string | Druhé výrobní číslo |
| `EAN` | string | EAN podle nastavení `WsEAN` |
| `EAN2` | string | Druhý EAN podle nastavení `WsEAN` |

Obecná `Restriction` povoluje volání v hodinách 08–20; firmy `0` a `6336` mají časové omezení
zrušené modifikací.

#### 5.2.15 StoItemList

Vrací seznam produktů sestavený z podmínky předané v `code`. Je vhodný pro získání základních
identifikátorů produktů z kategorie, uzlu prezentačního stromu nebo produktového parametru.

**`resultType`:** `StoItemList` · `StoItemList_El` · `StoItemList_Schema`

##### Filtrování a parametry

- Bez prefixu obsahuje `code` jeden nebo více produktových kódů oddělených tabulátorem.
- `{StrId}ID` vybere produkty z viditelné větve prezentačního stromu.
- `{ScaId}ID` vybere produkty přiřazené systémové kategorii.
- `{CpaId}ID` vybere produkty, které mají přiřazenou hodnotu daného parametru.
- `GetResultByFromTo` není podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemList&code=%7BStrId%7D7046`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 648 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <Item StiId="467969" StiCode="675632" StiCode2="ZB0490" StiPartNo="40AF0135EU" StiEAN="0191999788403" StiEAN2="" />
  <Item StiId="548233" StiCode="765014" StiPartNo="GX90T77924" StiEAN="0193268856752" StiEAN2="" />
  <Item StiId="584090" StiCode="844490" StiCode2="ZB0490" StiPartNo="40AY0090EU" StiEAN="0195348192095" StiEAN2="1P40AY0090EU" />
  <Item StiId="602577" StiCode="845204" StiPartNo="40B00300EU" StiEAN="0195348677295" StiEAN2="" />
  <Item StiId="663071" StiCode="LNC00247" StiPartNo="GX91M73945" StiEAN="0195892091318" StiEAN2="" />
  <Item StiId="663072" StiCode="LNC00248" StiPartNo="GX91M73946" StiEAN="0195892091325" StiEAN2="" />
  <Item StiId="668983" StiCode="LNM00594" StiCode2="ZB0490" StiPartNo="40B90000WW" StiPartNo2="40B90000WW" StiEAN="0195892097808" StiEAN2="" />
  <Item StiId="672620" StiCode="LNC00421" StiPartNo="GX91P83589" StiEAN="0195892101819" StiEAN2="" />
  <Item StiId="672629" StiCode="LNC00429" StiPartNo="GXH1Q27133" StiEAN="0195892103660" StiEAN2="" />
  <Item StiId="672792" StiCode="LNM00669" StiPartNo="4X11N40212" StiPartNo2="4X11N40212" StiEAN="0195892095453" StiEAN2="" />
  <Item StiId="683558" StiCode="LNC00834" StiPartNo="GXH1T52710" StiEAN="0195892131946" StiEAN2="" />
  <Item StiId="683815" StiCode="LNM01047" StiPartNo="40B90100EU" StiEAN="0195892097716" StiEAN2="" />
  <Item StiId="683817" StiCode="LNM01049" StiPartNo="40BA0265EU" StiEAN="0195892112907" StiEAN2="" />
  <Item StiId="683819" StiCode="LNM01050" StiPartNo="40BC0100EU" StiEAN="0195892120551" StiEAN2="" />
  <Item StiId="683822" StiCode="LNM01051" StiPartNo="40BC0135EU" StiEAN="0195892130499" StiEAN2="" />
  <Item StiId="683824" StiCode="LNM01052" StiPartNo="40BE0135EU" StiEAN="0195892121305" StiEAN2="" />
  <Item StiId="695888" StiCode="LNM01353" StiPartNo="40BF0100EU" StiPartNo2="40BF0100EU" StiEAN="0195892132486" StiEAN2="" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemList.xml`](examples/priority/StoItemList.xml)
##### Atributy elementu `Item`

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | Interní ID produktu |
| `Code` | string | Kód produktu |
| `Code2` | string | Druhý kód produktu |
| `PartNo` | string | Výrobní číslo |
| `PartNo2` | string | Druhé výrobní číslo |
| `EAN` | string | EAN podle nastavení `WsEAN` |
| `EAN2` | string | Druhý EAN podle nastavení `WsEAN` |

Výběr následně respektuje produktovou viditelnost a řádková oprávnění uživatele.
`ResultListUser.config` pro tento export neobsahuje zvláštní omezení.

#### 5.2.16 StiPacking

Vrací logistické varianty balení produktu a případné obalové složky. Jde o produktový a logistický
export s hierarchií `StoItem` → `StiPacking` → `Wrap`.

**`resultType`:** `StiPacking` · `StiPacking_El` · `StiPacking_Schema`

##### Filtrování a parametry

- `GetResultByCode` podporuje běžné produktové prefixy; bez prefixu filtruje podle `StiCode`.
- Více hodnot lze předat oddělených tabulátorem. `GetResultByFromTo` není podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StiPacking&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 341 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" EAN2="">
    <StiPacking Id="623147" StiId="695888" PatUsdId="313" PatId="1" PatCode="BA" PatName="Balitelné" PauUsdId="929" PauId="0" PauCode="UNI" PauName="Jednotka" Qty="1.000" Length="23.0" Height="8.0" Width="14.0" Volume="2576.0" Weight="0.64000">
      <Wrap Id="851309" Weight="0.067" WrtId="20" WrtName="Papír" />
      <Wrap Id="851310" Weight="0.005" WrtId="2" WrtName="MP - PE - transparentní" />
      <Wrap Id="851311" Weight="0.014" WrtId="6" WrtName="MP - Jiné plasty - transparentní" />
    </StiPacking>
  </StoItem>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StiPacking.xml`](examples/priority/StiPacking.xml)
##### Element `StoItem`

Obsahuje atributy `Id` (`i4`), `Code`, `Code2`, `PartNo`, `PartNo2`, `EAN` a `EAN2` (`string`).

##### Vnořený element `StiPacking` (`0..N`)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | ID varianty balení |
| `StiId` | i4 | ID produktu |
| `EAN` | string | Kód balení `LspStoCode1` |
| `PatUsdId`, `PatId` | i4 | Interní identifikátory typu balení |
| `PatCode`, `PatName` | string | Kód a název typu balení |
| `PauUsdId`, `PauId` | i4 | Interní identifikátory jednotky balení |
| `PauCode`, `PauName` | string | Kód a název jednotky balení |
| `Qty` | fixed.9.3 | Množství v balení |
| `Length`, `Height`, `Width` | fixed.6.1 | Rozměry balení, jsou-li nenulové |
| `Volume` | fixed.10.1 | Objem balení, je-li nenulový |
| `Weight`, `WeightW` | fixed.10.5 | Hmotnosti balení, jsou-li nenulové |

##### Vnořený element `Wrap` (`0..N` na balení)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | ID obalové složky |
| `LspId` | i4 | ID nadřazeného balení |
| `Weight` | fixed.9.3 | Hmotnost obalové složky |
| `WrtUsdId`, `WrtId` | i4 | Interní identifikátory druhu obalu |
| `WrtCode`, `WrtName` | string | Kód a název druhu obalu |

Obecná `Restriction` povoluje volání v hodinách 08–20; firmy `0` a `6336` mají časové omezení
zrušené modifikací.

#### 5.2.17 StiRelation

Vrací obecné vztahy mezi dvojicemi viditelných produktů. Nezahrnuje typy vztahu `3` a `4`;
podmíněné nabídky typu `4` poskytuje samostatný export `StiRelationCO`.

**`resultType`:** `StiRelation` · `StiRelation_El` · `StiRelation_Schema`

##### Filtrování a parametry

- `GetResultByCode` filtruje zdrojový produkt podle `StiCode`.
- Konfigurace deklaruje prefix `{PartNo}`, ale odvozená tabulka `s` neobsahuje sloupec `StiPartNo`;
  tato varianta může skončit SQL chybou a není považována za funkčně ověřenou.
- Více hodnot lze předat oddělených tabulátorem.
- `GetResultByFromTo` filtruje datum změny vztahu `StiRelation.SirU` včetně obou hranic.
- Vrací globální vztahy a vztahy určené firmě přihlášeného uživatele.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StiRelation&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 1275 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StiRelation />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StiRelation.xml`](examples/priority/StiRelation.xml)
##### Atributy elementu `StiRelation`

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | ID vztahu |
| `SreId` | ui1 | ID typu vztahu |
| `SreName` | string | Název typu vztahu z `SysDes` |
| `StiId` | i4 | ID zdrojového produktu |
| `StiCode` | string | Kód zdrojového produktu |
| `StiIdR` | i4 | ID souvisejícího produktu |
| `StiCodeR` | string | Kód souvisejícího produktu |
| `Sort` | i4 | Pořadí vztahu |

`ResultListUser.config` pro tento export neobsahuje zvláštní omezení.

#### 5.2.18 StoItemNode

Vrací přiřazení produktů k uzlům prezentačních stromů a pro každé přiřazení také cestu od typu
stromu přes nadřazené uzly k přiřazenému uzlu.

**`resultType`:** `StoItemNode` · `StoItemNode_El` · `StoItemNode_Schema`

##### Filtrování a parametry

`GetResultByCode` podporuje běžné produktové prefixy a seznam hodnot oddělených tabulátorem.
`GetResultByFromTo` není podporováno. Skryté typy a větve stromu se nevracejí.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemNode&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 227 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" EAN2="">
    <NodeAssign Id="4039">
      <Node Id="-2147483648" Name="Druhy" />
      <Node Id="19584" Name="Počítačové příslušenství" />
      <Node Id="107" Name="Příslušenství PC/Notebooky" />
      <Node Id="4039" Name="Port replikátory a dokovací stanice" />
    </NodeAssign>
    <NodeAssign Id="7046">
      <Node Id="-2147483647" Name="Značky" />
      <Node Id="6317" Name="Lenovo" />
      <Node Id="6318" Name="Notebooky" />
      <Node Id="6323" Name="Příslušenství k notebookům" />
      <Node Id="7046" Name="Port replikátory/Docking station" />
    </NodeAssign>
    <NodeAssign Id="32789">
      <Node Id="-2147483647" Name="Značky" />
      <Node Id="6317" Name="Lenovo" />
      <Node Id="28484" Name="Příslušenství" />
      <Node Id="32789" Name="Port replikátory/Docking station" />
    </NodeAssign>
  </StoItem>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemNode.xml`](examples/priority/StoItemNode.xml)
##### Struktura elementů

- `StoItem` (`0..N`) má atributy `Id`, `Code`, `Code2`, `PartNo`, `PartNo2`, `EAN`, `EAN2`.
- `NodeAssign` (`0..N`) obsahuje `Id`, což je ID přímo přiřazeného uzlu.
- `Node` (`1..N` na přiřazení) obsahuje `Id` a `Name` každého uzlu cesty; úroveň typu stromu má záporné ID.

Obecná `Restriction` povoluje volání v hodinách 08–20. Firmy `0`, `6336`, `986`, `14610`,
`25337` a `37852` mají časové omezení zrušené modifikací.

#### 5.2.19 StoItemHook

Vrací komponenty navázané na produkty typu sestava nebo balíček (`StiYSttId IN (2,3)`) a cenu
komponenty pro firmu přihlášeného uživatele.

**`resultType`:** `StoItemHook` · `StoItemHook_El` · `StoItemHook_Schema`

##### Filtrování a parametry

- `GetResultByCode` podporuje běžné produktové prefixy; vztahují se k nadřazenému produktu.
- `GetResultByFromTo` filtruje změnu produktu nebo jeho ceny (`StiU` nebo `SipU`).

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemHook&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 150 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItemHook />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemHook.xml`](examples/priority/StoItemHook.xml)
##### Atributy elementu `StoItemHook`

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | ID vazby `StoItemPack.SikId` |
| `IdMaster`, `CodeMaster` | i4, string | ID a kód nadřazeného produktu |
| `IdSlave`, `CodeSlave`, `NameSlave` | i4, string, string | ID, kód a název komponenty |
| `PriceSlave` | fixed.19.4 | Cena komponenty pro přihlášenou firmu |

Základní konfigurace povoluje běžné volání bez hodinového omezení, ale `ByFromTo` pouze v hodinách
08–20. Uživatelská konfigurace omezuje běžné volání na 08–20 s výjimkou firem `0`, `6336` a `13013`.

#### 5.2.20 StoItemPriceOrdCur

Vrací objednací cenu produktů v měně nastavené na firmě přihlášeného uživatele. Kořen `Result`
obsahuje kód této měny.

**`resultType`:** `StoItemPriceOrdCur` · `StoItemPriceOrdCur_El` · `StoItemPriceOrdCur_Schema`

##### Filtrování a parametry

- `GetResultByCode` podporuje běžné produktové prefixy a více hodnot oddělených tabulátorem.
- `GetResultByFromTo` filtruje datum změny `StoItemPrice.SipU` včetně obou hranic.
- Vrací jen produkty s kladnou `PriceOrd`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemPriceOrdCur&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 165 requestů pro varianty popsané v této sekci.

```xml
<Result CurCode="CZK">
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" PriceOrd="3889.0000" PriceRef="0.7600" PriceRef2="0.0000" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemPriceOrdCur.xml`](examples/priority/StoItemPriceOrdCur.xml)
##### Struktura a pole

- `Result.CurCode` (`string`) je kód měny firmy z `UsrDes.UsdCodeE`.
- `StoItem` obsahuje `Id`, `Code`, `Code2`, `PartNo`, `PartNo2`, `EAN`, `EAN2`, `PriceOrd`,
  `PriceRef`, `PriceRefInfo`, `PriceRef2` a `PriceRef2Info`; cenová pole mají typ `fixed.19.4`.

Základní i uživatelská konfigurace omezují běžné volání a `ByFromTo` na hodiny 08–20. Pro firmu
`27804` modifikace povoluje běžné volání jen v sudých hodinách 08, 10, 12, 14, 16, 18 a 20.

#### 5.2.21 StoItemQtyFreeEx

Rozšiřuje skladový export o dostupnost a nejbližší očekávané dodávky, a to jak v celkovém, tak
ve volném množství.

**`resultType`:** `StoItemQtyFreeEx` · `StoItemQtyFreeEx_El` · `StoItemQtyFreeEx_Schema`

##### Filtrování a parametry

`GetResultByCode` podporuje běžné produktové prefixy a více hodnot oddělených tabulátorem.
`GetResultByFromTo` není podporováno. Bez `code` se vynechají produkty bez jakékoliv dostupnostní hodnoty.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemQtyFreeEx&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 36191 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" EAN2="" QtyFreeIs="1" Avail="21" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemQtyFreeEx.xml`](examples/priority/StoItemQtyFreeEx.xml)
##### Atributy elementu `StoItem`

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id`, `Code`, `Code2`, `PartNo`, `PartNo2`, `EAN`, `EAN2` | různé | Základní identifikace produktu |
| `QtyFreeIs` | boolean | Příznak dostupnosti hodnoty volného množství |
| `QtyFree` | i4 | Volné množství |
| `Avail` | i4 | Předpokládaná dostupnost zboží ve dnech; `StiAvail`, případně výchozí `ScsAvail` systémové kategorie |
| `DateNextShip` | dateTime | Datum nejbližší očekávané dodávky |
| `QtyNextShipIs` | boolean | Příznak dostupnosti množství nejbližší dodávky |
| `QtyNextShip` | i4 | Celkové množství nejbližší dodávky |
| `DateNextShipFree` | dateTime | Datum nejbližší dodávky s volným množstvím |
| `QtyNextShipFreeIs` | boolean | Příznak dostupnosti volného množství nejbližší dodávky |
| `QtyNextShipFree` | i4 | Volné množství nejbližší dodávky |

Množství mohou být omezena hodnotou `MaxI`, pokud uživatel nemá parametr
`Result-QtyFree-IgnoreMaxI`. `ResultListUser.config` omezuje viditelnost na explicitní seznam firem
uvedený v konfiguraci.

#### 5.2.22 StrStiSync

Synchronizační export části prezentačního stromu a produktů, které jsou do vybrané větve zařazeny.
Součástí jsou základní parametry prostředí pro tvorbu adres obrázků a sazby daně.

**`resultType`:** `StrStiSync` · `StrStiSync_El` · `StrStiSync_Schema`

##### Filtrování a parametry

Parametr `code` je číselné ID uzlu prezentačního stromu. Konfigurace podporuje také záporné ID
odvozené od typu stromu. Výběr zahrnuje zadaný uzel a jeho potomky. `GetResultByFromTo` není
podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StrStiSync&code=7046`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 53248 requestů pro varianty popsané v této sekci. Níže je zkrácený, ale dobře formovaný výřez; úplný výstup je v odkazovaném souboru.

```xml
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=" UrlBaseThumbnail="https://terminal.sws.cz/img.asp?attname=thumbnail&amp;attpedid=52&amp;attsrcid=" UrlBaseEnlargement="https://terminal.sws.cz/img.asp?attname=enlargement&amp;attpedid=52&amp;attsrcid=" UrlBaseImgGalery="https://terminal.sws.cz/img.asp?attid=" CouCode="CZ " TaxRateLow="12" TaxRateHigh="21">
  <SPresentTree Id="7046" IdP="6323" Name="Port replikátory/Docking station">
    <StoItem Id="548233" Code="765014" PartNo="GX90T77924" Name="Lenovo Hub CONS USB-C  7-in-1 Travel" NameE="Lenovo Hub CONS USB-C  7-in-1 Travel" NameMan="Lenovo" WarDur="372" CutCode="84718000  " Weight="0.10800" CouCode="CN        " TaxRate="21.0000" RefProName="REMA" RefCode="9.9.99" RefProName2="Autorský fond CZ" RefCode2="9.99" WeightRef="0.03200" ImgSize="21261" ThumbnailSize="1347" NoteShort="Lenovo hub CONS USB-C  7-in-1 Travel HUB" Note="Lenovo USB-C 7-in-1 Hub&#13;&#10;&#13;&#10;Produktivita na cestách. Konečně je zde dokovací stanice pro jednorázové cestování. Připojte a nabíjejte nová a starší zařízení, ať jste kdekoli. &#13;&#10;Elegantní a kompaktní, rozbočovač Lenovo USB-C 7 v 1 zapadá do vaší každodenní tašky neomezenou produktivitu.&#13;&#10;&#13;&#10;Technické...">
      <ImgGal />
    </StoItem>
    <StoItem Id="602577" Code="845204" PartNo="40B00300EU" Name="Lenovo Dock ThinkPad Thunderbolt 4 WorkStation 230W" NameE="Lenovo Dock ThinkPad Thunderbolt 4 WorkStation 230W" NameMan="Lenovo" WarDur="1116" CutCode="84718000  " Weight="0.57000" CouCode="CN        " TaxRate="21.0000" RefProName="ASEKOL" RefCode="5.55." RefProName2="Autorský fond CZ" RefCode2="9.99" WeightRef="0.45000" ImgSize="17412" ThumbnailSize="1967" EnlargementSize="59000" NoteShort="Lenovo ThinkPad Thunderbolt 4 WorkStation Dock&#13;&#10;&#13;&#10;&#13;&#10;&#13;&#10;Nejlepší funkce&#13;&#10;ThinkPad Thunderbolt™ 4 Workstation Dock podporuje až 230W PD&#13;&#10;Podpora jednoho displeje 8K@30Hz nebo až 4 4K@60HZ&#13;&#10;tiché upgrady firmwaru, podpora vPro/AMT Pass through a&#13;&#10;rychlost pře" Note="Premium Thunderbolt™ 4 Docking Experience: ThinkPad Thunderbolt 4 Workstation Dock (40B0) poskytuje spolehlivé a konzistentní špičkové video, datové a napájecí připojení. Lenovo ThinkPad® Thunderbolt™ 4 Workstation Dock, navržený pro ty, kteří odmítají být průměrní, poskytuje prvotřídní výkon dok...">
      <ImgGal />
    </StoItem>
  </SPresentTree>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/StrStiSync.xml`](examples/priority/StrStiSync.xml)
##### Struktura elementů

`Result` obsahuje uzly `SPresentTree`; každý uzel může obsahovat produkty `StoItem` a každý produkt
galerii `ImgGal`.

| Element | Pole | Typ | Popis |
| ---- | ---- | --- | ----- |
| `Result` | `UrlBase`, `UrlBaseImg`, `UrlBaseThumbnail`, `UrlBaseEnlargement`, `UrlBaseImgGalery` | string | Základní URL služby a obrazových variant |
| `Result` | `CouCode`, `TaxRateLow`, `TaxRateHigh` | různé | Kód země a nízká/vysoká sazba daně |
| `SPresentTree` | `Id`, `IdP`, `Sort`, `Name` | různé | ID uzlu, rodiče, pořadí a název |
| `StoItem` | `Id`, `Code`, `PartNo`, `Name`, `NameE`, `NameAdd`, `NameMan` | různé | Identifikace a názvy produktu |
| `StoItem` | `WarDur`, `CutCode`, `QtyPack`, `Weight`, `CouCode`, `TaxRate` | různé | Záruční doba, celní kód, balení, hmotnost, země a daň |
| `StoItem` | `RefProName`, `RefCode`, `RefProName2`, `RefCode2`, `WeightRef`, `MeasureRef2` | různé | Referenční údaje produktu |
| `StoItem` | `ImgSize`, `ThumbnailSize`, `EnlargementSize` | i4 | Velikosti obrazových variant |
| `StoItem` | `NoteShort`, `Note` | string | Krátký a úplný popis |
| `ImgGal` | `Id`, `Name`, `Tag`, `Sort`, `Size` | různé | Identifikace a metadata obrázku galerie |

Volání `ByCode` je standardně povoleno v hodinách 08 až 11 a 14 až 20. Pro firmy vyjmenované
v `Modification` se časové omezení ruší.

#### 5.2.23 DocTrDel

Dokladový export potvrzených externích dodacích listů vybraných skladových pohybů. Vrací hlavičku,
skladové operace a případná sériová čísla.

**`resultType`:** `DocTrDel` · `DocTrDel_El` · `DocTrDel_Schema`

##### Filtrování a parametry

`GetResultByCode` vyhledává přesný `Delivery.DelCode`. `GetResultByFromTo` filtruje datum potvrzení
`Delivery.DelDateConf`; bez parametrů se použije začátek předchozího dne. Export omezuje záznamy
na `DelState = 1`, `DelInt = 0`, firmu připojení a typy pohybu `40`, `45` a `65`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=DocTrDel&code=DV18254712`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 616 requestů pro varianty popsané v této sekci. Identifikační, adresní, sériové a trackingové hodnoty jsou anonymizované.

```xml
<Result>
  <Delivery Id="6204263" Code="DV18254712" Type="0" NoteExt="" C="2018-08-15T12:24:00" DateAcc="2018-08-15T00:00:00" DateConf="2018-08-15T13:27:00" SmtId="40" SmtCode="SAL" SmtName="Prodej" DemId="8" DemCode="0" DemName="SWS Praha" CstId="ANONYMIZED" CstName="ANONYMIZED" CstNameAdd="ANONYMIZED" CstNameAdd2="ANONYMIZED" CstStreet="ANONYMIZED" CstCity="ANONYMIZED" CstPostCode="ANONYMIZED" CstCouName="Česká republika">
    <StoOper Id="21194281" DelId="6204263" Qty="1.000" StiId="496446" StiCode="183534" StiEAN="" StiEAN2="" StiName="Dell Latitude 5480/i7-7820HQ/8GB/512GB SSD/FHD/Win 10" OrdCode="OP18189186" OriC="2018-08-15T12:09:00" Prc="29500.0000" CurCode="CZK" PrcCur="29500.0000" />
    <Warranty Id="52590869" Qty="1.000" SerialNo="ANONYMIZED" StiId="496446" StiCode="183534" Dur="1095" />
  </Delivery>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/DocTrDel.xml`](examples/priority/DocTrDel.xml)
##### Struktura elementů

`Result` obsahuje `Delivery`; pod ním se opakují `StoOper` a jejich případné `Warranty`.

| Element | Pole | Typ | Popis |
| ---- | ---- | --- | ----- |
| `Delivery` | `Id`, `Code`, `CodeO`, `ZCodeO`, `Type`, `C` | různé | Identifikace, kódy, typ a datum vytvoření dokladu |
| `Delivery` | `DateAcc`, `DateConf`, `DateS`, `DateHand` | dateTime | Účetní, potvrzovací, expediční a předávací datum |
| `Delivery` | `NoteExt` | string | Externí poznámka; viz upozornění níže |
| `Delivery` | `SmtId`, `SmtCode`, `SmtName` | různé | Identifikace typu skladového pohybu |
| `Delivery` | `DemId`, `DemCode`, `DemName` | různé | Identifikace způsobu dopravy |
| `Delivery` | `CstId`, `CstName`, `CstNameAdd`, `CstNameAdd2`, `CstStreet`, `CstCity`, `CstPostCode`, `CstCouName` | různé | Dodací adresa |
| `StoOper` | `Id`, `DelId`, `Qty` | různé | ID operace, ID dodacího listu a množství |
| `StoOper` | `StiId`, `StiCode`, `StiCode2`, `StiPartNo`, `StiPartNo2`, `StiEAN`, `StiEAN2`, `StiName` | různé | Identifikace produktu |
| `StoOper` | `OrdCode`, `OrdCodeO`, `OriC` | různé | Kódy objednávky a datum vytvoření její položky |
| `StoOper` | `Prc`, `CurCode`, `PrcCur` | různé | Cena v základní měně, měna a cena v měně |
| `Warranty` | `Id`, `Qty`, `SerialNo`, `StiId`, `StiCode`, `Dur` | různé | Sériové číslo, množství, produkt a délka záruky |

Konfigurace pro `NoteExt` používá výraz, který při neprázdném `DelNoteExt` vrátí `DelCodeO`, nikoli
obsah poznámky. Jde o ověřenou vlastnost SQL definice a pravděpodobnou chybu konfigurace.
`ResultListUser.config` povoluje export standardně v hodinách 08 až 20; pro firmy `6336` a `0`
časové omezení ruší.

#### 5.2.24 Order

Export objednávek přihlášené firmy včetně objednávkových položek, fakturačních firemních údajů a
dodacích adres.

**`resultType`:** `Order` · `Order_El` · `Order_Schema`

##### Filtrování a parametry

`GetResultByCode` vyhledává přesný `Orders.OrdCode`. `GetResultByFromTo` filtruje datum vytvoření
`Orders.OrdC`. Bez parametrů export vrací neuzavřené objednávky. Ve všech režimech vylučuje interní
objednávky a objednávky s nulovou hodnotou, pokud nejde o příslušný zvláštní typ nabídky.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=Order&code=OP17210792`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 28310 requestů pro varianty popsané v této sekci. Identifikační, adresní, sériové a trackingové hodnoty jsou anonymizované.

```xml
<Result>
  <Order Id="3746959" Code="OP17210792" CodeO="BLOKACE" CurCode="CZK" Type="0" Closed="1" C="2017-09-22T12:39:00">
    <OrdItem Id="20578654" StiId="433334" StiCode="ADMINPOPLR" StiCode2="" Code="ADMINPOPLR" Name="Balné, manipulace" Qty="1.0000" QtyCanc="1.0000" CurCode="CZK" PrcCur="25.0000" PrcTaxCur="5.2500" Prc="25.0000" PrcTax="5.2500" />
    <OrdItem Id="20578657" StiId="437360" StiCode="180581" StiCode2="" Code="180581" Name="DELL Latitude 5480/i7-7600U/8GB/1TB/GeForce 930MX/14.0&quot; FHD/Win 10 Pro 64bit/Černá" Qty="2.0000" QtyInv="2.0000" OriDeliv="2.0000" CurCode="CZK" PrcCur="20377.0000" PrcTaxCur="4279.1700" Prc="20377.0000" PrcTax="4279.1700" PrcRef="14.0000" PrcRefTax="16.9400" PrcRef2="30.0000" PrcRefTax2="36.3000" />
    <OrdItem Id="20578660" StiId="445903" StiCode="180957" StiCode2="" Code="180957" Name="DELL Vostro 5468/i7-7500U/8GB/1TB/GeForce 940MX/14&quot;/HD/FingerPrint/Win 10 PRO 64bit/šedý" Qty="1.0000" QtyInv="1.0000" OriDeliv="1.0000" CurCode="CZK" PrcCur="12283.0000" PrcTaxCur="2579.4300" Prc="12283.0000" PrcTax="2579.4300" PrcRef="14.0000" PrcRefTax="16.9400" PrcRef2="30.0000" PrcRefTax2="36.3000" />
  </Order>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/Order.xml`](examples/priority/Order.xml)
##### Struktura elementů

`Result` obsahuje `Order`; pod ním jsou `ZCompany`, `ComShipTo`, `ZComShipTo` a opakované `OrdItem`.

| Element | Pole | Typ | Popis |
| ---- | ---- | --- | ----- |
| `Order` | `Id`, `Code`, `CodeO`, `ZCodeO`, `CurCode`, `Type`, `Closed`, `C`, `NoteExt` | různé | Identifikace a základní údaje objednávky |
| `ZCompany` | `Id`, `CodeO`, `RegId`, `TaxNum`, `Name`, `NameAdd`, `Street`, `City`, `PostCode`, `Title`, `FName`, `LName`, `Tel`, `TelMob`, `Fax`, `EMail` | různé | Údaje firmy a kontaktu |
| `ComShipTo`, `ZComShipTo` | `Id`, `Name`, `NameAdd`, `NameAdd3`, `Street`, `City`, `PostCode`, `Tel`, `Fax`, `EMail` | různé | Dodací adresa; XML `NameAdd3` pochází ze zdrojového pole `NameAdd2` |
| `OrdItem` | `Id`, `StiId`, `StiCode`, `StiCode2`, `Code`, `Name` | různé | Identifikace položky a produktu |
| `OrdItem` | `Qty`, `QtyCanc`, `QtyBlock`, `QtyInv`, `OriDeliv` | různé | Objednané, zrušené, blokované, fakturované a dodané množství |
| `OrdItem` | `CurCode`, `PrcCur`, `PrcTaxCur`, `Prc`, `PrcTax`, `ZPrc`, `ZPrcTax` | různé | Měna a prodejní ceny |
| `OrdItem` | `PrcRef`, `PrcRefTax`, `PrcRef2`, `PrcRefTax2` | různé | Referenční ceny a jejich hodnoty s daní |

#### 5.2.25 StoItemShop_El

Produktový XML feed pro e-shopy. Vrací produktové údaje, ceny, sklad, dostupnost, kategorie, obrázky,
parametry, vazby, přílohy a varianty. `StoItemShoptet_El` používá stejný příkaz přes `IncludeText`, ale
pevně zapíná volbu `ShoptetStrict`, která upravuje strukturu pro Shoptet.

**`resultType`:** `StoItemShop_El` · `StoItemShoptet_El`

##### Filtrování a parametry

`GetResultByCode` podporuje prefixy `StiId`, `PartNo`, `PartNo2`, `CodeEAN`, `ManName` a `CodeAll`;
více hodnot lze oddělit tabulátorem. `GetResultByFromTo` filtruje datum změny produktu `StoItem.StiU`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemShop_El&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 288 requestů pro varianty popsané v této sekci.

```xml
<SHOP>
  <SHOPITEM id="695888">
    <CODE>LNM01353</CODE>
    <EAN>0195892132486</EAN>
    <PART_NUMBER>40BF0100EU</PART_NUMBER>
    <NAME>Lenovo ThinkPad USB4 Dock 5000 - 65W - EU</NAME>
    <MANUFACTURER>Lenovo</MANUFACTURER>
    <SHORT_DESCRIPTION>Popis produktu

Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstr</SHORT_DESCRIPTION>
    <DESCRIPTION>Popis produktu

Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstream konektivitou o propustnosti 40 Gb/s, což umožňuje rozšířit konfiguraci monitorů o více pixelů a vyšší obnovovací frekvence.

Dokovací stanice může dodávat 65 W napájení notebooku při použití 100W napájecího adaptéru, nebo lze použít 135W adaptér, který zvýší nabíjecí výkon až na 100 W pro notebook.



Hlavní vlastnosti



Dokovací stanice ThinkPad® USB4 Dock 5000 s nejnovější technologií USB4 nabízí až čtyřnásobný výkon konektivity oproti USB-C 3.2 Gen 2. Díky propustnosti až 40 Gb/s můžete připojit buď jeden monitor s ultravysokým rozlišením 8K při 60 Hz, nebo dva monitory 4K s obnovovací frekvencí 144 Hz. Snadno tak rozšíříte svůj notebook Lenovo na plnohodnotnou pracovní platformu s různými periferními zařízeními.

Dok podporuje Power Delivery 3.1 a poskytuje až 100 W pro rychlé nabíjení notebooku, takže můžete jednoduše rozšířit možnosti svého pracovního prostoru.



Dokovací stanice je navíc univerzálně kompatibilní s různými operačními systémy.</DESCRIPTION>
    <WARRANTY>36</WARRANTY>
    <ITEM_TYPE>product</ITEM_TYPE>
    <UNIT>ks</UNIT>
    <PRICE>4598.58</PRICE>
    <STANDARD_PRICE>3889.00</STANDARD_PRICE>
    <PURCHASE_PRICE>3889.76</PURCHASE_PRICE>
    <RECYCLING_FEE>0.76</RECYCLING_FEE>
    <FEE>0.76</FEE>
    <FEE2>0.00</FEE2>
    <VAT>21</VAT>
    <PRICE_VAT>5564.28</PRICE_VAT>
    <PURCHASE_PRICE_VAT>4706.61</PURCHASE_PRICE_VAT>
    <PRICE_MIN>4597.82</PRICE_MIN>
    <CURRENCY>CZK</CURRENCY>
    <LOGISTIC>
      <WEIGHT>0.64000</WEIGHT>
      <HEIGHT>8.0</HEIGHT>
      <WIDTH>14.0</WIDTH>
      <DEPTH>23.0</DEPTH>
    </LOGISTIC>
    <STOCK>
      <AMOUNT>1.000</AMOUNT>
    </STOCK>
    <AVAILABILITY>skladem</AVAILABILITY>
    <CATEGORIES>
      <CATEGORY id="4039">Druhy &gt; Počítačové příslušenství &gt; Příslušenství PC/Notebooky &gt; Port replikátory a dokovací stanice</CATEGORY>
      <CATEGORY id="7046">Značky &gt; Lenovo &gt; Notebooky &gt; Příslušenství k notebookům &gt; Port replikátory/Docking station</CATEGORY>
      <CATEGORY id="32789">Značky &gt; Lenovo &gt; Příslušenství &gt; Port replikátory/Docking station</CATEGORY>
      <DEFAULT_CATEGORY id="4039">Druhy &gt; Počítačové příslušenství &gt; Příslušenství PC/Notebooky &gt; Port replikátory a dokovací stanice</DEFAULT_CATEGORY>
    </CATEGORIES>
    <IMAGES>
      <IMAGE>https://terminal.sws.cz/img.asp?attid=59765449</IMAGE>
    </IMAGES>
    <TEXT_PROPERTIES>
      <TEXT_PROPERTY>
        <NAME>GPSR</NAME>
        <VALUE>Lenovo (Slovakia);Landererova 12,811 09,Bratislava,Slovakia;compliance@lenovo.com</VALUE>
      </TEXT_PROPERTY>
    </TEXT_PROPERTIES>
    <FLAGS>
      <ACTION>0</ACTION>
      <NEW>1</NEW>
      <TIP>0</TIP>
    </FLAGS>
  </SHOPITEM>
</SHOP>
```

Úplný reprodukovaný payload: [`examples/priority/StoItemShop_El.xml`](examples/priority/StoItemShop_El.xml)
##### Struktura elementů

Kořenem feedu je `SHOP`; opakovaný `SHOPITEM` obsahuje základní pole produktu a vnořené skupiny
`LOGISTIC`, `STOCK`, `CATEGORIES`, `IMAGES`, `TEXT_PROPERTIES`, `RELATED_PRODUCTS`,
`ALTERNATIVE_PRODUCTS`, `RELATED_FILES`, `VARIANTS` a podle konfigurace také `EXTRA_COLUMNS`.

| Skupina | Pole / elementy | Popis |
| ---- | ---- | ----- |
| Identifikace | `id`, `CODE`, `EAN`, `PART_NUMBER`, `NAME`, `MANUFACTURER` | Identifikace produktu; atribut `id` se v režimu `ShoptetStrict` nevrací |
| Popis | `SHORT_DESCRIPTION`, `DESCRIPTION` | Krátký a úplný produktový popis |
| Ceny | `PRICE`, `STANDARD_PRICE`, `PURCHASE_PRICE`, `RECYCLING_FEE`, `FEE`, `FEE2`, `VAT`, `PRICE_VAT`, `PURCHASE_PRICE_VAT`, `PRICE_MIN`, `CURRENCY` | Cenové údaje; `FEE`, `FEE2` a `PRICE_MIN` se v režimu `ShoptetStrict` nevracejí |
| Stav | `CONDITION`, `AVAILABILITY`, `AVAILABILITY_OUT_OF_STOCK` | Stav a dostupnost; `CONDITION` se v režimu `ShoptetStrict` nevrací |
| `LOGISTIC` | `WEIGHT`, `HEIGHT`, `WIDTH`, `DEPTH` | Logistické rozměry a hmotnost |
| `STOCK` | `AMOUNT` | Skladové množství |
| `CATEGORIES` | opakovaný `CATEGORY`, `DEFAULT_CATEGORY` | Cesty kategorií; ID kategorií a `DEFAULT_CATEGORY` jsou pouze mimo `ShoptetStrict` |
| `IMAGES` | opakovaný `IMAGE` | URL produktových obrázků |
| `TEXT_PROPERTIES` | `TEXT_PROPERTY` s `NAME` a `VALUE` | Textové parametry produktu |
| Vazby | `RELATED_PRODUCTS/CODE`, `ALTERNATIVE_PRODUCTS/CODE` | Kódy souvisejících a alternativních produktů |
| Příznaky | `FLAGS/ACTION`, `FLAGS/NEW`, `FLAGS/TIP` | Příznaky produktové nabídky |
| `RELATED_FILES` | `RELATED_FILE` s `TEXT` a `URL` | Související dokumenty a soubory |
| `VARIANTS` | opakovaný `VARIANT` | Varianty produktu s vlastní identifikací, cenami, skladem, dostupností a parametry |
| `EXTRA_COLUMNS` | dynamické elementy | Firemně specifická pole doplněná databázovým triggerem |

Přesná pole `EXTRA_COLUMNS` nelze určit staticky, protože je může měnit trigger
`TrgX AutoWsExportStoItemShop`. `ResultListUser.config` standardně povoluje `StoItemShop_El`
v hodinách 08 až 20; pro firmy `6336`, `0` a `10640` časové omezení ruší.

#### 5.2.26 X-Cybex

Zákaznický produktový export pro Cybex. Spojuje produktové a cenové údaje, dostupnost, očekávanou
dodávku, recyklační poplatky, obrázky a cesty v prezentačních stromech.

**`resultType`:** `X-Cybex` · `X-Cybex_El` · `X-Cybex_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje přesný `StoItem.StiCode`. `GetResultByFromTo` sleduje změnu produktu
`StiU` nebo ceny `SipU`. Výsledek podléhá produktovým řádkovým oprávněním a obsahuje pouze viditelné,
objednatelné produkty v ceníku s kladnou vypočtenou objednávkovou cenou.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-Cybex&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 204 requestů pro varianty popsané v této sekci.

```xml
<Result UrlBase="http://https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseImg="http://https://terminal.sws.cz/img.asp?stiid=" UrlBaseThumbnail="http://https://terminal.sws.cz/img.asp?attname=thumbnail&amp;attpedid=52&amp;attsrcid=">
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" StoCode1="0195892132486" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" ManName="Lenovo" Prc="3889.0000" PrcList="4597.8200" TaxRate="21.0000" CutCode="84718000" RefPrc="0.7600" RefProName="ASEKOL" RefCode="5.55." RefPrc2="0.0000" RefProName2="Autorský fond CZ" RefCode2="9.99" QtyFreeIs="1" WarDur="1116" Weight="0.64000" SNTrack="1" ImgSize="14400" ThumbnailSize="1322" Note="Popis produktu&#13;&#10;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstream konektivitou o propustnosti 40 Gb/s, což umožňuje rozšířit konfiguraci monitorů o více pixelů a vyšší obnovovací frekvence.&#13;&#10;Dokovací stanice může dodávat 65 W napájení notebooku při použití 100W napájecího adaptéru, nebo lze použít 135W adaptér, který zvýší nabíjecí výkon až na 100 W pro notebook.&#13;&#10;&#13;&#10;Hlavní vlastnosti&#13;&#10;&#13;&#10;Dokovací stanice ThinkPad® USB4 Dock 5000 s nejnovější technologií USB4 nabízí až čtyřnásobný výkon konektivity oproti USB-C 3.2 Gen 2. Díky propustnosti až 40 Gb/s můžete připojit buď jeden monitor s ultravysokým rozlišením 8K při 60 Hz, nebo dva monitory 4K s obnovovací frekvencí 144 Hz. Snadno tak rozšíříte svůj notebook Lenovo na plnohodnotnou pracovní platformu s různými periferními zařízeními.&#13;&#10;Dok podporuje Power Delivery 3.1 a poskytuje až 100 W pro rychlé nabíjení notebooku, takže můžete jednoduše rozšířit možnosti svého pracovního prostoru.&#13;&#10;&#13;&#10;Dokovací stanice je navíc univerzálně kompatibilní s různými operačními systémy.">
    <SPresentTree SptStiId="695888" Level0="Druhy" Level1="Počítačové příslušenství" Level2="Příslušenství PC/Notebooky" Level3="Port replikátory a dokovací stanice" />
    <SPresentTree SptStiId="695888" Level0="PH" Level1="DIS00/ Stationary Computer" Level2="DIS0000001/ Desktop-FIX" Level3="DIS000000100000003/ A-Brand FIX / Desktop Accessory" />
    <SPresentTree SptStiId="695888" Level0="Značky" Level1="Lenovo" Level2="Notebooky" Level3="Příslušenství k notebookům" Level4="Port replikátory/Docking station" />
    <SPresentTree SptStiId="695888" Level0="Značky" Level1="Lenovo" Level2="Příslušenství" Level3="Port replikátory/Docking station" />
    <SPresentTree SptStiId="695888" Level0="Značky" Level1="Retail" Level2="KB" Level3="KB 4%" />
  </StoItem>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-Cybex.xml`](examples/priority/X-Cybex.xml)

`Result` nese `UrlBase`, `UrlBaseImg` a `UrlBaseThumbnail`. Pod ním se opakuje `StoItem`, ke kterému
jsou připojeny řádky `SPresentTree` s cestami kategorií.

SQL definice skládá kořenové adresy přidáním prefixu `http://` před hodnotu `WebSite`, která již
v aktuálním prostředí začíná `https://`. Reprodukovaný výstup proto skutečně obsahuje neplatný tvar
`http://https://...`; nejde o chybu této dokumentace. Klient by měl adresu validovat, případně je
vhodné opravit skládání URL v konfiguraci exportu.

| Skupina | Pole | Popis |
| ---- | ---- | ----- |
| Identifikace | `Id`, `Code`, `PartNo`, `StoCode1`, `StoCode2`, `Name`, `ManName` | Identifikace a název produktu a výrobce |
| Ceny | `Prc`, `PrcList`, `TaxRate`, `RefPrc`, `RefPrc2`, `RefProName`, `RefProName2`, `RefCode`, `RefCode2` | Objednávková, ceníková a referenční cena včetně souvisejících údajů |
| Dostupnost | `QtyFreeIs`, `QtyFree`, `QtyNextShipIs`, `QtyNextShip`, `DateNextShip` | Volné a očekávané množství; příznaky rozlišují skrytou hodnotu |
| Produkt | `CutCode`, `WarDur`, `Weight`, `SNTrack`, `Note` | Celní kód, záruka, hmotnost, sledování sériových čísel a popis |
| Obrázky | `ImgSize`, `ThumbnailSize` | Velikost hlavního obrázku a náhledu |
| `SPresentTree` | `Level0` až `Level6` | Typ stromu a jednotlivé úrovně cesty |

Standardní časové omezení je 08 až 20; pro firmy `6336` a `0` se neuplatňuje.

#### 5.2.27 ConetPriceOrd

Zákaznický produktový export objednávkové ceny a volného množství přes vazbu Conet.

**`resultType`:** `ConetPriceOrd` · `ConetPriceOrd_El` · `ConetPriceOrd_Schema`

##### Filtrování a parametry

Parametr `code` musí mít podobu `ComId,StiCode[,StiCode...]`. První hodnota je číselné ID firmy,
podle kterého se v `SWSConet_dlr` dohledá kontakt a jeho cenová a skladová pravidla; následují přesné
kódy produktů oddělené čárkou. `GetResultByFromTo` není podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=ConetPriceOrd&code=8623%2CLNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 128 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Code="LNM01353" PriceOrd="3551.0000" QtyFree="44" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/ConetPriceOrd.xml`](examples/priority/ConetPriceOrd.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Code` | string | Kód produktu |
| `PriceOrd` | money | Vypočtená objednávková cena pro zadanou firmu |
| `QtyFree` | i4 | Volné množství omezené maximem produktu `StiQtyMaxI` |

Export je dostupný bez časového omezení, ale `Visibility` jej omezuje na firmy `6336`, `8623` a `0`.

#### 5.2.28 X-HPTRON

Rozšířený zákaznický produktový export pro HP Tronic. Kombinuje identifikaci, ceny, dostupnost,
záruky, obrázky, produktové parametry, prezentační strom a logistická balení.

**`resultType`:** `X-HPTRON` · `X-HPTRON_El` · `X-HPTRON_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `StiPartNo` s prefixem `{PartNo}`; podporuje více
hodnot oddělených tabulátorem. `GetResultByFromTo` sleduje `StiU` nebo `SipU`. Vedle běžně
viditelných produktů může zahrnout produkt s blokovaným množstvím na objednávce dané firmy.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-HPTRON&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 30 requestů pro varianty popsané v této sekci.

```xml
<Result UrlBase="http://https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseImg="http://https://terminal.sws.cz/img.asp?stiid=" UrlBaseThumbnail="http://https://terminal.sws.cz/img.asp?attname=thumbnail&amp;attpedid=52&amp;attsrcid=">
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" ManName="Lenovo" Weight="0.64000" PriceDea="3889.0000" QtyFreeIs="1" WarDur="1116" PriceRef="0.7600" RefProName="ASEKOL" RefCode="5.55." PriceRef2="0.0000" RefProName2="Autorský fond CZ" RefCode2="9.99" TaxRate="21.0000" ThumbnailIs="1" ThumbnailSize="1322" ImgIs="1" ImgSize="14400" EnlargementIs="1" EnlargementSize="19826" Note="Popis produktu&#13;&#10;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstream konektivitou o propustnosti 40 Gb/s, což umožňuje rozšířit konfiguraci monitorů o více pixelů a vyšší obnovovací frekvence.&#13;&#10;Dokovací stanice může dodávat 65 W napájení notebooku při použití 100W napájecího adaptéru, nebo lze použít 135W adaptér, který zvýší nabíjecí výkon až na 100 W pro notebook.&#13;&#10;&#13;&#10;Hlavní vlastnosti&#13;&#10;&#13;&#10;Dokovací stanice ThinkPad® USB4 Dock 5000 s nejnovější technologií USB4 nabízí až čtyřnásobný výkon konektivity oproti USB-C 3.2 Gen 2. Díky propustnosti až 40 Gb/s můžete připojit buď jeden monitor s ultravysokým rozlišením 8K při 60 Hz, nebo dva monitory 4K s obnovovací frekvencí 144 Hz. Snadno tak rozšíříte svůj notebook Lenovo na plnohodnotnou pracovní platformu s různými periferními zařízeními.&#13;&#10;Dok podporuje Power Delivery 3.1 a poskytuje až 100 W pro rychlé nabíjení notebooku, takže můžete jednoduše rozšířit možnosti svého pracovního prostoru.&#13;&#10;&#13;&#10;Dokovací stanice je navíc univerzálně kompatibilní s různými operačními systémy." Avail="21">
    <StiPar Name="GPSR" Value="Lenovo (Slovakia);Landererova 12,811 09,Bratislava,Slovakia;compliance@lenovo.com" />
    <SpresentTree Level0="Druhy" Level1="Počítačové příslušenství" Level2="Příslušenství PC/Notebooky" Level3="Port replikátory a dokovací stanice" />
    <SpresentTree Level0="PH" Level1="DIS00/ Stationary Computer" Level2="DIS0000001/ Desktop-FIX" Level3="DIS000000100000003/ A-Brand FIX / Desktop Accessory" />
    <SpresentTree Level0="Značky" Level1="Lenovo" Level2="Notebooky" Level3="Příslušenství k notebookům" Level4="Port replikátory/Docking station" />
    <SpresentTree Level0="Značky" Level1="Lenovo" Level2="Příslušenství" Level3="Port replikátory/Docking station" />
    <SpresentTree Level0="Značky" Level1="Retail" Level2="KB" Level3="KB 4%" />
    <Packing Qty="1.000" Type="Balitelné" Unit="Jednotka" Length="23.0" Height="8.0" Width="14.0" Weight="0.64000" />
  </StoItem>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-HPTRON.xml`](examples/priority/X-HPTRON.xml)

`Result` obsahuje URL pro produkt, obrázek a náhled. Pod `StoItem` jsou vnořeny `StiPar`,
`SpresentTree` a `Packing`.

Také zde SQL přidává `http://` před hodnotu `WebSite`, která už obsahuje `https://`. Hodnoty
`UrlBase`, `UrlBaseImg` a `UrlBaseThumbnail` proto mají v reprodukovaném výstupu neplatný prefix
`http://https://...`. Jde o vlastnost aktuální definice exportu, nikoli o úpravu ukázky.

| Element | Pole | Popis |
| ---- | ---- | ----- |
| `StoItem` | `Id`, `Code`, `PartNo`, `PartNo2`, `EAN`, `EAN2`, `Name`, `NameAdd`, `ManName` | Identifikace a názvy produktu |
| `StoItem` | `PriceDea`, `PriceRef`, `PriceRef2`, `RefProName`, `RefCode`, `RefProName2`, `RefCode2`, `TaxRate` | Prodejní a referenční ceny a daň |
| `StoItem` | `QtyFreeIs`, `QtyFree`, `Avail`, `DateNextShip`, `QtyNextShip`, `DateNextShipFree`, `QtyNextShipFree` | Dostupnost a očekávané dodávky |
| `StoItem` | `WarType`, `WarDur`, `Weight`, `Note` | Typ a délka záruky, hmotnost a popis |
| `StoItem` | `ThumbnailIs`, `ThumbnailSize`, `ImgIs`, `ImgSize`, `EnlargementIs`, `EnlargementSize` | Dostupnost a velikosti obrazových variant |
| `StiPar` | `Name`, `Value`, `Measure` | Publikovaný produktový parametr |
| `SpresentTree` | `Level0` až `Level6` | Cesta v prezentačním stromu |
| `Packing` | `Qty`, `QtyU`, `Type`, `Unit`, `Length`, `Height`, `Width`, `Weight`, `WeightW`, `EAN` | Množství, typ, rozměry a EAN balení |

Export je viditelný firmám `6336`, `0`, `1331` a `1862`. Standardní časové omezení je 08 až 20;
pro firmy `6336` a `0` neplatí.

#### 5.2.29 X-OrdTrack

Dokladový export sledovacích adres zásilek souvisejících se zadanou objednávkou.

**`resultType`:** `X-OrdTrack` · `X-OrdTrack_El` · `X-OrdTrack_Schema`

##### Filtrování a parametry

Parametr `code` je kód objednávky `Orders.OrdCode` patřící firmě přihlášeného kontaktu. SQL používá
operátor `LIKE`, ale bez doplnění zástupných znaků. `GetResultByFromTo` není podporováno. Export
propojí objednávku přes dodací list a skladovou operaci s dosud neuzavřenou expedicí.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-OrdTrack&code=OP16245317`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 58687 requestů pro varianty popsané v této sekci. Identifikační, adresní, sériové a trackingové hodnoty jsou anonymizované.

```xml
<Result>
  <Expedition ExpCodeO="ANONYMIZED" DemName="DPD" TrackURL="ANONYMIZED" />
  <Expedition ExpCodeO="ANONYMIZED" DemName="DPD" TrackURL="ANONYMIZED" />
  <Expedition ExpCodeO="ANONYMIZED" DemName="DPD" TrackURL="ANONYMIZED" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-OrdTrack.xml`](examples/priority/X-OrdTrack.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `ExpCodeO` | string | Externí kód expedice používaný jako číslo zásilky |
| `DemName` | string | Název způsobu dopravy |
| `TrackURL` | string | Sledovací URL sestavená pro podporované kódy dopravce `1`, `2`, `5`, `11`, `15` a `17` |

Definice povoluje export ve všech dnech a hodinách.

#### 5.2.30 X-StoItemPriceOrd

Rozšířený export objednávkových a dalších cen produktu, PartNo a EAN. Dostupnost pevných cenových
úrovní je řízena oprávněními přihlášeného kontaktu.

**`resultType`:** `X-StoItemPriceOrd` · `X-StoItemPriceOrd_El` · `X-StoItemPriceOrd_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, `StiPartNo` s prefixem `{PartNo}` nebo výrobce s prefixem
`{ManName}`; podporuje více hodnot oddělených tabulátorem. `GetResultByFromTo` filtruje změnu ceny
`StoItemPrice.SipU`. Výsledek respektuje produktová řádková oprávnění a obsahuje jen kladnou
objednávkovou cenu.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemPriceOrd&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 62 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PriceOrd="3889.0000" PriceEU="4597.8200" PriceRef="0.7600" PriceRef2="0.0000" TaxRate="21.0000" PriceB2CMin="4597.8200" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" EAN2="" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemPriceOrd.xml`](examples/priority/X-StoItemPriceOrd.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id`, `Code` | různé | ID a kód produktu |
| `PriceOrd`, `PriceEU`, `PriceRef`, `PriceRef2`, `PriceB2CMin` | money | Objednávková, koncová, referenční a minimální B2C cena |
| `TaxRate` | různé | Sazba daně |
| `PriceFullIs` | boolean | Příznak oprávnění k úplným pevným cenám |
| `PriceList`, `Price0` až `Price5` | money | Ceníková a pevné cenové úrovně vracené podle oprávnění |
| `PartNo`, `PartNo2`, `EAN`, `EAN2` | string | Produktová a čárová označení |

Export je viditelný firmám `0`, `6336` a `7653`. Základní i intervalová metoda jsou omezeny na
hodiny 08 až 20.

#### 5.2.31 X-StoItemThin

Úsporný produktový export názvu, identifikátorů, cen a skladové dostupnosti.

**`resultType`:** `X-StoItemThin` · `X-StoItemThin_El` · `X-StoItemThin_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `StiPartNo` s prefixem `{PartNo}`, a podporuje více
hodnot oddělených tabulátorem. `GetResultByFromTo` filtruje změnu ceny `SipU`. Export respektuje
viditelnost, objednatelnost a řádková oprávnění produktu a vrací pouze kladnou objednávkovou cenu.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemThin&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 159 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" PriceOrd="3889.0000" PriceRef="0.7600" PriceRef2="0.0000" QtyFreeIs="1" Id="695888" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemThin.xml`](examples/priority/X-StoItemThin.xml)

| Skupina | Pole | Popis |
| ---- | ---- | ----- |
| Produkt | `Id`, `Code`, `PartNo`, `PartNo2`, `EAN`, `EAN2`, `Name`, `NameAdd` | Identifikace a název produktu |
| Ceny | `PriceOrd`, `PriceRef`, `PriceRef2`, `PriceList`, `Price0` až `Price5`, `PriceFullIs` | Objednávková, referenční a oprávněním řízené pevné ceny |
| Dostupnost | `QtyFreeIs`, `QtyFree` | Příznak skryté hodnoty a volné množství |

Export je viditelný firmám `6336`, `4156`, `0` a `1462`. `GetResultByFromTo` je povoleno v hodinách
08 až 20.

#### 5.2.32 X-StiIcecat

Produktový export vazby na dealerský produktový profil Icecat.

**`resultType`:** `X-StiIcecat` · `X-StiIcecat_El` · `X-StiIcecat_Schema`

##### Filtrování a parametry

`GetResultByCode` vyhledává přesný `StiCode`. `GetResultByFromTo` filtruje změnu vazby
`ConParSet.CpsU`. Vrací viditelné produkty s nenulovou hodnotou parametru `CpsCpaId = 49`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StiIcecat&code=DLS00164`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 90 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <CpsSti Id="21739081" StiId="676206" StiCode="DLS00164" IcecatID="93617307" IcecatURL="http://prf.icecat.biz/index.cgi?mi=start;smi=product;shopname=swsdealer;lang=cz;product_id=93617307" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StiIcecat.xml`](examples/priority/X-StiIcecat.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | ID vazby `ConParSet.CpsId` |
| `StiId`, `StiCode` | různé | ID a kód produktu |
| `IcecatID` | i4 | Číselné ID produktu Icecat z `CpsTagI` |
| `IcecatURL` | string | URL dealerského profilu sestavená z `IcecatID` |

Standardní i intervalové volání je omezeno na hodiny 08 až 20; pro firmy `6336` a `0` se omezení
základního volání ruší.

#### 5.2.33 X-StoItemQtyFree

Zákaznický export volného množství doplněný o PartNo a EAN. Pro firmu `7653` přičítá také blokované
množství jejích objednávek, včetně produktů, které jinak nemají kladnou skladovou hodnotu.

**`resultType`:** `X-StoItemQtyFree` · `X-StoItemQtyFree_El` · `X-StoItemQtyFree_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `StiPartNo` s prefixem `{PartNo}`, a podporuje více
hodnot oddělených tabulátorem. Bez `code` vrací pouze kladné množství. `GetResultByFromTo` není
podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemQtyFree&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 107 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Code="LNM01353" QtyFreeIs="1" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemQtyFree.xml`](examples/priority/X-StoItemQtyFree.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Code` | string | Kód produktu |
| `QtyFreeIs` | boolean | Příznak, že je množství dostupné, ale jeho hodnota je skryta |
| `QtyFree` | i4 | Volné množství, případně navýšené o blokaci objednávek firmy `7653` |
| `PartNo`, `PartNo2`, `EAN`, `EAN2` | string | Produktová a čárová označení |

Export je viditelný pouze firmám `0`, `6336`, `576` a `7653`.

#### 5.2.34 X-SipPrcZMin

Cenový export minimální prodejní ceny produktu.

**`resultType`:** `X-SipPrcZMin` · `X-SipPrcZMin_El` · `X-SipPrcZMin_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `StiPartNo` s prefixem `{PartNo}`, a podporuje více
hodnot oddělených tabulátorem. `GetResultByFromTo` sleduje změnu produktu `StiU` nebo ceny `SipU`.
Výsledek respektuje řádková oprávnění a běžné podmínky viditelnosti a objednatelnosti produktu.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-SipPrcZMin&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 89 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PrcZMin="4597.8200" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-SipPrcZMin.xml`](examples/priority/X-SipPrcZMin.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | ID produktu |
| `Code` | string | Kód produktu |
| `PrcZMin` | money | Minimální prodejní cena `StoItemPrice.SipPrcZMin` |

#### 5.2.35 X-StoItemKBProgres

Zákaznická varianta produktového exportu pro KB Progres s pevnou identifikací dodavatele, cenami,
dostupností, výrobcem a rozměry logistického balení.

**`resultType`:** `X-StoItemKBProgres` · `X-StoItemKBProgres_El` · `X-StoItemKBProgres_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `StiPartNo` s prefixem `{PartNo}`, a podporuje více
hodnot oddělených tabulátorem. `GetResultByFromTo` filtruje změnu ceny `SipU`. Export respektuje
řádková oprávnění a obsahuje jen produkty s kladnou objednávkovou cenou.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemKBProgres&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 30 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem VendorId="0005627" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" EAN2="" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" PriceOrd="3889.0000" PriceRef="0.7600" PriceRef2="0.0000" CutCode="84718000" QtyFreeIs="1" WeightN="0.64000" LengthB="23.0" HeightB="8.0" WidthB="14.0" WeightB="0.64000" Manufacturer="Lenovo" Note="Popis produktu&#13;&#10;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstream konektivitou o propustnosti 40 Gb/s, což umožňuje rozšířit konfiguraci monitorů o více pixelů a vyšší obnovovací frekvence.&#13;&#10;Dokovací stanice může dodávat 65 W napájení notebooku při použití 100W napájecího adaptéru, nebo lze použít 135W adaptér, který zvýší nabíjecí výkon až na 100 W pro notebook.&#13;&#10;&#13;&#10;Hlavní vlastnosti&#13;&#10;&#13;&#10;Dokovací stanice ThinkPad® USB4 Dock 5000 s nejnovější technologií USB4 nabízí až čtyřnásobný výkon konektivity oproti USB-C 3.2 Gen 2. Díky propustnosti až 40 Gb/s můžete připojit buď jeden monitor s ultravysokým rozlišením 8K při 60 Hz, nebo dva monitory 4K s obnovovací frekvencí 144 Hz. Snadno tak rozšíříte svůj notebook Lenovo na plnohodnotnou pracovní platformu s různými periferními zařízeními.&#13;&#10;Dok podporuje Power Delivery 3.1 a poskytuje až 100 W pro rychlé nabíjení notebooku, takže můžete jednoduše rozšířit možnosti svého pracovního prostoru.&#13;&#10;&#13;&#10;Dokovací stanice je navíc univerzálně kompatibilní s různými operačními systémy." Id="695888" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemKBProgres.xml`](examples/priority/X-StoItemKBProgres.xml)

| Skupina | Pole | Popis |
| ---- | ---- | ----- |
| Identifikace | `VendorId`, `Id`, `Code`, `PartNo`, `PartNo2`, `EAN`, `EAN2`, `Name`, `NameAdd` | Pevné ID dodavatele `0005627` a identifikace produktu |
| Ceny | `PriceOrd`, `PriceRef`, `PriceRef2` | Objednávková a referenční ceny |
| Dostupnost | `QtyFreeIs`, `QtyFree` | Příznak skryté hodnoty a volné množství |
| Logistika | `CutCode`, `WeightN`, `LengthB`, `HeightB`, `WidthB`, `WeightB` | Celní kód, čistá hmotnost a rozměry/hmotnost balení |
| Další | `Manufacturer`, `Note` | Výrobce a produktový popis |

Export je viditelný firmám `0`, `6336` a `7653`. Základní i intervalové volání je omezeno na
hodiny 08 až 20.

#### 5.2.36 X-ConetSipPrcZMin

Conet varianta exportu minimální prodejní ceny. SQL struktura a filtrování odpovídají
`X-SipPrcZMin`; samostatný `resultType` omezuje dostupnost na firmy používající Conet.

**`resultType`:** `X-ConetSipPrcZMin` · `X-ConetSipPrcZMin_El` · `X-ConetSipPrcZMin_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `StiPartNo` s prefixem `{PartNo}`, a podporuje více
hodnot oddělených tabulátorem. `GetResultByFromTo` sleduje změnu produktu `StiU` nebo ceny `SipU`.
Výsledek respektuje řádková oprávnění a běžné podmínky viditelnosti a objednatelnosti produktu.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-ConetSipPrcZMin&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 707 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="695888" Code="LNM01353" PrcZMin="4597.8200" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-ConetSipPrcZMin.xml`](examples/priority/X-ConetSipPrcZMin.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | ID produktu |
| `Code` | string | Kód produktu |
| `PrcZMin` | money | Minimální prodejní cena `SipPrcZMin` |

Export je viditelný pouze firmám `0`, `8623` a `6336`.

#### 5.2.37 X-ConetStoItemQtyFreeEx

Conet export skladové dostupnosti a nejbližších očekávaných dodávek. Číselné množství může být
podle oprávnění nahrazeno pouze příznakem jeho dostupnosti.

**`resultType`:** `X-ConetStoItemQtyFreeEx` · `X-ConetStoItemQtyFreeEx_El` · `X-ConetStoItemQtyFreeEx_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `StiPartNo` s prefixem `{PartNo}`, a podporuje více
hodnot oddělených tabulátorem. Bez `code` vynechá produkty bez skladové, dostupnostní nebo budoucí
dodávkové hodnoty. `GetResultByFromTo` není podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-ConetStoItemQtyFreeEx&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 1141 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Code="LNM01353" StiXSisId="1" QtyFreeIs="1" Avail="21" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-ConetStoItemQtyFreeEx.xml`](examples/priority/X-ConetStoItemQtyFreeEx.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Code` | string | Kód produktu |
| `StiXSisId` | ui1 | ID stavu skladové položky, například novinka, výprodej nebo speciální nabídka |
| `QtyFreeIs`, `QtyNextShipIs`, `QtyNextShipFreeIs` | boolean | Příznaky dostupnosti odpovídajících množstevních hodnot |
| `QtyFree`, `QtyNextShip`, `QtyNextShipFree` | i4 | Volné a očekávané množství |
| `Avail` | i4 | Předpokládaná dostupnost zboží ve dnech; hodnota produktu nebo systémové kategorie |
| `DateNextShip`, `DateNextShipFree` | dateTime | Nejbližší celková a volná očekávaná dodávka |

Očekávaná množství jsou omezena hodnotou `MaxI`. Export je viditelný pouze firmám `0`, `8623`
a `6336`.

#### 5.2.38 X-StoItemQtyFreeWithQtyOriBlock

Skladový export, který k volnému množství přičítá množství blokované na objednávkách přihlášené
firmy. Produkt blokovaný na objednávce může být vrácen i bez kladné skladové zásoby.

**`resultType`:** `X-StoItemQtyFreeWithQtyOriBlock` · `X-StoItemQtyFreeWithQtyOriBlock_El` · `X-StoItemQtyFreeWithQtyOriBlock_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `StiPartNo` s prefixem `{PartNo}`, a podporuje více
hodnot oddělených tabulátorem. Bez `code` vybírá kladné skladové nebo blokované množství.
`GetResultByFromTo` není podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemQtyFreeWithQtyOriBlock&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 501 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Code="LNM01353" QtyFreeIs="1" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemQtyFreeWithQtyOriBlock.xml`](examples/priority/X-StoItemQtyFreeWithQtyOriBlock.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Code` | string | Kód produktu |
| `QtyFreeIs` | boolean | Příznak dostupnosti bez zpřístupněné číselné hodnoty |
| `QtyFree` | i4 | Volné množství navýšené o blokaci objednávek firmy |

Export je viditelný pouze firmám vyjmenovaným ve `Visibility` v `ResultListUser.config`.

#### 5.2.39 X-StoItemQtyFreeWithQtyOriBlockEx

Rozšíření předchozího exportu o dostupnost a nejbližší očekávané dodávky.

**`resultType`:** `X-StoItemQtyFreeWithQtyOriBlockEx` · `X-StoItemQtyFreeWithQtyOriBlockEx_El` · `X-StoItemQtyFreeWithQtyOriBlockEx_Schema`

##### Filtrování a parametry

Filtrování `code` a započtení blokací odpovídá `X-StoItemQtyFreeWithQtyOriBlock`. Bez `code` výsledek
vynechá produkty bez skladové, dostupnostní nebo budoucí dodávkové hodnoty. `GetResultByFromTo`
není podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemQtyFreeWithQtyOriBlockEx&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 120 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Code="LNM01353" QtyFreeIs="1" Avail="21" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemQtyFreeWithQtyOriBlockEx.xml`](examples/priority/X-StoItemQtyFreeWithQtyOriBlockEx.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Code` | string | Kód produktu |
| `QtyFreeIs`, `QtyNextShipIs`, `QtyNextShipFreeIs` | boolean | Příznaky dostupnosti množství |
| `QtyFree`, `QtyNextShip`, `QtyNextShipFree` | i4 | Volné množství včetně blokací a očekávaná množství |
| `Avail` | i4 | Číselná dostupnost produktu nebo systémové kategorie |
| `DateNextShip`, `DateNextShipFree` | dateTime | Nejbližší celková a volná dodávka |

Očekávaná množství podléhají `MaxI`, pokud kontakt nemá oprávnění `Result-QtyFree-IgnoreMaxI`.
Viditelnost je omezena na seznam firem v konfiguraci.

#### 5.2.40 X-StoItemQtyFreeBOHPT

HP Tronic varianta dostupnosti s blokovaným množstvím, očekávanými dodávkami a produktovými
identifikátory PartNo a EAN.

**`resultType`:** `X-StoItemQtyFreeBOHPT` · `X-StoItemQtyFreeBOHPT_El` · `X-StoItemQtyFreeBOHPT_Schema`

##### Filtrování a parametry

Filtrování a výpočet odpovídají `X-StoItemQtyFreeWithQtyOriBlockEx`. `GetResultByCode` podporuje
`StiCode`, `{PartNo}` a více hodnot oddělených tabulátorem. `GetResultByFromTo` není podporováno.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemQtyFreeBOHPT&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 188 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" QtyFreeIs="1" Avail="21" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemQtyFreeBOHPT.xml`](examples/priority/X-StoItemQtyFreeBOHPT.xml)

| Skupina | Pole | Popis |
| ---- | ---- | ----- |
| Identifikace | `Code`, `PartNo`, `PartNo2`, `EAN`, `EAN2` | Produktová a čárová označení |
| Dostupnost | `QtyFreeIs`, `QtyFree`, `Avail` | Volné množství včetně blokací a dostupnost |
| Dodávky | `DateNextShip`, `QtyNextShipIs`, `QtyNextShip`, `DateNextShipFree`, `QtyNextShipFreeIs`, `QtyNextShipFree` | Nejbližší celková a volná očekávaná dodávka |

Pole `Commodity` a `Manufacturer` se sice připravují v dočasné tabulce, ale finální `SELECT` je má
zakomentovaná a do XML je nevrací. Export je viditelný pouze firmám `0`, `6336` a `1862`.

#### 5.2.41 X-DeletedStiCode

Produktový změnový export kódů odstraněných z databáze. Je vhodný pro synchronizaci, která potřebuje
odstranit dříve převzatý produkt nebo uvolnit jeho kód.

**`resultType`:** `X-DeletedStiCode` · `X-DeletedStiCode_El` · `X-DeletedStiCode_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje přesný odstraněný `SzsStiCode` a podporuje více hodnot oddělených
tabulátorem. `GetResultByFromTo` filtruje datum `SzsCDate`. Zdrojovou tabulkou je
`SWSZruseneStiCode`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-DeletedStiCode&code=T73-00655`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 33 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="86485" Code="T73-00655" DDate="2012-11-13T00:00:00" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-DeletedStiCode.xml`](examples/priority/X-DeletedStiCode.xml)

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | Původní ID produktu `SzsStiId` |
| `Code` | string | Odstraněný produktový kód |
| `DDate` | dateTime | Datum zaznamenání odstranění |

Základní i intervalové volání je omezeno na hodiny 08 až 20.

#### 5.2.42 X-StoItemQtyFreeRealX

První část zákaznického XML feedu kombinujícího ceny, sklad `29` a základní identifikaci produktu.
Je určen pro dávkové zpracování maximálně prvních 35 000 produktů.

**`resultType`:** `X-StoItemQtyFreeRealX`

##### Filtrování a parametry

`GetResultByCode` podporuje `StiCode`, `{PartNo}`, `{ManName}` a více hodnot oddělených tabulátorem.
`GetResultByFromTo` sleduje `StiU` nebo `SipU`. Bez ohledu na filtr SQL používá `TOP 35000`.
Blokace objednávek se započítávají podle `ConwithOriBlocked` stejně jako u `X-StoItemQtyFreeReal`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemQtyFreeRealX&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 167 requestů pro varianty popsané v této sekci.

```xml
<items>
  <item>
    <Pricing>
      <PriceWithFee>3889.7600</PriceWithFee>
      <PriceWithoutFee>3889.0000</PriceWithoutFee>
      <RecycleFee>0.7600</RecycleFee>
      <CopyrightFee>0.0000</CopyrightFee>
      <Currency>CZK</Currency>
    </Pricing>
    <Storage>
      <StoredQuantity>44</StoredQuantity>
    </Storage>
    <Product>
      <Name>Lenovo ThinkPad USB4 Dock 5000 - 65W - EU</Name>
      <DealerCode>LNM01353</DealerCode>
      <PartNumber>40BF0100EU</PartNumber>
      <Ean>0195892132486</Ean>
    </Product>
  </item>
</items>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemQtyFreeRealX.xml`](examples/priority/X-StoItemQtyFreeRealX.xml)

Kořenem je `items`, pod kterým se opakuje `item` se skupinami `Pricing`, `Storage` a `Product`.

| Skupina | Pole | Popis |
| ---- | ---- | ----- |
| `Pricing` | `PriceWithFee` | Dealerská cena navýšená o recyklační a autorský poplatek |
| `Pricing` | `PriceWithoutFee`, `RecycleFee`, `CopyrightFee`, `Currency` | Cena bez poplatků, oba poplatky a pevná měna `CZK` |
| `Storage` | `StoredQuantity` | Součet běžného `QtyFree` a `QtyFree2` skladu `29` |
| `Product` | `Name`, `DealerCode`, `PartNumber`, `Ean` | Název a identifikace produktu |

Export je viditelný pouze firmám `0`, `6336` a `7993`.

#### 5.2.43 X-StoItemQtyFreeRealX2

Druhá část feedu `X-StoItemQtyFreeRealX`. Struktura, ceny, skladový výpočet, parametry a oprávnění
jsou shodné; liší se pouze stránkováním produktů.

**`resultType`:** `X-StoItemQtyFreeRealX2`

##### Filtrování a parametry

SQL řadí produkty podle `StiId` a používá `OFFSET 35000 ROWS`, takže vrací produkty od řádku 35 001.
Na rozdíl od první části nemá další limit počtu řádků. Prakticky je určen pro `GetResult`: filtr
`code` se vyhodnotí před stránkováním, a proto `GetResultByCode` s jedním produktem po aplikaci
`OFFSET 35000` vrátí prázdný výsledek. Parametry `from` a `to` SQL definice nepoužívá.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResult?resultType=X-StoItemQtyFreeRealX2`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 170 requestů pro varianty popsané v této sekci. Níže je zkrácený, ale dobře formovaný výřez; úplný výstup je v odkazovaném souboru.

```xml
<items>
  <item>
    <Pricing>
      <PriceWithFee>3094.0000</PriceWithFee>
      <PriceWithoutFee>3094.0000</PriceWithoutFee>
      <RecycleFee>0.0000</RecycleFee>
      <CopyrightFee>0.0000</CopyrightFee>
      <Currency>CZK</Currency>
    </Pricing>
    <Storage>
      <StoredQuantity>0</StoredQuantity>
    </Storage>
    <Product>
      <Name>SONY GP- grip pro snímáníAlpha a7C II a a7CR</Name>
      <DealerCode>SNF00060</DealerCode>
      <PartNumber>GPX2.CE</PartNumber>
      <Ean>4548736156609</Ean>
    </Product>
  </item>
  <item>
    <Pricing>
      <PriceWithFee>21960.3400</PriceWithFee>
      <PriceWithoutFee>21916.0000</PriceWithoutFee>
      <RecycleFee>11.3400</RecycleFee>
      <CopyrightFee>33.0000</CopyrightFee>
      <Currency>CZK</Currency>
    </Pricing>
    <Storage>
      <StoredQuantity>0</StoredQuantity>
    </Storage>
    <Product>
      <Name>Lenovo YOGA 7 2-in-1 14ILL10   83JQ00KDCK   EXTRIO</Name>
      <DealerCode>LNC01461</DealerCode>
      <PartNumber>83JQ00KDCK</PartNumber>
    </Product>
  </item>
</items>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemQtyFreeRealX2.xml`](examples/priority/X-StoItemQtyFreeRealX2.xml)

Kořen `items`, element `item` a skupiny `Pricing`, `Storage` a `Product` jsou identické s první částí.
Export je viditelný pouze firmám `0`, `6336` a `7993`.

#### 5.2.44 X-StoItemBaseReal

Rozšířený zákaznický produktový export s běžnou a druhou dealerskou cenou, množstevními cenovými
tipy, blokacemi objednávek, obrázky a galerií.

**`resultType`:** `X-StoItemBaseReal` · `X-StoItemBaseReal_El` · `X-StoItemBaseReal_Schema`

##### Filtrování a parametry

`GetResultByCode` podporuje `StiCode`, `{PartNo}`, `{ManName}` a více hodnot oddělených tabulátorem.
`GetResultByFromTo` sleduje `StiU` nebo `SipU`. Výsledek respektuje řádková oprávnění, kladnou
objednávkovou cenu a nastavení `ConwithOriBlocked`.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemBaseReal&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 81 requestů pro varianty popsané v této sekci.

```xml
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseThumbnail="https://terminal.sws.cz/img.asp?attname=thumbnail&amp;attpedid=52&amp;attsrcid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=" UrlBaseEnlargement="https://terminal.sws.cz/img.asp?attname=enlargement&amp;attpedid=52&amp;attsrcid=" UrlBaseImgGalery="https://terminal.sws.cz/img.asp?attpedid=52&amp;attid=" CouCode="CZ" TaxRateLow="12" TaxRateHigh="21">
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" NameE="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" ManName="Lenovo" CouCode="CN" UrlExt="https://psref.lenovo.com/accessory/40BF0100EU" PriceEU="4597.8200" PriceB2CMin="4597.8200" PriceDea2="3889.0000" PriceDea="3889.0000" PriceRef="0.7600" RefProName="ASEKOL" RefCode="5.55." PriceRef2="0.0000" RefProName2="Autorský fond CZ" RefCode2="9.99" WeightRef="0.54750" TaxRate="21.0000" CutCode="84718000" QtyFree="44" WarDur="1116" WarDurEU="1116" SNTrack="1" Weight="0.64000" ScaId="53" ThumbnailIs="1" ThumbnailSize="1322" ImgIs="1" ImgSize="14400" EnlargementIs="1" EnlargementSize="19826" SisName="Novinka" NoteShort="Popis produktu&#13;&#10;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstr" Note="Popis produktu&#13;&#10;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstream konektivitou o propustnosti 40 Gb/s, což umožňuje rozšířit konfiguraci monitorů o více pixelů a vyšší obnovovací frekvence.&#13;&#10;Dokovací stanice může dodávat 65 W napájení notebooku při použití 100W napájecího adaptéru, nebo lze použít 135W adaptér, který zvýší nabíjecí výkon až na 100 W pro notebook.&#13;&#10;&#13;&#10;Hlavní vlastnosti&#13;&#10;&#13;&#10;Dokovací stanice ThinkPad® USB4 Dock 5000 s nejnovější technologií USB4 nabízí až čtyřnásobný výkon konektivity oproti USB-C 3.2 Gen 2. Díky propustnosti až 40 Gb/s můžete připojit buď jeden monitor s ultravysokým rozlišením 8K při 60 Hz, nebo dva monitory 4K s obnovovací frekvencí 144 Hz. Snadno tak rozšíříte svůj notebook Lenovo na plnohodnotnou pracovní platformu s různými periferními zařízeními.&#13;&#10;Dok podporuje Power Delivery 3.1 a poskytuje až 100 W pro rychlé nabíjení notebooku, takže můžete jednoduše rozšířit možnosti svého pracovního prostoru.&#13;&#10;&#13;&#10;Dokovací stanice je navíc univerzálně kompatibilní s různými operačními systémy.">
    <ImgGal />
  </StoItem>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemBaseReal.xml`](examples/priority/X-StoItemBaseReal.xml)

Struktura `Result` → `StoItem` → `ImgGal` odpovídá rozšířeným produktovým exportům. Vedle běžné
identifikace, popisu, záruk, obrázků a poplatků přidává:

| Pole | Typ | Popis |
| ---- | --- | ----- |
| `PriceDea`, `PriceDea2` | money | Vypočtená dealerská cena a její druhá výstupní hodnota |
| `PriceB2CMin` | money | Minimální B2C cena |
| `TipsPrice` | money | Množstevní cena vypočtená pro hranici `PcsQtyF` |
| `TipsQtyF`, `TipsQtyT` | různé | Dolní a horní hranice množstevní ceny |
| `QtyFree` | i4 | Volné množství, případně včetně vybraných blokací objednávek |

Export je viditelný firmám `0`, `6336` a `1862`. Základní i intervalové volání je omezeno na
hodiny 08 až 20.

#### 5.2.45 X-StoItemBaseWithoutPriceStock

Produktový export základních a rozšířených popisných údajů bez cen a skladového množství.

**`resultType`:** `X-StoItemBaseWithoutPriceStock` · `X-StoItemBaseWithoutPriceStock_El` · `X-StoItemBaseWithoutPriceStock_Schema`

##### Filtrování a parametry

`GetResultByCode` podporuje `StiCode`, `{PartNo}`, `{PartNo2}`, `{CodeEAN}`, `{ManName}` a více
hodnot oddělených tabulátorem. `GetResultByFromTo` sleduje `StiU` nebo `SipU`. Export respektuje
řádková oprávnění, ale nevyžaduje kladnou objednávkovou cenu.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemBaseWithoutPriceStock&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 30 requestů pro varianty popsané v této sekci.

```xml
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseThumbnail="https://terminal.sws.cz/img.asp?attname=thumbnail&amp;attpedid=52&amp;attsrcid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=" UrlBaseEnlargement="https://terminal.sws.cz/img.asp?attname=enlargement&amp;attpedid=52&amp;attsrcid=" UrlBaseImgGalery="https://terminal.sws.cz/img.asp?attid=" CouCode="CZ" TaxRateLow="12" TaxRateHigh="21">
  <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" NameE="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" ManName="Lenovo" CouCode="CN" UrlExt="https://psref.lenovo.com/accessory/40BF0100EU" WeightRef="0.54750" TaxRate="21.0000" CutCode="84718000" WarDur="1116" WarDurEU="1116" SNTrack="1" Weight="0.64000" ScaId="53" ThumbnailIs="1" ThumbnailSize="1322" ImgIs="1" ImgSize="14400" EnlargementIs="1" EnlargementSize="19826" SisName="Novinka" NoteShort="Popis produktu&#13;&#10;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstr" Note="Popis produktu&#13;&#10;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstream konektivitou o propustnosti 40 Gb/s, což umožňuje rozšířit konfiguraci monitorů o více pixelů a vyšší obnovovací frekvence.&#13;&#10;Dokovací stanice může dodávat 65 W napájení notebooku při použití 100W napájecího adaptéru, nebo lze použít 135W adaptér, který zvýší nabíjecí výkon až na 100 W pro notebook.&#13;&#10;&#13;&#10;Hlavní vlastnosti&#13;&#10;&#13;&#10;Dokovací stanice ThinkPad® USB4 Dock 5000 s nejnovější technologií USB4 nabízí až čtyřnásobný výkon konektivity oproti USB-C 3.2 Gen 2. Díky propustnosti až 40 Gb/s můžete připojit buď jeden monitor s ultravysokým rozlišením 8K při 60 Hz, nebo dva monitory 4K s obnovovací frekvencí 144 Hz. Snadno tak rozšíříte svůj notebook Lenovo na plnohodnotnou pracovní platformu s různými periferními zařízeními.&#13;&#10;Dok podporuje Power Delivery 3.1 a poskytuje až 100 W pro rychlé nabíjení notebooku, takže můžete jednoduše rozšířit možnosti svého pracovního prostoru.&#13;&#10;&#13;&#10;Dokovací stanice je navíc univerzálně kompatibilní s různými operačními systémy.">
    <ImgGal />
  </StoItem>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemBaseWithoutPriceStock.xml`](examples/priority/X-StoItemBaseWithoutPriceStock.xml)

`Result` obsahuje základní URL, adresy obrázků, zemi a daňové sazby. `StoItem` vrací identifikaci,
názvy, výrobce, záruku, logistické údaje, stav produktu, popis a metadata obrázků; `ImgGal` obsahuje
galerii. Cenová pole `PriceEU`, `PriceDea`, `PriceRef`, `PriceRef2` a skladová pole `QtyFreeIs`,
`QtyFree` jsou v SQL zakomentována a do XML se nevracejí.

Základní i intervalové volání je omezeno na hodiny 08 až 20; pro firmy `0` a `6336` časové omezení
neplatí.

#### 5.2.46 X-StoItemXXLDelivModePrc

Dopravní export cen podporovaných způsobů dopravy pro nadrozměrné nebo atypické produkty s `StiXXL = 1`.

**`resultType`:** `X-StoItemXXLDelivModePrc` · `X-StoItemXXLDelivModePrc_El` · `X-StoItemXXLDelivModePrc_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `{PartNo}`, a podporuje více hodnot oddělených tabulátorem. `GetResultByFromTo` sleduje změnu produktu `StiU`. Pro produkt se vybírají neskryté způsoby dopravy, které podporují XXL produkty, mají aktivní ceníkový záznam pro jeho `StiXDfpId` a nemají dolní hodnotový limit.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemXXLDelivModePrc&code=BNQ00169`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 72 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Id="697234" Code="BNQ00169">
    <DelivMode DemName="Gebrüder Weiss" DfcPrc="200.0000" OrderLimit="100000.0000" Code="_WS_DIST_063" />
    <DelivMode DemName="Gebrüder Weiss dobírka" DfcPrc="265.0000" OrderLimit="100000.0000" Code="_WS_DIST_064" />
  </StoItem>
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemXXLDelivModePrc.xml`](examples/priority/X-StoItemXXLDelivModePrc.xml)

| Element / pole | Typ | Popis |
| ---- | --- | ----- |
| `StoItem.Id`, `StoItem.Code` | různé | ID a kód XXL produktu |
| `DelivMode.DemName` | string | Název způsobu dopravy |
| `DelivMode.DfcPrc` | money | Cena dopravy pro skupinu produktu |
| `DelivMode.OrderLimit` | různé | Limit objednávky ze `DelivMode.DemTrCLimitI` |
| `DelivMode.Code` | string | WebService kód dopravy ve formátu `_WS_DIST_NNN` |

Jeden `StoItem` může obsahovat více elementů `DelivMode`. Základní i intervalové volání je omezeno na hodiny 08 až 20.

#### 5.2.47 X-StoItemQtyFreeShip

Skladový export volného množství, číselné dostupnosti a nejbližší očekávané volné dodávky produktu.

**`resultType`:** `X-StoItemQtyFreeShip` · `X-StoItemQtyFreeShip_El` · `X-StoItemQtyFreeShip_Schema`

##### Filtrování a parametry

`GetResultByCode` filtruje `StiCode`, případně `{PartNo}`, a podporuje více hodnot oddělených tabulátorem. Export nepodporuje `from` ani `to`. Bez `code` základní výběr zahrnuje jen produkty s kladným volným množstvím; pro firmu `ComId = 7653` se přičítá její kladně blokované množství z objednávek.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=X-StoItemQtyFreeShip&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 163 requestů pro varianty popsané v této sekci.

```xml
<Result>
  <StoItem Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" QtyFreeIs="1" Avail="21" />
</Result>
```

Úplný reprodukovaný payload: [`examples/priority/X-StoItemQtyFreeShip.xml`](examples/priority/X-StoItemQtyFreeShip.xml)

| Pole `StoItem` | Typ | Popis |
| ---- | --- | ----- |
| `Code`, `PartNo`, `PartNo2`, `EAN`, `EAN2` | string | Identifikace produktu |
| `QtyFreeIs` | boolean | Příznak kladného volného množství |
| `QtyFree` | i4 | Volné množství; vrácení číselné hodnoty závisí na oprávnění `Field-QtyFree` |
| `Avail` | i4 | Předpokládaná dostupnost produktu ve dnech |
| `DateNextShipFree` | dateTime | Nejbližší datum příjmové fronty s kladným volným množstvím `QueQtyFree` |
| `QtyNextShipFreeIs` | boolean | Příznak kladného množství nejbližší volné dodávky |
| `QtyNextShipFree` | i4 | Volné množství nejbližší dodávky; může být omezeno hodnotou `MaxI` |

Pole `DateNextShip`, `QtyNextShipIs` a `QtyNextShip` se sice uvnitř příkazu počítají, ale ve finálním SELECTu jsou zakomentována a do XML se aktuálně nevracejí. Dvě shodné definice v `ResultListUser.config` představují jeden export, nikoli dva ResultListy.

#### 5.2.48 StoItemGPSR

Produktový export GPSR údajů získaných z GPSR kategorie výrobce a ze souvisejících příloh produktu.

**`resultType`:** `StoItemGPSR`

##### Filtrování a parametry

`GetResultByCode` bez prefixu filtruje `StiCode`. Dále podporuje `{StiId}`, `{PartNo}`, `{PartNo2}`, `{CodeEAN}`, `{ManName}`, `{CodeAll}` a více hodnot oddělených tabulátorem. `{CodeAll}` hledá ve viditelných alternativních kódech `StoItemCode`. `GetResultByFromTo` není podporováno.

Do základního výběru vstupují viditelné a objednatelné produkty s kladnou cenou pro cenovou hladinu firmy. Ve výsledku zůstanou jen produkty, pro které `dbo.fGpsrManufacturer` nebo `dbo.fGpsrAttach` vrátí alespoň jeden záznam.

##### Příklad volání a XML odpovědi

`https://terminal.sws.cz/i6ws/Default.asmx/GetResultByCode?resultType=StoItemGPSR&code=LNM01353`

Reprodukováno read-only spuštěním SQL `Command` pro `UserConId = 109895`. Statistiky evidují 72 requestů pro varianty popsané v této sekci.

SQL pro zvolené parametry nevrátil žádný XML řádek. Jde o ověřený prázdný výsledek, nikoli o chybějící ukázku.

Úplný reprodukovaný payload: [`examples/priority/StoItemGPSR.xml`](examples/priority/StoItemGPSR.xml)
##### Struktura elementů

`Result` obsahuje `0..N` elementů `StoItem`. Každý produkt může obsahovat `0..N` elementů `Manufacturer` a `0..N` elementů `Link`.

| Pole `StoItem` | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | Interní ID produktu |
| `Code`, `Code2` | string | Hlavní a druhý kód produktu |
| `PartNo`, `PartNo2` | string | Objednací označení výrobce a jeho druhá varianta |
| `EAN`, `EAN2` | string | EAN hodnoty získané podle kontaktního nastavení `WsEAN` |
| `Name` | string | Název produktu `StiPLName` |

| Pole `Manufacturer` | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | ID GPSR kategorie výrobce |
| `Name`, `Address`, `EMail` | string | Základní kontaktní sada výrobce |
| `NameER`, `AddressER`, `EMailER` | string | Druhá kontaktní sada výrobce |

Funkce `dbo.fGpsrManufacturer` vrací také telefonní pole obou sad, ale tento ResultList je do XML nezařazuje.

| Pole `Link` | Typ | Popis |
| ---- | --- | ----- |
| `Id` | i4 | ID přílohy `Attach.AttId` |
| `Type` | string | Volná řetězcová hodnota: část `Attach.AttTag` za prefixem `sys-gpsr-`; nejde o pevný číselník |
| `Name` | string | Název přílohy nebo odkazu |
| `Note` | string | Poznámka přílohy |
| `Url` | string | URL; u binární přílohy se skládá z URL galerie a `AttId`, jinak se použije `Attach.AttUrl` |

Funkce přijímá každý tag ve tvaru `sys-gpsr-*` a žádný seznam povolených suffixů nekontroluje. Databáze aktuálně neobsahuje aktivní GPSR kategorii ani žádný tag s tímto prefixem. Export nemá v `ResultListUser.config` další restrikce ani omezení viditelnosti.
