# WebService – Product API

> **Purpose of this document:** Description of the SWS/I6 (CyberSoft) WebService for the purposes
> of handover and integration under ALSO. The document covers the architecture, authentication,
> request and response formats, naming conventions, and a complete catalog of the available exports.

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
- [6. Special important exports](#6-special-important-exports)
  - [6.1 Alza – export X-StoItemQtyFreeRealX](#61-alza--export-x-stoitemqtyfreerealx)
  - [6.2 HP Tronic – export X-StoItemQtyFreeBOHPT](#62-hp-tronic--export-x-stoitemqtyfreebohpt)
- [7. OneDrive link with all materials](#7-onedrive-link-with-all-materials)
---

## 1. Overview

The SWS WebService gives partners machine access to the data of the **I6 ERP system (CyberSoft)**.
It covers product information (StoItem), stock levels, prices, images, attributes, presentation
trees (categories), documents (invoices, delivery notes), and orders.

The service is built as an **ASP.NET Web Service (`.asmx`)** and runs as the application directory
`/i6ws/` on the distributor's eShop. It can be accessed via the **SOAP** protocol; methods with
simple parameters (the exports) are also available via **HTTP GET/POST** — exports can therefore
be downloaded with a plain link (URL).




## 2. Base URL

The web service runs as the application directory `/i6ws/` on the distributor's eShop:

| Country | Base URL                              |
|---------|---------------------------------------|
| CZ      | `https://terminal.sws.cz/i6ws/`       |
| CZ      | `https://www.sws.cz/i6ws/`            |
| SK      | `https://www.swsi.sk/i6ws/`           |
| SK      | `https://www.alsotechnology.sk/i6ws/` |

**Main endpoints:**

| Endpoint                | Purpose                                                                                       |
|-------------------------|-----------------------------------------------------------------------------------------------|
| `Default.asmx`          | Universal data reading (exports) – methods `GetResult` (all products), `GetResultByCode` (a single product), `GetResultByFromTo` |
| `Order.asmx`            | Creating and managing orders – method `Create`                                                |
| `ResultTypeInfo.ashx`   | Overview of all available exports with descriptions and schemas                               |




---

## 3. Request format

### 3.1 Reading data – `Default.asmx`

Three methods are available, all accessible via HTTP GET (as well as SOAP).

```
GET https://USER:PASSWORD@HOST/i6ws/Default.asmx/GetResult?resultType=‹RESULT_TYPE›
GET https://USER:PASSWORD@HOST/i6ws/Default.asmx/GetResultByCode?resultType=‹RESULT_TYPE›&code=‹CODE›
GET https://USER:PASSWORD@HOST/i6ws/Default.asmx/GetResultByFromTo?resultType=‹RESULT_TYPE›&from=‹FROM›&to=‹TO›
```

| Method              | Description                                                                                        | Parameters                 |
|---------------------|----------------------------------------------------------------------------------------------------|----------------------------|
| `GetResult`         | Returns the complete export (all products, all items in stock, etc.)                               | `resultType`               |
| `GetResultByCode`   | Filters the export by code – returns a single record for the given product                          | `resultType`, `code`       |
| `GetResultByFromTo` | Filters the export by a from/to date range – typically by the recorded change date of the record    | `resultType`, `from`, `to` |



##### Usage statistics for GetResultByFromTo over the last 30 days

| CodePrefix   | Requests | Used by companies | Note |
|--------------|----------|--------------------|----------|
| DocTrInv     | 11909    | 18                 | Document Transfer – Invoice (format for import into I6). |
| Order        | 8629     | 2                  | Export of orders with items, including ShipTo and B2C information. |
| DocTrExp     | 1398     | 3                  | Document Transfer – Expedition (format for import into I6). |
| DocTrDel     | 643      | 3                  | Document Transfer – Delivery. |
| StoItemBase  | 243      | 6                  | Detailed product description. Unclear why partners use FromTo with this export — probably a mistake. |
| X-Cybex      | 175      | 1                  | Customized StoItemBase. Unclear why FromTo is used here — probably a mistake. |
| CpsStiVal    | 58       | 3                  | Product parameters. FromTo is not needed here either — probably a mistake. |


`GetResultByFromTo` is used to download documents for a given period from one I6 instance into
another. More detailed statistics are available on OneDrive in
[websevice_statistics.xlsx](https://also-my.sharepoint.com/:f:/p/michal_jurca/IgCI5I3cmva2R5Xrp_RlleESAeO7Vzqr02bFcOZ-G_LWXb8?e=4uyzDY).



**Parameters:**

| Parameter    | Type        | Required                  | Description                                                                                |
|--------------|-------------|---------------------------|--------------------------------------------------------------------------------------------|
| `resultType` | String      | Yes                       | Name of the export, e.g. `StoItemBase` (see the catalog below)                             |
| `code`       | String      | For `GetResultByCode`     | Filter – product code, tree node IdP, condition… Prefix `{PartNo}` = search by PartNo      |
| `from`       | String/Date | For `GetResultByFromTo`   | Start of the range – format `YYYY-MM-DD` or `YYYY-MM-DD HH:MM:SS`                          |
| `to`         | String/Date | For `GetResultByFromTo`   | End of the range                                                                           |

> **Note on the `code` parameter:** Searching by PartNo is activated with the `{PartNo}` prefix:
> ```
> GetResultByCode?resultType=StoItemQtyFree&code={PartNo}600623
> ```

##### Filtering via `GetResultByCode` — `code` prefixes

This export supports **extended lookup** by code type. A prefix at the beginning of the `code`
parameter determines which field is used for filtering (no prefix = the main code `StiCode`):

| Prefix       | Filters by                                                 | Example                          |
|--------------|-----------------------------------------------------------|----------------------------------|
| *(none)*     | Main stock code (`StiCode`)                                | `code=LNM01353`                  |
| `{StiId}`    | Internal product ID                                        | `code={StiId}695888`             |
| `{PartNo}`   | Manufacturer part number                                   | `code={PartNo}40BF0100EU`        |
| `{PartNo2}`  | Second manufacturer part number                            | `code={PartNo2}40BF0100EU`       |
| `{CodeEAN}`  | EAN                                                        | `code={CodeEAN}0195892132486`    |
| `{ManName}`  | Manufacturer name (category of type `MAN`)                 | `code={ManName}Lenovo`           |
| `{CodeAll}`  | Any recorded product code (`StoItemCode`)                  | `code={CodeAll}...`              |




##### Usage statistics over the last 30 days

| ExportType   | CodePrefix | Requests | Used by companies |
|--------------|------------|----------|--------------------|
| StoItemBase  | PartNo     | 1273     | 2                  |
| StoItemBase  | ManName    | 62       | 1                  |
| StiRelation  | ManName    | 62       | 1                  |



> **Batch query:** The `code` parameter can contain **multiple values separated by a tab
> character** (`\t`) — records for all of them are returned. The prefix is written once at the
> beginning and applies to the whole batch.


##### Usage statistics of batch queries (`\t`) over the last 30 days

| ExportType      | Requests | Used by companies |
|-----------------|----------|--------------------|
| StoItemBase     | 20545    | 12                 |
| StoItemSiv      | 761      | 1                  |
| StoItemPriceOrd | 714      | 1                  |




### 3.2 Authentication

Access is tied to a **partner account** (the same credentials as for the eShop) and uses
**HTTP Basic authentication**. Credentials can be passed in two ways:

- **HTTP header** `Authorization: Basic ‹base64(user:password)›` — recommended for integrations,
- **directly in the URL** — `https://USER:PASSWORD@HOST/i6ws/…` (see the examples in section 3.1);
  convenient for quick testing in a browser or a script.


### 3.3 Writing data – `Order.asmx`

Orders are created via the `Order.asmx` endpoint (method `Create`). Its description is outside
the scope of this document — see the separate document [orders.md](orders.md).

---

## 4. Comparison with the ALSO Product API

The ALSO Product API offers 7 methods. The table below shows which SWS exports cover the same
functionality.

| # | ALSO Product API method | Description (ALSO)                                        | Corresponding SWS export(s)                                     | Note                                                                  |
|---|-------------------------|-----------------------------------------------------------|-----------------------------------------------------------------|-----------------------------------------------------------------------|
| 1 | `AllProducts`           | Basic info about all products available in the e-shop     | `StoItemBase`                                  | SWS returns prices, stock and images (only `Id`; the URL is composed from `UrlBase*`) in a single export. |
| 2 | `AllOfflineProducts`    | Products in the partner's catalog that are not online     | —                                                               | **TODO** — no direct equivalent `‹verify›`                            |
| 3 | `ProductFullInfo`       | Complete product detail – description, attributes, images, prices | `StoItemBase` + `CpsSti`/`CpsStiVal` + `AttSti`         | SWS requires combining several exports for the same result            |
| 4 | `ProductNow`            | Current stock, price and availability for one product     | `StoItemSiv`, or availability and price separately: `StoItemQtyFree` + `StoItemPriceOrdCur` | Called via `GetResultByCode` with the product code                    |
| 5 | `AllProductsNow`        | Stock, price and availability for all products            | `StoItemSiv`, or availability and price separately: `StoItemQtyFree` + `StoItemPriceOrdCur` | Called via `GetResult` for all products                               |
| 6 | `ProductImages`         | Available product images                                  | `StoItemBase` or `AttSti`                                       | SWS returns URLs composed from `UrlBase*` + `Id`; types are distinguished by a tag |
| 7 | `Categories`            | Complete e-shop category hierarchy                        | `SPresentTree`, `SCategorySys`                                  | SWS uses a flat list with a parent ID and a sort key (3 characters per level) |

---

## 5. Export catalog

Every export exists in three variants — they differ only by the suffix in `resultType`:

| Suffix    | Description                              | Example |
|-----------|------------------------------------------|---------|
| *(none)*  | Data as XML attributes — more compact    | name |
| `_El`     | Data as XML elements — more readable     | name_El |
| `_Schema` | XSD schema of the export                 | name_Schema |

**Example — the same data in three variants (`StoItemQtyFree`):**

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=LNM01353&resultType=StoItemQtyFree`

```xml
<!-- Atributy (výchozí) -->
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" EAN2="" QtyFree="51" />
</Result>
```

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=LNM01353&resultType=StoItemQtyFree_El`

```xml
<!-- Elementy (_El) -->
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem>
        <Id>695888</Id>
        <Code>LNM01353</Code>
        <PartNo>40BF0100EU</PartNo>
        <PartNo2>40BF0100EU</PartNo2>
        <EAN>0195892132486</EAN>
        <EAN2>
    </EAN2>
        <QtyFree>51</QtyFree>
    </StoItem>
</Result>
```

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=LNM01353&resultType=StoItemQtyFree_Schema`

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

### 5.1 Most-used exports

| #  | ResultType          | Companies   | Description                                                  |
|----|---------------------|------------:|--------------------------------------------------------------|
| 1  | `StoItemBase`       | 130         | Complete product catalog                                     |
| 2  | `StoItemQtyFree`    | 104         | Current free stock quantity                                  |
| 3  | `StoItemSiv`        | 57          | Purchase price and stock availability                        |
| 4  | `SPresentTree`      | 56          | Hierarchical product category tree                           |
| 5  | `DocTrInv`          | 51          | Document Transfer – Invoice (format for import into I6). Invoices |
| 6  | `StoItemPriceOrd`   | 36          | Purchase price                                               |
| 7  | `CpsStiVal`         | 27          | Export of StoItem parameters – Name × Value only (filtered by StoItem code) |
| 8  | `StiRelation`       | 19          | Relations between products (accessories, alternatives). Export of StoItem relations |
| 9  | `StoItemBase_El`    | 18          | Complete product catalog — output as XML elements            |
| 10 | `AttSti`            | 16          | Product attachments (images, documents)                      |
| 11 | `CpsSti`            | 16          | Product parameters. Export of StoItem parameters including the parameter definitions |
| 12 | `StoItemQtyFree_El` | 16          | Current free stock quantity — output as XML elements         |
| 13 | `StrStiSync`        | 12          | Product tree synchronization. Export for synchronizing SPresentTree + StoItem. The `code` must be the ID of an SPresentTree node |


More detailed statistics are available on OneDrive in
[websevice_statistics.xlsx](https://also-my.sharepoint.com/:f:/p/michal_jurca/IgCI5I3cmva2R5Xrp_RlleESAeO7Vzqr02bFcOZ-G_LWXb8?e=4uyzDY).

---

### 5.2 Examples of the most-used exports

> **Type legend** (applies to all field tables below): `i2`/`i4`/`i8` = integer (16/32/64 bit) · `ui1` = byte (0–255) ·
> `fixed.14.4` / `number` / `money` = decimal number · `string` = text · `boolean` = 0/1.

#### 5.2.1 StoItemBase

Returns product descriptions, prices, VAT, stock availability, logistics data and image
information in a single call. Corresponds to the `AllProducts` (or `ProductFullInfo`) method
of the ALSO Product API.

**`resultType`:** `StoItemBase` · `StoItemBase_El` · `StoItemBase_Schema`

##### Example:

`https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?resultType=StoItemBase&code=LNM01353`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseThumbnail="https://terminal.sws.cz/img.asp?attname=thumbnail&amp;attpedid=52&amp;attsrcid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=" UrlBaseEnlargement="https://terminal.sws.cz/img.asp?attname=enlargement&amp;attpedid=52&amp;attsrcid=" UrlBaseImgGalery="https://terminal.sws.cz/img.asp?attid=" CouCode="CZ" TaxRateLow="12" TaxRateHigh="21">
    <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" NameE="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" ManName="Lenovo" CouCode="CN" UrlExt="https://psref.lenovo.com/accessory/40BF0100EU" PriceEU="4597.8200" PriceB2CMin="4597.8200" PriceDea="3539.2200" PriceOrd="3539.2200" PriceRef="0.7600" RefProName="ASEKOL" RefCode="5.55." PriceRef2="0.0000" RefProName2="Autorský fond CZ" RefCode2="9.99" WeightRef="0.54750" TaxRate="21.0000" CutCode="84718000" QtyFree="51" WarDur="1116" WarDurEU="1116" SNTrack="1" Weight="0.64000" ScaId="53" ThumbnailIs="1" ThumbnailSize="1322" ImgIs="1" ImgSize="14400" EnlargementIs="1" EnlargementSize="19826" SisName="Novinka" NoteShort="Popis produktu&#xD;&#xA;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstr" Note="Popis produktu&#xD;&#xA;Dokovací stanice Lenovo™ ThinkPad® USB4 Dock 5000 je navržena pro zvýšení každodenní produktivity. Jedná se o nástupce oblíbené Universal USB-C Dock, vybavený nejmodernější technologií USB4. Dok lze k notebooku připojit pomocí USB4 s upstream konektivitou o propustnosti 40 Gb/s, což umožňuje rozšířit konfiguraci monitorů o více pixelů a vyšší obnovovací frekvence.&#xD;&#xA;Dokovací stanice může dodávat 65 W napájení notebooku při použití 100W napájecího adaptéru, nebo lze použít 135W adaptér, který zvýší nabíjecí výkon až na 100 W pro notebook.&#xD;&#xA;&#xD;&#xA;Hlavní vlastnosti&#xD;&#xA;&#xD;&#xA;Dokovací stanice ThinkPad® USB4 Dock 5000 s nejnovější technologií USB4 nabízí až čtyřnásobný výkon konektivity oproti USB-C 3.2 Gen 2. Díky propustnosti až 40 Gb/s můžete připojit buď jeden monitor s ultravysokým rozlišením 8K při 60 Hz, nebo dva monitory 4K s obnovovací frekvencí 144 Hz. Snadno tak rozšíříte svůj notebook Lenovo na plnohodnotnou pracovní platformu s různými periferními zařízeními.&#xD;&#xA;Dok podporuje Power Delivery 3.1 a poskytuje až 100 W pro rychlé nabíjení notebooku, takže můžete jednoduše rozšířit možnosti svého pracovního prostoru.&#xD;&#xA;&#xD;&#xA;Dokovací stanice je navíc univerzálně kompatibilní s různými operačními systémy.">
        <ImgGal />
    </StoItem>
</Result>
```

##### Attributes of the `Result` element (envelope, once per document)

| Field               | Type   | Description                                                           |
|---------------------|--------|-----------------------------------------------------------------------|
| `UrlBase`           | string | Base URL of the eShop/website                                         |
| `UrlBaseThumbnail`  | string | Base URL for thumbnails — final URL = `UrlBaseThumbnail` + `StoItem.Id` |
| `UrlBaseImg`        | string | Base URL for images — final URL = `UrlBaseImg` + `StoItem.Id`         |
| `UrlBaseEnlargement`| string | Base URL for enlargements                                             |
| `UrlBaseImgGalery`  | string | Base URL for gallery images — combined with `ImgGal.Id`               |
| `CouCode`           | string | Default country code                                                  |
| `TaxRateLow`        | ui1    | Reduced VAT rate (%)                                                  |
| `TaxRateHigh`       | ui1    | Standard/high VAT rate (%)                                            |
| `Void`              | string | `‹verify›` (reserved/empty attribute)                                 |

##### Attributes of the `StoItem` element

| Field           | Type        | Description                                                                |
|-----------------|-------------|----------------------------------------------------------------------------|
| `Id`            | i4          | Internal product ID in I6                                                  |
| `Code`          | string      | Main SWS stock code (e.g. `LNM01353`)                                      |
| `Code2`         | string      | Alternative/second code `‹verify›`                                         |
| `PartNo`        | string      | Manufacturer catalog (part) number                                         |
| `PartNo2`       | string      | Second manufacturer part/order number                                      |
| `EAN`           | string      | EAN                                                                        |
| `EAN2`          | string      | Second EAN                                                                 |
| `Name`          | string      | Product name                                                               |
| `NameAdd`       | string      | Name addition (extending text) `‹verify›`                                  |
| `NameE`         | string      | Name in English                                                            |
| `NameDoc`       | string      | Name used on documents                                                     |
| `NameShort`     | string      | Short name                                                                 |
| `NameSeo`       | string      | SEO name (for URLs / search engines)                                       |
| `ManName`       | string      | Manufacturer name                                                          |
| `CouCode`       | string      | Country-of-origin code                                                     |
| `UrlExt`        | string      | External URL (e.g. product page on the manufacturer's site)                |
| `PriceEU`       | fixed.14.4  | MSRP, list price                                                           |
| `PriceB2CMin`   | fixed.14.4  | Minimum B2C selling price (MAP)                                            |
| `PriceDea`      | fixed.14.4  | Dealer price                                                               |
| `PriceOrd`      | fixed.14.4  | Order (purchase) price                                                     |
| `PriceRef`      | fixed.14.4  | Recycling fee                                                              |
| `PriceRefInfo`  | fixed.14.4  | Informative value of the recycling fee                                     |
| `RefProName`    | string      | Name of the reference product `‹verify›`                                   |
| `RefCode`       | string      | Code of the reference product `‹verify›`                                   |
| `PriceRef2`     | fixed.14.4  | Copyright fee                                                              |
| `PriceRef2Info` | fixed.14.4  | Informative value of the copyright fee                                     |
| `RefProName2`   | string      | Name of the second reference product `‹verify›`                            |
| `RefCode2`      | string      | Code of the second reference product `‹verify›`                            |
| `WeightRef`     | number      | Reference weight (for fee calculation?) `‹verify›`                         |
| `MeasureRef2`   | number      | Reference measure/quantity `‹verify›`                                      |
| `TaxRate`       | fixed.14.4  | VAT rate of the product (%)                                                |
| `TatCodeE`      | string      | `‹verify›`                                                                 |
| `CutCode`       | string      | Customs tariff code                                                        |
| `QtyFreeIs`     | boolean     | Flag whether the available quantity is tracked/valid                       |
| `QtyFree`       | i4          | Free (available) quantity in stock                                         |
| `QtyPack`       | number      | Quantity per package (carton)                                              |
| `WarDur`        | i4          | Warranty length (months)                                                   |
| `WarDurEU`      | i4          | Warranty length for the end customer / EU (months) `‹verify›`              |
| `SNTrack`       | ui1         | Serial number tracking (0 = no / type of tracking)                         |
| `NonDivQty`     | number      | Non-divisible (minimum order) quantity `‹verify›`                          |
| `Weight`        | number      | Weight (kg)                                                                |
| `XXL`           | boolean     | Oversized goods                                                            |
| `ScaId`         | i4          | `‹verify›`                                                                 |
| `ThumbnailIs`   | boolean     | Thumbnail exists                                                           |
| `ThumbnailSize` | i8          | Thumbnail size (B)                                                         |
| `ImgIs`         | boolean     | Main image exists                                                          |
| `ImgSize`       | i8          | Main image size (B)                                                        |
| `EnlargementIs` | boolean     | Enlargement exists                                                         |
| `EnlargementSize`| i8         | Enlargement size (B)                                                       |
| `SisName`       | string      | `‹verify›`                                                                 |
| `SitId`         | ui1         | `‹verify›`                                                                 |
| `NonMater`      | ui1         | Flag for non-material product (service/license/ESD)? `‹verify›`            |
| `SttId`         | ui1         | `‹verify›`                                                                 |
| `NoteShort`     | string      | Short note                                                                 |
| `StiDemIdDis`   | string      | `‹verify›`                                                                 |
| `EprelId`       | i4          | Record ID in the EU EPREL database (energy labels)                         |
| `Note`          | string      | Note (longer text)                                                         |

##### Nested `ImgGal` elements (image gallery, 0..N per product)

| Field   | Type   | Description                                                    |
|---------|--------|----------------------------------------------------------------|
| `Id`    | i4     | Gallery image ID; URL = `UrlBaseImgGalery` + `Id`              |
| `Name`  | string | Image name/file                                                |
| `Tag`   | string | Image type/label (distinguishes the kind of image)             |
| `Sort`  | i2     | Display order                                                  |
| `Size`  | i8     | Image size (B)                                                 |

#### 5.2.2 StoItemQtyFree

Returns only the product identification and the free quantity — no prices, names or images.
Suitable for frequent stock polling (much smaller data volume than `StoItemBase`).
Corresponds to the `AllProductsNow` / `ProductNow` methods of the ALSO Product API.

**`resultType`:** `StoItemQtyFree` · `StoItemQtyFree_El` · `StoItemQtyFree_Schema`

##### Example:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" EAN2="" QtyFree="51" />
</Result>
```

##### Attributes of the `StoItem` element

| Field       | Type    | Description                                                  |
|-------------|---------|--------------------------------------------------------------|
| `Id`        | i4      | Internal product ID in I6                                    |
| `Code`      | string  | Main SWS stock code (e.g. `LNM01353`)                        |
| `Code2`     | string  | Alternative/second code `‹verify›`                           |
| `PartNo`    | string  | Manufacturer catalog (part) number                           |
| `PartNo2`   | string  | Second manufacturer part/order number                        |
| `EAN`       | string  | EAN                                                          |
| `EAN2`      | string  | Second EAN                                                   |
| `QtyFreeIs` | boolean | Flag                                                         |
| `QtyFree`   | i4      | Free (available) quantity in stock                           |

#### 5.2.3 StoItemSiv

A combined availability-and-price export — returns stock, the order price, basic identification
and logistics data in one call, without the image gallery and extended names. A compromise
between the lightweight `StoItemQtyFree` and the full `StoItemBase`. Corresponds to the
`ProductNow` method (via `GetResultByCode`) or `AllProductsNow` (via `GetResult`) of the ALSO
Product API — it covers both availability and price with a single export.

**`resultType`:** `StoItemSiv` · `StoItemSiv_El` · `StoItemSiv_Schema`

##### Example:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result UrlBase="https://terminal.sws.cz/default.asp?cls=stoitem&amp;stiid=" UrlBaseImg="https://terminal.sws.cz/img.asp?stiid=">
    <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" Name="Lenovo ThinkPad USB4 Dock 5000 - 65W - EU" ManName="Lenovo" SisName="Novinka" SiuCode="ks" UrlSuffix="695888" UrlExt="https://psref.lenovo.com/accessory/40BF0100EU" QtyFree="51" PriceEU="4597.8200" PriceOrd="3539.2200" PriceRef="0.7600" PriceRef2="0.0000" WarDur="1116" ImgSize="14400" CutCode="84718000" Weight="0.64000" />
</Result>
```

##### Attributes of the `Result` element (envelope)

| Field        | Type   | Description                                                        |
|--------------|--------|--------------------------------------------------------------------|
| `UrlBase`    | string | Base URL of the eShop/website                                      |
| `UrlBaseImg` | string | Base URL for the main image — final URL = `UrlBaseImg` + `StoItem.Id` |
| `Void`       | string | `‹verify›` (reserved/empty attribute)                              |

##### Attributes of the `StoItem` element

| Field           | Type        | Description                                                      |
|-----------------|-------------|------------------------------------------------------------------|
| `Id`            | i4          | Internal product ID in I6; used to compose the image URL         |
| `Code`          | string      | Main SWS stock code                                              |
| `Code2`         | string      | Alternative/second code `‹verify›`                               |
| `PartNo`        | string      | Manufacturer catalog (part) number                               |
| `PartNo2`       | string      | Second manufacturer part/order number                            |
| `EAN`           | string      | EAN (barcode)                                                    |
| `EAN2`          | string      | Second EAN                                                       |
| `Name`          | string      | Product name                                                     |
| `ManName`       | string      | Manufacturer name                                                |
| `SisName`       | string      | `‹verify›`                                                       |
| `SiuCode`       | string      | `‹verify — unit-of-measure code (pcs/pack)?›`                    |
| `UrlSuffix`     | string      | Suffix appended to `UrlBase` (completes the product URL) `‹verify›` |
| `UrlExt`        | string      | Link to the product on the manufacturer's site                   |
| `QtyFreeIs`     | boolean     | Flag whether the available quantity is tracked/valid             |
| `QtyFree`       | i4          | Free (available) quantity in stock                               |
| `PriceEU`       | fixed.14.4  | MSRP                                                             |
| `PriceOrd`      | fixed.14.4  | Order (purchase) price                                           |
| `PriceRef`      | fixed.14.4  | Recycling fee                                                    |
| `PriceRefInfo`  | fixed.14.4  | Informative value of the recycling fee                           |
| `PriceRef2`     | fixed.14.4  | Copyright fee                                                    |
| `PriceRef2Info` | fixed.14.4  | Informative value of the copyright fee                           |
| `WarDur`        | i4          | Warranty length (months)                                         |
| `ImgSize`       | i8          | Main image size (B); 0 = no image                                |
| `SitId`         | ui1         | `‹verify›`                                                       |
| `NonMater`      | ui1         | Flag for non-material product (service/license/ESD)? `‹verify›`  |
| `CutCode`       | string      | Customs tariff code                                              |
| `Weight`        | number      | Weight (kg)                                                      |
| `XXL`           | boolean     | Oversized goods                                                  |

#### 5.2.4 SPresentTree

Export of the presentation (category) tree. It returns a **flat list of tree nodes**; the
hierarchy is reconstructed on the client side from the sort key — **each level occupies 3
characters** (`AAA` = 1st level, `AAABBB` = 2nd level, etc.). The parent link is carried by
`IdP` (empty = root node). Top-level nodes correspond to *tree types* (price-list trees); their
`Id` is derived as a negative value (`-2147483648 + type`). Corresponds to the `Categories`
method of the ALSO Product API.

Thanks to `FOR XML AUTO`, the structure is **two-level**: an `SPresentTree` node contains 0..N
nested `StoItem` elements — i.e. the products assigned directly to that node. Categories with no
products that also have no product anywhere below them (at any sub-level) are removed from the
output.

**`resultType`:** `SPresentTree` · `SPresentTree_El` · `SPresentTree_Schema`

**Filtering via `GetResultByCode`:** the `code` parameter = `IdP` (node ID) — returns the given
sub-branch of the tree. A negative `code` filters by *tree type*.

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

| Field        | Type   | Description                                                                 |
|--------------|--------|-----------------------------------------------------------------------------|
| `UrlBase`    | string | Base URL of the category; final URL = `UrlBase` + `SPresentTree.Id` (link `…default.asp?cls=spresenttrees&strid=`) |
| `UrlBaseImg` | string | Base URL of the product image; final URL = `UrlBaseImg` + `StoItem.Id` (or `Code`) |
| `Void`       | string | Reserved empty attribute (always NULL)                                      |

##### `SPresentTree` element (tree node / category)

| Field     | Type   | Description                                                                  |
|-----------|--------|------------------------------------------------------------------------------|
| `Id`      | i4     | Node ID (`StrId`). For top-level tree types it is derived as `-2147483648 + type` |
| `IdP`     | i4     | Parent node ID; empty/NULL = root level                                      |
| `Sort`    | string | Sort key used for ordering and for reconstructing the hierarchy — 3 characters per nesting level |
| `Name`    | string | Category name (localized — the language of the logged-in partner is applied) |
| `Tag`     | string | Optional node label/tag (only if set)                                        |
| `ImgSize` | i8     | Category image size in B (only if an image is present)                       |
| `NameSEO` | string | SEO name of the category (for URLs / search engines)                         |
| `Note`    | string | Node note                                                                    |
| `NameAdd` | string | Additional name / extending text                                             |
| `StrWWW`  | string | Custom WWW link of the category (if set)                                     |

##### Nested `StoItem` element (products in the node, 0..N)

| Field  | Type   | Description                                              |
|--------|--------|----------------------------------------------------------|
| `Id`   | i4     | Internal product ID (`StiId`); for composing the image URL |
| `Code` | string | Product stock code (`StiCode`)                           |

> **Note on content:** Only products that pass the standard WebService visibility filters
> (product stock/sales flags, the partner's row-level permissions) are included in the output.
> The set of products may therefore differ between partners depending on their permissions.

#### 5.2.5 DocTrInv

Invoice transfer format — **"Document Transfer – Invoice"**; per the export definition it is
intended for **import into another I6 instance** (system-to-system document exchange). It returns
the complete invoice including the VAT summary, line items, serial numbers (warranties), linked
delivery notes, and the order including end-customer data for dropshipment.

Unlike the product exports it uses **`FOR XML EXPLICIT`** — the output is therefore strictly
**hierarchical** (nested elements with attributes), not a flat list:

```
Result
└── Invoice (invoice – header)
    ├── DocTaxSum   (VAT summary – 0..N)
    ├── InvItem     (invoice line items – 0..N)
    ├── Warranty    (serial numbers / warranties – 0..N)
    ├── Delivery    (delivery notes – 0..N)
    └── Order       (order + dropshipment end customer – 0..N)
```

**`resultType`:** `DocTrInv` · `DocTrInv_El` · `DocTrInv_Schema`

##### Filtering and scope

| Call                  | Behavior                                                                                   |
|-----------------------|---------------------------------------------------------------------------------------------|
| `GetResultByCode`     | `code` = invoice number (`InvCode`, e.g. `CRDC120009`)                                      |
| `GetResultByFromTo`   | `from`/`to` filters by the invoice creation date (`InvC`) as well as by the last confirmed delivery note (`DelDateConf`) |
| `GetResult` (no params) | Returns only invoices created in the **last ~1–2 days** (`InvC >= today − 1`)             |

> The export is always **restricted to the company of the logged-in partner** (`InvComId`) and
> returns only **completed, non-internal** invoices (`InvState = 1`, `InvInt = 0`). Partners
> therefore see only their own documents.

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
| `Code`        | string      | Invoice number                                                            |
| `ZCode`       | string      | Invoice number for the dropship/end customer (only if present) `‹verify›` |
| `CodeO`       | string      | External invoice number (customer's number, only if present)              |
| `SymCon`      | string      | Payment matching/variable symbol `‹verify›`                               |
| `Tag`         | string      | Invoice label/flag (only if present)                                      |
| `OrdId`       | i4          | ID of the linked order                                                    |
| `OrdCode`     | string      | Number of the linked order                                                |
| `OrdCodeO`    | string      | External order number                                                     |
| `OrdC`        | datetime    | Order creation date                                                       |
| `Type`        | —           | Invoice type (code list; e.g. invoice/credit note) `‹verify values›`      |
| `DateAcc`     | date        | Accounting date / tax point date `‹verify›`                               |
| `DateDue`     | date        | Due date                                                                  |
| `CurCode`     | string      | Currency code (ISO, `UsdCodeE`)                                           |
| `Val`         | fixed.14.4  | Total value in the domestic currency                                      |
| `ValCur`      | fixed.14.4  | Total value in the invoice currency                                       |
| `ValRnd`      | fixed.14.4  | Rounding (domestic currency)                                              |
| `ValRndCur`   | fixed.14.4  | Rounding (invoice currency)                                               |
| `ValPaid`     | fixed.14.4  | Amount paid (domestic currency)                                           |
| `ValPaidCur`  | fixed.14.4  | Amount paid (invoice currency)                                            |
| `ZVal`        | fixed.14.4  | Value for the end customer (dropship) `‹verify›`                          |
| `C`           | datetime    | Invoice creation date (created)                                           |
| `IdC`         | i4          | ID of the related invoice (for a credit note, the original invoice)       |
| `CodeC`       | string      | Number of the related invoice (for a credit note, the original invoice)   |

##### `DocTaxSum` element (VAT summary, 0..N)

| Attribute   | Type        | Description                                  |
|-------------|-------------|----------------------------------------------|
| `Id`        | i4          | VAT summary row ID (`DtsId`)                 |
| `TaxRate`   | fixed.14.4  | VAT rate (%)                                 |
| `Base`      | fixed.14.4  | Tax base (domestic currency)                 |
| `ValTax`    | fixed.14.4  | Tax amount (domestic currency)               |
| `BaseCur`   | fixed.14.4  | Tax base (invoice currency)                  |
| `ValTaxCur` | fixed.14.4  | Tax amount (invoice currency)                |

##### `InvItem` element (invoice line items, 0..N)

| Attribute     | Type        | Description                                                            |
|---------------|-------------|------------------------------------------------------------------------|
| `Id`          | i4          | Invoice item ID (`IniId`)                                              |
| `StiId`       | i4          | Product ID                                                             |
| `StiCode`     | string      | Product stock code                                                     |
| `StiCode2`    | string      | Alternative product code                                               |
| `StiPartNo`   | string      | Part number                                                            |
| `StiPartNo2`  | string      | Second part number                                                     |
| `StiEAN`      | string      | EAN (filled according to the partner's `WsEAN` setting, otherwise empty) |
| `StiEAN2`     | string      | Second EAN                                                             |
| `StiName`     | string      | Product name (stock name)                                              |
| `Name`        | string      | Name on the invoice line (custom item text, only if present)           |
| `OrdId`       | i4          | Order ID of the item                                                   |
| `OrdCode`     | string      | Order number of the item                                               |
| `OrdCodeO`    | string      | External order number of the item                                      |
| `OriC`        | datetime    | Creation date of the order item                                        |
| `Qty`         | number      | Quantity                                                               |
| `TaxRate`     | fixed.14.4  | VAT rate of the item (%)                                               |
| `Prc`         | fixed.14.4  | Unit price excl. VAT (domestic currency)                               |
| `PrcTax`      | fixed.14.4  | Unit price incl. VAT (domestic currency)                               |
| `CurCode`     | string      | Currency code of the item                                              |
| `PrcCur`      | fixed.14.4  | Price excl. VAT (invoice currency)                                     |
| `PrcTaxCur`   | fixed.14.4  | Price incl. VAT (invoice currency)                                     |
| `PrcRefCur`   | fixed.14.4  | Recycling fee (invoice currency)                                       |
| `RefCode`     | string      | Recycling fee code                                                     |
| `RefProCode`  | string      | Recycling fee product code                                             |
| `PrcRefCur2`  | fixed.14.4  | Copyright fee (invoice currency)                                       |
| `RefCode2`    | string      | Copyright fee code                                                     |
| `RefProCode2` | string      | Copyright fee product code                                             |
| `ZPrc`        | fixed.14.4  | Price excl. VAT for the end customer (dropship)                        |
| `ZPrcTax`     | fixed.14.4  | Price incl. VAT for the end customer                                   |
| `ZPrcRef`     | fixed.14.4  | Recycling fee – dropship                                               |
| `ZPrcRef2`    | fixed.14.4  | Copyright fee – dropship                                               |
| `RefIs`       | boolean     | Flag that the line **is** a recycling fee (not a product)              |

##### `Warranty` element (serial numbers / warranties, 0..N)

| Attribute  | Type   | Description                                                 |
|------------|--------|-------------------------------------------------------------|
| `Id`       | i4     | Warranty ID (`WarId`)                                       |
| `Qty`      | number | Quantity for the given serial number                        |
| `SerialNo` | string | Serial number (only for products with SN tracking)          |
| `StiId`    | i4     | Product ID                                                  |
| `StiCode`  | string | Product stock code                                          |
| `Dur`      | i4     | Warranty length (days; `NULL` = not specified)              |

##### `Delivery` element (delivery notes, 0..N)

| Attribute     | Type   | Description                                                      |
|---------------|--------|------------------------------------------------------------------|
| `Id`          | i4     | Delivery note ID (`DelId`)                                       |
| `Code`        | string | Delivery note number                                             |
| `ZCode`       | string | Delivery note number for dropship (only if present)              |
| `OrdId`       | i4     | Order ID                                                         |
| `OrdCode`     | string | Order number                                                     |
| `CstId`       | i4     | Delivery address ID; if delivered to the company's registered office = `-ComId` |
| `CstName`     | string | Delivery address name (otherwise the customer company name)      |
| `CstNameAdd`  | string | Name addition                                                    |
| `CstNameAdd2` | string | Second name addition                                             |
| `CstStreet`   | string | Street                                                           |
| `CstCity`     | string | City                                                             |
| `CstPostCode` | string | Postal code                                                      |
| `CstCouName`  | string | Country                                                          |

##### `Order` element (order + dropshipment end customer, 0..N)

The `Cst*` address = the delivery address of the order. The **`ZCm*` / `ZCst*`** prefixes = data
of the **end customer** in direct dropshipment (where the goods are delivered on behalf of the
partner).

| Attribute      | Type   | Description                                                       |
|----------------|--------|-------------------------------------------------------------------|
| `Id`           | i4     | Order ID (`OrdId`)                                                |
| `Code`         | string | Order number                                                      |
| `CodeO`        | string | External order number (from the customer)                         |
| `Tag`          | string | Order label                                                       |
| `NoteExt`      | string | External note on the order                                        |
| `C`            | datetime | Order creation date                                             |
| `OrwName`      | string | Order status / processing method `‹verify›`                       |
| `CstId`        | i4     | Delivery address ID of the order (`-ComId` = registered office)   |
| `CstName`      | string | Delivery address name                                             |
| `CstNameAdd`   | string | Name addition                                                     |
| `CstNameAdd2`  | string | Second name addition                                              |
| `CstStreet`    | string | Street                                                            |
| `CstCity`      | string | City                                                              |
| `CstPostCode`  | string | Postal code                                                       |
| `CstCouName`   | string | Country                                                           |
| `ZDirect`      | —      | Direct dropshipment flag (shipment goes directly to the end customer) |
| `ZIPrn`        | —      | Flag: print the invoice into the shipment `‹verify›`              |
| `ZDPrn`        | —      | Flag: print the delivery note into the shipment `‹verify›`        |
| `ZCmId`        | i4     | End customer ID (dropship)                                        |
| `ZCmRegId`     | string | End customer company registration number (IČO)                    |
| `ZCmTaxNum`    | string | End customer VAT number (DIČ)                                     |
| `ZCmName`      | string | End customer name                                                 |
| `ZCmNameAdd`   | string | Name addition                                                     |
| `ZCmStreet`    | string | Street                                                            |
| `ZCmCity`      | string | City                                                              |
| `ZCmPostCode`  | string | Postal code                                                       |
| `ZCmTitle`     | string | Salutation / title                                                |
| `ZCmFName`     | string | First name                                                        |
| `ZCmLName`     | string | Last name                                                         |
| `ZCmTel`       | string | Phone                                                             |
| `ZCmTelMob`    | string | Mobile                                                            |
| `ZCmFax`       | string | Fax                                                               |
| `ZCmEMail`     | string | E-mail                                                            |
| `ZCstName`     | string | Dropship delivery address – name (if different from `ZCm*`)       |
| `ZCstNameAdd`  | string | Name addition                                                     |
| `ZCstNameAdd2` | string | Second name addition                                              |
| `ZCstStreet`   | string | Street                                                            |
| `ZCstCity`     | string | City                                                              |
| `ZCstPostCode` | string | Postal code                                                       |
| `ZCstCouName`  | string | Country                                                           |

#### 5.2.6 StoItemPriceOrd

Pricing export — the partner's **order (purchase) prices**. Returns the order price, reference
(recycling and copyright) fees, and the VAT rate. Per the export definition.

Covers the pricing part of the `ProductNow` / `AllProductsNow` methods of the ALSO Product API
(availability is handled by `StoItemQtyFree`).

**`resultType`:** `StoItemPriceOrd` · `StoItemPriceOrd_El` · `StoItemPriceOrd_Schema`




##### Example:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="695888" Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" PriceOrd="3539.2200" PriceEU="4597.8200" PriceRef="0.7600" PriceRef2="0.0000" TaxRate="21.0000" PriceB2CMin="4597.8200" />
</Result>
```

##### Attributes of the `StoItem` element

| Field          | Type   | Description                                                                      |
|----------------|--------|----------------------------------------------------------------------------------|
| `Id`           | i4     | Internal product ID (`StiId`)                                                    |
| `Code`         | string | Main SWS stock code                                                              |
| `Code2`        | string | Alternative/second code                                                          |
| `PartNo`       | string | Manufacturer (catalog) part number                                               |
| `PartNo2`      | string | Second part number                                                               |
| `EAN`          | string | EAN                                                                              |
| `EAN2`         | string | Second EAN                                                                       |
| `PriceOrd`     | money  | The partner's **order (purchase) price** — the main price of this export         |
| `PriceEU`      | money  | End/recommended price (converted to the partner's currency, if configured) `‹verify meaning – MSRP?›` |
| `PriceRef`     | money  | Recycling fee linked to the product                                              |
| `PriceRefInfo` | money  | Informative value of the recycling fee                                           |
| `PriceRef2`    | money  | Copyright fee                                                                    |
| `PriceRef2Info`| money  | Informative value of the copyright fee                                           |
| `TaxRate`      | fixed.14.4 | VAT rate (%); in cross-border mode recalculated for the destination country (`TaxMeCouId`) |
| `PriceFullIs`  | boolean | Flag that the partner is authorized to see the full set of fixed prices (`Price*`) |
| `PriceList`    | money  | List (fixed) price — **only with special authorization**, otherwise empty        |
| `Price0`       | money  | Fixed price level 0 — only with special authorization                            |
| `Price1`       | money  | Fixed price level 1 — only with special authorization                            |
| `Price2`       | money  | Fixed price level 2 — only with special authorization                            |
| `Price3`       | money  | Fixed price level 3 — only with special authorization                            |
| `Price4`       | money  | Fixed price level 4 — only with special authorization                            |
| `Price5`       | money  | Fixed price level 5 — only with special authorization                            |
| `PriceB2CMin`  | money  | Minimum B2C selling price (MAP), converted to the partner's currency             |

##### Notes on prices

- Prices are returned only for products with a **positive order price** (`PriceOrd > 0`).
- Depending on the partner's settings (`WsPriceCur`), prices may be converted to the partner's
  **currency** at the current exchange rate; in that case `PriceEU` and `PriceB2CMin` are
  converted to the same currency.
- `PriceFullIs = 1` indicates that (subject to authorization) the `PriceList`/`Price0–5` fields
  are also available. Without authorization these fields remain empty and `PriceFullIs = 0`.

> **Note for ALSO:** A standard partner receives `PriceOrd`, `PriceRef*`, `TaxRate` and
> `PriceB2CMin`; the `PriceList`/`Price0–5` set is an extension tied to special authorization.

#### 5.2.7 CpsStiVal

Export of **product parameters (attributes)** — technical specifications in a **name × value**
format. Per the export definition: *"Export parameters of StoItems – Name × Value only (filtered
by Code of StoItem)."* Each element corresponds to one parameter of one product; a product with
N parameters returns N elements. Together with `StoItemBase` it covers the `ProductFullInfo`
method of the ALSO Product API (the attribute part).

**`resultType`:** `CpsStiVal` · `CpsStiVal_El` · `CpsStiVal_Schema`

> **Usage recommendation:** This export is primarily intended for **filtering by product code**
> (`GetResultByCode`). Via `GetResult` it returns the parameters of all products — which can be
> a very large volume of data.

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
| `Id`         | i4     | ID of the specific parameter value on the product (`CpsId`) — unique row key   |
| `StiId`      | i4     | Internal product ID                                                            |
| `StiCode`    | string | Main SWS stock code of the product                                             |
| `StiCode2`   | string | Alternative product code                                                       |
| `StiPartNo`  | string | Part number                                                                    |
| `StiPartNo2` | string | Second part number                                                             |
| `StiEAN`     | string | EAN (filled according to the partner's `WsEAN` setting, otherwise empty)       |
| `StiEAN2`    | string | Second EAN                                                                     |
| `CpaId`      | i4     | Parameter definition ID (shared by all products with the same parameter)       |
| `Code`       | string | Parameter code (`CpaCode`) — machine identifier of the parameter               |
| `Grp`        | string | Parameter group (`CpaGrp`) for grouping into sections (only if set)            |
| `Name`       | string | Parameter name (localized) — e.g. "Diagonal", "Weight"                         |
| `NameAdd`    | string | Additional parameter description (only if present)                             |
| `Single`     | —      | Flag that the parameter has a single value (only if non-zero) `‹verify›`       |
| `Ord`        | i4     | Parameter display order (only if non-zero)                                     |
| `Value`      | string | **Parameter value** — either from the code list (`CpvValue`), or free text (`CpsTag`) |
| `ValueAdd`   | string | Additional value / note on the value (only if present)                         |
| `Measure`    | number | Unit of measure / numeric measure of the value (only if non-zero) `‹verify – unit vs. numeric value?›` |
| `CprOrd`     | i4     | Order of the value within the parameter's code list (only if non-zero)         |

#### 5.2.8 AttSti

Export of **product attachments** — images, datasheets, documentation and other files linked to
a product. Each element = one attachment; a product with N attachments returns N elements.
Covers the `ProductImages` method of the ALSO Product API (and in general also non-media
attachments, if recorded on the product).

**`resultType`:** `AttSti` · `AttSti_El` · `AttSti_Schema`

Supports the same set of prefixes as `StoItemPriceOrd` (see [Request format](#3-request-format)):
no prefix = `StiCode`, plus `{StiId}`, `{PartNo}`, `{PartNo2}`, `{CodeEAN}`, `{ManName}`,
`{CodeAll}`. Multiple values can be separated by a tab character (`\t`).

##### Building the attachment URL

The `Url` field is returned **ready to use**, but it is built in two ways depending on the
attachment type:

- **External attachment** (`AttUrl` contains `://`) → `Url` = the external link directly.
- **Internal attachment** (file in I6) → `Url` = `UrlBaseImgGalery` + `Id`
  (i.e. `…/img.asp?attid=‹Id›`). The client can therefore use `Url` directly, without composing it.

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

| Field        | Type   | Description                                                                 |
|--------------|--------|-----------------------------------------------------------------------------|
| `Id`         | i4     | Attachment ID (`AttId`); also used to build the `Url` for internal attachments |
| `StiId`      | i4     | Internal product ID                                                         |
| `StiCode`    | string | Main stock code of the product                                              |
| `StiCode2`   | string | Alternative product code                                                    |
| `StiPartNo`  | string | Part number                                                                 |
| `StiPartNo2` | string | Second part number                                                          |
| `StiEAN`     | string | EAN (filled according to the partner's `WsEAN` setting, otherwise empty)    |
| `StiEAN2`    | string | Second EAN                                                                  |
| `Name`       | string | Attachment name (only if set) — e.g. "Thumbnail", "Enlargement", a caption  |
| `Tag`        | string | Attachment label/type (only if present) — distinguishes the kind of attachment `‹verify values›` |
| `File`       | string | Attachment file name (without path; the directory is stripped from `AttUrl`) |
| `Url`        | string | **Ready-to-use attachment URL** — an external link, or internal `…/img.asp?attid=‹Id›` |
| `Size`       | i8     | Attachment size in bytes (may be empty for external attachments)            |
| `Sort`       | i2     | Attachment sort order (only if non-zero)                                    |

#### 5.2.9 CpsSti

Export of **product parameters including their definitions** — the normalized (relational)
variant of `CpsStiVal`. Per the export definition: *"Export parameters of StoItems include
parameter's definition."* Unlike `CpsStiVal`, which repeats the name and value on every row,
`CpsSti` returns the **parameter definitions and the value code list separately**, and the
product assignments only reference them by ID. Suitable when the client wants to build their own
parameter database (download the definitions once, have products reference them). Together with
`StoItemBase` it covers the attribute part of the `ProductFullInfo` method of the ALSO Product
API.

**`resultType`:** `CpsSti` · `CpsSti_El` · `CpsSti_Schema`

> ⚠️ **`CpsStiVal` vs. `CpsSti`:** If a plain "product → parameter → value" list is enough for
> you, use **`CpsStiVal`** (simpler, flat). Use `CpsSti` only when you also need the **definition
> metadata** (types, code lists, language variants, links to categories).

##### Output structure

The output is **hierarchical** (`FOR XML EXPLICIT`). Under the `Result` root there are five
separate collections, each containing `Row` elements distinguished by level:

```
Result
├── ConPar        → Row (parameter definitions)          [level 7]
├── ConParValue   → Row (value code list)                [level 8]
├── ConParRange   → Row (allowed values per parameter)   [level 9]
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

Linking on the client side: `ConParSet.CpaId` → `ConPar.Id`, `ConParSet.CpvId` →
`ConParValue.Id`; `ConParRange` restricts which values (`CpvId`) belong to which parameter
(`CpaId`); `ConParStr` maps a parameter to a presentation tree node (see `SPresentTree`).

##### `ConPar` → `Row` — parameter definition

| Field     | Type   | Description                                                       |
|-----------|--------|-------------------------------------------------------------------|
| `Id`      | i4     | Parameter ID (`CpaId`)                                            |
| `Type`    | ui1    | Parameter type (`CpaType`; types 0 and 2 are returned) `‹verify values›` |
| `Single`  | —      | Flag that the parameter has a single value `‹verify›`             |
| `Code`    | string | Machine code of the parameter                                     |
| `Grp`     | string | Parameter group (for grouping into sections)                      |
| `Ord`     | i4     | Parameter display order                                           |
| `Name`    | string | Parameter name (localized)                                        |
| `AddName` | string | Additional name (note: in the attribute `Row!7!AddName` = `CpaNameAdd`) |
| `NameE`   | string | Name in English                                                   |
| `NameAddE`| string | Additional name in English                                        |
| `Note`    | string | Note on the parameter                                             |

##### `ConParValue` → `Row` — code-list value

| Field      | Type   | Description                                              |
|------------|--------|----------------------------------------------------------|
| `Id`       | i4     | Value ID (`CpvId`)                                       |
| `Measure`  | number | Unit of measure / measure of the value `‹verify›`        |
| `Code`     | string | Machine code of the value                                |
| `Value`    | string | Value (localized)                                        |
| `ValueAdd` | string | Value addition                                           |
| `ValueE`   | string | Value in English                                         |
| `ValueAddE`| string | Value addition in English                                |

##### `ConParRange` → `Row` — allowed parameter value

| Field   | Type | Description                                       |
|---------|------|---------------------------------------------------|
| `Id`    | i4   | Link ID (`CprId`)                                 |
| `CpaId` | i4   | Parameter ID (`ConPar.Id`)                        |
| `CpvId` | i4   | ID of the allowed value (`ConParValue.Id`)        |

##### `ConParSet` → `Row` — value assignment to a product

| Field     | Type   | Description                                                              |
|-----------|--------|--------------------------------------------------------------------------|
| `Id`      | i4     | Assignment ID (`CpsId`)                                                  |
| `StiId`   | i4     | Product ID                                                               |
| `CpaId`   | i4     | Parameter ID (`ConPar.Id`)                                               |
| `CpvId`   | i4     | ID of the code-list value (`ConParValue.Id`); empty = the value is free text |
| `StiCode` | string | Product stock code                                                       |
| `Value`   | string | Value — from the code list (`CpvValue`), or free text (`CpsTag`)         |
| `Measure` | number | Numeric measure of the value (only if non-zero) `‹verify›`               |

##### `ConParStr` → `Row` — parameter-to-category link

| Field     | Type   | Description                                                                 |
|-----------|--------|-----------------------------------------------------------------------------|
| `Id`      | i4     | Link ID (`CosId`)                                                           |
| `StrId`   | i4     | Presentation tree node ID (`SPresentTree.Id`)                               |
| `CpaId`   | i4     | Parameter ID (`ConPar.Id`)                                                  |
| `StrSort` | string | Sort key of the node (3 characters/level) — determines for which category the parameter is used |

## 6. Special important exports

### 6.1 Alza – export X-StoItemQtyFreeRealX

The timeout on Alza's side for downloading the data is 5 minutes. The export was customized to
their requirements. They have their own fixed format which they simply consume.

Alza downloads the data and then places orders via EDI.

##### Example:
sample for one product, 40BF0100EU

https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=LNM01353&resultType=X-StoItemQtyFreeRealX

```xml
<?xml version="1.0" encoding="utf-8"?>
<items>
    <item>
        <Pricing>
            <PriceWithFee>3557.7600</PriceWithFee>
            <PriceWithoutFee>3557.0000</PriceWithoutFee>
            <RecycleFee>0.7600</RecycleFee>
            <CopyrightFee>0.0000</CopyrightFee>
            <Currency>CZK</Currency>
        </Pricing>
        <Storage>
            <StoredQuantity>51</StoredQuantity>
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

##### Format required by Alza:

| Field name | Description | Format |
|---|---|---|
| **Pricing** | | |
| PriceWithFee | (one piece of the) product purchase price with fees | *number (with "." as a decimal point)* |
| PriceWithoutFee¹⁾ | (one piece of the) product purchase price without fees | *number (with "." as a decimal point)* |
| RecycleFee | recycleFee | *number* |
| CopyrightFee | copyrightFee | *number* |
| Currency | currency of the product | *ISO 4217 format (USD, CZK, EUR, HUF, ...)* |
| **Storage** | | |
| StoredQuantity²⁾ | number of the product pieces | *number* |
| **Product** | | |
| DealerCode | code of the dealer | *text* |
| PartNumber | part number of the product | *text format* |
| Ean | ean code of the product | *text format* |
| Name | name of the product | *text* |

### 6.2 HP Tronic – export X-StoItemQtyFreeBOHPT

HP Tronic (CZ) owns the company Nay (SK); they share one common system, but each company
downloads the data separately. HP Tronic handles the blocking of products via orders for both
companies together. Through the web service they want to see when goods will be restocked and
how many units they can order (free stock + blocked goods).

##### Example:
sample for one product, 40BF0100EU

```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Code="LNM01353" PartNo="40BF0100EU" PartNo2="40BF0100EU" EAN="0195892132486" QtyFree="51" Avail="21" />
</Result>
```

QtyFree – free stock + blocked goods

Avail – number of days until restocking




## 7. OneDrive link with all materials

All materials related to the web service are available here:
[Link to OneDrive](https://also-my.sharepoint.com/:f:/p/michal_jurca/IgCI5I3cmva2R5Xrp_RlleESAeO7Vzqr02bFcOZ-G_LWXb8?e=4uyzDY).
