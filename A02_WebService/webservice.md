# WebService – Export & Order API

> **Účel dokumentu:** Kompletní popis stávajícího firemního webservisu (I6 / ERP) pro účely
> převzetí a integrace pod ALSO. Dokument popisuje architekturu, autentizaci, formát požadavků
> a odpovědí, konvence pojmenování a úplný katalog dostupných exportů.
>
> ⚠️ **Stav dokumentu:** Místa označená `‹…›` a **TODO** je třeba doplnit reálnými hodnotami
> (URL, přihlašovací údaje, ukázky odpovědí). Předpoklady jsou v textu výslovně označeny.

---

## Overview

WebService poskytuje partnerům strojový přístup k datům informačního systému **I6** – informace
o produktech (StoItem), skladové dostupnosti, cenách, obrázcích, parametrech, prezentačních
stromech (kategoriích), dokladech (faktury, dodací listy) a objednávkách.

Service je postavený jako **ASP.NET Web Service (`.asmx`)**. Data se získávají voláním jedné ze
tří univerzálních metod nad endpointem `Default.asmx`, kde se konkrétní export volí parametrem
`resultType`. Objednávky se zakládají samostatným endpointem `Order.asmx`.

Hlavní skupiny dat:

| Skupina | Příklady exportů | Popis |
|---|---|---|
| Produkty – základ | `StoItemBase`, `StoItemActive`, `StoItemList` | Základní informace o produktech |
| Sklad / dostupnost | `StoItemQtyFree`, `StoItemQtyFreeEx` | Skladové zásoby a termíny naskladnění |
| Ceny | `StoItemPriceOrd`, `StoItemPriceEU`, `StoItemPriceOrdCur` | Nákupní a koncové ceny |
| Parametry / atributy | `CpsSti`, `CpsStiVal`, `AttSti` | Parametry a přílohy produktů |
| Identifikátory | `StoItemEAN`, `StoItemEPREL`, `StoItemGPSR` | EAN, EPREL, GPSR a další |
| Kategorie / stromy | `SPresentTree`, `SCategorySys`, `StoItemNode` | Prezentační a systémové stromy |
| Vztahy | `StiRelation`, `StiRelationCO` | Vazby mezi produkty |
| Doklady | `DocTrInv`, `DocTrDel`, `DocTrExp`, `DocTrLoa` | Přenos dokladů |
| Objednávky | `Order`, `OrderDelivMode`, `OrderPaymentMode`, `OrderQueue` | Objednávky a číselníky k nim |
| B2C / nastavení | `ZCompany`, `ZShop`, `ComBank`, `ComShipTo` | B2C uživatelé a nastavení |
| Speciální (`X-…`) | `X-Cybex`, `X-HPTRON`, `X-ShopBaseCZC` | Zákaznicky upravené / dedikované feedy |

---

## Base URLs

> **TODO:** Doplnit reálné adresy.

| Prostředí | URL |
|---|---|
| Test | `https://‹TEST-HOST›/ws/` |
| Produkce | `https://‹PROD-HOST›/ws/` |

Hlavní endpointy:

| Endpoint | Účel |
|---|---|
| `Default.asmx` | Univerzální čtení dat (exporty) – metody `GetResult`, `GetResultByCode`, `GetResultByFromTo` |
| `Order.asmx` | Zakládání a správa objednávek – metoda `Create` |

---

## Authentication

> **Předpoklad / TODO k potvrzení:** Autentizace probíhá přes **wslogin** – přihlašovací jméno
> a heslo přidělené v systému I6 pro daného partnera. Doplnit přesný mechanismus (HTTP Basic,
> parametr v URL, hlavička, token).

Každý partner má v I6 přiřazena oprávnění (`ConId` v I6 databázi), která určují:

- ke kterým **exportům** (`resultType`) má přístup,
- jaká **data** vidí (ceny, sklady, kategorie podle nastavení účtu),
- zda má povoleny **speciální / fixní ceny** (`PriceList`, `Price0–6` jen na zvláštní oprávnění),
- jaká **časová okna** platí (individuální výjimky per `ComId`).

---

## Časová okna volání (Allowed days / hours)

Každý export má v I6 nastavené **povolené dny v týdnu** a **povolené hodiny**, kdy ho lze volat,
a to zvlášť pro každou ze tří metod (`GetResult`, `GetResultByCode`, `GetResultByFromTo`).

Exporty s omezeným oknem jsou dostupné **08:00–20:00 Po–Ne**. Exporty bez explicitního nastavení
jsou dostupné **nepřetržitě** (24/7). Konkrétní partneři (`ComId`) mohou mít individuální výjimky.

| Skupina | Exporty (výběr) | Okno volání |
|---|---|---|
| Produkty – základ (heavy) | `StoItemBase`, `StoItemSiv`, `StoItemNode`, `StoItemHook` | 08:00–20:00 |
| Ceny | `StoItemPriceOrd`, `StoItemPriceOrdCur` | 08:00–20:00 |
| Přílohy / parametry | `AttSti`, `CpsSti`, `StiPacking` | 08:00–20:00 |
| Doklady | `DocTrInv`, `DocTrDel`, `DocTrExp`, `DocTrLoa` | 08:00–20:00 |
| Feedy (e-shop) | `StoItemShop_El`, `StoItemShoptet_El` | 08:00–20:00 |
| Identifikátory | `StoItemEAN` | 08:00–20:00 |
| Konfigurátor | `Config` | 08:00–20:00 |
| Sklad / dostupnost | `StoItemQtyFree`, `StoItemQtyFreeEx`, `StoItemQtyFreeBO`, `…Qud`, `…QudT` | nepřetržitě |
| Ceny EU | `StoItemPriceEU` | nepřetržitě |
| Katalog / stromy | `SPresentTree`, `SCategorySys`, `StoItemList`, `SPresentTreeType` | nepřetržitě |
| Parametry | `CpsStiVal`, `AttCpsSti` | nepřetržitě |
| Vztahy | `StiRelation`, `StiRelationCO` | nepřetržitě |
| Objednávky | `Order`, `OrderDelivMode`, `OrderPaymentMode`, `OrderQueue`, `OrderToken` | nepřetržitě |
| Firma / adresy | `ComBank`, `ComShipTo`, `Company`, `ZCompany`, `ZShop` | nepřetržitě |
| Reklamace / servis | `Reclaim`, `Service` | nepřetržitě |
| Conet kanál | `ConetDocTrInv`, `ConetPriceOrd` | nepřetržitě (00–23) |
| Synchronizace | `StrStiSync` | nepřetržitě (ByCode, 00–23) |

> Mimo povolené okno service požadavek odmítne. Individuální výjimky (ComId) nastavuje správce I6.

---

## Obecný formát požadavku

### Čtení dat – `Default.asmx`

```
GET https://‹HOST›/ws/Default.asmx/GetResult?resultType=‹RESULT_TYPE›
GET https://‹HOST›/ws/Default.asmx/GetResultByCode?resultType=‹RESULT_TYPE›&Code=‹CODE›
GET https://‹HOST›/ws/Default.asmx/GetResultByFromTo?resultType=‹RESULT_TYPE›&From=‹FROM›&To=‹TO›
```

| Metoda | Popis | Parametry |
|---|---|---|
| `GetResult` | Vrátí kompletní export | `resultType` |
| `GetResultByCode` | Filtruje export podle kódu | `resultType`, `Code` |
| `GetResultByFromTo` | Filtruje export podle rozsahu (typicky datum změny / období) | `resultType`, `From`, `To` |

**Parametry:**

| Parametr | Typ | Povinný | Popis |
|---|---|---|---|
| `resultType` | String | Ano | Název exportu, např. `StoItemBase` (viz katalog níže) |
| `Code` | String | Pro `GetResultByCode` | Filtr – význam závisí na exportu (kód produktu, IdP stromu, podmínka…) |
| `From` | String/Date | Pro `GetResultByFromTo` | Začátek rozsahu (formát **TODO** – očekává se `YYYY-MM-DD[ HH:MM:SS]`) |
| `To` | String/Date | Pro `GetResultByFromTo` | Konec rozsahu |

> **Pozn. k `Code`:** Význam se liší podle exportu. Příklady:
> - `SPresentTree` → `Code` = `IdP` (filtrace větve stromu)
> - `StoItemList` → `Code` = podmínka ve tvaru `{StrId}XXX`, `{ScaId}XXX` nebo `{CpaId}XXX`
> - `StrStiSync` → `Code` = `Id` prezentačního stromu (`SPresentTree`)
> - `Reclaim`, `Service` → `Code` = identifikátor konkrétní reklamace / servisu

### Zakládání objednávek – `Order.asmx`

```
POST https://‹HOST›/ws/Order.asmx/Create
```

Tělo požadavku obsahuje objednávku se zbožím, dodací adresou (ShipTo) a B2C informacemi.
Hodnoty číselníků se získávají přes odpovídající exporty:

| Pole v objednávce | Číselník (export) |
|---|---|
| Způsob dopravy | `OrderDelivMode` |
| Způsob platby | `OrderPaymentMode` |
| Fronta / `@QudId` | `OrderQueue` |
| Dodací termín | `Queue` |

> **TODO:** Doplnit strukturu request payloadu metody `Create` (povinná/volitelná pole) a ukázku.

---

## Formát odpovědi

> **Předpoklad / TODO k potvrzení:** Service vrací **XML** (typické pro `.asmx` + varianty
> `_El` / `_Schema`). Pokud podporuje i JSON, doplnit.

Odpověď obsahuje sadu záznamů daného exportu. U každého exportu existuje varianta `_Schema`,
která vrací **definici (XSD schéma)** struktury místo dat – vhodné pro generování parserů na
straně příjemce.

**Ukázka (ilustrativní – TODO nahradit reálným výstupem):**

```xml
<StoItemBase>
  <Item Code="123456" Name="..." PartNo="..." EAN="..." Brand="..." />
  <Item Code="123457" Name="..." PartNo="..." EAN="..." Brand="..." />
</StoItemBase>
```

---

## Konvence pojmenování exportů

| Konvence | Význam |
|---|---|
| `Název` | Standardní export – data ve formě **atributů** (XML) |
| `Název_El` | Varianta téhož exportu s daty ve formě **elementů** místo atributů (stejný obsah, jiná serializace) |
| `Název_Schema` | Vrací **XSD schéma** exportu (definici struktury), nikoli data |
| `X-Název` | **Speciální / zákaznicky upravený** export (dedikovaný feed pro konkrétního partnera nebo účel – Cybex, HP Tronic, CZC, Shoptet…) |
| `Z…` | Exporty B2C oblasti / e-shopových nastavení (`ZCompany`, `ZShop`) |
| `Conet…` | Varianty přenášené kanálem **Conet** |

> **TODO k potvrzení:** Význam `_El` (element vs. atribut) a `_Schema` (XSD) je odvozený – prosím
> potvrdit.

---

## Katalog exportů – standardní

Sloupce: **ResultType** · **_El** (existuje element varianta) · **_Schema** (existuje schéma) ·
**Timeout** (max. doba zpracování v sekundách) · **Popis**.

### Přílohy

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `AttCpsSti` | ✓ | ✓ | 60 s | Export Attachments of StoItem's parameters. |
| `AttSti` | ✓ | ✓ | 300 s | Export Attachments of StoItems. ⏰ 08–20 |

### Firma

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `ComBank` | ✓ | ✓ | – | List of client's bank accounts. |
| `ComShipTo` | ✓ | ✓ | – | List of ShipTo address. |
| `Company` | ✓ | ✓ | 60 s | Export of B2B users. |
| `ZCompany` | ✓ | ✓ | 60 s | Export of B2C users. |
| `ZShop` | ✓ | ✓ | – | ZShop settings. |
| `Config` | ✓ | ✓ | 600 s | Configurator data. ⏰ 08–20 |

### Doklady

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `ConetDocTrInv` | – | ✓ | 120 s | Document Transfer – Invoice via Conet. |
| `DocTrDel` | – | ✓ | 90 s | Document Transfer – Delivery. ⏰ 08–20 |
| `DocTrExp` | ✓ | ✓ | 90 s | Document Transfer – Expedition (Format for import into I6). ⏰ 08–20 |
| `DocTrInv` | – | ✓ | 90 s | Document Transfer – Invoice (Format for import into I6). ⏰ 08–20 |
| `DocTrLoa` | – | ✓ | 90 s | Document Transfer – Loan. ⏰ 08–20 |
| `Reclaim` | – | – | 60 s | Export of Reclaim details. `GetResult` / `GetResultByCode` |
| `Service` | – | – | 60 s | Export of Service details. `GetResult` / `GetResultByCode` |

### Objednávky

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `ConetPriceOrd` | ✓ | ✓ | 120 s | Get order price via Conet. |
| `Order` | – | ✓ | 60 s | Export of Orders with Items include ShipTo and B2C informations. Without parameters returns all open orders. |
| `OrderDelivMode` | ✓ | ✓ | – | List of Delivery Mode for `Order.asmx/Create`. |
| `OrderPaymentMode` | ✓ | ✓ | – | List of Payment Mode for `Order.asmx/Create`. |
| `OrderQueue` | ✓ | ✓ | – | List of Queue for `Order.asmx/Create/Order/@QudId`. |
| `OrderToken` | ✓ | ✓ | – | List of info about Order Token(s). |
| `Queue` | ✓ | ✓ | – | Delivery term. |

### Produkty – základ

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `StoItemActive` | ✓ | ✓ | 600 s | List of active products. |
| `StoItemBase` | ✓ | ✓ | 600 s | Base informations about products. ⏰ 08–20 |
| `StoItemEAN` | ✓ | ✓ | – | Export of StoItem EAN. ⏰ 08–20 |
| `StoItemEPREL` | ✓ | ✓ | – | Export of StoItem EPREL Info. |
| `StoItemGPSR` | – | – | 600 s | Product's GPSR informations. |
| `StoItemHook` | ✓ | ✓ | 600 s | Hooked products. ⏰ 08–20 |
| `StoItemList` | ✓ | ✓ | 60 s | List of StoItems by Conditions in Code – `{StrId}XXX` / `{ScaId}XXX` / `{CpaId}XXX`. |
| `StoItemNode` | ✓ | ✓ | 600 s | Export references: StoItem – TreeNode. ⏰ 08–20 |
| `StoItemShop` | ✓ (jen `_El`) | – | 600 s | Base informations about products – shop feed. ⏰ 08–20 |
| `StoItemShoptet` | ✓ (jen `_El`) | – | 600 s | Base informations about products – Shoptet feed. ⏰ 08–20 |
| `StoItemSiv` | ✓ | ✓ | 600 s | Export for I6 module StoItemCom. ⏰ 08–20 |
| `StiPacking` | ✓ | ✓ | 60 s | Export StoItem's Packing. ⏰ 08–20 |
| `StrStiSync` | ✓ | ✓ | 120 s | Export for synchronisation of SPresentTree + StoItem. `Code` = Id of SPresentTree. |

### Produkty – ceny

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `StoItemPriceEU` | ✓ | ✓ | – | Export of End User's prices. |
| `StoItemPriceOrd` | ✓ | ✓ | 600 s | Order prices. Fix prices: PriceList, Price0-6 only on special permission. ⏰ 08–20 |
| `StoItemPriceOrdCur` | ✓ | ✓ | 600 s | Order prices in user's currency. ⏰ 08–20 |

### Produkty – sklad

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `StoItemQtyFree` | ✓ | ✓ | 15 s | Products on store. |
| `StoItemQtyFreeBO` | ✓ | ✓ | 15 s | Products on store + blocked. |
| `StoItemQtyFreeEx` | ✓ | ✓ | 30 s | Products on store with availability and next ship. |
| `StoItemQtyFreeExQud` | ✓ | ✓ | 40 s | Products on store with availability and next ship (itemized by QudId). |
| `StoItemQtyFreeExQudT` | ✓ | ✓ | 40 s | Products on store with availability and next ship (sum of all user's stores). |

### Produkty – feedy

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `SCategorySys` | ✓ | ✓ | 10 s | Catalog of system categories. |
| `SPresentTree` | ✓ | ✓ | 3000 s | Hiearchical presentation tree. `IdP` = parent (empty = top level), `Sort` = 3 chars/level. `ByCode` filters by `IdP`. |
| `SPresentTreeType` | ✓ | ✓ | 10 s | Type of SPresentTree (export complete tree type via `Code` = Id). |
| `StoItemAukroMPOrder_El` | ✓ (jen `_El`) | – | – | Internal export for mp.aukro.cz. |

### Parametry

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `CpsSti` | – | ✓ | 60 s | Export parameters of StoItems include parameter's definition. ⏰ 08–20 |
| `CpsStiVal` | ✓ | ✓ | 60 s | Export parameters of StoItems – Name x Value only (filtered by Code of StoItem). |

### Vztahy

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `StiRelation` | ✓ | ✓ | 60 s | Export Relations of StoItems. |
| `StiRelationCO` | ✓ | ✓ | 60 s | Export Relations-ConditionalOffer of StoItems. |

> **Legenda:** ⏰ 08–20 = export je dostupný pouze v čase 08:00–20:00 (výchozí okno; individuální partneři mohou mít výjimky). Ostatní jsou dostupné nepřetržitě.

---

## Katalog exportů – speciální (`X-…`) a B2C (`Z…`)

| ResultType | _El | _Schema | Timeout | Popis |
|---|:--:|:--:|---:|---|
| `X-AttSti` | ✓ | ✓ | 120 s | Special Export Attachments of StoItems with SWS w_x attachments. ⏰ 08–20 |
| `X-ConetAttSti` | ✓ | ✓ | 120 s | Special Export Attachments of StoItems with SWS w_x attachments (Conet). ⏰ 08–20 |
| `X-ConetCpsSti` | – | ✓ | 600 s | Export parameters of StoItems include parameter's definition (Conet). ⏰ 08–20 |
| `X-ConetSipPrcZMin` | ✓ | ✓ | 120 s | Minimum resale price (Conet). |
| `X-ConetStoItemQtyFreeEx` | ✓ | ✓ | 60 s | Products on store with availability and next ship (Conet). |
| `X-Cybex` | ✓ | ✓ | 900 s | Special export for Cybex. ⏰ 08–20 |
| `X-DeletedStiCode` | ✓ | ✓ | 120 s | List deleted StiCode from database (maybe used for new product). ⏰ 08–20 |
| `X-Diskont` | – | ✓ | 9000 s | Special export for Diskontni nakupy (included StiRelation, ImgGal, SPresentTree). |
| `X-DocTrDel` | – | ✓ | 90 s | Document Transfer – Delivery (Price with Fee). ⏰ 08–20 |
| `X-EntecCompany` | ✓ | ✓ | 300 s | Companies from Entec db. |
| `X-EntecContact` | ✓ | ✓ | 300 s | Contacts from Entec db. |
| `X-GetLicKey` | ✓ | ✓ | 300 s | Get License Key for Order Id. |
| `X-GetToken` | ✓ | ✓ | 300 s | Get MS ESD token for Order Id. |
| `X-HPTRON` | ✓ | ✓ | 900 s | Special export for HP Tronic. ⏰ 08–20 |
| `X-IniPrevDay` | ✓ | ✓ | 240 s | Invoice items from previous day. ⏰ 08–20 |
| `X-OpenOrdItemWithQueDateShip` | ✓ | ✓ | 300 s | Open Orders items with estimated ship date. |
| `X-OrdTrack` | ✓ | ✓ | 60 s | Get expedition URL track for order code. |
| `X-RatePL` | ✓ | ✓ | – | Get rate used in Price List. |
| `X-ShopBaseCZC` | ✓ | ✓ | 1200 s | Base informations about products – CZC data feed. ⏰ 08–20 |
| `X-SipPrcZMin` | ✓ | ✓ | 120 s | Minimum resale price. |
| `X-SpcStoItemBase` | ✓ | ✓ | 1800 s | Customizable feed StoItemBase (configured per wslogin in I6). ⏰ 08–20 |
| `X-SpcStoItemBrother` | ✓ | ✓ | 1200 s | Special feed for Venim. |
| `X-SPresentTree_SK` | ✓ | ✓ | 600 s | Hiearchical presentation tree (SK). |
| `X-StiIcecat` | ✓ | ✓ | 120 s | Export Icecat dealer URL. ⏰ 08–20 |
| `X-StiImgChng` | ✓ | ✓ | 300 s | Products – last date image change. ⏰ 08–20 |
| `X-StoItemBase_SK` | ✓ | ✓ | 1200 s | Base informations about products (SK). |
| `X-StoItemBaseNoteBR` | ✓ | ✓ | 1200 s | Base informations about products with BR tag in Note. ⏰ 08–20 |
| `X-StoItemBaseReal` | ✓ | ✓ | 1200 s | Base informations about products. ⏰ 08–20 |
| `X-StoItemBaseWithoutPriceStock` | ✓ | ✓ | 1200 s | Base informations about products without prices and stock info. ⏰ 08–20 |
| `X-StoItemEAN` | ✓ | ✓ | 180 s | EAN code(s) of products. ⏰ 08–20 |
| `X-StoItemEnhance` | ✓ | ✓ | 1200 s | Enhanced informations about products. ⏰ 08–20 |
| `X-StoItemGPSR` | ✓ | ✓ | 60 s | Product's GPSR informations (new version). |
| `X-StoItemKBProgres` | ✓ | ✓ | 600 s | Modified StoItemBase for special customers. ⏰ 08–20 |
| `X-StoItemNameDesc` | ✓ | ✓ | 900 s | Informations about products. (Code, name, note). ⏰ 08–20 |
| `X-StoItemOriBlocked` | ✓ | ✓ | 300 s | Products blocked on orders. |
| `X-StoItemPriceEU` | ✓ | ✓ | – | Export of End User's prices. ⏰ 08–20 |
| `X-StoItemPriceOrd` | ✓ | ✓ | 1200 s | Order prices with PartNo and EAN. Fix prices: PriceList, Price0-6 only on special permission. ⏰ 08–20 |
| `X-StoItemPriceOrdCur` | ✓ | ✓ | 240 s | Alternate StoItemPriceOrdCur, ByFromTo change today 5–21. |
| `X-StoItemPriceOrdCZCEUR` | ✓ | ✓ | 1200 s | Order prices + price in EUR. Fix prices: PriceList, Price0-6 only on special permission. |
| `X-StoItemQtyFree` | ✓ | ✓ | 300 s | Products on store. (Code + PartNo, EAN). |
| `X-StoItemQtyFreeBOHPT` | ✓ | ✓ | 300 s | Products on store + on block orders + next ship. |
| `X-StoItemQtyFreeReal` | ✓ | ✓ | 300 s | Products on store. |
| `X-StoItemQtyFreeRealX` | – | ✓ | 300 s | Combined product information for XML feed. |
| `X-StoItemQtyFreeRealX2` | – | ✓ | 300 s | Combined product information for XML feed. |
| `X-StoItemQtyFreeShip` | ✓ | ✓ | 300 s | Products on store with availability and next ship. |
| `X-StoItemQtyFreeWES` | ✓ | ✓ | 300 s | Products on store and external store. |
| `X-StoItemQtyFreeWithQtyOriBlock` | ✓ | ✓ | 300 s | Products on store + on block orders. |
| `X-StoItemQtyFreeWithQtyOriBlockEx` | ✓ | ✓ | 300 s | Products on store + on block orders + next ship. |
| `X-StoItemSiv` | ✓ | ✓ | 600 s | TEST VERSION – Export for I6 module StoItemCom. |
| `X-StoItemThin` | ✓ | ✓ | 900 s | Thin informations about products. (name, pn, price, stock). |
| `X-StoItemWarType` | ✓ | ✓ | 60 s | Extra warranty type info. ⏰ 08–20 |
| `X-StoItemXXLDelivModePrc` | ✓ | ✓ | 60 s | DelivMode Price for XXL products. ⏰ 08–20 |
| `X-XiaomiSNSale` | ✓ | ✓ | 300 s | SN of sold products Xiaomi. |

> **Legenda:** ⏰ 08–20 = export je dostupný pouze v čase 08:00–20:00 (výchozí okno; individuální partneři mohou mít výjimky). Ostatní jsou dostupné nepřetržitě.

---

## Detailní popis nejpoužívanějších exportů

> Pořadí dle četnosti reálného používání (TOP 20). Pole jsou odvozena z účelu exportu –
> **TODO:** doplnit přesné názvy a typy polí z reálné odpovědi nebo z `_Schema` varianty.

### 1. `StoItemBase` — Base informations about products
Nejčastější export. Vrací základní katalogové údaje o produktech.

- **Timeout:** 600 s
- **Okno volání:** 08:00–20:00
- **Metody:** `GetResult` · `GetResultByCode` (Code = StiCode) · `GetResultByFromTo` (From/To = datum změny)

```
GET .../Default.asmx/GetResult?resultType=StoItemBase
GET .../Default.asmx/GetResultByCode?resultType=StoItemBase&Code=‹STICODE›
GET .../Default.asmx/GetResultByFromTo?resultType=StoItemBase&From=‹FROM›&To=‹TO›
```

Očekávaná pole (k potvrzení): `Code`, `Name`, `PartNo`, `EAN`, `Brand`, `Category`,
`Weight`, `Note`, `ChangeDate`. (Varianty bez cen/skladu viz `X-StoItemBaseWithoutPriceStock`.)

---

### 2. `StoItemQtyFree` — Products on store
Aktuální volné množství na skladě. Velmi rychlý export (timeout 15 s).

- **Timeout:** 15 s
- **Okno volání:** nepřetržitě
- **Metody:** `GetResult` · `GetResultByCode` (Code = StiCode)

```
GET .../Default.asmx/GetResult?resultType=StoItemQtyFree
GET .../Default.asmx/GetResultByCode?resultType=StoItemQtyFree&Code=‹STICODE›
```

Očekávaná pole: `Code`, `QtyFree`. Rozšířené varianty:

| Export | Timeout | Popis |
|---|---:|---|
| `StoItemQtyFreeEx` | 30 s | + termín nejbližšího naskladnění |
| `StoItemQtyFreeBO` | 15 s | + blokované množství |
| `StoItemQtyFreeExQud` | 40 s | + naskladnění, rozpad dle `QudId` |
| `StoItemQtyFreeExQudT` | 40 s | + naskladnění, součet všech skladů uživatele |

---

### 3. `StoItemSiv` — Export for I6 module StoItemCom
Export určený pro modul StoItemCom v I6.

- **Timeout:** 600 s
- **Okno volání:** 08:00–20:00
- **Metody:** `GetResult` · `GetResultByCode` · `GetResultByFromTo`

> **TODO:** Popsat pole výstupu.

---

### 4. `SPresentTree` — Hiearchical presentation tree
Hierarchická stromová struktura produktů (kategorie e-shopu). Největší timeout v celém systému.

- **Timeout:** 3000 s
- **Okno volání:** nepřetržitě
- **Metody:** `GetResult` · `GetResultByCode` (Code = `IdP` – filtruje větev)

```
GET .../Default.asmx/GetResult?resultType=SPresentTree
GET .../Default.asmx/GetResultByCode?resultType=SPresentTree&Code=‹IdP›
```

Pole: `Id`, `IdP` (rodič – prázdné = nejvyšší úroveň), `Name`, `Sort` (3 znaky na úroveň,
např. `AAA` = 1. úroveň, `AAABBB` = 2. úroveň). `ByCode` filtruje větev dle `IdP`.

Typ stromu (celý typ): `resultType=SPresentTreeType&Code=‹Id›` (timeout 10 s).

---

### 5. `DocTrInv` — Document Transfer – Invoice
Faktura ve formátu pro import do I6.

- **Timeout:** 90 s
- **Okno volání:** 08:00–20:00
- **Metody:** `GetResult` · `GetResultByCode` · `GetResultByFromTo`

> **TODO:** Popsat hlavičku a položky dokladu.

---

### 6. `StoItemPriceOrd` — Order prices
Objednací (nákupní) ceny produktů. Fixní ceny (`PriceList`, `Price0–6`) jen na zvláštní oprávnění.

- **Timeout:** 600 s
- **Okno volání:** 08:00–20:00
- **Metody:** `GetResult` · `GetResultByCode` · `GetResultByFromTo`

```
GET .../Default.asmx/GetResult?resultType=StoItemPriceOrd
GET .../Default.asmx/GetResultByFromTo?resultType=StoItemPriceOrd&From=‹FROM›&To=‹TO›
```

Varianta v měně uživatele: `StoItemPriceOrdCur` (timeout 600 s, okno 08–20).
Rozšířená varianta s PartNo a EAN: `X-StoItemPriceOrd` (timeout 1200 s).

---

### 7. `CpsStiVal` — Export parameters of StoItems – Name x Value only
Parametry StoItemů zúžené na dvojice název–hodnota, filtrované kódem StoItemu.

- **Timeout:** 60 s
- **Okno volání:** nepřetržitě
- **Metody:** `GetResult` · `GetResultByCode` (Code = StiCode)

---

### 8. `StiRelation` — Export Relations of StoItems
Vazby mezi StoItemy (příslušenství, alternativy…).

- **Timeout:** 60 s
- **Okno volání:** nepřetržitě
- **Metody:** `GetResult`

Varianta `StiRelationCO` = Conditional Offer (timeout 60 s).

---

### 9. `AttSti` — Export Attachments of StoItems
Přílohy (dokumenty/obrázky) navázané na StoItemy.

- **Timeout:** 300 s
- **Okno volání:** 08:00–20:00
- **Metody:** `GetResult` · `GetResultByCode` · `GetResultByFromTo`

Varianta `AttCpsSti` = přílohy parametrů (timeout 60 s, nepřetržitě).

---

### 10. `CpsSti` — Export parameters of StoItems incl. definition
Parametry StoItemů včetně definice parametru (na rozdíl od `CpsStiVal`).

- **Timeout:** 60 s
- **Okno volání:** 08:00–20:00
- **Metody:** `GetResult` · `GetResultByCode` · `GetResultByFromTo`

---

### 11. `StoItemEAN` — Export of StoItem EAN
EAN kód(y) produktů.

- **Timeout:** –
- **Okno volání:** 08:00–20:00
- **Metody:** `GetResult`

---

### 12. `StoItemQtyFreeEx` — Products on store with availability and next ship
Skladová dostupnost rozšířená o dostupnost a termín nejbližšího naskladnění.

- **Timeout:** 30 s
- **Okno volání:** nepřetržitě
- **Metody:** `GetResult` · `GetResultByCode`

---

### 13. `StrStiSync` — Export for synchronisation of SPresentTree + StoItem
Export pro synchronizaci `SPresentTree` + `StoItem`. Jako `Code` se posílá Id stromu SPresentTree.

- **Timeout:** 120 s
- **Okno volání:** nepřetržitě (00–23, všechny dny)
- **Metody:** `GetResultByCode` (povinný – `Code` = Id stromu)

```
GET .../Default.asmx/GetResultByCode?resultType=StrStiSync&Code=‹TREE_ID›
```

---

### 14. `StoItemShop` (`_El`) — Base informations about products – shop feed
Základní informace o produktech ve formě feedu pro e-shop (timeout 600 s, okno 08–20).
Varianta pro Shoptet: `StoItemShoptet_El` (timeout 600 s, okno 08–20).

---

### 15. `StoItemActive` — List of active products
Seznam aktivních produktů.

- **Timeout:** 600 s
- **Okno volání:** nepřetržitě
- **Metody:** `GetResult`

---

### 16. Varianty `_El` (`StoItemBase_El`, `StoItemQtyFree_El`, `CpsStiVal_El`, `SPresentTree_El`)
Element-based varianty výše uvedených exportů – stejný obsah, data jako XML elementy místo atributů.

---

### 17. Varianty `_Schema` (`AttSti_Schema`, `StoItemBase_Schema`)
Vrací XSD schéma struktury daného exportu. Vhodné pro vygenerování parserů u příjemce.

---

## Otevřené body k doplnění (TODO)

1. **Base URL** – reálné test + produkční adresy.
2. **Autentizace** – přesný mechanismus (wslogin / Basic / token), kde se předává.
3. **Formát odpovědi** – potvrdit XML (případně JSON), přiložit ukázky.
4. **`Order.asmx/Create`** – struktura request payloadu, povinná pole, ukázka.
5. **Reálné ukázky odpovědí** – alespoň pro TOP exporty (`StoItemBase`, `StoItemQtyFree`,
   `StoItemPriceOrd`, `SPresentTree`, `DocTrInv`).
6. **Pole exportů** – doplnit z `_Schema` variant (názvy, typy, povinnost).
7. **Chybové stavy** – návratové kódy / formát chyb.
8. **Stránkování / limity** – zda existují limity počtu záznamů a jak se stránkuje.
