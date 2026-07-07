> **⚠️ Document version 0.5**
> This document is not finished — it is a working draft. Places marked `‹…›` and **TODO** need to be filled in with real values (URLs, credentials, sample responses). Assumptions are explicitly flagged in the text.


---

# WebService – Product API

> **Purpose of this document:** A complete description of the SWS/I6 (CyberSoft) WebService for the
> purposes of handover and integration under ALSO. The document covers the architecture,
> authentication, request and response formats, naming conventions, and the full catalog of
> available exports.
>


---

## Overview

The SWS WebService gives partners machine access to data in the **I6 ERP system (CyberSoft)**.
It covers product information (StoItem), stock levels, prices, images, attributes, presentation
trees (categories), documents (invoices, delivery notes) and orders.

The service is built as an **ASP.NET Web Service (`.asmx`)** and runs as the application directory
`/i6ws/` on the distributor's eShop. It can be communicated with using the **SOAP** protocol; for
methods with simple parameters (exports) it can also be used over **HTTP GET/POST** — exports can
therefore be downloaded with a plain link (URL).


## Base URL

The web service runs as the application directory `/i6ws/` on the distributor's eShop:

```
https://terminal.sws.cz/i6ws/
```
```
https://www.sws.cz/i6ws/
```


**Main endpoints:**

| Endpoint                | Purpose                                                                                        |
|-------------------------|-----------------------------------------------------------------------------------------------|
| `Default.asmx`          | Universal data reads (exports) — methods `GetResult` (all products), `GetResultByCode` (a single product), `GetResultByFromTo` |
| `Order.asmx`            | Creating and managing orders — method `Create`                                                 |
| `ResultTypeInfo.ashx`   | Overview of all available exports with descriptions and schemas                               |

---


## Request format

### Reading data — `Default.asmx`

Three methods are available, all accessible over HTTP GET (as well as SOAP).

```
GET https://USER:PASSWORD@HOST/i6ws/Default.asmx/GetResult?resultType=‹RESULT_TYPE›
GET https://USER:PASSWORD@HOST/i6ws/Default.asmx/GetResultByCode?resultType=‹RESULT_TYPE›&code=‹CODE›
GET https://USER:PASSWORD@HOST/i6ws/Default.asmx/GetResultByFromTo?resultType=‹RESULT_TYPE›&from=‹FROM›&to=‹TO›
```

| Method              | Description                                                                          | Parameters                 |
|---------------------|--------------------------------------------------------------------------------------|----------------------------|
| `GetResult`         | Returns the complete export (all products, everything in stock, etc.)                | `resultType`               |
| `GetResultByCode`   | Filters the export by code — returns a single record for the given product           | `resultType`, `code`       |
| `GetResultByFromTo` | Filters the export by date from/to — typically by the record's logged change date    | `resultType`, `from`, `to` |

**Parameters:**

| Parameter    | Type        | Required                  | Description                                                                                 |
|--------------|-------------|---------------------------|---------------------------------------------------------------------------------------------|
| `resultType` | String      | Yes                       | Export name, e.g. `StoItemBase` (see catalog below)                                          |
| `code`       | String      | For `GetResultByCode`     | Filter — product code, tree IdP, condition… Prefix `{PartNo}` = search by PartNo             |
| `from`       | String/Date | For `GetResultByFromTo`   | Range start — format `YYYY-MM-DD` or `YYYY-MM-DD HH:MM:SS`                                    |
| `to`         | String/Date | For `GetResultByFromTo`   | Range end                                                                                    |

> **Note on the `code` parameter:** Searching by PartNo is activated with the `{PartNo}` prefix:
> ```
> GetResultByCode?resultType=StoItemQtyFree&code={PartNo}600623
> ```






## Comparison with the ALSO Product API

The ALSO Product API offers 7 methods. Below is a mapping of which SWS exports cover the same
functionality.

| # | ALSO Product API method | Description (ALSO)                                         | Corresponding SWS export(s)                                     | Note                                                                  |
|---|-------------------------|-----------------------------------------------------------|-----------------------------------------------------------------|-----------------------------------------------------------------------|
| 1 | `AllProducts`           | Basic info on all products available in the e-shop        | `StoItemBase`                                                   | SWS returns prices, stock and images (only `Id` with URL) in one export. |
| 2 | `AllOfflineProducts`    | Products in the partner's catalog that are not online     |                                                                 |                                                                       |
| 3 | `ProductFullInfo`       | Complete product detail — description, attributes, images, prices | `StoItemBase` + `CpsSti`/`CpsStiVal` + `AttSti`         | SWS requires a combination of multiple exports for the same result    |
| 4 | `ProductNow`            | Current stock, price and availability for a single product | `StoItemSiv`, or availability and price separately via `StoItemQtyFree`, `StoItemPriceOrdCur` | Called via `GetResultByCode` with the product code |
| 5 | `AllProductsNow`        | Stock, price and availability for all products            | `StoItemSiv`, or availability and price separately via `StoItemQtyFree`, `StoItemPriceOrdCur` | Called via `GetResult` for all products |
| 6 | `ProductImages`         | Available product images                                  | `StoItemBase` or `AttSti`                                       | SWS returns URLs assembled from `UrlBase*` + `Id`; types distinguished by tag |
| 7 | `Categories`            | Complete e-shop category hierarchy                        | `SPresentTree`, `SCategorySys`                                  | SWS uses a flat list with a parent ID and a sort key (3 chars per level) |

---

## Export catalog

Each export exists in three variants — they differ only by the suffix in `resultType`:

| Suffix    | Description                            | Example |
|-----------|----------------------------------------|---------|
| *(none)*  | Data as XML attributes — more compact  | name    |
| `_El`     | Data as XML elements — more readable   | name_El |
| `_Schema` | XSD schema of the export               | name_Schema |

**Example — same data, three variants (`StoItemQtyFree`):**

https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree

```xml
<!-- Attributes (default) -->
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="685699" Code="ASC00511" PartNo="GU605CX-QR149" PartNo2="90NR0M65-M007X0" EAN="4711636262347" EAN2="" QtyFree="2" />
</Result>
```

https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree_El

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
        <EAN2>
    </EAN2>
        <QtyFree>2</QtyFree>
    </StoItem>
</Result>
```

https://terminal.sws.cz/i6ws/default.asmx/GetResultByCode?code=ASC00511&resultType=StoItemQtyFree_Schema


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

### Most-used exports

| # | ResultType         | Number of companies | Description                                              |
|---|--------------------|---------------------|----------------------------------------------------------|
| 1 | `StoItemBase`      | 130                 | Complete product catalog                                 |
| 2 | `StoItemQtyFree`   | 104                 | Current free quantity in stock                           |
| 3 | `StoItemSiv`       | 57                  | Purchase price and stock status                          |
| 4 | `SPresentTree`     | 56                  | Hierarchical tree of product categories                  |
| 5 | `DocTrInv`         | 51                  | Invoices                                                 |
| 6 | `StoItemPriceOrd`  | 36                  | Purchase price                                           |
| 7 | `CpsStiVal`        | 27                  | Product attributes including parameter definitions       |
| 8 | `StiRelation`      | 19                  | Relationships between products (accessories, alternatives) |
| 9 | `StoItemBase_El`   | 18                  | Output as XML elements. Complete product catalog         |
| 10| `AttSti`           | 16                  | Product attachments (images, documents), invoices        |
| 11| `CpsSti`           | 16                  | Product parameters                                       |
| 12| `StoItemQtyFree_El`| 16                  | Output as XML elements. Current free quantity in stock   |
| 12| `StrStiSync`       | 12                  | Product tree synchronization                             |


---


### Examples of the most-used exports

#### StoItemBase

In a single call it returns product descriptions, prices, VAT, stock availability, logistics data
and image information. Corresponds to the `AllProducts` method (and partly `ProductFullInfo`) of the
ALSO Product API.

**`resultType`:** `StoItemBase` · `StoItemBase_El` · `StoItemBase_Schema`

**Type legend:** `i2`/`i4`/`i8` = integer (16/32/64 bit) · `ui1` = byte (0–255) ·
`fixed.14.4` / `number` = decimal number · `string` = text · `boolean` = 0/1.

##### Attributes of the `Result` element (envelope, once per document)

| Field               | Type   | Description                                                            |
|---------------------|--------|-----------------------------------------------------------------------|
| `UrlBase`           | string | Base URL of the eshop/website                                         |
| `UrlBaseThumbnail`  | string | Base URL for thumbnails — resulting URL = `UrlBaseThumbnail` + `StoItem.Id` |
| `UrlBaseImg`        | string | Base URL for images — resulting URL = `UrlBaseImg` + `StoItem.Id`     |
| `UrlBaseEnlargement`| string | Base URL for enlargements                                            |
| `UrlBaseImgGalery`  | string | Base URL for gallery images — combined with `ImgGal.Id`               |
| `CouCode`           | string | Default country code                                                  |
| `TaxRateLow`        | ui1    | Reduced VAT rate (%)                                                   |
| `TaxRateHigh`       | ui1    | Standard/high VAT rate (%)                                            |
| `Void`              | string | `‹verify›` (reserved/empty attribute)                                 |

##### Attributes of the `StoItem` element

| Field           | Type        | Description                                                                 |
|-----------------|-------------|----------------------------------------------------------------------------|
| `Id`            | i4          | Internal product ID in I6                                                   |
| `Code`          | string      | Main SWS stock code (e.g. `ASC00511`)                                       |
| `Code2`         | string      | Alternative/second code `‹verify›`                                          |
| `PartNo`        | string      | Manufacturer's catalog (part) number                                       |
| `PartNo2`       | string      | Second manufacturer part/order number                                      |
| `EAN`           | string      | EAN                                                                         |
| `EAN2`          | string      | Second EAN                                                                  |
| `Name`          | string      | Product name                                                               |
| `NameAdd`       | string      | Name supplement (extending text) `‹verify›`                                 |
| `NameE`         | string      | English name                                                               |
| `NameDoc`       | string      | Name used on documents                                                     |
| `NameShort`     | string      | Short name                                                                 |
| `NameSeo`       | string      | SEO name (for URLs / search engines)                                       |
| `ManName`       | string      | Manufacturer name                                                          |
| `CouCode`       | string      | Country of origin code                                                     |
| `UrlExt`        | string      | External URL (e.g. product page at the manufacturer) `‹verify›`            |
| `PriceEU`       | fixed.14.4  | MSRP, list price                                                           |
| `PriceB2CMin`   | fixed.14.4  | Minimum B2C selling price (MAP)                                            |
| `PriceDea`      | fixed.14.4  | Dealer price                                                               |
| `PriceOrd`      | fixed.14.4  | Order (purchase) price                                                     |
| `PriceRef`      | fixed.14.4  | Copyright/author levy                                                      |
| `PriceRefInfo`  | fixed.14.4  | Informational value of the reference levy `‹verify›`                       |
| `RefProName`    | string      | Reference product name `‹verify›`                                          |
| `RefCode`       | string      | Reference product code `‹verify›`                                          |
| `PriceRef2`     | fixed.14.4  | Recycling levy `‹verify›`                                                   |
| `PriceRef2Info` | fixed.14.4  | Informational value of the second reference levy `‹verify›`                |
| `RefProName2`   | string      | Name of the second reference product `‹verify›`                            |
| `RefCode2`      | string      | Code of the second reference product `‹verify›`                            |
| `WeightRef`     | number      | Reference weight (for levy calculation?) `‹verify›`                        |
| `MeasureRef2`   | number      | Reference measure/quantity `‹verify›`                                      |
| `TaxRate`       | fixed.14.4  | Product VAT rate (%)                                                       |
| `TatCodeE`      | string      | `‹verify›`                                                                 |
| `CutCode`       | string      | `‹verify — customs tariff / code?›`                                        |
| `QtyFreeIs`     | boolean     | Flag indicating whether the available quantity is tracked/valid           |
| `QtyFree`       | i4          | Free (available) quantity in stock                                        |
| `QtyPack`       | number      | Quantity per pack (carton)                                                |
| `WarDur`        | i4          | Warranty length (months)                                                  |
| `WarDurEU`      | i4          | Warranty length for the end customer / EU (months) `‹verify›`             |
| `SNTrack`       | ui1         | Serial number tracking (0 = no / tracking type)                          |
| `NonDivQty`     | number      | Indivisible (minimum order) quantity `‹verify›`                           |
| `Weight`        | number      | Weight (kg)                                                               |
| `XXL`           | boolean     | Oversized goods                                                          |
| `XXS`           | boolean     | `‹verify›`                                                                |
| `ScaId`         | i4          | `‹verify›`                                                                |
| `ThumbnailIs`   | boolean     | Thumbnail exists                                                         |
| `ThumbnailSize` | i8          | Thumbnail size (B)                                                       |
| `ImgIs`         | boolean     | Main image exists                                                        |
| `ImgSize`       | i8          | Main image size (B)                                                      |
| `EnlargementIs` | boolean     | Enlargement exists                                                       |
| `EnlargementSize`| i8         | Enlargement size (B)                                                     |
| `SisName`       | string      | `‹verify›`                                                                |
| `SitId`         | ui1         | `‹verify›`                                                                |
| `NonMater`      | ui1         | Flag for a non-material product (service/license/ESD)? `‹verify›`         |
| `SttId`         | ui1         | `‹verify›`                                                                |
| `NoteShort`     | string      | Short note                                                               |
| `StiDemIdDis`   | string      | `‹verify›`                                                                |
| `EprelId`       | i4          | Record ID in the EU EPREL database (energy labels)                       |
| `Note`          | string      | Note (longer text)                                                       |

##### Nested `ImgGal` elements (image gallery, 0..N per product)

| Field   | Type   | Description                                                    |
|---------|--------|----------------------------------------------------------------|
| `Id`    | i4     | Gallery image ID; URL = `UrlBaseImgGalery` + `Id`             |
| `Name`  | string | Image name/file                                              |
| `Tag`   | string | Image type/label (distinguishes the kind of image)          |
| `Sort`  | i2     | Display order                                                |
| `Size`  | i8     | Image size (B)                                               |


#### StoItemQtyFree

Returns only the product identification and free quantity — no prices, names or images. Suitable
for frequent stock queries (smaller data volume than `StoItemBase`). Corresponds to the
`AllProductsNow` / `ProductNow` methods of the ALSO Product API.

##### Example:
```xml
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="685699" Code="ASC00511" PartNo="GU605CX-QR149" PartNo2="90NR0M65-M007X0" EAN="4711636262347" EAN2="" QtyFree="2" />
</Result>
```


##### Attributes of the `StoItem` element

| Field       | Type    | Description                                                  |
|-------------|---------|--------------------------------------------------------------|
| `Id`        | i4      | Internal product ID in I6                                    |
| `Code`      | string  | Main SWS stock code (e.g. `ASC00511`)                       |
| `Code2`     | string  | Alternative/second code `‹verify›`                          |
| `PartNo`    | string  | Manufacturer's catalog (part) number                       |
| `PartNo2`   | string  | Second manufacturer part/order number                      |
| `EAN`       | string  | EAN                                                         |
| `EAN2`      | string  | Second EAN                                                  |
| `QtyFreeIs` | boolean | Flag                                                        |
| `QtyFree`   | i4      | Free (available) quantity in stock                         |

**Example call and response** — see the [Export catalog](#export-catalog) section above
(`StoItemQtyFree` is used as the example for all three variants).


#### StoItemSiv

A combined availability-and-price export — returns stock, order price and basic identification
plus logistics data in a single call, without the image gallery or extended names. A compromise
between the lightweight `StoItemQtyFree` and the full `StoItemBase`. Corresponds to the `ProductNow`
method (via `GetResultByCode`) or `AllProductsNow` (via `GetResult`) of the ALSO Product API — it
covers both availability and price in one export.

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
| `UrlBaseImg` | string | Base URL for the main image — resulting URL = `UrlBaseImg` + `StoItem.Id` |
| `Void`       | string | `‹verify›` (reserved/empty attribute)                            |

##### Attributes of the `StoItem` element

| Field           | Type        | Description                                                      |
|-----------------|-------------|------------------------------------------------------------------|
| `Id`            | i4          | Internal product ID in I6; used to build the image URL           |
| `Code`          | string      | Main SWS stock code                                             |
| `Code2`         | string      | Alternative/second code `‹verify›`                             |
| `PartNo`        | string      | Manufacturer's catalog (part) number                            |
| `PartNo2`       | string      | Second manufacturer part/order number                          |
| `EAN`           | string      | EAN (barcode)                                                  |
| `EAN2`          | string      | Second EAN                                                     |
| `Name`          | string      | Product name                                                  |
| `ManName`       | string      | Manufacturer name                                             |
| `SisName`       | string      | `‹verify›`                                                     |
| `SiuCode`       | string      | `‹verify — unit of measure code (pcs/pack)?›`                  |
| `UrlSuffix`     | string      | Suffix appended to `UrlBase` (completes the product URL) `‹verify›` |
| `UrlExt`        | string      | External URL `‹verify›`                                        |
| `QtyFreeIs`     | boolean     | Flag indicating whether the available quantity is tracked/valid |
| `QtyFree`       | i4          | Free (available) quantity in stock                            |
| `PriceEU`       | fixed.14.4  | `‹verify — end/recommended price (MSRP)?›`                     |
| `PriceOrd`      | fixed.14.4  | Order (purchase) price                                        |
| `PriceRef`      | fixed.14.4  | Price of the linked reference levy (recycling/copyright?) `‹verify›` |
| `PriceRefInfo`  | fixed.14.4  | Informational value of the reference levy `‹verify›`          |
| `PriceRef2`     | fixed.14.4  | Price of the second reference levy `‹verify›`                  |
| `PriceRef2Info` | fixed.14.4  | Informational value of the second reference levy `‹verify›`   |
| `WarDur`        | i4          | Warranty length (months)                                      |
| `ImgSize`       | i8          | Main image size (B); 0 = no image                             |
| `SitId`         | ui1         | `‹verify›`                                                     |
| `NonMater`      | ui1         | Flag for a non-material product (service/license/ESD)? `‹verify›` |
| `CutCode`       | string      | `‹verify — customs tariff / code?›`                           |
| `Weight`        | number      | Weight (kg)                                                   |
| `XXL`           | boolean     | Oversized goods                                              |
| `XXS`           | boolean     | `‹verify›`                                                     |



#### SPresentTree

Export of the presentation (category) tree. It returns a **flat list of tree nodes**, where the
hierarchy is reconstructed on the client side from the sort key — **each level has 3 reserved
characters** (`AAA` = level 1, `AAABBB` = level 2, and so on). The parent link is carried by `IdP`
(empty = root node). Top-level nodes correspond to *tree types* (price-list trees); their `Id` is
derived as a negative value (`-2147483648 + type`). Corresponds to the `Categories` method of the
ALSO Product API.

Thanks to `FOR XML AUTO` the structure is **two-level**: a `SPresentTree` node contains 0..N nested
`StoItem` elements — i.e. the products placed directly in the given node. Categories without
products that also have no product beneath them (at any sublevel) are removed from the output.



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
|--------------|--------|------------------------------------------------------------------------------|
| `UrlBase`    | string | Base category URL; resulting URL = `UrlBase` + `SPresentTree.Id` (link `…default.asp?cls=spresenttrees&strid=`) |
| `UrlBaseImg` | string | Base product image URL; resulting URL = `UrlBaseImg` + `StoItem.Id` (or `Code`) |
| `Void`       | string | Reserved empty attribute (always NULL)                                       |

##### `SPresentTree` element (tree node / category)

| Field     | Type   | Description                                                                    |
|-----------|--------|--------------------------------------------------------------------------------|
| `Id`      | i4     | Node ID (`StrId`). For top-level tree types it is derived as `-2147483648 + type` |
| `IdP`     | i4     | Parent node ID; empty/NULL = root level                                        |
| `Sort`    | string | Sort key for ordering and hierarchy reconstruction — 3 chars per nesting level |
| `Name`    | string | Category name (localized — the partner's login language applies)               |
| `Tag`     | string | Optional node label/tag (only when filled)                                     |
| `ImgSize` | i8     | Category image size in B (only when an image is present)                       |
| `NameSEO` | string | Category SEO name (for URLs / search engines)                                  |
| `Note`    | string | Note on the node                                                               |
| `NameAdd` | string | Supplementary name / extending text                                            |
| `StrWWW`  | string | Custom WWW link for the category (if set)                                       |

##### Nested `StoItem` element (products in the node, 0..N)

| Field  | Type   | Description                                              |
|--------|--------|----------------------------------------------------------|
| `Id`   | i4     | Internal product ID (`StiId`); for building the image URL |
| `Code` | string | Product stock code (`StiCode`)                          |

> **Note on contents:** Only products that pass the standard WebService visibility filters
> (product stock/sale flags, partner row permissions) enter the output. The set of products may
> therefore differ between partners according to their permissions.


#### DocTrInv


An invoice transfer format — **"Document Transfer – Invoice"** — which, per the export definition,
is intended for **import into another I6 instance** (cross-system document exchange). It returns the
complete invoice including the VAT recap, line items, serial numbers (warranties), linked delivery
notes and the order, including end-customer data for dropshipment.

Unlike the product exports, it uses **`FOR XML EXPLICIT`** — the output is therefore strictly
**hierarchical** (nested elements with attributes), not a flat list:

```
Result
└── Invoice (invoice – header)
    ├── DocTaxSum   (VAT recap – 0..N)
    ├── InvItem     (invoice line items – 0..N)
    ├── Warranty    (serial numbers / warranties – 0..N)
    ├── Delivery    (delivery notes – 0..N)
    └── Order       (order + dropshipment end customer – 0..N)
```

**`resultType`:** `DocTrInv` (variants `_El` / `_Schema` — `‹verify›`; with `FOR XML EXPLICIT`
the three-variant convention may not apply the same way as with other exports)

**Filtering and scope:**

| Call                     | Behavior                                                                                  |
|--------------------------|-------------------------------------------------------------------------------------------|
| `GetResultByCode`        | `code` = invoice number (`InvCode`, e.g. `CRDC120009`)                                    |
| `GetResultByFromTo`      | `from`/`to` filters by the invoice creation date (`InvC`) and by the last confirmed delivery note (`DelDateConf`) |
| `GetResult` (no params)  | Returns only invoices created in the **last ~1–2 days** (`InvC >= today − 1`)             |

> The export is always **restricted to the logged-in partner's company** (`InvComId`) and returns
> only **completed, non-internal** invoices (`InvState = 1`, `InvInt = 0`). A partner thus sees only
> their own documents.

##### `Invoice` element (invoice header)

| Attribute     | Type        | Description                                                               |
|---------------|-------------|---------------------------------------------------------------------------|
| `Id`          | i4          | Internal invoice ID (`InvId`)                                             |
| `Code`        | string      | Invoice number                                                           |
| `ZCode`       | string      | Invoice number for dropship/end customer (only when present) `‹verify›`  |
| `CodeO`       | string      | External invoice number (number at the buyer, only when present)         |
| `SymCon`      | string      | Payment matching/variable symbol `‹verify›`                              |
| `Tag`         | string      | Invoice label/flag (only when present)                                   |
| `OrdId`       | i4          | ID of the linked order                                                   |
| `OrdCode`     | string      | Number of the linked order                                              |
| `OrdCodeO`    | string      | External order number                                                    |
| `OrdC`        | datetime    | Order creation date                                                     |
| `Type`        | —           | Invoice type (enumeration; e.g. invoice/credit note) `‹verify values›`   |
| `DateAcc`     | date        | Accounting case date / tax point (DUZP) `‹verify›`                       |
| `DateDue`     | date        | Due date                                                                |
| `CurCode`     | string      | Currency code (ISO, `UsdCodeE`)                                          |
| `Val`         | fixed.14.4  | Total value in home currency                                           |
| `ValCur`      | fixed.14.4  | Total value in invoice currency                                        |
| `ValRnd`      | fixed.14.4  | Rounding (home currency)                                               |
| `ValRndCur`   | fixed.14.4  | Rounding (invoice currency)                                            |
| `ValPaid`     | fixed.14.4  | Paid (home currency)                                                   |
| `ValPaidCur`  | fixed.14.4  | Paid (invoice currency)                                                |
| `ZVal`        | fixed.14.4  | Value for the end customer (dropship) `‹verify›`                        |
| `C`           | datetime    | Invoice creation date (created)                                        |
| `IdC`         | i4          | ID of the related invoice (original invoice for a credit note)         |
| `CodeC`       | string      | Number of the related invoice (original invoice for a credit note)     |

##### `DocTaxSum` element (VAT recap, 0..N)

| Attribute   | Type        | Description                                  |
|-------------|-------------|----------------------------------------------|
| `Id`        | i4          | Recap row ID (`DtsId`)                        |
| `TaxRate`   | fixed.14.4  | VAT rate (%)                                  |
| `Base`      | fixed.14.4  | Tax base (home currency)                     |
| `ValTax`    | fixed.14.4  | Tax amount (home currency)                   |
| `BaseCur`   | fixed.14.4  | Tax base (invoice currency)                  |
| `ValTaxCur` | fixed.14.4  | Tax amount (invoice currency)                |

##### `InvItem` element (invoice line items, 0..N)

| Attribute     | Type        | Description                                                            |
|---------------|-------------|------------------------------------------------------------------------|
| `Id`          | i4          | Invoice line item ID (`IniId`)                                         |
| `StiId`       | i4          | Product ID                                                            |
| `StiCode`     | string      | Product stock code                                                   |
| `StiCode2`    | string      | Alternative product code                                            |
| `StiPartNo`   | string      | Part number                                                          |
| `StiPartNo2`  | string      | Second part number                                                  |
| `StiEAN`      | string      | EAN (added per the partner's `WsEAN` parameter, otherwise empty)    |
| `StiEAN2`     | string      | Second EAN                                                          |
| `StiName`     | string      | Product name (stock)                                                |
| `Name`        | string      | Name on the invoice line (line's own text, only when present)       |
| `OrdId`       | i4          | Order ID of the item                                                |
| `OrdCode`     | string      | Order number of the item                                            |
| `OrdCodeO`    | string      | External order number of the item                                  |
| `OriC`        | datetime    | Creation date of the order item                                    |
| `Qty`         | number      | Quantity                                                            |
| `TaxRate`     | fixed.14.4  | Line VAT rate (%)                                                   |
| `Prc`         | fixed.14.4  | Unit price excl. VAT (home currency)                               |
| `PrcTax`      | fixed.14.4  | Unit price incl. VAT (home currency)                              |
| `CurCode`     | string      | Line currency code                                                 |
| `PrcCur`      | fixed.14.4  | Price excl. VAT (invoice currency)                                |
| `PrcTaxCur`   | fixed.14.4  | Price incl. VAT (invoice currency)                                |
| `PrcRefCur`   | fixed.14.4  | Recycling levy (invoice currency)                                 |
| `RefCode`     | string      | Recycling levy code                                               |
| `RefProCode`  | string      | Product code of the recycling levy                                |
| `PrcRefCur2`  | fixed.14.4  | Second recycling levy (invoice currency)                          |
| `RefCode2`    | string      | Code of the second recycling levy                                 |
| `RefProCode2` | string      | Product code of the second levy                                   |
| `ZPrc`        | fixed.14.4  | Price excl. VAT for the end customer (dropship)                   |
| `ZPrcTax`     | fixed.14.4  | Price incl. VAT for the end customer                              |
| `ZPrcRef`     | fixed.14.4  | Recycling levy – dropship                                         |
| `ZPrcRef2`    | fixed.14.4  | Second recycling levy – dropship                                  |
| `RefIs`       | boolean     | Flag that the row **is** a recycling levy (not a product)         |

##### `Warranty` element (serial numbers / warranties, 0..N)

| Attribute  | Type    | Description                                                 |
|------------|---------|-------------------------------------------------------------|
| `Id`       | i4      | Warranty ID (`WarId`)                                        |
| `Qty`      | number  | Quantity for the given serial number                       |
| `SerialNo` | string  | Serial number (only for products with SN tracking)         |
| `StiId`    | i4      | Product ID                                                 |
| `StiCode`  | string  | Product stock code                                         |
| `Dur`      | i4      | Warranty length (days; `NULL` = not specified)             |

##### `Delivery` element (delivery notes, 0..N)

| Attribute     | Type   | Description                                                       |
|---------------|--------|-------------------------------------------------------------------|
| `Id`          | i4     | Delivery note ID (`DelId`)                                        |
| `Code`        | string | Delivery note number                                            |
| `ZCode`       | string | Delivery note number for dropship (only when present)           |
| `OrdId`       | i4     | Order ID                                                        |
| `OrdCode`     | string | Order number                                                   |
| `CstId`       | i4     | Delivery address ID; if delivery to the company's registered seat = `-ComId` |
| `CstName`     | string | Delivery address name (otherwise the buyer company's name)      |
| `CstNameAdd`  | string | Name supplement                                                |
| `CstNameAdd2` | string | Second name supplement                                         |
| `CstStreet`   | string | Street                                                        |
| `CstCity`     | string | City                                                          |
| `CstPostCode` | string | Postal code                                                  |
| `CstCouName`  | string | Country                                                       |

##### `Order` element (order + dropshipment end customer, 0..N)

The `Cst*` address = the order's delivery address. The prefix **`ZCm*` / `ZCst*`** = the
**end customer's** data in direct dropshipment (where the goods are delivered on the partner's
behalf).

| Attribute      | Type     | Description                                                       |
|----------------|----------|-------------------------------------------------------------------|
| `Id`           | i4       | Order ID (`OrdId`)                                                |
| `Code`         | string   | Order number                                                    |
| `CodeO`        | string   | External order number (from the buyer)                          |
| `Tag`          | string   | Order label                                                     |
| `NoteExt`      | string   | External note on the order                                     |
| `C`            | datetime | Order creation date                                            |
| `OrwName`      | string   | Order status / processing method `‹verify›`                     |
| `CstId`        | i4       | Order delivery address ID (`-ComId` = company seat)            |
| `CstName`      | string   | Delivery address name                                          |
| `CstNameAdd`   | string   | Name supplement                                                |
| `CstNameAdd2`  | string   | Second name supplement                                         |
| `CstStreet`    | string   | Street                                                        |
| `CstCity`      | string   | City                                                          |
| `CstPostCode`  | string   | Postal code                                                  |
| `CstCouName`   | string   | Country                                                       |
| `ZDirect`      | —        | Direct dropshipment flag (shipped directly to the end customer) |
| `ZIPrn`        | —        | Flag to print the invoice into the shipment `‹verify›`          |
| `ZDPrn`        | —        | Flag to print the delivery note into the shipment `‹verify›`    |
| `ZCmId`        | i4       | End customer ID (dropship)                                     |
| `ZCmRegId`     | string   | End customer company registration number (IČO)                |
| `ZCmTaxNum`    | string   | End customer VAT number (DIČ)                                  |
| `ZCmName`      | string   | End customer name                                             |
| `ZCmNameAdd`   | string   | Name supplement                                               |
| `ZCmStreet`    | string   | Street                                                        |
| `ZCmCity`      | string   | City                                                          |
| `ZCmPostCode`  | string   | Postal code                                                   |
| `ZCmTitle`     | string   | Salutation / title                                            |
| `ZCmFName`     | string   | First name                                                    |
| `ZCmLName`     | string   | Last name                                                     |
| `ZCmTel`       | string   | Phone                                                         |
| `ZCmTelMob`    | string   | Mobile                                                        |
| `ZCmFax`       | string   | Fax                                                           |
| `ZCmEMail`     | string   | E-mail                                                        |
| `ZCstName`     | string   | Dropship delivery address – name (if it differs from `ZCm*`)   |
| `ZCstNameAdd`  | string   | Name supplement                                               |
| `ZCstNameAdd2` | string   | Second name supplement                                        |
| `ZCstStreet`   | string   | Street                                                        |
| `ZCstCity`     | string   | City                                                          |
| `ZCstPostCode` | string   | Postal code                                                   |
| `ZCstCouName`  | string   | Country                                                       |



#### StoItemPriceOrd

A price export — the partner's **order (purchase) prices**. It returns the order price, reference
(recycling and copyright) levies and the VAT rate, per the export definition.

Covers the pricing part of the `ProductNow` / `AllProductsNow` methods of the ALSO Product API
(availability is handled by `StoItemQtyFree`).




##### Filtering via `GetResultByCode` — `code` prefixes

This export supports **extended search** by code type. A prefix at the start of the `code` parameter
determines which field is filtered on (no prefix = main code `StiCode`):

| Prefix       | Filters by                                                | Example                          |
|--------------|-----------------------------------------------------------|----------------------------------|
| *(none)*     | Main stock code (`StiCode`)                               | `code=0320663`                   |
| `{StiId}`    | Internal product ID                                       | `code={StiId}685699`             |
| `{PartNo}`   | Part number                                               | `code={PartNo}GU605CX-QR149`     |
| `{PartNo2}`  | Second part number                                        | `code={PartNo2}90NR0M65-M007X0`  |
| `{CodeEAN}`  | EAN                                                       | `code={CodeEAN}4711636262347`    |
| `{ManName}`  | Manufacturer name (category of type `MAN`)               | `code={ManName}ASUS`             |
| `{CodeAll}`  | Any logged product code (`StoItemCode`)                   | `code={CodeAll}...`              |

> **Bulk query:** Multiple values separated by a tab (`\t`) can be placed in `code` — records for
> all of them are returned. The prefix is given once at the start and applies to the whole batch.


```xml
##### Example:
<?xml version="1.0" encoding="utf-8"?>
<Result>
    <StoItem Id="685699" Code="ASC00511" PartNo="GU605CX-QR149" PartNo2="90NR0M65-M007X0" EAN="4711636262347" PriceOrd="81144.2200" PriceEU="90900.8300" PriceRef="11.3400" PriceRef2="33.0000" TaxRate="21.0000" />
</Result>
```


##### Attributes of the `StoItem` element

| Field          | Type   | Description                                                                       |
|----------------|--------|-----------------------------------------------------------------------------------|
| `Id`           | i4     | Internal product ID (`StiId`)                                                     |
| `Code`         | string | Main SWS stock code                                                              |
| `Code2`        | string | Alternative/second code                                                          |
| `PartNo`       | string | Part (catalog) number                                                            |
| `PartNo2`      | string | Second part number                                                               |
| `EAN`          | string | EAN                                                                              |
| `EAN2`         | string | Second EAN                                                                       |
| `PriceOrd`     | money  | **Order (purchase) price** of the partner — the main price of this export         |
| `PriceEU`      | money  | End/recommended price (converted to the partner's currency, if configured) `‹verify meaning – MSRP?›` |
| `PriceRef`     | money  | Recycling levy linked to the product                                             |
| `PriceRefInfo` | money  | Informational value of the recycling levy                                        |
| `PriceRef2`    | money  | Second recycling levy                                                            |
| `PriceRef2Info`| money  | Informational value of the second levy                                           |
| `TaxRate`      | fixed.14.4 | VAT rate (%); in a cross-border regime recalculated by the destination country (`TaxMeCouId`) |
| `PriceFullIs`  | boolean | Flag that the partner is authorized to see the complete set of fixed prices (`Price*`) |
| `PriceList`    | money  | List (fixed) price — **only with special permission**, otherwise empty           |
| `Price0`       | money  | Fixed price level 0 — only with special permission                               |
| `Price1`       | money  | Fixed price level 1 — only with special permission                               |
| `Price2`       | money  | Fixed price level 2 — only with special permission                               |
| `Price3`       | money  | Fixed price level 3 — only with special permission                               |
| `Price4`       | money  | Fixed price level 4 — only with special permission                               |
| `Price5`       | money  | Fixed price level 5 — only with special permission                               |
| `PriceB2CMin`  | money  | Minimum B2C selling price (MAP), converted to the partner's currency             |

##### Notes on prices

- Prices are returned only for products with a **positive order price** (`PriceOrd > 0`).
- Depending on the partner's settings (`WsPriceCur`), prices may be converted to their **currency**
  at the current exchange rate; in that case `PriceEU` and `PriceB2CMin` are converted to the same
  currency.
- `PriceFullIs = 1` signals that the `PriceList`/`Price0–5` fields are available (subject to
  permission). Without permission these fields are empty even when `PriceFullIs = 0`.

> **Note for ALSO:** A standard partner receives `PriceOrd`, `PriceRef*`, `TaxRate` and
> `PriceB2CMin`; the `PriceList`/`Price0–5` set is an add-on tied to special permission.


#### CpsStiVal

Export of **product parameters (attributes)** — technical specifications in **name × value** format.
Per the export definition: *"Export parameters of StoItems – Name × Value only (filtered by Code of
StoItem)."* Each element corresponds to one parameter of one product; a product with N parameters
returns N elements. Together with `StoItemBase` it covers the `ProductFullInfo` method of the ALSO
Product API (the attribute part).



> **Usage recommendation:** The export is primarily intended for **filtering by product code**
> (`GetResultByCode`). Via `GetResult` it returns the parameters of all products — this can be a
> large volume of data.



##### Attributes of the `Row` element (one product parameter)

| Field        | Type   | Description                                                                     |
|--------------|--------|--------------------------------------------------------------------------------|
| `Id`         | i4     | ID of the specific parameter value on the product (`CpsId`) — the row's unique key |
| `StiId`      | i4     | Internal product ID                                                            |
| `StiCode`    | string | Main product stock code                                                        |
| `StiCode2`   | string | Alternative product code                                                       |
| `StiPartNo`  | string | Part number                                                                    |
| `StiPartNo2` | string | Second part number                                                             |
| `StiEAN`     | string | EAN (added per the partner's `WsEAN` parameter, otherwise empty)               |
| `StiEAN2`    | string | Second EAN                                                                      |
| `CpaId`      | i4     | Parameter definition ID (shared by all products with the same parameter)        |
| `Code`       | string | Parameter code (`CpaCode`) — the parameter's machine identifier                 |
| `Grp`        | string | Parameter group (`CpaGrp`) for grouping into sections (only when filled)        |
| `Name`       | string | Parameter name (localized) — e.g. "Diagonal", "Weight"                         |
| `NameAdd`    | string | Supplementary parameter description (only when present)                        |
| `Single`     | —      | Flag that the parameter has only a single value (only when non-null) `‹verify›` |
| `Ord`        | i4     | Parameter order for listing (only when non-zero)                              |
| `Value`      | string | **Parameter value** — either from an enumeration (`CpvValue`) or free text (`CpsTag`) |
| `ValueAdd`   | string | Supplementary value / note on the value (only when present)                    |
| `Measure`    | number | Unit of measure / numeric measure of the value (only when non-zero) `‹verify – unit vs. numeric value?›` |
| `CprOrd`     | i4     | Order of the value within the parameter's enumeration (only when non-zero)     |

#### AttSti

Export of **product attachments** — images, datasheets, documentation and other files linked to a
product. Each element = one attachment; a product with N attachments returns N elements. Covers the
`ProductImages` method of the ALSO Product API (and, in general, non-media attachments as well, if
they are logged on the product).



Supports the same set of prefixes as `StoItemPriceOrd` (see [Request format](#request-format)):
no prefix = `StiCode`, plus `{StiId}`, `{PartNo}`, `{PartNo2}`, `{CodeEAN}`, `{ManName}`, `{CodeAll}`.
Multiple values can be separated by a tab (`\t`).

```
GetResultByCode?resultType=AttSti&code={ManName}DATAWAY
```

##### Building the attachment URL

The `Url` field is returned **ready to use**, but it is produced in two ways depending on the
attachment type:

- **External attachment** (`AttUrl` contains `://`) → `Url` = the external link directly.
- **Internal attachment** (a file in I6) → `Url` = `UrlBaseImgGalery` + `Id`
  (i.e. `…/img.asp?attid=‹Id›`). The client can therefore use `Url` directly without assembling it.


##### Attributes of the `AttSti` element (one attachment)

| Field        | Type   | Description                                                                  |
|--------------|--------|-----------------------------------------------------------------------------|
| `Id`         | i4     | Attachment ID (`AttId`); also used to build `Url` for internal attachments    |
| `StiId`      | i4     | Internal product ID                                                          |
| `StiCode`    | string | Main product stock code                                                      |
| `StiCode2`   | string | Alternative product code                                                     |
| `StiPartNo`  | string | Part number                                                                  |
| `StiPartNo2` | string | Second part number                                                           |
| `StiEAN`     | string | EAN (added per the partner's `WsEAN` parameter, otherwise empty)             |
| `StiEAN2`    | string | Second EAN                                                                    |
| `Name`       | string | Attachment name (only when filled) — e.g. "Thumbnail", "Enlargement", caption |
| `Tag`        | string | Attachment label/type (only when present) — distinguishes the kind of attachment `‹verify values›` |
| `File`       | string | Attachment file name (without path; the directory is stripped from `AttUrl`)  |
| `Url`        | string | **Ready-to-use attachment URL** — external link, or internal `…/img.asp?attid=‹Id›` |
| `Size`       | i8     | Attachment size in bytes (may be empty for external ones)                    |
| `Sort`       | i2     | Attachment order for sorting (only when non-zero)                            |


#### CpsSti

Export of **product parameters including their definitions** — the normalized (relational) variant
of `CpsStiVal`. Per the export definition: *"Export parameters of StoItems include parameter's
definition."* Unlike `CpsStiVal`, which repeats the name and value on every row, `CpsSti` returns
the **parameter definitions and value enumeration separately** and the product assignments only
reference them by ID. Suitable when the client wants to build its own parametric database
(download the definitions once, products reference them). Together with `StoItemBase` it covers the
attribute part of the `ProductFullInfo` method of the ALSO Product API.



> ⚠️ **`CpsStiVal` vs. `CpsSti`:** If a plain "product → parameter → value" list is enough for you,
> use **`CpsStiVal`** (simpler, flat). Use `CpsSti` only when you also need the **definition
> metadata** (types, enumerations, language variants, category links).

##### Output structure

The output is **hierarchical** (`FOR XML EXPLICIT`). Under the `Result` root there are five separate
collections, each with `Row` elements distinguished by level:

```
Result
├── ConPar        → Row (parameter definitions)         [level 7]
├── ConParValue   → Row (value enumeration)             [level 8]
├── ConParRange   → Row (allowed values of a parameter) [level 9]
├── ConParSet     → Row (value assignments to products) [level 10]
└── ConParStr     → Row (parameter-to-category links)   [level 11]
```

Linking on the client side: `ConParSet.CpaId` → `ConPar.Id`, `ConParSet.CpvId` →
`ConParValue.Id`; `ConParRange` restricts which values (`CpvId`) belong to which parameter
(`CpaId`); `ConParStr` maps a parameter to a presentation-tree node (see `SPresentTree`).

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
| `NameE`   | string | English name                                                    |
| `NameAddE`| string | Supplementary English name                                      |
| `Note`    | string | Note on the parameter                                           |

##### `ConParValue` → `Row` — enumeration value

| Field      | Type   | Description                                              |
|------------|--------|----------------------------------------------------------|
| `Id`       | i4     | Value ID (`CpvId`)                                       |
| `Measure`  | number | Unit of measure / value measure `‹verify›`               |
| `Code`     | string | Machine code of the value                                |
| `Value`    | string | Value (localized)                                        |
| `ValueAdd` | string | Value supplement                                         |
| `ValueE`   | string | Value in English                                         |
| `ValueAddE`| string | Value supplement in English                              |

##### `ConParRange` → `Row` — allowed parameter value

| Field   | Type | Description                                       |
|---------|------|---------------------------------------------------|
| `Id`    | i4   | Link ID (`CprId`)                                 |
| `CpaId` | i4   | Parameter ID (`ConPar.Id`)                        |
| `CpvId` | i4   | Allowed value ID (`ConParValue.Id`)               |

##### `ConParSet` → `Row` — value assignment to a product

| Field     | Type   | Description                                                              |
|-----------|--------|--------------------------------------------------------------------------|
| `Id`      | i4     | Assignment ID (`CpsId`)                                                   |
| `StiId`   | i4     | Product ID                                                              |
| `CpaId`   | i4     | Parameter ID (`ConPar.Id`)                                              |
| `CpvId`   | i4     | Enumeration value ID (`ConParValue.Id`); empty = the value is free text  |
| `StiCode` | string | Product stock code                                                      |
| `Value`   | string | Value — from the enumeration (`CpvValue`) or free text (`CpsTag`)        |
| `Measure` | number | Numeric value measure (only when non-zero) `‹verify›`                    |

##### `ConParStr` → `Row` — parameter-to-category link

| Field     | Type   | Description                                                                  |
|-----------|--------|-----------------------------------------------------------------------------|
| `Id`      | i4     | Link ID (`CosId`)                                                           |
| `StrId`   | i4     | Presentation-tree node ID (`SPresentTree.Id`)                              |
| `CpaId`   | i4     | Parameter ID (`ConPar.Id`)                                                  |
| `StrSort` | string | Node sort key (3 chars/level) — determines the category where the parameter is used |

##### Notes

- Only parameters **published** for the web are returned (`CpaPublishWS`/`CpaPublish = 1`,
  `CpaHide = 0`) with a non-empty value; parameter types `CpaType IN (0, 2)`.
- The product set (`ConParSet`) respects the partner's **row permissions** — a different partner may
  see different products.
- `ConParStr` (the category link) returns only nodes from **visible** branches of the presentation
  tree.
