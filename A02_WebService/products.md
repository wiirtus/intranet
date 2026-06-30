
> **⚠️ Verze dokumentu 0.5**  
> Dokument není dokončen, jedná se o pracovní verzi. Místa označená `‹…›` a **TODO** je třeba doplnit reálnými hodnotami (URL, přihlašovací údaje, ukázky odpovědí). Předpoklady jsou v textu výslovně označeny.


---

# WebService – Product API

> **Účel dokumentu:** Kompletní popis SWS/I6 (CyberSoft) WebServisu pro účely předání a integrace
> pod ALSO. Dokument popisuje architekturu, autentizaci, formát požadavků
> a odpovědí, konvence pojmenování a úplný katalog dostupných exportů.
>


---

## Přehled

SWS WebService poskytuje partnerům strojový přístup k datům **ERP systému I6 (CyberSoft)**.
Pokrývá informace o produktech (StoItem), skladové zásoby, ceny, obrázky, atributy, prezentační
stromy (kategorie), doklady (faktury, dodací listy) a objednávky.

Service je postaven jako **ASP.NET Web Service (`.asmx`)** a je provozován jako aplikační adresář
`/i6ws/` na eShopu distributora. Se službou lze komunikovat pomocí protokolu **SOAP**, u metod s jednoduchými parametry
(exporty) také pomocí **HTTP GET/POST** – exporty lze tedy stahovat obyčejným odkazem (URL).


## Base URL

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


## Formát požadavku

### Čtení dat – `Default.asmx`

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






## Srovnání s ALSO Product API

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

## Katalog exportů

Každý export existuje ve třech variantách — liší se pouze suffixem v `resultType`:

| Suffix    | Popis                                 |
|-----------|---------------------------------------|
| *(žádný)* | Data jako XML atributy — kompaktnější |
| `_El`     | Data jako XML elementy — čitelnější   |
| `_Schema` | XSD schéma exportu                    |

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

### Nejpoužívanější exporty