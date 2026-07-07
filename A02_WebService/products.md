
> **⚠️ Verze dokumentu 0.5**  
> Dokument není dokončen, jedná se o pracovní verzi. Místa označená `‹…›` a **TODO** je třeba doplnit reálnými hodnotami (URL, přihlašovací údaje, ukázky odpovědí). Předpoklady jsou v textu výslovně označeny.


---

# WebService – Product API

> **Účel dokumentu:** Kompletní popis SWS/I6 (CyberSoft) WebServisu pro účely předání a integrace
> pod ALSO. Dokument popisuje architekturu, autentizaci, formát požadavků
> a odpovědí, konvence pojmenování a úplný katalog dostupných exportů.
>


---

## Obsah

- [1. Přehled](#1-přehled)
- [2. Base URL](#2-base-url)
- [3. Formát požadavku](#3-formát-požadavku)
  - [3.1 Čtení dat – Default.asmx](#31-čtení-dat--defaultasmx)
- [4. Srovnání s ALSO Product API](#4-srovnání-s-also-product-api)
- [5. Katalog exportů](#5-katalog-exportů)
  - [5.1 Nejpoužívanější exporty](#51-nejpoužívanější-exporty)
  - [5.2 Příklady nejpoužívanějších exportů](#52-příklady-nejpoužívanějších-exportů)
    - [5.2.1 StoItemBase](#521-stoitembase)
    - [5.2.2 StoItemQtyFree](#522-stoitemqtyfree)
    - [5.2.3 StoItemSiv](#523-stoitemsiv)
    - [5.2.4 SPresentTree](#524-spresenttree)
    - [5.2.5 DocTrInv](#525-doctrinv)
    - [5.2.6 StoItemPriceOrd](#526-stoitempriceord)
    - [5.2.7 CpsStiVal](#527-cpsstival)
    - [5.2.8 AttSti](#528-attsti)
    - [5.2.9 CpsSti](#529-cpssti)

---

## 1. Přehled

SWS WebService poskytuje partnerům strojový přístup k datům **ERP systému I6 (CyberSoft)**.
Pokrývá informace o produktech (StoItem), skladové zásoby, ceny, obrázky, atributy, prezentační
stromy (kategorie), doklady (faktury, dodací listy) a objednávky.

Service je postaven jako **ASP.NET Web Service (`.asmx`)** a je provozován jako aplikační adresář
`/i6ws/` na eShopu distributora. Se službou lze komunikovat pomocí protokolu **SOAP**, u metod s jednoduchými parametry
(exporty) také pomocí **HTTP GET/POST** – exporty lze tedy stahovat obyčejným odkazem (URL).


## 2. Base URL

Webová služba je provozována jako aplikační adresář `/i6ws/` na eShopu distributora:

```
https://terminal.sws.cz/i6ws/
```
```
https://www.sws.cz/i6ws/
```


**Hlavní endpointy:**

| Endpoint                | Účel                                                                                          |
|-------------------------|-----------------------------------------------------------------------------------------------|
| `Default.asmx`          | Univerzální čtení dat (exporty) – metody `GetResult` (pro všechny produkty), `GetResultByCode` (pro jenom jeden produkt), `GetResultByFromTo`  |
| `Order.asmx`            | Zakládání a správa objednávek – metoda `Create`                                               |
| `ResultTypeInfo.ashx`   | Přehled všech dostupných exportů s popisem a schématy                                        |

---


## 3. Formát požadavku

### 3.1 Čtení dat – `Default.asmx`

K dispozici jsou tři metody, všechny dostupné přes HTTP GET (i SOAP).

```
GET https://JMENO:HESLO@HOST/i6ws/Default.asmx/GetResult?resultType=‹RESULT_TYPE›
GET https://JMENO:HESLO@HOST/i6ws/Default.asmx/GetResultByCode?resultType=‹RESULT_TYPE›&code=‹CODE›
GET https://JMENO:HESLO@HOST/i6ws/Default.asmx/GetResultByFromTo?resultType=‹RESULT_TYPE›&from=‹FROM›&to=‹TO›
```

| Metoda              | Popis                                                                                              | Parametry                  |
|---------------------|----------------------------------------------------------------------------------------------------|----------------------------|
| `GetResult`         | Vrátí kompletní export (všechny produkty, vše skladem apod.)              | `resultType`               |
| `GetResultByCode`   | Filtruje export podle kódu – vrátí jeden záznam pro daný produkt                                           | `resultType`, `code`       |
| `GetResultByFromTo` | Filtruje export podle datumu od/do – typicky dle evidované změny záznamu                           | `resultType`, `from`, `to` |

**Parametry:**

| Parametr     | Typ         | Povinný                   | Popis                                                                                      |
|--------------|-------------|---------------------------|--------------------------------------------------------------------------------------------|
| `resultType` | String      | Ano                       | Název exportu, např. `StoItemBase` (viz katalog níže)                                      |
| `code`       | String      | Pro `GetResultByCode`     | Filtr – kód produktu, IdP stromu, podmínka… Prefix `{PartNo}` = hledat dle PartNo          |
| `from`       | String/Date | Pro `GetResultByFromTo`   | Začátek rozsahu – formát `YYYY-MM-DD` nebo `YYYY-MM-DD HH:MM:SS`                          |
| `to`         | String/Date | Pro `GetResultByFromTo`   | Konec rozsahu                                                                              |

> **Poznámka k parametru `code`:** Vyhledávání dle PartNo se aktivuje prefixem `{PartNo}`:
> ```
> GetResultByCode?resultType=StoItemQtyFree&code={PartNo}600623
> ```






## 4. Srovnání s ALSO Product API

ALSO Product API nabízí 7 metod. Níže je uvedeno, které SWS exporty pokrývají stejnou funkcionalitu.

| # | ALSO Product API metoda | Popis (ALSO)                                              | Odpovídající SWS export(y)                                      | Poznámka                                                              |
|---|-------------------------|-----------------------------------------------------------|-----------------------------------------------------------------|-----------------------------------------------------------------------|
| 1 | `AllProducts`           | Základní info o všech produktech dostupných v e-shopu     | `StoItemBase`                                  | SWS vrací ceny, sklad i obrázky (only `Id` with URL) v jednom exportu.                     |
| 2 | `AllOfflineProducts`    | Produkty v katalogu partnera, které nejsou online         |            |  |
| 3 | `ProductFullInfo`       | Kompletní detail produktu – popis, atributy, obrázky, ceny | `StoItemBase` + `CpsSti`/`CpsStiVal` + `AttSti`               | SWS vyžaduje kombinaci více exportů pro stejný výsledek               |
| 4 | `ProductNow`            | Aktuální sklad, cena a dostupnost pro jeden produkt       | `StoItemSiv` nebo dostupnost a cena zvlášt `StoItemQtyFree`, `StoItemPriceOrdCur`                        | Volání přes `GetResultByCode` s kódem produktu                        |
| 5 | `AllProductsNow`        | Sklad, cena a dostupnost pro všechny produkty             | `StoItemSiv` nebo dostupnost a cena zvlášt `StoItemQtyFree`, `StoItemPriceOrdCur`                           | Volání přes `GetResult` pro všechny produkty                 |
| 6 | `ProductImages`         | Dostupné obrázky produktu                                 |`StoItemBase` nebo  `AttSti`                                            | SWS vrací URL sestavené z `UrlBase*` + `Id`; typy rozlišeny tagem    |
| 7 | `Categories`            | Kompletní hierarchie kategorií e-shopu                    | `SPresentTree`, `SCategorySys`                                  | SWS používá plochý seznam s ID rodiče a sort klíčem (3 znaky/úroveň) |

---

## 5. Katalog exportů

Každý export existuje ve třech variantách — liší se pouze suffixem v `resultType`:

| Suffix    | Popis                                 |Příklad|
|-----------|---------------------------------------|-------|
| *(žádný)* | Data jako XML atributy — kompaktnější |name|
| `_El`     | Data jako XML elementy — čitelnější   |name_El|
| `_Schema` | XSD schéma exportu                    |name_Schema|

**Příklad — stejná data, tři varianty (`StoItemQtyFree`):**

https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree

```xml
<!-- Atributy (výchozí) -->
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="685699" Code="ASC00511" PartNo="GU605CX-QR149" PartNo2="90NR0M65-M007X0" EAN="4711636262347" EAN2="" QtyFree="2" />
</Result>
```

https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree_El

```xml
<!-- Elementy (_El) -->
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem>
        <Id>685699</Id>
        <Code>ASC00511</Code>
        <PartNo>GU605CX-QR149</PartNo>
        <PartNo2>90NR0M65-M007X0</PartNo2>
        <EAN>4711636262347</EAN>
        <EAN2>
    </EAN2>
        <QtyFree>2</QtyFree>
    </StoItem>
</Result>
```

https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree_Schema


```xml
<!-- Schéma (_Schema) — definice všech polí a jejich datových typů -->
<?xml version="1.0" encoding="utf-8"?>
<Schema name="Schema1" xmlns="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes">
    <ElementType name="Result" content="eltOnly" model="closed" order="many">
        <element type="StoItem" maxOccurs="*" />
        <AttributeType name="Void" dt:type="string" />
        <attribute type="Void" />
    </ElementType>
    <ElementType name="StoItem" content="empty" model="closed">
        <AttributeType name="Id" dt:type="i4" />
        <AttributeType name="Code" dt:type="string" />
        <AttributeType name="Code2" dt:type="string" />
        <AttributeType name="PartNo" dt:type="string" />
        <AttributeType name="PartNo2" dt:type="string" />
        <AttributeType name="EAN" dt:type="string" />
        <AttributeType name="EAN2" dt:type="string" />
        <AttributeType name="QtyFreeIs" dt:type="boolean" />
        <AttributeType name="QtyFree" dt:type="i4" />
        <attribute type="Id" />
        <attribute type="Code" />
        <attribute type="Code2" />
        <attribute type="PartNo" />
        <attribute type="PartNo2" />
        <attribute type="EAN" />
        <attribute type="EAN2" />
        <attribute type="QtyFreeIs" />
        <attribute type="QtyFree" />
    </ElementType>
</Schema>
```

### 5.1 Nejpoužívanější exporty

| # | ResultType            | Počet  firem                      | Popis                                                    |
|---|-----------------------|---------------------------------------|----------------------------------------------------------|
| 1 | `StoItemBase`         | 130   | Kompletní katalog produktů          |
| 2 | `StoItemQtyFree`      | 104          | Aktuální volné množství na skladě                        |
| 3 | `StoItemSiv`          | 57   | Nákupní cena a stav skladem                                  |
| 4 | `SPresentTree`        | 56               | Hierarchický strom kategorií produktů                    |
| 5 | `DocTrInv`    | 51        | Faktury         |
| 6 | `StoItemPriceOrd`           | 36               | Nakupni cena              |
| 7 | `CpsStiVal`              | 27                      | Atributy produktů včetně definic parametrů               |
| 8 | `StiRelation`              | 19            |    Vazby mezi produkty (příslušenství, alternativy)                   |
| 9 | `StoItemBase_El`         | 18                       | Výstup jako xml element.  Kompletní katalog produktů    |
| 10| `AttSti`            | 16   | Přílohy produktů (obrázky, dokumenty) faktur                                            |
| 11| `CpsSti`            | 16  | Parametry produktů
| 12| `StoItemQtyFree_El`            | 16   | Výstup jako xml element. Aktuální volné množství na skladě
| 12| `StrStiSync`            | 12   | Synchronizace stromu produktů


---


### 5.2 Příklady nejpoužívanějších exportů

#### 5.2.1 StoItemBase

V jednom volání vrací popis produktů,  ceny, DPH,
skladovou dostupnost, logistické údaje i informace o obrázcích. Odpovídá metodě `AllProducts`
(příp. `ProductFullInfo`) z ALSO Product API.

**`resultType`:** `StoItemBase` · `StoItemBase_El` · `StoItemBase_Schema`

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
| `Void`              | string | `‹ověřit›` (rezervovaný/prázdný atribut)                              |

##### Atributy elementu `StoItem`

| Pole            | Typ         | Popis                                                                      |
|-----------------|-------------|----------------------------------------------------------------------------|
| `Id`            | i4          | Interní ID produktu v i6       |
| `Code`          | string      | Hlavní skladový kód SWS (např. `ASC00511`)                                 |
| `Code2`         | string      | Alternativní/druhý kód `‹ověřit›`                                          |
| `PartNo`        | string      | Katalogové (výrobní) číslo výrobce                                         |
| `PartNo2`       | string      | Druhé výrobní/objednací číslo výrobce                                      |
| `EAN`           | string      | EAN                                                            |
| `EAN2`          | string      | Druhý EAN                                                                  |
| `Name`          | string      | Název produktu                                                            |
| `NameAdd`       | string      | Doplněk názvu (rozšiřující text) `‹ověřit›`                                |
| `NameE`         | string      | Název v angličtině                                                        |
| `NameDoc`       | string      | Název používaný na dokladech                                              |
| `NameShort`     | string      | Zkrácený název                                                            |
| `NameSeo`       | string      | SEO název (pro URL / vyhledávače)                                         |
| `ManName`       | string      | Název výrobce (Manufacturer)                                             |
| `CouCode`       | string      | Kód země původu                                                          |
| `UrlExt`        | string      | Externí URL (např. stránka produktu u výrobce) `‹ověřit›`                 |
| `PriceEU`       | fixed.14.4  |  MSRP, list price                           |
| `PriceB2CMin`   | fixed.14.4  | Minimální B2C prodejní cena (MAP)                                        |
| `PriceDea`      | fixed.14.4  | Dealerská cena                                                            |
| `PriceOrd`      | fixed.14.4  | Objednací (nákupní) cena                                                  |
| `PriceRef`      | fixed.14.4  | autorský poplatek |
| `PriceRefInfo`  | fixed.14.4  | Informativní hodnota referenčního poplatku `‹ověřit›`                     |
| `RefProName`    | string      | Název referenčního produktu `‹ověřit›`                                    |
| `RefCode`       | string      | Kód referenčního produktu `‹ověřit›`                                      |
| `PriceRef2`     | fixed.14.4  | recyklační poplatek `‹ověřit›`                             |
| `PriceRef2Info` | fixed.14.4  | Informativní hodnota druhého ref. poplatku `‹ověřit›`                     |
| `RefProName2`   | string      | Název druhého referenčního produktu `‹ověřit›`                           |
| `RefCode2`      | string      | Kód druhého referenčního produktu `‹ověřit›`                             |
| `WeightRef`     | number      | Referenční hmotnost (pro výpočet poplatku?) `‹ověřit›`                    |
| `MeasureRef2`   | number      | Referenční míra/množství `‹ověřit›`                                      |
| `TaxRate`       | fixed.14.4  | Sazba DPH produktu (%)                                                    |
| `TatCodeE`      | string      | `‹ověřit›`                                                                |
| `CutCode`       | string      | `‹ověřit — celní sazebník / kód?›`                                        |
| `QtyFreeIs`     | boolean     | Příznak, zda je dostupné množství evidováno/platné                       |
| `QtyFree`       | i4          | Volné (dostupné) množství skladem                                        |
| `QtyPack`       | number      | Množství v balení (karton)                                              |
| `WarDur`        | i4          | Délka záruky (měsíce)                                                    |
| `WarDurEU`      | i4          | Délka záruky pro koncového zákazníka / EU (měsíce) `‹ověřit›`            |
| `SNTrack`       | ui1         | Evidence sériových čísel (0 = ne / typ sledování)                        |
| `NonDivQty`     | number      | Nedělitelné (minimální odběrové) množství `‹ověřit›`                      |
| `Weight`        | number      | Hmotnost (kg)                                                            |
| `XXL`           | boolean     | Nadrozměrné zboží                                                        |
| `XXS`           | boolean     | `‹ověřit›`                                                                |
| `ScaId`         | i4          | `‹ověřit›`                                                                |
| `ThumbnailIs`   | boolean     | Existuje náhled                                                          |
| `ThumbnailSize` | i8          | Velikost náhledu (B)                                                     |
| `ImgIs`         | boolean     | Existuje hlavní obrázek                                                  |
| `ImgSize`       | i8          | Velikost hlavního obrázku (B)                                            |
| `EnlargementIs` | boolean     | Existuje zvětšenina                                                      |
| `EnlargementSize`| i8         | Velikost zvětšeniny (B)                                                  |
| `SisName`       | string      | `‹ověřit›`                                                                |
| `SitId`         | ui1         | `‹ověřit›`                                                                |
| `NonMater`      | ui1         | Příznak nehmotného produktu (služba/licence/ESD)? `‹ověřit›`             |
| `SttId`         | ui1         | `‹ověřit›`                                                                |
| `NoteShort`     | string      | Krátká poznámka                                                          |
| `StiDemIdDis`   | string      | `‹ověřit›`                                                                |
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

##### Příklad:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="685699" Code="ASC00511" PartNo="GU605CX-QR149" PartNo2="90NR0M65-M007X0" EAN="4711636262347" EAN2="" QtyFree="2" />
</Result>
```

##### Atributy elementu `StoItem`

| Pole        | Typ     | Popis                                                        |
|-------------|---------|--------------------------------------------------------------|
| `Id`        | i4      | Interní ID produktu v i6                                     |
| `Code`      | string  | Hlavní skladový kód SWS (např. `ASC00511`)                  |
| `Code2`     | string  | Alternativní/druhý kód `‹ověřit›`                           |
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

##### Příklad:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=">
    <StoItem Id="230726" Code="578307" Code2="ZB0788" PartNo="A76/01B" EAN="8711500802521" EAN2="4895229106093" Name="Philips baterie knoflíková A76, alkalická - 1ks (LR44)" ManName="Philips" SiuCode="ks" UrlSuffix="230726" UrlExt="http://www.consumer.philips.com/c/zvlastni-baterie/alkalicke-a76_01b/prd/cz/" QtyFree="9" PriceEU="28.1000" PriceOrd="11.5000" PriceRef="0.0000" PriceRef2="0.0000" WarDur="744" ImgSize="16384" CutCode="85065030" Weight="0.00400" />
</Result>
```

##### Atributy elementu `Result` (obálka)

| Pole         | Typ    | Popis                                                              |
|--------------|--------|--------------------------------------------------------------------|
| `UrlBase`    | string | Základ URL eshopu/webu                                            |
| `UrlBaseImg` | string | Základ URL pro hlavní obrázek — výsledná URL = `UrlBaseImg` + `StoItem.Id` |
| `Void`       | string | `‹ověřit›` (rezervovaný/prázdný atribut)                          |

##### Atributy elementu `StoItem`

| Pole            | Typ         | Popis                                                            |
|-----------------|-------------|------------------------------------------------------------------|
| `Id`            | i4          | Interní ID produktu v i6; slouží k sestavení URL obrázku         |
| `Code`          | string      | Hlavní skladový kód SWS                                          |
| `Code2`         | string      | Alternativní/druhý kód `‹ověřit›`                               |
| `PartNo`        | string      | Katalogové (výrobní) číslo výrobce                              |
| `PartNo2`       | string      | Druhé výrobní/objednací číslo výrobce                           |
| `EAN`           | string      | EAN (čárový kód)                                                |
| `EAN2`          | string      | Druhý EAN                                                       |
| `Name`          | string      | Název produktu                                                 |
| `ManName`       | string      | Název výrobce (Manufacturer)                                   |
| `SisName`       | string      | `‹ověřit›`                                                      |
| `SiuCode`       | string      | `‹ověřit — kód měrné jednotky (ks/bal.)?›`                      |
| `UrlSuffix`     | string      | Přípona připojovaná k `UrlBase` (dokončení URL produktu) `‹ověřit›` |
| `UrlExt`        | string      | Externí URL `‹ověřit›`                                          |
| `QtyFreeIs`     | boolean     | Příznak, zda je dostupné množství evidováno/platné              |
| `QtyFree`       | i4          | Volné (dostupné) množství skladem                              |
| `PriceEU`       | fixed.14.4  | `‹ověřit — koncová/doporučená cena (MSRP)?›`                    |
| `PriceOrd`      | fixed.14.4  | Objednací (nákupní) cena                                        |
| `PriceRef`      | fixed.14.4  | Cena navázaného referenčního poplatku (recyklační/autorský?) `‹ověřit›` |
| `PriceRefInfo`  | fixed.14.4  | Informativní hodnota referenčního poplatku `‹ověřit›`          |
| `PriceRef2`     | fixed.14.4  | Cena druhého referenčního poplatku `‹ověřit›`                  |
| `PriceRef2Info` | fixed.14.4  | Informativní hodnota druhého ref. poplatku `‹ověřit›`         |
| `WarDur`        | i4          | Délka záruky (měsíce)                                          |
| `ImgSize`       | i8          | Velikost hlavního obrázku (B); 0 = obrázek není                |
| `SitId`         | ui1         | `‹ověřit›`                                                      |
| `NonMater`      | ui1         | Příznak nehmotného produktu (služba/licence/ESD)? `‹ověřit›`   |
| `CutCode`       | string      | `‹ověřit — celní sazebník / kód?›`                             |
| `Weight`        | number      | Hmotnost (kg)                                                  |
| `XXL`           | boolean     | Nadrozměrné zboží                                              |
| `XXS`           | boolean     | `‹ověřit›`                                                      |



#### 5.2.4 SPresentTree

Export prezentačního (kategorického) stromu. Vrací **plochý seznam uzlů** stromu, kde se
hierarchie rekonstruuje na straně klienta ze sort klíče — **každá úroveň má vyhrazené 3 znaky**
(`AAA` = 1. úroveň, `AAABBB` = 2. úroveň atd.). Vazbu na rodiče nese `IdP` (prázdné = kořenový
uzel). Top-level uzly odpovídají *typům stromu* (ceníkové stromy), jejich `Id` je odvozené jako
záporná hodnota (`-2147483648 + typ`). Odpovídá metodě `Categories` z ALSO Product API.

Díky `FOR XML AUTO` je struktura **dvouúrovňová**: uzel `SPresentTree` obsahuje 0..N vnořených
elementů `StoItem` — tj. produkty zařazené přímo do daného uzlu. Kategorie bez produktů, které
zároveň nemají pod sebou žádný produkt (na žádné podúrovni), jsou z výstupu odstraněny.



**Filtrování přes `GetResultByCode`:** parametr `code` = `IdP` (ID uzlu) — vrátí danou podvětev
stromu. Záporné `code` filtruje podle *typu stromu*.

##### Příklad:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=spresenttrees&amp;strid=" UrlBaseImg="https://terminal.sws.cz/img.asp?strid=">
    <SPresentTree Id="21224" IdP="12695" Sort="001Z6WKCC" Name="5G/LTE">
        <StoItem Code="447665" Id="640646"/>
        <StoItem Code="ZXL00038" Id="666764"/>
        <StoItem Code="ZXL00105" Id="686879"/>
        <StoItem Code="ZXL00109" Id="691042"/>
        <StoItem Code="ZXL00123" Id="697709"/>
    </SPresentTree>
    <SPresentTree Id="21409" IdP="21353" Sort="001ZBW126" Name="Acar">
        <StoItem Code="398242" Id="561103"/>
        <StoItem Code="398423" Id="561108"/>
    </SPresentTree>
</Result>
```

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

**`resultType`:** `DocTrInv` (varianty `_El` / `_Schema` — `‹ověřit›`, u `FOR XML EXPLICIT`
se konvence tří variant nemusí uplatnit stejně jako u ostatních exportů)

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
| `ZCode`       | string      | Číslo faktury pro dropship/koncového zákazníka (jen je-li) `‹ověřit›`     |
| `CodeO`       | string      | Externí číslo faktury (číslo u odběratele, jen je-li)                     |
| `SymCon`      | string      | Párovací/variabilní symbol platby `‹ověřit›`                              |
| `Tag`         | string      | Štítek/příznak faktury (jen je-li)                                        |
| `OrdId`       | i4          | ID navázané objednávky                                                    |
| `OrdCode`     | string      | Číslo navázané objednávky                                                 |
| `OrdCodeO`    | string      | Externí číslo objednávky                                                  |
| `OrdC`        | datetime    | Datum pořízení objednávky                                                 |
| `Type`        | —           | Typ faktury (číselník; např. faktura/dobropis) `‹ověřit hodnoty›`         |
| `DateAcc`     | date        | Datum účetního případu / DUZP `‹ověřit›`                                  |
| `DateDue`     | date        | Datum splatnosti                                                          |
| `CurCode`     | string      | Kód měny (ISO, `UsdCodeE`)                                                |
| `Val`         | fixed.14.4  | Celková hodnota v domácí měně                                            |
| `ValCur`      | fixed.14.4  | Celková hodnota v měně faktury                                          |
| `ValRnd`      | fixed.14.4  | Zaokrouhlení (domácí měna)                                               |
| `ValRndCur`   | fixed.14.4  | Zaokrouhlení (měna faktury)                                              |
| `ValPaid`     | fixed.14.4  | Uhrazeno (domácí měna)                                                   |
| `ValPaidCur`  | fixed.14.4  | Uhrazeno (měna faktury)                                                  |
| `ZVal`        | fixed.14.4  | Hodnota pro koncového zákazníka (dropship) `‹ověřit›`                     |
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
| `OrwName`      | string | Stav / způsob zpracování objednávky `‹ověřit›`                 |
| `CstId`        | i4     | ID dodací adresy objednávky (`-ComId` = sídlo firmy)           |
| `CstName`      | string | Název dodací adresy                                            |
| `CstNameAdd`   | string | Doplněk názvu                                                 |
| `CstNameAdd2`  | string | Druhý doplněk názvu                                           |
| `CstStreet`    | string | Ulice                                                        |
| `CstCity`      | string | Město                                                        |
| `CstPostCode`  | string | PSČ                                                          |
| `CstCouName`   | string | Země                                                        |
| `ZDirect`      | —      | Příznak přímého dropshipmentu (zásilka přímo koncovému zák.)   |
| `ZIPrn`        | —      | Příznak tisku faktury do zásilky `‹ověřit›`                    |
| `ZDPrn`        | —      | Příznak tisku dodacího listu do zásilky `‹ověřit›`            |
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

##### Příklad:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="685699" Code="ASC00511" PartNo="GU605CX-QR149" PartNo2="90NR0M65-M007X0" EAN="4711636262347" PriceOrd="81144.2200" PriceEU="90900.8300" PriceRef="11.3400" PriceRef2="33.0000" TaxRate="21.0000" />
</Result>
```

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
| `PriceEU`      | money  | Koncová/doporučená cena (přepočtená do měny partnera, je-li nastaveno) `‹ověřit význam – MSRP?›` |
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
| `Single`     | —      | Příznak, že parametr má jen jednu hodnotu (jen je-li nenulový) `‹ověřit›`       |
| `Ord`        | i4     | Pořadí parametru pro řazení ve výpisu (jen je-li nenulové)                     |
| `Value`      | string | **Hodnota parametru** — buď z číselníku (`CpvValue`), nebo volný text (`CpsTag`) |
| `ValueAdd`   | string | Doplňková hodnota / poznámka k hodnotě (jen je-li)                             |
| `Measure`    | number | Měrná jednotka / číselná míra hodnoty (jen je-li nenulová) `‹ověřit – jednotka vs. číselná hodnota?›` |
| `CprOrd`     | i4     | Pořadí hodnoty v rámci číselníku parametru (jen je-li nenulové)                |

#### 5.2.8 AttSti

Export **příloh produktů** — obrázky, datasheety, dokumentace a další soubory navázané na produkt.
Každý element = jedna příloha; produkt
s N přílohami vrátí N elementů. Pokrývá metodu `ProductImages` z ALSO Product API (a obecně
i nemedia přílohy, pokud jsou u produktu evidovány).



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
| `Tag`        | string | Štítek/typ přílohy (jen je-li) — rozlišení druhu přílohy `‹ověřit hodnoty›`  |
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
| `Type`    | ui1    | Typ parametru (`CpaType`; vrací se typy 0 a 2) `‹ověřit hodnoty›` |
| `Single`  | —      | Příznak, že parametr má jedinou hodnotu `‹ověřit›`               |
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
| `Measure`  | number | Měrná jednotka / míra hodnoty `‹ověřit›`                 |
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
| `Measure` | number | Číselná míra hodnoty (jen je-li nenulová) `‹ověřit›`                     |

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