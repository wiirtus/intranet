> **⚠️ Verze dokumentu 0.5**  
> Dokument není dokončen, jedná se o pracovní verzi. Místa označená `‹…›` a **TODO** je třeba doplnit reálnými hodnotami (URL, přihlašovací údaje, ukázky odpovědí). Předpoklady jsou v textu výslovně označeny.

---

# WebService – Product API

> **Účel dokumentu:** Kompletní popis SWS/I6 (CyberSoft) WebServisu pro účely předání a integrace
> pod ALSO. Dokument popisuje architekturu, autentizaci, formát požadavků
> a odpovědí, konvence pojmenování a úplný katalog dostupných exportů.

---

## Obsah

- [1. Přehled](#1-přehled)
- [2. Base URL](#2-base-url)
- [3. Formát požadavku](#3-formát-požadavku)
  - [3.1 Čtení dat – Default.asmx](#31-čtení-dat--defaultasmx)
  - [3.2 Autentizace](#32-autentizace)
  - [3.3 Zápis dat – Order.asmx](#33-zápis-dat--orderasmx)
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

| Země | Base URL                              |
|------|---------------------------------------|
| CZ   | `https://terminal.sws.cz/i6ws/`       |
| CZ   | `https://www.sws.cz/i6ws/`            |
| SK   | `https://www.swsi.sk/i6ws/`           |
| SK   | `https://www.alsotechnology.sk/i6ws/` |

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
| `GetResultByFromTo` | Filtruje export podle data od/do – typicky dle evidované změny záznamu                           | `resultType`, `from`, `to` |

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

### 3.2 Autentizace

Přístup je vázán na **účet partnera** (stejné přihlašovací údaje jako do eShopu distributora) a
používá **HTTP Basic authentication**. Přihlášení lze předat dvěma způsoby:

- **HTTP hlavičkou** `Authorization: Basic ‹base64(jméno:heslo)›` — doporučeno pro integrace,
- **přímo v URL** — `https://JMENO:HESLO@HOST/i6ws/…` (viz příklady v sekci 3.1); vhodné pro rychlé
  otestování v prohlížeči či skriptu.

Oprávnění účtu zároveň určuje **rozsah vracených dat** — viditelnost produktů, cenové hladiny
(`PriceFullIs`, viz `StoItemPriceOrd`) i omezení dokladů na vlastní firmu (viz `DocTrInv`).

> **TODO:** doplnit postup zřízení přístupu a testovací přihlašovací údaje `‹…›`.

### 3.3 Zápis dat – `Order.asmx`

Zakládání objednávek probíhá přes endpoint `Order.asmx` (metoda `Create`). Popis je mimo rozsah
tohoto dokumentu — viz samostatný dokument [orders.md](orders.md).

---

## 4. Srovnání s ALSO Product API

ALSO Product API nabízí 7 metod. Níže je uvedeno, které SWS exporty pokrývají stejnou funkcionalitu.

| # | ALSO Product API metoda | Popis (ALSO)                                              | Odpovídající SWS export(y)                                      | Poznámka                                                              |
|---|-------------------------|-----------------------------------------------------------|-----------------------------------------------------------------|-----------------------------------------------------------------------|
| 1 | `AllProducts`           | Základní info o všech produktech dostupných v e-shopu     | `StoItemBase`                                  | SWS vrací ceny, sklad i obrázky (pouze `Id`, URL se skládá z `UrlBase*`) v jednom exportu. |
| 2 | `AllOfflineProducts`    | Produkty v katalogu partnera, které nejsou online         | —                                                               | **TODO** — bez přímého ekvivalentu `‹ověřit›`                         |
| 3 | `ProductFullInfo`       | Kompletní detail produktu – popis, atributy, obrázky, ceny | `StoItemBase` + `CpsSti`/`CpsStiVal` + `AttSti`               | SWS vyžaduje kombinaci více exportů pro stejný výsledek               |
| 4 | `ProductNow`            | Aktuální sklad, cena a dostupnost pro jeden produkt       | `StoItemSiv`, nebo dostupnost a cena zvlášť: `StoItemQtyFree` + `StoItemPriceOrdCur`                        | Volání přes `GetResultByCode` s kódem produktu                        |
| 5 | `AllProductsNow`        | Sklad, cena a dostupnost pro všechny produkty             | `StoItemSiv`, nebo dostupnost a cena zvlášť: `StoItemQtyFree` + `StoItemPriceOrdCur`                           | Volání přes `GetResult` pro všechny produkty                 |
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

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree`

```xml
<!-- Atributy (výchozí) -->
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="685699" Code="ASC00511" PartNo="GU605CX-QR149" PartNo2="90NR0M65-M007X0" EAN="4711636262347" EAN2="" QtyFree="2" />
</Result>
```

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree_El`

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
        <EAN2></EAN2>
        <QtyFree>2</QtyFree>
    </StoItem>
</Result>
```

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree_Schema`

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

| #  | ResultType          | Počet firem | Popis                                                        |
|----|---------------------|------------:|--------------------------------------------------------------|
| 1  | `StoItemBase`       | 130         | Kompletní katalog produktů                                   |
| 2  | `StoItemQtyFree`    | 104         | Aktuální volné množství na skladě                            |
| 3  | `StoItemSiv`        | 57          | Nákupní cena a stav skladem                                  |
| 4  | `SPresentTree`      | 56          | Hierarchický strom kategorií produktů                        |
| 5  | `DocTrInv`          | 51          | Faktury                                                      |
| 6  | `StoItemPriceOrd`   | 36          | Nákupní cena                                                 |
| 7  | `CpsStiVal`         | 27          | Atributy produktů včetně definic parametrů                   |
| 8  | `StiRelation`       | 19          | Vazby mezi produkty (příslušenství, alternativy)             |
| 9  | `StoItemBase_El`    | 18          | Kompletní katalog produktů — výstup jako XML elementy        |
| 10 | `AttSti`            | 16          | Přílohy produktů (obrázky, dokumenty)                        |
| 11 | `CpsSti`            | 16          | Parametry produktů                                           |
| 12 | `StoItemQtyFree_El` | 16          | Aktuální volné množství na skladě — výstup jako XML elementy |
| 13 | `StrStiSync`        | 12          | Synchronizace stromu produktů                                |

---

### 5.2 Příklady nejpoužívanějších exportů

> **Legenda typů** (platí pro všechny tabulky polí níže): `i2`/`i4`/`i8` = celé číslo (16/32/64 bit) · `ui1` = byte (0–255) ·
> `fixed.14.4` / `number` / `money` = desetinné číslo · `string` = text · `boolean` = 0/1.

#### 5.2.1 StoItemBase

V jednom volání vrací popis produktů,  ceny, DPH,
skladovou dostupnost, logistické údaje i informace o obrázcích. Odpovídá metodě `AllProducts`
(příp. `ProductFullInfo`) z ALSO Product API.

**`resultType`:** `StoItemBase` · `StoItemBase_El` · `StoItemBase_Schema`

##### Příklad:

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?resultType=StoItemBase&code=TCL00117`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseThumbnail="https://terminal.sws.cz/img.asp?attname=thumbnail&amp;attpedid=52&amp;attsrcid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=" UrlBaseEnlargement="https://terminal.sws.cz/img.asp?attname=enlargement&amp;attpedid=52&amp;attsrcid=" UrlBaseImgGalery="https://terminal.sws.cz/img.asp?attid=" CouCode="CZ" TaxRateLow="12" TaxRateHigh="21">
    <StoItem Id="673242" Code="TCL00117" PartNo="65Q6C" PartNo2="5901292526665" EAN="5901292526665" Name="TCL 65Q6C SMART TV 65&quot; QLED/4K UHD/Mini LED/144Hz/4xHDMI/USB/LAN/GoogleTV" NameAdd="4100 PPI/Dolby Vision IQ/HDR10+/HDR10/HLG" NameE="TCL 65Q6C" ManName="TCL" CouCode="CN" UrlExt="https://www.tcl.com/cz/cs/" PriceEU="15467.1600" PriceDea="12638.0000" PriceOrd="12638.0000" PriceRef="215.1000" RefProName="ASEKOL" RefCode="2.03." PriceRef2="0.0000" RefProName2="Autorský fond CZ" RefCode2="9.99" WeightRef="17.20000" TaxRate="21.0000" CutCode="85287240" QtyFree="20" WarDur="744" WarDurEU="744" SNTrack="1" Weight="20.30000" XXL="1" ScaId="1487" ThumbnailIs="1" ThumbnailSize="2197" ImgIs="1" ImgSize="111285" NoteShort="Televize – Google TV, Mini LED, 165cm, 4K Ultra HD, 100/120 Hz (144 Hz – herní režim), HDR10+, Dolby Vision, lokální stmívání, antireflexní obraz, DVB-T2/S2/C, 4× HDMI, 1× USB, LAN, WiFi, Bluetooth, DLNA, Chromecast, Miracast, HbbTV 2.0.3, herní režim, hl" Note="Televize – Google TV, Mini LED, ...">
        <ImgGal Id="53098456" Name="Image1" Tag="sys-gal-enl" Sort="1" Size="37866" />
        <ImgGal Id="53098457" Name="Image1" Tag="sys-gal-enl" Sort="2" Size="54590" />
        <ImgGal Id="53098458" Name="Image1" Tag="sys-gal-enl" Sort="3" Size="54279" />
        <ImgGal Id="53098459" Name="Image1" Tag="sys-gal-enl" Sort="4" Size="31121" />
        <ImgGal Id="53098460" Name="Image1" Tag="sys-gal-enl" Sort="5" Size="35862" />
        <ImgGal Id="53098461" Name="Image1" Tag="sys-gal-enl" Sort="6" Size="43787" />
        <ImgGal Id="53098462" Name="Image1" Tag="sys-gal-enl" Sort="7" Size="34645" />
        <ImgGal Id="53098463" Name="Image1" Tag="sys-gal-enl" Sort="8" Size="50589" />
        <ImgGal Id="53098464" Name="Image1" Tag="sys-gal-enl" Sort="9" Size="8323" />
        <ImgGal Id="53098465" Name="Image1" Tag="sys-gal-enl" Sort="10" Size="8246" />
        <ImgGal Id="53098466" Name="Image1" Tag="sys-gal-enl" Sort="11" Size="5792" />
        <ImgGal Id="53098470" Name="Image1" Tag="sys-gal-enl" Sort="12" Size="39502" />
        <ImgGal Id="53099139" Name="Image1" Tag="sys-gal-thu" Sort="1" Size="8767" />
        <ImgGal Id="53099140" Name="Image1" Tag="sys-gal-thu" Sort="2" Size="26486" />
        <ImgGal Id="53099141" Name="Image1" Tag="sys-gal-thu" Sort="3" Size="26191" />
        <ImgGal Id="53099142" Name="Image1" Tag="sys-gal-thu" Sort="4" Size="6463" />
        <ImgGal Id="53099143" Name="Image1" Tag="sys-gal-thu" Sort="5" Size="12486" />
        <ImgGal Id="53099144" Name="Image1" Tag="sys-gal-thu" Sort="6" Size="14240" />
        <ImgGal Id="53099145" Name="Image1" Tag="sys-gal-thu" Sort="7" Size="7019" />
        <ImgGal Id="53099146" Name="Image1" Tag="sys-gal-thu" Sort="8" Size="9174" />
        <ImgGal Id="53099147" Name="Image1" Tag="sys-gal-thu" Sort="9" Size="3782" />
        <ImgGal Id="53099148" Name="Image1" Tag="sys-gal-thu" Sort="10" Size="4006" />
        <ImgGal Id="53099149" Name="Image1" Tag="sys-gal-thu" Sort="11" Size="3555" />
        <ImgGal Id="53099150" Name="Image1" Tag="sys-gal-thu" Sort="12" Size="15306" />
    </StoItem>
</Result>
```

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

Viz úvod sekce [Katalog exportů](#5-katalog-exportů) — `StoItemQtyFree` je tam použit
jako ukázka všech tří variant výstupu (atributy, `_El`, `_Schema`) včetně URL volání.

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

**`resultType`:** `SPresentTree` · `SPresentTree_El` · `SPresentTree_Schema`

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

**`resultType`:** `DocTrInv` · `DocTrInv_El` · `DocTrInv_Schema`

##### Filtrování a rozsah

| Volání                | Chování                                                                                  |
|-----------------------|-------------------------------------------------------------------------------------------|
| `GetResultByCode`     | `code` = číslo faktury (`InvCode`, např. `CRDC120009`)                                    |
| `GetResultByFromTo`   | `from`/`to` filtruje dle data pořízení faktury (`InvC`) i dle posledního potvrzeného DL (`DelDateConf`) |
| `GetResult` (bez param.) | Vrací pouze faktury pořízené za **poslední ~1–2 dny** (`InvC >= dnes − 1`)             |

> Export je vždy **omezen na firmu přihlášeného partnera** (`InvComId`) a vrací jen
> **dokončené, neinterní** faktury (`InvState = 1`, `InvInt = 0`). Partner tak vidí jen své doklady.

##### Příklad:

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=FV26092791&resultType=DocTrInv`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <Invoice Id="8272021" Code="FV26092791" CodeO="26092791" SymCon="0008" Tag="AUTO" OrdId="6936129" OrdCode="OP26106050" OrdCodeO="4500565843" OrdC="2026-07-01T11:18:00" Type="73" DateAcc="2026-07-01T00:00:00" DateDue="2026-09-29T00:00:00" CurCode="CZK" Val="44310.9300" ValCur="44310.9300" ValRnd="0.0000" ValRndCur="0.0000" ValPaid="0.0000" ValPaidCur="0.0000" C="2026-07-01T12:08:00">
        <DocTaxSum Id="22299964" TaxRate="21.0000" Base="36620.6000" ValTax="7690.3300" BaseCur="36620.6000" ValTaxCur="7690.3300" />
        <InvItem Id="45450960" StiId="514671" StiCode="777806" StiCode2="KABCT1K30" StiPartNo="CB-DP-HDMI-3" StiEAN="8594125009847" StiEAN2="" StiName="C-TECH Kabel DisplayPort/HDMI, 3m, černý" OrdId="6936129" OrdCode="OP26106050" OrdCodeO="4500565843" OriC="2026-07-01T11:18:00" Qty="3.000" TaxRate="21.0000" Prc="160.0000" PrcTax="33.6000" CurCode="CZK" PrcCur="160.0000" PrcTaxCur="33.6000" PrcRefCur="0.1000" RefCode="5-32-4" RefProCode="REM" PrcRefCur2="0.0000" RefCode2="9.99" RefProCode2="AFcz" />
        <InvItem Id="45450961" StiId="674126" StiCode="GMB00027" StiPartNo="CC-DP-HDMI-6" StiPartNo2="8716309082082" StiEAN="8716309082082" StiEAN2="" StiName="GEMBIRD Kabel DisplayPort na HDMI, M/M, 1,8m" OrdId="6936129" OrdCode="OP26106050" OrdCodeO="4500565843" OriC="2026-07-01T11:18:00" Qty="10.000" TaxRate="21.0000" Prc="64.0000" PrcTax="13.4400" CurCode="CZK" PrcCur="64.0000" PrcTaxCur="13.4400" PrcRefCur="0.1000" RefCode="5.84.(P)" RefProCode="ASE" PrcRefCur2="0.0000" RefCode2="9.99" RefProCode2="AFcz" />
        <InvItem Id="45450962" StiId="695888" StiCode="LNM01353" StiPartNo="40BF0100EU" StiPartNo2="40BF0100EU" StiEAN="0195892132486" StiEAN2="" StiName="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" OrdId="6936129" OrdCode="OP26106050" OrdCodeO="4500565843" OriC="2026-07-01T11:18:00" Qty="10.000" TaxRate="21.0000" Prc="3549.1700" PrcTax="745.3300" CurCode="CZK" PrcCur="3549.1700" PrcTaxCur="745.3300" PrcRefCur="0.7600" RefCode="5.55." RefProCode="ASE" PrcRefCur2="0.0000" RefCode2="9.99" RefProCode2="AFcz" />
        <InvItem Id="45450963" StiId="81640" StiCode="RECFEE" StiEAN="" StiEAN2="" StiName="Recyklační příspěvek" Qty="1.000" TaxRate="21.0000" Prc="0.3000" PrcTax="0.0600" CurCode="CZK" PrcCur="0.3000" PrcTaxCur="0.0600" RefIs="1" />
        <InvItem Id="45450964" StiId="176570" StiCode="RECFEEAS" StiEAN="" StiEAN2="" StiName="Recyklační příspěvek ASEKOL" Qty="1.000" TaxRate="21.0000" Prc="8.6000" PrcTax="1.8100" CurCode="CZK" PrcCur="8.6000" PrcTaxCur="1.8100" RefIs="1" />
        <Warranty Id="97240435" Qty="10.000" StiId="674126" StiCode="GMB00027" Dur="744" />
        <Warranty Id="97240445" Qty="1.000" SerialNo="SYEU0225E" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240446" Qty="1.000" SerialNo="SYEU02291" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240447" Qty="1.000" SerialNo="SYEU0222Y" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240448" Qty="1.000" SerialNo="SYEU0221T" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240449" Qty="1.000" SerialNo="SYEU0221X" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240450" Qty="1.000" SerialNo="SYEU022FZ" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240451" Qty="1.000" SerialNo="SYEU02236" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240452" Qty="1.000" SerialNo="SYEU0223C" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240453" Qty="1.000" SerialNo="SYEU022CA" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240454" Qty="1.000" SerialNo="SYEU022BT" StiId="695888" StiCode="LNM01353" Dur="1116" />
        <Warranty Id="97240566" Qty="3.000" StiId="514671" StiCode="777806" Dur="744" />
        <Delivery Id="9794587" Code="DV26128360" OrdId="6936129" OrdCode="OP26106050" CstId="244945" CstName="HPTronic Zlín, spol. s r.o." CstNameAdd="OD Prior Zlín" CstNameAdd2="IT oddělení" CstStreet="náměstí Práce 2523" CstCity="Zlín" CstPostCode="76001" CstCouName="Česká republika" />
        <Order Id="6936129" Code="OP26106050" CodeO="4500565843" C="2026-07-01T11:18:00" OrwName="Internetem" CstId="244945" CstName="HPTronic Zlín, spol. s r.o." CstNameAdd="OD Prior Zlín" CstNameAdd2="IT oddělení" CstStreet="náměstí Práce 2523" CstCity="Zlín" CstPostCode="76001" CstCouName="Česká republika" />
    </Invoice>
</Result>
```

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

**`resultType`:** `CpsStiVal` · `CpsStiVal_El` · `CpsStiVal_Schema`

> **Doporučení k použití:** Export je primárně určen k **filtrování podle kódu produktu**
> (`GetResultByCode`). Přes `GetResult` vrací parametry všech produktů — může jít o velký objem dat.

##### Příklad:

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=TCL00117&resultType=CpsStiVal`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <Row Id="21133925" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="79" Code="PUP" Grp="NTB" Name="Počet USB portů (NTB, TV)" NameAdd="Porty" Single="1" Ord="1000" Value="1" ValueAdd="1" Measure="1.0000" />
    <Row Id="21133926" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="198" Code="Vyr" Grp="TVZ" Name="Výrobce (TV)" Single="1" Value="TCL" />
    <Row Id="21133933" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="661" Code="VES" Grp="MON" Name="Podpora VESA (monitory, TV)" Single="1" Ord="200" Value="Ano" Measure="1.0000" />
    <Row Id="21133934" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="730" Code="OST" Grp="TVZ" Name="Operační systém (TV)" Single="1" Value="Google TV" />
    <Row Id="21133935" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="731" Code="OBR" Grp="TVZ" Name="Tvar obrazovky (TV)" Single="1" Value="Rovná" />
    <Row Id="21133936" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="732" Code="TNR" Grp="TVZ" Name="Typ tuneru" Value="DVB-T2" />
    <Row Id="21133937" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="732" Code="TNR" Grp="TVZ" Name="Typ tuneru" Value="DVB-S2" />
    <Row Id="21133938" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="732" Code="TNR" Grp="TVZ" Name="Typ tuneru" Value="DVB-C" />
    <Row Id="21133939" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="733" Code="DLN" Grp="TVZ" Name="Podpora DLNA (TV)" Single="1" Value="Ano" Measure="1.0000" />
    <Row Id="21133940" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="734" Code="WIF" Grp="TVZ" Name="Wi-Fi (TV)" Single="1" Value="Ano" Measure="1.0000" />
    <Row Id="21133941" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="735" Code="ETH" Grp="TVZ" Name="Ethernet LAN (TV)" Single="1" Value="Ano" Measure="1.0000" />
    <Row Id="21133943" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="737" Code="TEU" Grp="TVZ" Name="Třída energetické účinnosti (TV)" Single="1" Value="F" />
    <Row Id="21133944" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="738" Code="P3D" Grp="TVZ" Name="Podpora 3D (TV)" Single="1" Value="Ne" Measure="2.0000" />
    <Row Id="21133945" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="739" Code="BVR" Grp="TVZ" Name="Barva rámečku (TV)" Single="1" Value="Šedá" />
    <Row Id="21133946" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="741" Code="FRQ" Grp="TVZ" Name="Frekvence panelu (TV)" Single="1" Value="288 Hz" Measure="288.0000" />
    <Row Id="21133947" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="742" Code="VRP" Grp="TVZ" Name="Výkon reproduktorů (TV)" Single="1" Value="2x10 W + 20W" />
    <Row Id="21133948" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="743" Code="CIS" Grp="TVZ" Name="CI/CI+ slot (TV)" Single="1" Value="CI+" />
    <Row Id="21133949" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="847" Code="RUH" Grp="TVZ" Name="Úhlopříčka (TV)" Single="1" Value="65&quot;" Measure="650.0000" />
    <Row Id="21133950" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="1116" Code="AA2" Grp="TVZ" Name="Apple Airplay 2" Single="1" Value="Ano" Measure="1.0000" />
    <Row Id="21133951" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="1117" Code="PHR" Grp="TVZ" Name="Podpora HDR" Value="Dolby Vision IQ" />
    <Row Id="21133952" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="1118" Code="HFc" Grp="TVZ" Name="Herní funkce" Value="AMD FreeSync Premium Pro" />
    <Row Id="21133953" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="1119" Code="TTV" Grp="TVZ" Name="Technologie (TV)" Single="1" Value="LED (Mini LED podsvícení)" />
    <Row Id="21133954" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="1120" Code="RTV" Grp="TVZ" Name="Rozlišení (TV)" Single="1" Value="3840x2160 (UHD)" Measure="38402160.0000" />
    <Row Id="21133955" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="1132" Code="HTV" Grp="TVZ" Name="Hotelový mód (TV)" Single="1" Value="Ne" Measure="2.0000" />
    <Row Id="21133959" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="10184" Code="HDM" Grp="MON" Name="HDMI počet (monitory, TV)" Single="1" Ord="70" Value="4" Measure="4.0000" />
    <Row Id="21625513" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" CpaId="1207" Code="GSR" Name="GPSR" Single="1" Value="TCL EUROPE SAS;15 rue Rouget de Lisle,Issy-les-Moulineaux,92130,France;CZsupport@tcl.com,+420 225 341 059" />
</Result>
```

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

**`resultType`:** `AttSti` · `AttSti_El` · `AttSti_Schema`

Podporuje stejnou sadu prefixů jako `StoItemPriceOrd` (viz [Formát požadavku](#3-formát-požadavku)):
bez prefixu `StiCode`, dále `{StiId}`, `{PartNo}`, `{PartNo2}`, `{CodeEAN}`, `{ManName}`, `{CodeAll}`.
Více hodnot lze oddělit tabulátorem (`\t`).

##### Sestavení URL přílohy

Pole `Url` je vráceno **hotové**, ale vzniká dvěma způsoby podle typu přílohy:

- **Externí příloha** (`AttUrl` obsahuje `://`) → `Url` = přímo externí odkaz.
- **Interní příloha** (soubor v i6) → `Url` = `UrlBaseImgGalery` + `Id`
  (tj. `…/img.asp?attid=‹Id›`). Klient tedy může použít `Url` přímo bez skládání.

##### Příklad:

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=TCL00117&resultType=AttSti`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <AttSti Id="53098456" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_1A.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098456" Size="37866" Sort="1" />
    <AttSti Id="53098457" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_2.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098457" Size="54590" Sort="2" />
    <AttSti Id="53098458" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_3.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098458" Size="54279" Sort="3" />
    <AttSti Id="53098459" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_5.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098459" Size="31121" Sort="4" />
    <AttSti Id="53098460" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_6.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098460" Size="35862" Sort="5" />
    <AttSti Id="53098461" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_7.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098461" Size="43787" Sort="6" />
    <AttSti Id="53098462" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_8.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098462" Size="34645" Sort="7" />
    <AttSti Id="53098463" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_9.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098463" Size="50589" Sort="8" />
    <AttSti Id="53098464" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_10.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098464" Size="8323" Sort="9" />
    <AttSti Id="53098465" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_11.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098465" Size="8246" Sort="10" />
    <AttSti Id="53098466" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_12.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098466" Size="5792" Sort="11" />
    <AttSti Id="53098470" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-enl" File="TCL_65_Q6C_4.jpg" Url="https://terminal.sws.cz/img.asp?attid=53098470" Size="39502" Sort="12" />
    <AttSti Id="53099123" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Thumbnail" Tag="sys-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099123" Size="2197" />
    <AttSti Id="53099139" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099139" Size="8767" Sort="1" />
    <AttSti Id="53099140" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099140" Size="26486" Sort="2" />
    <AttSti Id="53099141" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099141" Size="26191" Sort="3" />
    <AttSti Id="53099142" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099142" Size="6463" Sort="4" />
    <AttSti Id="53099143" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099143" Size="12486" Sort="5" />
    <AttSti Id="53099144" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099144" Size="14240" Sort="6" />
    <AttSti Id="53099145" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099145" Size="7019" Sort="7" />
    <AttSti Id="53099146" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099146" Size="9174" Sort="8" />
    <AttSti Id="53099147" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099147" Size="3782" Sort="9" />
    <AttSti Id="53099148" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099148" Size="4006" Sort="10" />
    <AttSti Id="53099149" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099149" Size="3555" Sort="11" />
    <AttSti Id="53099150" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Name="Image1" Tag="sys-gal-thu" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099150" Size="15306" Sort="12" />
    <AttSti Id="53099166" StiId="673242" StiCode="TCL00117" StiPartNo="65Q6C" StiPartNo2="5901292526665" StiEAN="5901292526665" StiEAN2="" Tag="sys-thu-big" File="TCL00117.jpg" Url="https://terminal.sws.cz/img.asp?attid=53099166" Size="20461" />
</Result>
```

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

**`resultType`:** `CpsSti` · `CpsSti_El` · `CpsSti_Schema`

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

##### Příklad:

`https://terminal.sws.cz/i6ws/default.asmx/GetResult?resultType=CpsSti`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <ConPar>
        <Row Id="74" Type="0" Single="1" Code="Bch" Grp="NTB" Ord="1000" Name="TPM chip (NTB)" AddName="Funkce" />
        <Row Id="75" Type="0" Single="1" Code="Sop" Grp="NTB" Ord="1000" Name="Snímač otisku prstu (NTB)" AddName="Funkce" />
        <Row Id="76" Type="0" Single="1" Code="THD" Grp="NTB" Ord="60" Name="Typ disku (NTB)" AddName="Disk" />
        <Row Id="77" Type="0" Single="1" Code="Pza" Grp="NTB" Ord="1000" Name="Polohovací zařízení (NTB)" />
        <Row Id="79" Type="0" Single="1" Code="PUP" Grp="NTB" Ord="1000" Name="Počet USB portů (NTB, TV)" AddName="Porty" />
        <Row Id="81" Type="0" Single="1" Code="ReP" Grp="NTB" Ord="80" Name="Replikátor portů (NTB)" AddName="Porty" />
        <Row Id="82" Type="0" Single="1" Code="Opm" Grp="NTB" Ord="1000" Name="Optická mechanika (NTB)" AddName="Funkce" />
        <Row Id="94" Type="0" Single="1" Code="Pis" Grp="MED" Ord="0" Name="Přepisovatelné (média)" />
        <Row Id="98" Type="0" Single="1" Code="Tec" Grp="MED" Ord="0" Name="Technologie (média)" />
        <Row Id="99" Type="0" Single="1" Code="Pri" Grp="NSt" Ord="0" Name="Připojení (NAS Storage)" />
        <Row Id="102" Type="0" Single="1" Code="Sto" Grp="NSt" Ord="0" Name="Možnost rozšíření (NAS Storage)" />
...
<ConParValue>
        <Row Id="291" Measure="0.0000" Code="THD" Value="SSD" />
        <Row Id="293" Measure="0.0000" Code="Pza" Value="Touchpad" />
        <Row Id="295" Measure="0.0000" Code="Pza" Value="Touchpad+trackpoint" />
        <Row Id="296" Measure="0.0000" Value="DVD±RW" />
        <Row Id="297" Measure="0.0000" Value="Blu-ray" />

...
<ConParRange>
        <Row Id="191" CpaId="10018" CpvId="10116" />
        <Row Id="196" CpaId="10018" CpvId="10710" />
        <Row Id="203" CpaId="10022" CpvId="10145" />
        <Row Id="211" CpaId="10023" CpvId="10149" />

...
<ConParSet>
        <Row Id="201505" StiId="44661" CpaId="10037" CpvId="10216" StiCode="501217" Value="Epson" />
        <Row Id="201506" StiId="44661" CpaId="10040" CpvId="10251" StiCode="501217" Value="Jehličková" />
        <Row Id="201507" StiId="44661" CpaId="10043" CpvId="10247" StiCode="501217" Value="A4" Measure="2.0000" />
        <Row Id="201509" StiId="44661" CpaId="10047" CpvId="10250" StiCode="501217" Value="Ne" Measure="2.0000" />
        <Row Id="201511" StiId="44661" CpaId="10048" CpvId="10250" StiCode="501217" Value="Ne" Measure="2.0000" />
        <Row Id="201513" StiId="44661" CpaId="10045" CpvId="10250" StiCode="501217" Value="Ne" Measure="2.0000" />
...

        <Row Id="5897" StrId="17940" CpaId="1208" StrSort="0008N9124" />
        <Row Id="5898" StrId="16514" CpaId="1208" StrSort="0008N96CO" />
        <Row Id="5899" StrId="49" CpaId="1208" StrSort="0008N9AL4" />
        <Row Id="5906" StrId="17940" CpaId="1214" StrSort="0008N9124" />
        <Row Id="5907" StrId="16514" CpaId="1214" StrSort="0008N96CO" />
        <Row Id="5908" StrId="49" CpaId="1214" StrSort="0008N9AL4" />
    </ConParStr>
</Result>
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
