> **⚠️ Document version 0.5**  
> The document is not finished; this is a working draft. Places marked `‹…›` and **TODO** need to be filled in with real values (URLs, credentials, sample responses). Assumptions are explicitly flagged in the text.

---

# WebService – Product API

> **Purpose of this document:** A complete description of the SWS/I6 (CyberSoft) WebService
> for the purposes of handover and integration under ALSO. The document covers the architecture,
> authentication, request and response formats, naming conventions, and the full catalog of
> available exports.

---

## Contents

- [1. Overview](#1-overview)
- [2. Base URL](#2-base-url)
- [3. Request format](#3-request-format)
  - [3.1 Reading data – Default.asmx](#31-reading-data--defaultasmx)
  - [3.2 Authentication](#32-authentication)
  - [3.3 Writing data – Order.asmx](#33-writing-data--orderasmx)
- [4. Comparison with the ALSO Product API](#4-comparison-with-the-also-product-api)
- [5. Export catalog](#5-export-catalog)
  - [5.1 Most-used exports](#51-most-used-exports)
  - [5.2 Examples of the most-used exports](#52-examples-of-the-most-used-exports)
    - [5.2.1 StoItemBase](#521-stoitembase)
    - [5.2.2 StoItemQtyFree](#522-stoitemqtyfree)
    - [5.2.3 StoItemSiv](#523-stoitemsiv)
    - [5.2.4 SPresentTree](#524-spresenttree)
    - [5.2.5 DocTrInv](#525-doctrinv)
    - [5.2.6 StoItemPriceOrd](#526-stoitempriceord)
    - [5.2.7 CpsStiVal](#527-cpsstival)
    - [5.2.8 AttSti](#528-attsti)
    - [5.2.9 CpsSti](#529-cpssti)
- [6. Special exports](#6-special-export)
---

## 1. Overview

The SWS WebService gives partners machine access to the data of the **I6 ERP system (CyberSoft)**.
It covers product information (StoItem), stock levels, prices, images, attributes, presentation
trees (categories), documents (invoices, delivery notes), and orders.

The service is built as an **ASP.NET Web Service (`.asmx`)** and is operated as the application
directory `/i6ws/` on the distributor's eShop. The service can be communicated with using the
**SOAP** protocol; for methods with simple parameters (exports) also via **HTTP GET/POST** – exports
can therefore be downloaded with a plain link (URL).

## 2. Base URL

The web service is operated as the application directory `/i6ws/` on the distributor's eShop:

| Country | Base URL                              |
|---------|---------------------------------------|
| CZ      | `https://terminal.sws.cz/i6ws/`       |
| CZ      | `https://www.sws.cz/i6ws/`            |
| SK      | `https://www.swsi.sk/i6ws/`           |
| SK      | `https://www.alsotechnology.sk/i6ws/` |

**Main endpoints:**

| Endpoint                | Purpose                                                                                        |
|-------------------------|-----------------------------------------------------------------------------------------------|
| `Default.asmx`          | Universal data reading (exports) – methods `GetResult` (for all products), `GetResultByCode` (for a single product), `GetResultByFromTo` |
| `Order.asmx`            | Creating and managing orders – method `Create`                                                 |
| `ResultTypeInfo.ashx`   | Overview of all available exports with descriptions and schemas                                |




---

## 3. Request format

### 3.1 Reading data – `Default.asmx`

Three methods are available, all accessible via HTTP GET (and SOAP).

```
GET https://USER:PASSWORD@HOST/i6ws/Default.asmx/GetResult?resultType=‹RESULT_TYPE›
GET https://USER:PASSWORD@HOST/i6ws/Default.asmx/GetResultByCode?resultType=‹RESULT_TYPE›&code=‹CODE›
GET https://USER:PASSWORD@HOST/i6ws/Default.asmx/GetResultByFromTo?resultType=‹RESULT_TYPE›&from=‹FROM›&to=‹TO›
```

| Method              | Description                                                                                         | Parameters                 |
|---------------------|----------------------------------------------------------------------------------------------------|----------------------------|
| `GetResult`         | Returns the complete export (all products, everything in stock, etc.)                               | `resultType`               |
| `GetResultByCode`   | Filters the export by code – returns a single record for the given product                          | `resultType`, `code`       |
| `GetResultByFromTo` | Filters the export by from/to date – typically by the recorded change of the record                 | `resultType`, `from`, `to` |



##### GetResultByFromTo usage statistics over the last 30 days

| CodePrefix   | Requests | Used by companies | Note |
|--------------|----------|--------------------|------|
| DocTrInv     | 11909    | 18                 | Invoice |
| Order        | 8629     | 2                  | Order |
| DocTrExp     | 1398     | 3                  |  |
| DocTrDel     | 643      | 3                  | Delivery note |
| StoItemBase  | 243      | 6                  | Detailed product description. Not sure why they use it here, probably a mistake. |
| X-Cybex      | 175      | 1                  | **TODO** |
| CpsStiVal    | 58       | 3                  | Product parameters |


GetResultByFromTo is used for downloading documents for a given period. Better statistics on OneDrive.



**Parameters:**

| Parameter    | Type        | Required                  | Description                                                                                 |
|--------------|-------------|---------------------------|---------------------------------------------------------------------------------------------|
| `resultType` | String      | Yes                       | Export name, e.g. `StoItemBase` (see catalog below)                                         |
| `code`       | String      | For `GetResultByCode`     | Filter – product code, tree IdP, condition… Prefix `{PartNo}` = search by PartNo            |
| `from`       | String/Date | For `GetResultByFromTo`   | Start of range – format `YYYY-MM-DD` or `YYYY-MM-DD HH:MM:SS`                                |
| `to`         | String/Date | For `GetResultByFromTo`   | End of range                                                                                 |

> **Note on the `code` parameter:** Searching by PartNo is activated with the `{PartNo}` prefix:
> ```
> GetResultByCode?resultType=StoItemQtyFree&code={PartNo}600623
> ```


##### Filtering via `GetResultByCode` — `code` prefixes

This export supports **extended searching** by code type. A prefix at the start of the `code`
parameter determines which field is filtered on (no prefix = main code `StiCode`):

| Prefix       | Filters by                                                | Example                          |
|--------------|-----------------------------------------------------------|----------------------------------|
| *(none)*     | Main stock code (`StiCode`)                               | `code=0320663`                   |
| `{StiId}`    | Internal product ID                                       | `code={StiId}685699`             |
| `{PartNo}`   | Part number                                               | `code={PartNo}GU605CX-QR149`     |
| `{PartNo2}`  | Second part number                                        | `code={PartNo2}90NR0M65-M007X0`  |
| `{CodeEAN}`  | EAN                                                       | `code={CodeEAN}4711636262347`    |
| `{ManName}`  | Manufacturer name (category of type `MAN`)                | `code={ManName}ASUS`             |
| `{CodeAll}`  | Any recorded product code (`StoItemCode`)                 | `code={CodeAll}...`              |


##### Usage statistics over the last 30 days

| CodePrefix | Requests | Used by companies |
|------------|----------|--------------------|
| PartNo     | 1104     | 2                  |
| ManName    | 120      | 1                  |



> **Bulk query:** Multiple values separated by a tab (`\t`) can be inserted into `code` — records for
> all of them are returned. The prefix is stated once at the start and applies to the whole batch.


##### Usage statistics over the last 30 days

| `\t` | Requests | Used by companies |
|------------|----------|--------------------|
|  `\t`    | 22053     | 14                  |



### 3.2 Authentication

Access is tied to the **partner's account** (the same credentials as for the distributor's eShop) and
uses **HTTP Basic authentication**. Credentials can be passed in two ways:

- **Via HTTP header** `Authorization: Basic ‹base64(user:password)›` — recommended for integrations,
- **Directly in the URL** — `https://USER:PASSWORD@HOST/i6ws/…` (see the examples in section 3.1);
  suitable for quick testing in a browser or a script.

The account's permissions also determine the **scope of returned data** — product visibility, price
levels (`PriceFullIs`, see `StoItemPriceOrd`), and the restriction of documents to the partner's own
company (see `DocTrInv`).

> **TODO:** add the procedure for setting up access and test credentials `‹…›`.

### 3.3 Writing data – `Order.asmx`

Order creation happens through the `Order.asmx` endpoint (method `Create`). The description is out of
scope for this document — see the separate document [orders.md](orders.md).

---

## 4. Comparison with the ALSO Product API

The ALSO Product API offers 7 methods. Below is a mapping of which SWS exports cover the same
functionality.

| # | ALSO Product API method | Description (ALSO)                                        | Corresponding SWS export(s)                                     | Note                                                                  |
|---|-------------------------|-----------------------------------------------------------|-----------------------------------------------------------------|-----------------------------------------------------------------------|
| 1 | `AllProducts`           | Basic info about all products available in the e-shop     | `StoItemBase`                                                    | SWS returns prices, stock, and images (only `Id`; the URL is composed from `UrlBase*`) in a single export. |
| 2 | `AllOfflineProducts`    | Products in the partner's catalog that are not online     | —                                                               | **TODO** — no direct equivalent `‹verify›`                            |
| 3 | `ProductFullInfo`       | Complete product detail – description, attributes, images, prices | `StoItemBase` + `CpsSti`/`CpsStiVal` + `AttSti`         | SWS requires a combination of several exports for the same result     |
| 4 | `ProductNow`            | Current stock, price, and availability for one product    | `StoItemSiv`, or availability and price separately: `StoItemQtyFree` + `StoItemPriceOrdCur` | Called via `GetResultByCode` with the product code                    |
| 5 | `AllProductsNow`        | Stock, price, and availability for all products           | `StoItemSiv`, or availability and price separately: `StoItemQtyFree` + `StoItemPriceOrdCur` | Called via `GetResult` for all products                               |
| 6 | `ProductImages`         | Available product images                                  | `StoItemBase` or `AttSti`                                       | SWS returns URLs composed from `UrlBase*` + `Id`; types distinguished by a tag |
| 7 | `Categories`            | Complete e-shop category hierarchy                        | `SPresentTree`, `SCategorySys`                                  | SWS uses a flat list with parent ID and a sort key (3 chars per level) |

---

## 5. Export catalog

Each export exists in three variants — they differ only in the suffix of `resultType`:

| Suffix    | Description                            | Example |
|-----------|----------------------------------------|---------|
| *(none)*  | Data as XML attributes — more compact  | name    |
| `_El`     | Data as XML elements — more readable   | name_El |
| `_Schema` | XSD schema of the export               | name_Schema |

**Example — the same data, three variants (`StoItemQtyFree`):**

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree`

```xml
<!-- Attributes (default) -->
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="685699" Code="ASC00511" PartNo="GU605CX-QR149" PartNo2="90NR0M65-M007X0" EAN="4711636262347" EAN2="" QtyFree="2" />
</Result>
```

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree_El`

```xml
<!-- Elements (_El) -->
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
<!-- Schema (_Schema) — definition of all fields and their data types -->
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

### 5.1 Most-used exports

| #  | ResultType          | No. of companies | Description                                                 |
|----|---------------------|-----------------:|-------------------------------------------------------------|
| 1  | `StoItemBase`       | 130              | Complete product catalog                                    |
| 2  | `StoItemQtyFree`    | 104              | Current free quantity in stock                              |
| 3  | `StoItemSiv`        | 57               | Purchase price and stock status                             |
| 4  | `SPresentTree`      | 56               | Hierarchical tree of product categories                     |
| 5  | `DocTrInv`          | 51               | Invoices                                                    |
| 6  | `StoItemPriceOrd`   | 36               | Purchase price                                              |
| 7  | `CpsStiVal`         | 27               | Product attributes including parameter definitions          |
| 8  | `StiRelation`       | 19               | Relationships between products (accessories, alternatives)  |
| 9  | `StoItemBase_El`    | 18               | Complete product catalog — output as XML elements           |
| 10 | `AttSti`            | 16               | Product attachments (images, documents)                     |
| 11 | `CpsSti`            | 16               | Product parameters                                          |
| 12 | `StoItemQtyFree_El` | 16               | Current free quantity in stock — output as XML elements     |
| 13 | `StrStiSync`        | 12               | Product tree synchronization                                |

---

### 5.2 Examples of the most-used exports

> **Type legend** (applies to all field tables below): `i2`/`i4`/`i8` = integer (16/32/64 bit) · `ui1` = byte (0–255) ·
> `fixed.14.4` / `number` / `money` = decimal number · `string` = text · `boolean` = 0/1.

#### 5.2.1 StoItemBase

In a single call it returns product descriptions, prices, VAT, stock availability, logistics data,
and image information. Corresponds to the `AllProducts` method (or `ProductFullInfo`) of the ALSO
Product API.

**`resultType`:** `StoItemBase` · `StoItemBase_El` · `StoItemBase_Schema`

##### Example:

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

##### Attributes of the `Result` element (envelope, once per document)

| Field               | Type   | Description                                                           |
|---------------------|--------|-----------------------------------------------------------------------|
| `UrlBase`           | string | Base URL of the eshop/website                                        |
| `UrlBaseThumbnail`  | string | Base URL for thumbnails — final URL = `UrlBaseThumbnail` + `StoItem.Id` |
| `UrlBaseImg`        | string | Base URL for images — final URL = `UrlBaseImg` + `StoItem.Id`         |
| `UrlBaseEnlargement`| string | Base URL for enlargements                                            |
| `UrlBaseImgGalery`  | string | Base URL for gallery images — combined with `ImgGal.Id`              |
| `CouCode`           | string | Default country code                                                 |
| `TaxRateLow`        | ui1    | Low VAT rate (%)                                                      |
| `TaxRateHigh`       | ui1    | Standard/high VAT rate (%)                                            |
| `Void`              | string | `‹verify›` (reserved/empty attribute)                               |

##### Attributes of the `StoItem` element

| Field           | Type        | Description                                                                |
|-----------------|-------------|----------------------------------------------------------------------------|
| `Id`            | i4          | Internal product ID in i6                                                  |
| `Code`          | string      | Main SWS stock code (e.g. `ASC00511`)                                      |
| `Code2`         | string      | Alternative/second code `‹verify›`                                         |
| `PartNo`        | string      | Manufacturer's catalog (part) number                                      |
| `PartNo2`       | string      | Second manufacturer part/order number                                     |
| `EAN`           | string      | EAN                                                                        |
| `EAN2`          | string      | Second EAN                                                                 |
| `Name`          | string      | Product name                                                              |
| `NameAdd`       | string      | Name supplement (extending text) `‹verify›`                               |
| `NameE`         | string      | Name in English                                                           |
| `NameDoc`       | string      | Name used on documents                                                    |
| `NameShort`     | string      | Shortened name                                                            |
| `NameSeo`       | string      | SEO name (for URLs / search engines)                                      |
| `ManName`       | string      | Manufacturer name                                                        |
| `CouCode`       | string      | Country of origin code                                                    |
| `UrlExt`        | string      | External URL (e.g. product page at the manufacturer) `‹verify›`          |
| `PriceEU`       | fixed.14.4  | MSRP, list price                                                          |
| `PriceB2CMin`   | fixed.14.4  | Minimum B2C selling price (MAP)                                           |
| `PriceDea`      | fixed.14.4  | Dealer price                                                              |
| `PriceOrd`      | fixed.14.4  | Order (purchase) price                                                    |
| `PriceRef`      | fixed.14.4  | Copyright fee                                                             |
| `PriceRefInfo`  | fixed.14.4  | Informational value of the reference fee `‹verify›`                       |
| `RefProName`    | string      | Reference product name `‹verify›`                                         |
| `RefCode`       | string      | Reference product code `‹verify›`                                         |
| `PriceRef2`     | fixed.14.4  | Recycling fee `‹verify›`                                                  |
| `PriceRef2Info` | fixed.14.4  | Informational value of the second ref. fee `‹verify›`                     |
| `RefProName2`   | string      | Name of the second reference product `‹verify›`                          |
| `RefCode2`      | string      | Code of the second reference product `‹verify›`                          |
| `WeightRef`     | number      | Reference weight (for fee calculation?) `‹verify›`                        |
| `MeasureRef2`   | number      | Reference measure/quantity `‹verify›`                                     |
| `TaxRate`       | fixed.14.4  | Product VAT rate (%)                                                       |
| `TatCodeE`      | string      | `‹verify›`                                                                |
| `CutCode`       | string      | `‹verify — customs tariff / code?›`                                       |
| `QtyFreeIs`     | boolean     | Flag whether the available quantity is recorded/valid                     |
| `QtyFree`       | i4          | Free (available) quantity in stock                                        |
| `QtyPack`       | number      | Quantity per pack (carton)                                                |
| `WarDur`        | i4          | Warranty length (months)                                                  |
| `WarDurEU`      | i4          | Warranty length for the end customer / EU (months) `‹verify›`             |
| `SNTrack`       | ui1         | Serial number tracking (0 = no / tracking type)                          |
| `NonDivQty`     | number      | Non-divisible (minimum order) quantity `‹verify›`                        |
| `Weight`        | number      | Weight (kg)                                                               |
| `XXL`           | boolean     | Oversized goods                                                           |
| `XXS`           | boolean     | `‹verify›`                                                                |
| `ScaId`         | i4          | `‹verify›`                                                                |
| `ThumbnailIs`   | boolean     | Thumbnail exists                                                          |
| `ThumbnailSize` | i8          | Thumbnail size (B)                                                        |
| `ImgIs`         | boolean     | Main image exists                                                         |
| `ImgSize`       | i8          | Main image size (B)                                                       |
| `EnlargementIs` | boolean     | Enlargement exists                                                        |
| `EnlargementSize`| i8         | Enlargement size (B)                                                      |
| `SisName`       | string      | `‹verify›`                                                                |
| `SitId`         | ui1         | `‹verify›`                                                                |
| `NonMater`      | ui1         | Non-material product flag (service/license/ESD)? `‹verify›`              |
| `SttId`         | ui1         | `‹verify›`                                                                |
| `NoteShort`     | string      | Short note                                                                |
| `StiDemIdDis`   | string      | `‹verify›`                                                                |
| `EprelId`       | i4          | Record ID in the EU EPREL database (energy labels)                       |
| `Note`          | string      | Note (longer text)                                                        |

##### Nested `ImgGal` elements (image gallery, 0..N per product)

| Field   | Type   | Description                                                     |
|---------|--------|----------------------------------------------------------------|
| `Id`    | i4     | Gallery image ID; URL = `UrlBaseImgGalery` + `Id`             |
| `Name`  | string | Image name/file                                                |
| `Tag`   | string | Image type/tag (distinguishes the kind of image)               |
| `Sort`  | i2     | Display order                                                  |
| `Size`  | i8     | Image size (B)                                                 |

#### 5.2.2 StoItemQtyFree

Returns only the product identification and the free quantity — without prices, names, or images.
Suitable for frequent stock queries (smaller data volume than `StoItemBase`). Corresponds to the
`AllProductsNow` / `ProductNow` method of the ALSO Product API.

**`resultType`:** `StoItemQtyFree` · `StoItemQtyFree_El` · `StoItemQtyFree_Schema`

##### Example:

See the introduction of the [Export catalog](#5-export-catalog) section — `StoItemQtyFree` is used
there as an example of all three output variants (attributes, `_El`, `_Schema`), including the call URL.

##### Attributes of the `StoItem` element

| Field       | Type    | Description                                                  |
|-------------|---------|-------------------------------------------------------------|
| `Id`        | i4      | Internal product ID in i6                                   |
| `Code`      | string  | Main SWS stock code (e.g. `ASC00511`)                       |
| `Code2`     | string  | Alternative/second code `‹verify›`                         |
| `PartNo`    | string  | Manufacturer's catalog (part) number                       |
| `PartNo2`   | string  | Second manufacturer part/order number                      |
| `EAN`       | string  | EAN                                                         |
| `EAN2`      | string  | Second EAN                                                  |
| `QtyFreeIs` | boolean | Flag                                                        |
| `QtyFree`   | i4      | Free (available) quantity in stock                         |

#### 5.2.3 StoItemSiv

A combined availability-and-price export — it returns stock, order price, and basic identification
plus logistics data in a single call, without the image gallery and extended names. A compromise
between the lightweight `StoItemQtyFree` and the full `StoItemBase`. Corresponds to the `ProductNow`
method (via `GetResultByCode`) or `AllProductsNow` (via `GetResult`) of the ALSO Product API — it
covers both availability and price in a single export.

**`resultType`:** `StoItemSiv` · `StoItemSiv_El` · `StoItemSiv_Schema`

##### Example:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=">
    <StoItem Id="230726" Code="578307" Code2="ZB0788" PartNo="A76/01B" EAN="8711500802521" EAN2="4895229106093" Name="Philips baterie knoflíková A76, alkalická - 1ks (LR44)" ManName="Philips" SiuCode="ks" UrlSuffix="230726" UrlExt="http://www.consumer.philips.com/c/zvlastni-baterie/alkalicke-a76_01b/prd/cz/" QtyFree="9" PriceEU="28.1000" PriceOrd="11.5000" PriceRef="0.0000" PriceRef2="0.0000" WarDur="744" ImgSize="16384" CutCode="85065030" Weight="0.00400" />
</Result>
```

##### Attributes of the `Result` element (envelope)

| Field        | Type   | Description                                                        |
|--------------|--------|--------------------------------------------------------------------|
| `UrlBase`    | string | Base URL of the eshop/website                                     |
| `UrlBaseImg` | string | Base URL for the main image — final URL = `UrlBaseImg` + `StoItem.Id` |
| `Void`       | string | `‹verify›` (reserved/empty attribute)                             |

##### Attributes of the `StoItem` element

| Field           | Type        | Description                                                      |
|-----------------|-------------|------------------------------------------------------------------|
| `Id`            | i4          | Internal product ID in i6; used to build the image URL           |
| `Code`          | string      | Main SWS stock code                                              |
| `Code2`         | string      | Alternative/second code `‹verify›`                              |
| `PartNo`        | string      | Manufacturer's catalog (part) number                            |
| `PartNo2`       | string      | Second manufacturer part/order number                           |
| `EAN`           | string      | EAN (barcode)                                                    |
| `EAN2`          | string      | Second EAN                                                       |
| `Name`          | string      | Product name                                                    |
| `ManName`       | string      | Manufacturer name                                              |
| `SisName`       | string      | `‹verify›`                                                      |
| `SiuCode`       | string      | `‹verify — unit-of-measure code (pcs/pack)?›`                   |
| `UrlSuffix`     | string      | Suffix appended to `UrlBase` (completes the product URL) `‹verify›` |
| `UrlExt`        | string      | External URL `‹verify›`                                         |
| `QtyFreeIs`     | boolean     | Flag whether the available quantity is recorded/valid           |
| `QtyFree`       | i4          | Free (available) quantity in stock                             |
| `PriceEU`       | fixed.14.4  | `‹verify — end/recommended price (MSRP)?›`                      |
| `PriceOrd`      | fixed.14.4  | Order (purchase) price                                         |
| `PriceRef`      | fixed.14.4  | Price of the linked reference fee (recycling/copyright?) `‹verify›` |
| `PriceRefInfo`  | fixed.14.4  | Informational value of the reference fee `‹verify›`            |
| `PriceRef2`     | fixed.14.4  | Price of the second reference fee `‹verify›`                    |
| `PriceRef2Info` | fixed.14.4  | Informational value of the second ref. fee `‹verify›`          |
| `WarDur`        | i4          | Warranty length (months)                                       |
| `ImgSize`       | i8          | Main image size (B); 0 = no image                              |
| `SitId`         | ui1         | `‹verify›`                                                      |
| `NonMater`      | ui1         | Non-material product flag (service/license/ESD)? `‹verify›`     |
| `CutCode`       | string      | `‹verify — customs tariff / code?›`                            |
| `Weight`        | number      | Weight (kg)                                                    |
| `XXL`           | boolean     | Oversized goods                                                |
| `XXS`           | boolean     | `‹verify›`                                                      |

#### 5.2.4 SPresentTree

Export of the presentation (category) tree. It returns a **flat list of tree nodes**, where the
hierarchy is reconstructed on the client side from the sort key — **each level has 3 reserved
characters** (`AAA` = level 1, `AAABBB` = level 2, etc.). The parent relationship is carried by `IdP`
(empty = root node). Top-level nodes correspond to *tree types* (price-list trees), and their `Id` is
derived as a negative value (`-2147483648 + type`). Corresponds to the `Categories` method of the ALSO
Product API.

Thanks to `FOR XML AUTO`, the structure is **two-level**: a `SPresentTree` node contains 0..N nested
`StoItem` elements — i.e. the products placed directly in that node. Categories without products that
also have no product beneath them (at any sub-level) are removed from the output.

**`resultType`:** `SPresentTree` · `SPresentTree_El` · `SPresentTree_Schema`

**Filtering via `GetResultByCode`:** the `code` parameter = `IdP` (node ID) — returns the given
subbranch of the tree. A negative `code` filters by *tree type*.

##### Example:

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

##### Attributes of the `Result` element (envelope)

| Field        | Type   | Description                                                                  |
|--------------|--------|-----------------------------------------------------------------------------|
| `UrlBase`    | string | Base URL of the category; final URL = `UrlBase` + `SPresentTree.Id` (link `…default.asp?cls=spresenttrees&strid=`) |
| `UrlBaseImg` | string | Base URL of the product image; final URL = `UrlBaseImg` + `StoItem.Id` (or `Code`) |
| `Void`       | string | Reserved empty attribute (always NULL)                                      |

##### `SPresentTree` element (tree node / category)

| Field     | Type   | Description                                                                   |
|-----------|--------|-------------------------------------------------------------------------------|
| `Id`      | i4     | Node ID (`StrId`). For top-level tree types it is derived as `-2147483648 + type` |
| `IdP`     | i4     | Parent node ID; empty/NULL = root level                                       |
| `Sort`    | string | Sort key for ordering and hierarchy reconstruction — 3 chars per nesting level |
| `Name`    | string | Category name (localized — the language applied per the logged-in partner)    |
| `Tag`     | string | Optional node label/tag (only if filled in)                                  |
| `ImgSize` | i8     | Category image size in B (only if an image is present)                        |
| `NameSEO` | string | SEO category name (for URLs / search engines)                                |
| `Note`    | string | Note on the node                                                             |
| `NameAdd` | string | Supplementary name / extending text                                          |
| `StrWWW`  | string | Custom WWW link of the category (if set)                                     |

##### Nested `StoItem` element (products in the node, 0..N)

| Field  | Type   | Description                                              |
|--------|--------|----------------------------------------------------------|
| `Id`   | i4     | Internal product ID (`StiId`); for building the image URL |
| `Code` | string | Product stock code (`StiCode`)                          |

> **Content note:** Only products that pass the standard WebService visibility filters (product
> stock/sale flags, partner row-level permissions) enter the output. The set of products may
> therefore differ between partners depending on their permissions.

#### 5.2.5 DocTrInv

Invoice transfer format — **"Document Transfer – Invoice"**, per the export definition intended for
**import into another I6 instance** (inter-system document exchange). It returns the complete invoice
including the VAT recapitulation, line items, serial numbers (warranties), linked delivery notes, and
the order including end-customer details in the case of dropshipment.

Unlike the product exports, it uses **`FOR XML EXPLICIT`** — the output is therefore strictly
**hierarchical** (nested elements with attributes), not a flat list:

```
Result
└── Invoice (invoice – header)
    ├── DocTaxSum   (VAT recapitulation – 0..N)
    ├── InvItem     (invoice line items – 0..N)
    ├── Warranty    (serial numbers / warranties – 0..N)
    ├── Delivery    (delivery notes – 0..N)
    └── Order       (order + dropshipment end customer – 0..N)
```

**`resultType`:** `DocTrInv` · `DocTrInv_El` · `DocTrInv_Schema`

##### Filtering and scope

| Call                     | Behavior                                                                                   |
|--------------------------|--------------------------------------------------------------------------------------------|
| `GetResultByCode`        | `code` = invoice number (`InvCode`, e.g. `CRDC120009`)                                     |
| `GetResultByFromTo`      | `from`/`to` filters by invoice creation date (`InvC`) and by the last confirmed DN (`DelDateConf`) |
| `GetResult` (no params.) | Returns only invoices created in the **last ~1–2 days** (`InvC >= today − 1`)              |

> The export is always **restricted to the logged-in partner's company** (`InvComId`) and returns only
> **completed, non-internal** invoices (`InvState = 1`, `InvInt = 0`). A partner thus sees only their own documents.

##### Example:

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

##### `Invoice` element (invoice header)

| Attribute     | Type        | Description                                                               |
|---------------|-------------|---------------------------------------------------------------------------|
| `Id`          | i4          | Internal invoice ID (`InvId`)                                             |
| `Code`        | string      | Invoice number                                                           |
| `ZCode`       | string      | Invoice number for the dropship/end customer (only if present) `‹verify›` |
| `CodeO`       | string      | External invoice number (number at the customer, only if present)        |
| `SymCon`      | string      | Payment matching/variable symbol `‹verify›`                              |
| `Tag`         | string      | Invoice label/flag (only if present)                                     |
| `OrdId`       | i4          | ID of the linked order                                                    |
| `OrdCode`     | string      | Number of the linked order                                               |
| `OrdCodeO`    | string      | External order number                                                    |
| `OrdC`        | datetime    | Order creation date                                                      |
| `Type`        | —           | Invoice type (code list; e.g. invoice/credit note) `‹verify values›`     |
| `DateAcc`     | date        | Accounting/taxable supply date (DUZP) `‹verify›`                         |
| `DateDue`     | date        | Due date                                                                 |
| `CurCode`     | string      | Currency code (ISO, `UsdCodeE`)                                          |
| `Val`         | fixed.14.4  | Total value in home currency                                            |
| `ValCur`      | fixed.14.4  | Total value in invoice currency                                        |
| `ValRnd`      | fixed.14.4  | Rounding (home currency)                                                |
| `ValRndCur`   | fixed.14.4  | Rounding (invoice currency)                                             |
| `ValPaid`     | fixed.14.4  | Paid (home currency)                                                    |
| `ValPaidCur`  | fixed.14.4  | Paid (invoice currency)                                                 |
| `ZVal`        | fixed.14.4  | Value for the end customer (dropship) `‹verify›`                         |
| `C`           | datetime    | Invoice creation date (created)                                          |
| `IdC`         | i4          | ID of the related invoice (for a credit note, the original invoice)      |
| `CodeC`       | string      | Number of the related invoice (for a credit note, the original invoice)  |

##### `DocTaxSum` element (VAT recapitulation, 0..N)

| Attribute   | Type        | Description                                   |
|-------------|-------------|-----------------------------------------------|
| `Id`        | i4          | Recapitulation line ID (`DtsId`)             |
| `TaxRate`   | fixed.14.4  | VAT rate (%)                                  |
| `Base`      | fixed.14.4  | Tax base (home currency)                     |
| `ValTax`    | fixed.14.4  | Tax amount (home currency)                   |
| `BaseCur`   | fixed.14.4  | Tax base (invoice currency)                  |
| `ValTaxCur` | fixed.14.4  | Tax amount (invoice currency)                |

##### `InvItem` element (invoice line items, 0..N)

| Attribute     | Type        | Description                                                             |
|---------------|-------------|-------------------------------------------------------------------------|
| `Id`          | i4          | Invoice item ID (`IniId`)                                               |
| `StiId`       | i4          | Product ID                                                             |
| `StiCode`     | string      | Product stock code                                                     |
| `StiCode2`    | string      | Alternative product code                                              |
| `StiPartNo`   | string      | Part number                                                           |
| `StiPartNo2`  | string      | Second part number                                                   |
| `StiEAN`      | string      | EAN (populated per the partner's `WsEAN` parameter, otherwise empty)  |
| `StiEAN2`     | string      | Second EAN                                                            |
| `StiName`     | string      | Product name (stock)                                                  |
| `Name`        | string      | Name on the invoice item (custom item text, only if present)          |
| `OrdId`       | i4          | Order ID of the item                                                  |
| `OrdCode`     | string      | Order number of the item                                             |
| `OrdCodeO`    | string      | External order number of the item                                    |
| `OriC`        | datetime    | Order item creation date                                             |
| `Qty`         | number      | Quantity                                                              |
| `TaxRate`     | fixed.14.4  | Item VAT rate (%)                                                     |
| `Prc`         | fixed.14.4  | Unit price excl. VAT (home currency)                                  |
| `PrcTax`      | fixed.14.4  | Unit price incl. VAT (home currency)                                 |
| `CurCode`     | string      | Item currency code                                                   |
| `PrcCur`      | fixed.14.4  | Price excl. VAT (invoice currency)                                   |
| `PrcTaxCur`   | fixed.14.4  | Price incl. VAT (invoice currency)                                   |
| `PrcRefCur`   | fixed.14.4  | Recycling fee (invoice currency)                                     |
| `RefCode`     | string      | Recycling fee code                                                   |
| `RefProCode`  | string      | Recycling fee product code                                          |
| `PrcRefCur2`  | fixed.14.4  | Second recycling fee (invoice currency)                             |
| `RefCode2`    | string      | Second recycling fee code                                           |
| `RefProCode2` | string      | Product code of the second fee                                     |
| `ZPrc`        | fixed.14.4  | Price excl. VAT for the end customer (dropship)                     |
| `ZPrcTax`     | fixed.14.4  | Price incl. VAT for the end customer                               |
| `ZPrcRef`     | fixed.14.4  | Recycling fee – dropship                                           |
| `ZPrcRef2`    | fixed.14.4  | Second recycling fee – dropship                                   |
| `RefIs`       | boolean     | Flag that the line **is** a recycling fee (not a product)         |

##### `Warranty` element (serial numbers / warranties, 0..N)

| Attribute  | Type   | Description                                                 |
|------------|--------|-------------------------------------------------------------|
| `Id`       | i4     | Warranty ID (`WarId`)                                       |
| `Qty`      | number | Quantity for the given serial number                       |
| `SerialNo` | string | Serial number (only for SN-tracked products)               |
| `StiId`    | i4     | Product ID                                                 |
| `StiCode`  | string | Product stock code                                         |
| `Dur`      | i4     | Warranty length (days; `NULL` = not specified)             |

##### `Delivery` element (delivery notes, 0..N)

| Attribute     | Type   | Description                                                      |
|---------------|--------|------------------------------------------------------------------|
| `Id`          | i4     | Delivery note ID (`DelId`)                                       |
| `Code`        | string | Delivery note number                                            |
| `ZCode`       | string | DN number for dropship (only if present)                        |
| `OrdId`       | i4     | Order ID                                                        |
| `OrdCode`     | string | Order number                                                   |
| `CstId`       | i4     | Delivery address ID; if delivered to the company HQ = `-ComId`  |
| `CstName`     | string | Delivery address name (otherwise the customer's company name)  |
| `CstNameAdd`  | string | Name supplement                                                |
| `CstNameAdd2` | string | Second name supplement                                         |
| `CstStreet`   | string | Street                                                         |
| `CstCity`     | string | City                                                           |
| `CstPostCode` | string | Postal code                                                   |
| `CstCouName`  | string | Country                                                       |

##### `Order` element (order + dropshipment end customer, 0..N)

The `Cst*` address = the order's delivery address. The **`ZCm*` / `ZCst*`** prefix = the details of the
**end customer** in direct dropshipment (where goods are delivered in the partner's name).

| Attribute      | Type     | Description                                                     |
|----------------|----------|-----------------------------------------------------------------|
| `Id`           | i4       | Order ID (`OrdId`)                                              |
| `Code`         | string   | Order number                                                   |
| `CodeO`        | string   | External order number (from the customer)                     |
| `Tag`          | string   | Order label                                                   |
| `NoteExt`      | string   | External note on the order                                    |
| `C`            | datetime | Order creation date                                          |
| `OrwName`      | string   | Order status / processing method `‹verify›`                   |
| `CstId`        | i4       | Order delivery address ID (`-ComId` = company HQ)             |
| `CstName`      | string   | Delivery address name                                        |
| `CstNameAdd`   | string   | Name supplement                                              |
| `CstNameAdd2`  | string   | Second name supplement                                       |
| `CstStreet`    | string   | Street                                                       |
| `CstCity`      | string   | City                                                         |
| `CstPostCode`  | string   | Postal code                                                 |
| `CstCouName`   | string   | Country                                                     |
| `ZDirect`      | —        | Direct dropshipment flag (shipment straight to the end customer) |
| `ZIPrn`        | —        | Flag to print the invoice into the shipment `‹verify›`        |
| `ZDPrn`        | —        | Flag to print the delivery note into the shipment `‹verify›`  |
| `ZCmId`        | i4       | End customer ID (dropship)                                   |
| `ZCmRegId`     | string   | End customer's company registration number (IČO)            |
| `ZCmTaxNum`    | string   | End customer's VAT number (DIČ)                              |
| `ZCmName`      | string   | End customer's name                                         |
| `ZCmNameAdd`   | string   | Name supplement                                            |
| `ZCmStreet`    | string   | Street                                                     |
| `ZCmCity`      | string   | City                                                       |
| `ZCmPostCode`  | string   | Postal code                                               |
| `ZCmTitle`     | string   | Salutation / title                                        |
| `ZCmFName`     | string   | First name                                                |
| `ZCmLName`     | string   | Last name                                                 |
| `ZCmTel`       | string   | Phone                                                     |
| `ZCmTelMob`    | string   | Mobile                                                    |
| `ZCmFax`       | string   | Fax                                                       |
| `ZCmEMail`     | string   | E-mail                                                    |
| `ZCstName`     | string   | Dropship delivery address – name (if it differs from `ZCm*`) |
| `ZCstNameAdd`  | string   | Name supplement                                            |
| `ZCstNameAdd2` | string   | Second name supplement                                    |
| `ZCstStreet`   | string   | Street                                                    |
| `ZCstCity`     | string   | City                                                      |
| `ZCstPostCode` | string   | Postal code                                              |
| `ZCstCouName`  | string   | Country                                                  |

#### 5.2.6 StoItemPriceOrd

A price export — the partner's **order (purchase) prices**. It returns the order price, reference
(recycling and copyright) fees, and the VAT rate. Per the export definition.

It covers the price part of the `ProductNow` / `AllProductsNow` methods of the ALSO Product API
(availability is handled by `StoItemQtyFree`).

**`resultType`:** `StoItemPriceOrd` · `StoItemPriceOrd_El` · `StoItemPriceOrd_Schema`








##### Example:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="685699" Code="ASC00511" PartNo="GU605CX-QR149" PartNo2="90NR0M65-M007X0" EAN="4711636262347" PriceOrd="81144.2200" PriceEU="90900.8300" PriceRef="11.3400" PriceRef2="33.0000" TaxRate="21.0000" />
</Result>
```

##### Attributes of the `StoItem` element

| Field          | Type       | Description                                                                       |
|----------------|------------|----------------------------------------------------------------------------------|
| `Id`           | i4         | Internal product ID (`StiId`)                                                    |
| `Code`         | string     | Main SWS stock code                                                              |
| `Code2`        | string     | Alternative/second code                                                          |
| `PartNo`       | string     | Part (catalog) number                                                            |
| `PartNo2`      | string     | Second part number                                                               |
| `EAN`          | string     | EAN                                                                              |
| `EAN2`         | string     | Second EAN                                                                       |
| `PriceOrd`     | money      | **Order (purchase) price** of the partner — the main price of this export        |
| `PriceEU`      | money      | End/recommended price (converted to the partner's currency, if set) `‹verify meaning – MSRP?›` |
| `PriceRef`     | money      | Recycling fee linked to the product                                             |
| `PriceRefInfo` | money      | Informational value of the recycling fee                                        |
| `PriceRef2`    | money      | Second recycling fee                                                             |
| `PriceRef2Info`| money      | Informational value of the second fee                                           |
| `TaxRate`      | fixed.14.4 | VAT rate (%); in the cross-border regime recalculated per the destination country (`TaxMeCouId`) |
| `PriceFullIs`  | boolean    | Flag that the partner is authorized to see the full set of fixed prices (`Price*`) |
| `PriceList`    | money      | List (fixed) price — **only with special permission**, otherwise empty          |
| `Price0`       | money      | Fixed price level 0 — only with special permission                              |
| `Price1`       | money      | Fixed price level 1 — only with special permission                              |
| `Price2`       | money      | Fixed price level 2 — only with special permission                              |
| `Price3`       | money      | Fixed price level 3 — only with special permission                              |
| `Price4`       | money      | Fixed price level 4 — only with special permission                              |
| `Price5`       | money      | Fixed price level 5 — only with special permission                              |
| `PriceB2CMin`  | money      | Minimum B2C selling price (MAP), converted to the partner's currency            |

##### Notes on prices

- Prices are returned only for products with a **positive order price** (`PriceOrd > 0`).
- Depending on the partner's setting (`WsPriceCur`), prices may be converted to their **currency** at the
  current exchange rate; in that case `PriceEU` and `PriceB2CMin` are converted to the same currency.
- `PriceFullIs = 1` signals that the `PriceList`/`Price0–5` fields are available (subject to permission).
  Without permission these fields are empty even when `PriceFullIs = 0`.

> **Note for ALSO:** A standard partner receives `PriceOrd`, `PriceRef*`, `TaxRate`, and `PriceB2CMin`;
> the `PriceList`/`Price0–5` set is an add-on tied to special permission.

#### 5.2.7 CpsStiVal

Export of **product parameters (attributes)** — technical specifications in **name × value** format.
Per the export definition: *"Export parameters of StoItems – Name × Value only (filtered by Code of
StoItem)."* Each element corresponds to a single parameter of a single product; a product with N
parameters returns N elements. Together with `StoItemBase` it covers the `ProductFullInfo` method of
the ALSO Product API (the attribute part).

**`resultType`:** `CpsStiVal` · `CpsStiVal_El` · `CpsStiVal_Schema`

> **Usage recommendation:** The export is primarily intended for **filtering by product code**
> (`GetResultByCode`). Via `GetResult` it returns the parameters of all products — which may be a large
> volume of data.

##### Example:

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

##### Attributes of the `Row` element (one product parameter)

| Field        | Type   | Description                                                                    |
|--------------|--------|--------------------------------------------------------------------------------|
| `Id`         | i4     | ID of the specific parameter value for the product (`CpsId`) — the row's unique key |
| `StiId`      | i4     | Internal product ID                                                            |
| `StiCode`    | string | Main product stock code                                                        |
| `StiCode2`   | string | Alternative product code                                                       |
| `StiPartNo`  | string | Part number                                                                    |
| `StiPartNo2` | string | Second part number                                                             |
| `StiEAN`     | string | EAN (populated per the partner's `WsEAN` parameter, otherwise empty)           |
| `StiEAN2`    | string | Second EAN                                                                     |
| `CpaId`      | i4     | Parameter definition ID (shared by all products with the same parameter)       |
| `Code`       | string | Parameter code (`CpaCode`) — the machine identifier of the parameter            |
| `Grp`        | string | Parameter group (`CpaGrp`) for grouping into sections (only if filled in)       |
| `Name`       | string | Parameter name (localized) — e.g. "Diagonal", "Weight"                          |
| `NameAdd`    | string | Supplementary parameter description (only if present)                           |
| `Single`     | —      | Flag that the parameter has only one value (only if non-zero) `‹verify›`        |
| `Ord`        | i4     | Parameter order for sorting in the listing (only if non-zero)                  |
| `Value`      | string | **Parameter value** — either from the code list (`CpvValue`) or free text (`CpsTag`) |
| `ValueAdd`   | string | Supplementary value / note on the value (only if present)                       |
| `Measure`    | number | Unit of measure / numeric measure of the value (only if non-zero) `‹verify – unit vs. numeric value?›` |
| `CprOrd`     | i4     | Order of the value within the parameter's code list (only if non-zero)         |

#### 5.2.8 AttSti

Export of **product attachments** — images, datasheets, documentation, and other files linked to a
product. Each element = one attachment; a product with N attachments returns N elements. It covers the
`ProductImages` method of the ALSO Product API (and, generally, non-media attachments too, if they are
recorded for the product).

**`resultType`:** `AttSti` · `AttSti_El` · `AttSti_Schema`

It supports the same set of prefixes as `StoItemPriceOrd` (see [Request format](#3-request-format)):
without a prefix `StiCode`, plus `{StiId}`, `{PartNo}`, `{PartNo2}`, `{CodeEAN}`, `{ManName}`, `{CodeAll}`.
Multiple values can be separated by a tab (`\t`).

##### Building the attachment URL

The `Url` field is returned **ready-made**, but it is produced in two ways depending on the attachment type:

- **External attachment** (`AttUrl` contains `://`) → `Url` = the external link directly.
- **Internal attachment** (a file in i6) → `Url` = `UrlBaseImgGalery` + `Id`
  (i.e. `…/img.asp?attid=‹Id›`). The client can therefore use `Url` directly without composing it.

##### Example:

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

##### Attributes of the `AttSti` element (one attachment)

| Field        | Type   | Description                                                                  |
|--------------|--------|------------------------------------------------------------------------------|
| `Id`         | i4     | Attachment ID (`AttId`); also used to build the `Url` for internal attachments |
| `StiId`      | i4     | Internal product ID                                                          |
| `StiCode`    | string | Main product stock code                                                      |
| `StiCode2`   | string | Alternative product code                                                     |
| `StiPartNo`  | string | Part number                                                                  |
| `StiPartNo2` | string | Second part number                                                           |
| `StiEAN`     | string | EAN (populated per the partner's `WsEAN` parameter, otherwise empty)         |
| `StiEAN2`    | string | Second EAN                                                                   |
| `Name`       | string | Attachment name (only if filled in) — e.g. "Thumbnail", "Enlargement", a caption |
| `Tag`        | string | Attachment label/type (only if present) — distinguishes the kind of attachment `‹verify values›` |
| `File`       | string | Attachment file name (without path; the directory is stripped from `AttUrl`)  |
| `Url`        | string | **Ready-made attachment URL** — an external link, or the internal `…/img.asp?attid=‹Id›` |
| `Size`       | i8     | Attachment size in bytes (may be empty for external attachments)             |
| `Sort`       | i2     | Attachment order for sorting (only if non-zero)                             |

#### 5.2.9 CpsSti

Export of **product parameters including their definitions** — the normalized (relational) variant of
`CpsStiVal`. Per the export definition: *"Export parameters of StoItems include parameter's
definition."* Unlike `CpsStiVal`, which repeats the name and value on every row, `CpsSti` returns the
**parameter definitions and the value code list separately**, and the assignment to products merely
references them by ID. Suitable when the client wants to build its own parameter database (download the
definitions once; products reference them). Together with `StoItemBase` it covers the attribute part of
the `ProductFullInfo` method of the ALSO Product API.

**`resultType`:** `CpsSti` · `CpsSti_El` · `CpsSti_Schema`

> ⚠️ **`CpsStiVal` vs. `CpsSti`:** If you just need a plain list of "product → parameter → value",
> use **`CpsStiVal`** (simpler, flat). Use `CpsSti` only when you also need the **definition metadata**
> (types, code lists, language variants, links to categories).

##### Output structure

The output is **hierarchical** (`FOR XML EXPLICIT`). Under the `Result` root there are five separate
collections, each with `Row` elements distinguished by level:

```
Result
├── ConPar        → Row (parameter definitions)          [level 7]
├── ConParValue   → Row (value code list)                [level 8]
├── ConParRange   → Row (permitted values of a parameter)[level 9]
├── ConParSet     → Row (value assignments to products)  [level 10]
└── ConParStr     → Row (parameter-to-category links)    [level 11]
```

##### Example:

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

Client-side linking: `ConParSet.CpaId` → `ConPar.Id`, `ConParSet.CpvId` → `ConParValue.Id`;
`ConParRange` restricts which values (`CpvId`) belong to which parameter (`CpaId`); `ConParStr` maps a
parameter onto a presentation-tree node (see `SPresentTree`).

##### `ConPar` → `Row` — parameter definition

| Field     | Type   | Description                                                       |
|-----------|--------|-------------------------------------------------------------------|
| `Id`      | i4     | Parameter ID (`CpaId`)                                            |
| `Type`    | ui1    | Parameter type (`CpaType`; types 0 and 2 are returned) `‹verify values›` |
| `Single`  | —      | Flag that the parameter has a single value `‹verify›`            |
| `Code`    | string | Machine code of the parameter                                    |
| `Grp`     | string | Parameter group (for grouping into sections)                    |
| `Ord`     | i4     | Parameter order for sorting                                     |
| `Name`    | string | Parameter name (localized)                                      |
| `AddName` | string | Supplementary name (note: in the `Row!7!AddName` attribute = `CpaNameAdd`) |
| `NameE`   | string | Name in English                                                 |
| `NameAddE`| string | Supplementary name in English                                   |
| `Note`    | string | Note on the parameter                                           |

##### `ConParValue` → `Row` — code-list value

| Field      | Type   | Description                                              |
|------------|--------|----------------------------------------------------------|
| `Id`       | i4     | Value ID (`CpvId`)                                       |
| `Measure`  | number | Unit of measure / value measure `‹verify›`              |
| `Code`     | string | Machine code of the value                               |
| `Value`    | string | Value (localized)                                       |
| `ValueAdd` | string | Value supplement                                        |
| `ValueE`   | string | Value in English                                        |
| `ValueAddE`| string | Value supplement in English                             |

##### `ConParRange` → `Row` — permitted parameter value

| Field   | Type | Description                                       |
|---------|------|---------------------------------------------------|
| `Id`    | i4   | Link ID (`CprId`)                                 |
| `CpaId` | i4   | Parameter ID (`ConPar.Id`)                        |
| `CpvId` | i4   | Permitted value ID (`ConParValue.Id`)             |

##### `ConParSet` → `Row` — value assignment to a product

| Field     | Type   | Description                                                              |
|-----------|--------|--------------------------------------------------------------------------|
| `Id`      | i4     | Assignment ID (`CpsId`)                                                   |
| `StiId`   | i4     | Product ID                                                              |
| `CpaId`   | i4     | Parameter ID (`ConPar.Id`)                                              |
| `CpvId`   | i4     | Value ID from the code list (`ConParValue.Id`); empty = the value is free text |
| `StiCode` | string | Product stock code                                                      |
| `Value`   | string | Value — from the code list (`CpvValue`), or free text (`CpsTag`)         |
| `Measure` | number | Numeric measure of the value (only if non-zero) `‹verify›`             |

##### `ConParStr` → `Row` — parameter-to-category link

| Field     | Type   | Description                                                                  |
|-----------|--------|-----------------------------------------------------------------------------|
| `Id`      | i4     | Link ID (`CosId`)                                                           |
| `StrId`   | i4     | Presentation-tree node ID (`SPresentTree.Id`)                              |
| `CpaId`   | i4     | Parameter ID (`ConPar.Id`)                                                  |
| `StrSort` | string | Node sort key (3 chars/level) — determines the category the parameter is used with |

## 6. Special exports

### 6.1 Alza - export X-StoItemQtyFreeRealX

##### Example:
sample for a single product TCL00117

https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=TCL00117&resultType=X-StoItemQtyFreeRealX

```xml
<?xml version="1.0" encoding="utf-8"?>
<items>
    <item>
        <Pricing>
            <PriceWithFee>11607.6000</PriceWithFee>
            <PriceWithoutFee>11392.5000</PriceWithoutFee>
            <RecycleFee>215.1000</RecycleFee>
            <CopyrightFee>0.0000</CopyrightFee>
            <Currency>CZK</Currency>
        </Pricing>
        <Storage>
            <StoredQuantity>565</StoredQuantity>
        </Storage>
        <Product>
            <Name>TCL 65Q6C SMART TV 65" QLED/4K UHD/Mini LED/144Hz/4xHDMI/USB/LAN/GoogleTV</Name>
            <DealerCode>TCL00117</DealerCode>
            <PartNumber>65Q6C</PartNumber>
            <Ean>5901292526665</Ean>
        </Product>
    </item>
</items>
```

#####  Format required by Alza:



### 6.2 HP Tronik
