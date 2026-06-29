# WebService – Export & Order API

> **Účel dokumentu:** Kompletní popis stávajícího firemního webservisu (I6 / ERP) pro účely
> převzetí a integrace pod ALSO. Dokument popisuje architekturu, autentizaci, formát požadavků
> a odpovědí, konvence pojmenování a úplný katalog dostupných exportů.
>
> ⚠️ **Stav dokumentu:** První verze. Místa označená `‹…›` a **TODO** je třeba doplnit reálnými
> hodnotami (URL, přihlašovací údaje, ukázky odpovědí). Předpoklady jsou v textu výslovně označeny.

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
> a heslo přidělené v systému I6 pro daného partnera (v některých exportech řízeno parametrem
> `wslogin`). Doplnit přesný mechanismus (HTTP Basic, parametr v URL, hlavička, token).

Každý partner má v I6 přiřazena oprávnění, která určují:

- ke kterým **exportům** (`resultType`) má přístup,
- jaká **data** vidí (ceny, sklady, kategorie podle nastavení účtu),
- zda má povoleny **speciální / fixní ceny** (`PriceList`, `Price0–6` jen na zvláštní oprávnění).

---

## Časová okna volání (Allowed days / hours)

Každý export má v I6 nastavené **povolené dny v týdnu** a **povolené hodiny**, kdy ho lze volat,
a to zvlášť pro každou ze tří metod (`GetResult`, `GetResultByCode`, `GetResultByFromTo`).

- Dny v týdnu: `01`–`07` (Po–Ne)
- Hodiny: `01`–`24` (resp. `00`)

Mimo povolené okno service požadavek odmítne. Konkrétní okna jsou nastavena per export per partner
podle zátěže – **TODO:** doplnit reálná okna pro produkční nasazení (defaultně bývá povoleno
nepřetržitě, tj. všechny dny a hodiny).

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
**Popis**. Podporu metod `GetResult` / `ByCode` / `ByFromTo` doplnit dle reálné konfigurace
(**TODO** – ve zdroji byla pro všechny záznamy nastavena plná časová okna).

| ResultType | _El | _Schema | Popis |
|---|:--:|:--:|---|
| `AttCpsSti` | ✓ | ✓ | Přílohy parametrů StoItemu |
| `AttSti` | ✓ | ✓ | Přílohy StoItemů |
| `ComBank` | ✓ | ✓ | Seznam bankovních účtů klienta |
| `ComShipTo` | ✓ | ✓ | Seznam dodacích adres (ShipTo) |
| `ConetDocTrInv` | – | ✓ | Přenos dokladu – faktura přes Conet |
| `ConetPriceOrd` | ✓ | ✓ | Cena objednávky přes Conet |
| `Config` | ✓ | ✓ | Data konfigurátoru |
| `CpsSti` | – | ✓ | Parametry StoItemů včetně definice parametru |
| `CpsStiVal` | ✓ | ✓ | Parametry StoItemů – pouze Název × Hodnota (filtr dle kódu StoItemu) |
| `DocTrDel` | – | ✓ | Přenos dokladu – dodací list |
| `DocTrExp` | ✓ | ✓ | Přenos dokladu – expedice (formát pro import do I6) |
| `DocTrInv` | – | ✓ | Přenos dokladu – faktura (formát pro import do I6) |
| `DocTrLoa` | – | ✓ | Přenos dokladu – zápůjčka |
| `Order` | – | ✓ | Export objednávek s položkami vč. ShipTo a B2C. Bez parametru vrací všechny otevřené objednávky |
| `OrderDelivMode` | ✓ | ✓ | Číselník způsobů dopravy pro `Order.asmx/Create` |
| `OrderPaymentMode` | ✓ | ✓ | Číselník způsobů platby pro `Order.asmx/Create` |
| `OrderQueue` | ✓ | ✓ | Číselník front pro `Order.asmx/Create/Order/@QudId` |
| `OrderToken` | ✓ | ✓ | Informace o tokenech objednávek |
| `Queue` | ✓ | ✓ | Dodací termín |
| `Reclaim` | – | – | Detaily reklamací (`GetResult` / `GetResultByCode`) |
| `SCategorySys` | ✓ | ✓ | Katalog systémových kategorií |
| `Service` | – | – | Detaily servisů (`GetResult` / `GetResultByCode`) |
| `SPresentTree` | ✓ | ✓ | Hierarchický prezentační strom StoItemů (`IdP` = rodič, `Sort` = 3 znaky/úroveň; ByCode filtruje dle `IdP`) |
| `SPresentTreeType` | ✓ | ✓ | Typ SPresentTree (export celého typu stromu: `resultType=SPresentTree&code=Id`) |
| `StiPacking` | ✓ | ✓ | Balení StoItemu |
| `StiRelation` | ✓ | ✓ | Vztahy mezi StoItemy |
| `StiRelationCO` | ✓ | ✓ | Vztahy – Conditional Offer |
| `StoItemActive` | ✓ | ✓ | Seznam aktivních produktů |
| `StoItemBase` | ✓ | ✓ | Základní informace o produktech |
| `StoItemEAN` | ✓ | ✓ | EAN kódy StoItemů |
| `StoItemEPREL` | ✓ | ✓ | EPREL informace StoItemu |
| `StoItemGPSR` | – | – | GPSR informace produktu |
| `StoItemHook` | ✓ | ✓ | „Zaháknuté" produkty (hooked) |
| `StoItemList` | ✓ | ✓ | Seznam StoItemů dle podmínky v `Code` (`{StrId}XXX` / `{ScaId}XXX` / `{CpaId}XXX`) |
| `StoItemNode` | ✓ | ✓ | Vazby StoItem – TreeNode |
| `StoItemPriceEU` | ✓ | ✓ | Koncové ceny (End User) |
| `StoItemPriceOrd` | ✓ | ✓ | Nákupní (objednací) ceny |
| `StoItemPriceOrdCur` | ✓ | ✓ | Nákupní ceny v měně uživatele |
| `StoItemQtyFree` | ✓ | ✓ | Skladová dostupnost |
| `StoItemQtyFreeBO` | ✓ | ✓ | Skladová dostupnost + blokované |
| `StoItemQtyFreeEx` | ✓ | ✓ | Dostupnost + termín nejbližšího naskladnění |
| `StoItemQtyFreeExQud` | ✓ | ✓ | Dostupnost + naskladnění (rozpad dle `QudId`) |
| `StoItemQtyFreeExQudT` | ✓ | ✓ | Dostupnost + naskladnění (součet všech skladů uživatele) |
| `StoItemShop` | ✓ (jen `_El`) | – | Základní info o produktech – feed pro e-shop |
| `StoItemShoptet` | ✓ (jen `_El`) | – | Základní info o produktech – feed pro Shoptet |
| `StoItemSiv` | ✓ | ✓ | Export pro I6 modul StoItemCom |
| `StrStiSync` | ✓ | ✓ | Synchronizace SPresentTree + StoItem (`Code` = Id stromu SPresentTree) |

---

## Katalog exportů – speciální (`X-…`) a B2C (`Z…`)

| ResultType | _El | _Schema | Popis |
|---|:--:|:--:|---|
| `X-AttSti` | ✓ | ✓ | Speciální přílohy StoItemů (SWS w_x přílohy) |
| `X-ConetAttSti` | ✓ | ✓ | Speciální přílohy StoItemů (Conet, SWS w_x) |
| `X-ConetCpsSti` | – | ✓ | Parametry StoItemů včetně definice (Conet) |
| `X-ConetSipPrcZMin` | ✓ | ✓ | Minimální prodejní cena (Conet) |
| `X-ConetStoItemQtyFreeEx` | ✓ | ✓ | Dostupnost + naskladnění (Conet) |
| `X-Cybex` | ✓ | ✓ | Speciální export pro Cybex |
| `X-DeletedStiCode` | ✓ | ✓ | Seznam smazaných StiCode (lze využít pro nový produkt) |
| `X-Diskont` | – | ✓ | Export pro Diskontní nákupy (vč. StiRelation, ImgGal, SPresentTree) |
| `X-DocTrDel` | – | ✓ | Přenos dokladu – dodací list (cena s poplatkem) |
| `X-EntecCompany` | ✓ | ✓ | Firmy z Entec DB |
| `X-EntecContact` | ✓ | ✓ | Kontakty z Entec DB |
| `X-GetLicKey` | ✓ | ✓ | Licenční klíč pro Order Id |
| `X-GetToken` | ✓ | ✓ | MS ESD token pro Order Id |
| `X-HPTRON` | ✓ | ✓ | Speciální export pro HP Tronic |
| `X-IniPrevDay` | ✓ | ✓ | Položky faktur z předchozího dne |
| `X-OpenOrdItemWithQueDateShip` | ✓ | ✓ | Položky otevřených objednávek s odhadem data expedice |
| `X-OrdTrack` | ✓ | ✓ | URL pro sledování zásilky dle kódu objednávky |
| `X-RatePL` | ✓ | ✓ | Kurz použitý v ceníku |
| `X-ShopBaseCZC` | ✓ | ✓ | Základní info o produktech – feed pro CZC |
| `X-SipPrcZMin` | ✓ | ✓ | Minimální prodejní cena |
| `X-SpcStoItemBase` | ✓ | ✓ | Konfigurovatelný feed StoItemBase (dle nastavení wslogin v I6) |
| `X-SpcStoItemBrother` | ✓ | ✓ | Speciální feed pro Venim |
| `X-SPresentTree_SK` | ✓ | ✓ | Hierarchický prezentační strom (SK) |
| `X-StiIcecat` | ✓ | ✓ | Icecat dealer URL |
| `X-StiImgChng` | ✓ | ✓ | Produkty – datum poslední změny obrázku |
| `X-StoItemBase_SK` | ✓ | ✓ | Základní info o produktech (SK) |
| `X-StoItemBaseNoteBR` | ✓ | ✓ | Základní info s tagem BR v poznámce |
| `X-StoItemBaseReal` | ✓ | ✓ | Základní info o produktech |
| `X-StoItemBaseWithoutPriceStock` | ✓ | ✓ | Základní info bez cen a skladu |
| `X-StoItemEAN` | ✓ | ✓ | EAN kódy produktů |
| `X-StoItemEnhance` | ✓ | ✓ | Rozšířené informace o produktech |
| `X-StoItemGPSR` | ✓ | ✓ | GPSR informace produktu (nová verze) |
| `X-StoItemKBProgres` | ✓ | ✓ | Upravený StoItemBase pro speciální zákazníky |
| `X-StoItemNameDesc` | ✓ | ✓ | Informace o produktech (kód, název, poznámka) |
| `X-StoItemOriBlocked` | ✓ | ✓ | Produkty blokované na objednávkách |
| `X-StoItemPriceEU` | ✓ | ✓ | Koncové ceny (End User) |
| `X-StoItemPriceOrd` | ✓ | ✓ | Nákupní ceny s PartNo a EAN (fixní ceny PriceList/Price0–6 jen na oprávnění) |
| `X-StoItemPriceOrdCur` | ✓ | ✓ | Alternativní StoItemPriceOrdCur, ByFromTo změna dnes 5–21 |
| `X-StoItemPriceOrdCZCEUR` | ✓ | ✓ | Nákupní ceny + cena v EUR |
| `X-StoItemQtyFree` | ✓ | ✓ | Skladová dostupnost (kód + PartNo, EAN) |
| `X-StoItemQtyFreeBOHPT` | ✓ | ✓ | Dostupnost + blokované objednávky + naskladnění |
| `X-StoItemQtyFreeReal` | ✓ | ✓ | Skladová dostupnost |
| `X-StoItemQtyFreeRealX` | – | ✓ | Kombinované info produktu pro XML feed |
| `X-StoItemQtyFreeRealX2` | – | ✓ | Kombinované info produktu pro XML feed |
| `X-StoItemQtyFreeShip` | ✓ | ✓ | Dostupnost + naskladnění |
| `X-StoItemQtyFreeWES` | ✓ | ✓ | Dostupnost na vlastním i externím skladu |
| `X-StoItemQtyFreeWithQtyOriBlock` | ✓ | ✓ | Dostupnost + blokované objednávky |
| `X-StoItemQtyFreeWithQtyOriBlockEx` | ✓ | ✓ | Dostupnost + blokované objednávky + naskladnění |
| `X-StoItemSiv` | ✓ | ✓ | TESTOVACÍ verze – export pro I6 modul StoItemCom |
| `X-StoItemThin` | ✓ | ✓ | Zkrácené info (název, PN, cena, sklad) |
| `X-StoItemWarType` | ✓ | ✓ | Typ rozšířené záruky |
| `X-StoItemXXLDelivModePrc` | ✓ | ✓ | Cena způsobu dopravy pro XXL produkty |
| `X-XiaomiSNSale` | ✓ | ✓ | Sériová čísla prodaných produktů Xiaomi |
| `ZCompany` | ✓ | ✓ | Export B2C uživatelů |
| `ZShop` | ✓ | ✓ | Nastavení ZShop |

---

## Detailní popis nejpoužívanějších exportů

> Pořadí dle četnosti reálného používání (TOP 20). Pole jsou odvozena z účelu exportu –
> **TODO:** doplnit přesné názvy a typy polí z reálné odpovědi nebo z `_Schema` varianty.

### 1. `StoItemBase` — Základní informace o produktech
Nejčastější export. Vrací základní katalogové údaje o produktech.

```
GET .../Default.asmx/GetResult?resultType=StoItemBase
GET .../Default.asmx/GetResultByCode?resultType=StoItemBase&Code=‹STICODE›
GET .../Default.asmx/GetResultByFromTo?resultType=StoItemBase&From=‹FROM›&To=‹TO›
```

Očekávaná pole (k potvrzení): `Code`, `Name`, `PartNo`, `EAN`, `Brand`, `Category`,
`Weight`, `Note`, `ChangeDate`. (Varianty bez cen/skladu viz `X-StoItemBaseWithoutPriceStock`.)

### 2. `StoItemQtyFree` — Skladová dostupnost
Aktuální volné množství na skladě.

```
GET .../Default.asmx/GetResult?resultType=StoItemQtyFree
GET .../Default.asmx/GetResultByCode?resultType=StoItemQtyFree&Code=‹STICODE›
```

Očekávaná pole: `Code`, `QtyFree`. Rozšířené varianty: `StoItemQtyFreeEx` (+ termín naskladnění),
`StoItemQtyFreeBO` (+ blokované), `…ExQud` / `…ExQudT` (rozpad / součet dle skladů).

### 3. `StoItemSiv` — Export pro I6 modul StoItemCom
Export určený pro modul StoItemCom v I6. **TODO:** popsat pole.

### 4. `SPresentTree` — Prezentační strom
Hierarchická stromová struktura produktů (kategorie e-shopu).

```
GET .../Default.asmx/GetResult?resultType=SPresentTree
GET .../Default.asmx/GetResultByCode?resultType=SPresentTree&Code=‹IdP›
```

Pole: `Id`, `IdP` (rodič – prázdné = nejvyšší úroveň), `Name`, `Sort` (3 znaky na úroveň,
např. `AAA` = 1. úroveň, `AAABBB` = 2. úroveň). ByCode filtruje větev dle `IdP`.

### 5. `DocTrInv` — Přenos dokladu: faktura
Faktura ve formátu pro import do I6. **TODO:** popsat hlavičku a položky.

### 6. `StoItemPriceOrd` — Nákupní ceny
Objednací (nákupní) ceny produktů. Varianta v měně uživatele: `StoItemPriceOrdCur`.
Fixní ceny (`PriceList`, `Price0–6`) jen na zvláštní oprávnění.

### 7. `CpsStiVal` — Parametry produktů (Název × Hodnota)
Parametry StoItemů zúžené na dvojice název–hodnota, filtrované kódem StoItemu.

### 8. `StiRelation` — Vztahy mezi produkty
Vazby mezi StoItemy (příslušenství, alternativy…). Varianta `StiRelationCO` = Conditional Offer.

### 9. `AttSti` — Přílohy produktů
Přílohy (dokumenty/obrázky) navázané na StoItemy. Varianta `AttCpsSti` = přílohy parametrů.

### 10. `CpsSti` — Parametry produktů vč. definice
Parametry StoItemů včetně definice parametru (na rozdíl od `CpsStiVal`).

### 11. `StoItemEAN` — EAN kódy
EAN kód(y) produktů.

### 12. `StoItemQtyFreeEx` — Dostupnost + naskladnění
Skladová dostupnost rozšířená o dostupnost a termín nejbližšího naskladnění.

### 13. `StrStiSync` — Synchronizace strom + produkty
Export pro synchronizaci `SPresentTree` + `StoItem`. Jako `Code` se posílá Id stromu SPresentTree.

### 14. `StoItemShop` (`_El`) — Feed pro e-shop
Základní informace o produktech ve formě feedu pro e-shop (varianta pro Shoptet: `StoItemShoptet`).

### 15. `StoItemActive` — Aktivní produkty
Seznam aktivních produktů.

### 16. Varianty `_El` (`StoItemBase_El`, `StoItemQtyFree_El`, `CpsStiVal_El`, `SPresentTree_El`)
Element-based varianty výše uvedených exportů – stejný obsah, data jako XML elementy místo atributů.

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
7. **Časová okna** – reálná povolená okna volání per export.
8. **Chybové stavy** – návratové kódy / formát chyb.
9. **Stránkování / limity** – zda existují limity počtu záznamů a jak se stránkuje.
