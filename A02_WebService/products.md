
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
`/i6ws/` na eShopu distributora. Data se získávají voláním jedné ze tří univerzálních metod
nad endpointem `Default.asmx`, kde se konkrétní export volí parametrem `resultType`.
Objednávky se zakládají samostatným endpointem `Order.asmx`.

Se službou lze komunikovat pomocí protokolu **SOAP**, u metod s jednoduchými parametry
(exporty) také pomocí **HTTP GET/POST** – exporty lze tedy stahovat obyčejným odkazem (URL).


## Srovnání s ALSO Product API

ALSO Product API nabízí 7 metod. Níže je uvedeno, které SWS exporty pokrývají stejnou funkcionalitu.

| # | ALSO Product API metoda | Popis (ALSO)                                              | Odpovídající SWS export(y)                                      | Poznámka                                                              |
|---|-------------------------|-----------------------------------------------------------|-----------------------------------------------------------------|-----------------------------------------------------------------------|
| 1 | `AllProducts`           | Základní info o všech produktech dostupných v e-shopu     | `StoItemBase`                                  | SWS vrací ceny, sklad i obrázky v jednom exportu                     |
| 2 | `AllOfflineProducts`    | Produkty v katalogu partnera, které nejsou online         |            | SWS nemá dedikovaný export; offline produkty jsou filtrovány in-query |
| 3 | `ProductFullInfo`       | Kompletní detail produktu – popis, atributy, obrázky, ceny | `StoItemBase` + `CpsSti`/`CpsStiVal` + `AttSti`               | SWS vyžaduje kombinaci více exportů pro stejný výsledek               |
| 4 | `ProductNow`            | Aktuální sklad, cena a dostupnost pro jeden produkt       | `StoItemQtyFree`, `StoItemPriceOrdCur`                        | Volání přes `GetResultByCode` s kódem produktu                        |
| 5 | `AllProductsNow`        | Sklad, cena a dostupnost pro všechny produkty             | `StoItemQtyFree` + `StoItemPriceOrd`                            | SWS vrací sklad a ceny ve dvou oddělených exportech                   |
| 6 | `ProductImages`         | Dostupné obrázky produktu                                 | `AttSti`, `X-AttSti`                                            | SWS vrací URL sestavené z `UrlBase*` + `Id`; typy rozlišeny tagem    |
| 7 | `Categories`            | Kompletní hierarchie kategorií e-shopu                    | `SPresentTree`, `SCategorySys`                                  | SWS používá plochý seznam s ID rodiče a sort klíčem (3 znaky/úroveň) |