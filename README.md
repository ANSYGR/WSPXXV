# WSPXXV

#### Webbserverprogrammering vt26

### Uppgiftsbeskrivning
Nu är det dags för att bygga en större applikation med hjälp av de tekniker vi har lärt oss i kursen Webbserverprogrammering. Syftet är att du ska lära dig att använda dina kunskaper för att bygga en webbapplikation med både front-end och back-end. Att ha kunskaper inom back-end-utveckling ger dig stora fördelar i livet om du tex ska bygga applikationer som sparar data och har användare med konton. Skulle du fortsätta med front-end (bara webbdesign) är det också väldigt meriterande att ha viss förståelse för vad som händer back-end. Både när du utvecklar själv men även när du kommunicerar med andra utvecklare.

Du kommer även under arbetets gång få miniföreläsningar om hur du kan göra utvecklingen/koden snyggare, bättre och lättare att hantera. Tex att separera olika funktionalitet eller tips för att testa koden.




## Matris

| Aspekt         | E                                                            | C                                                            | A                                                            |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Dokumentation  | Tillsammans med läraren dokumenterar du **översiktligt** din applikations funktionalitet, utvecklingsprocess och säkerhet och använder **med viss säkerhet *enkel*** terminologi. | Med läraren som bollplank dokumenterar du **utförligt** din applikations funktionalitet, utvecklingsprocess och säkerhet och använder **med viss säkerhet** ***korrekt*** terminologi. | Med läraren som bollplank dokumenterar du **utförligt  och nyanserat** din applikations funktionalitet, utvecklingsprocess och säkerhet och **använder med säkerhet *korrekt*** terminologi. |
| Arkitektur     | Tillsammans med läraren utvecklar du en applikation där koden har en **enkel** kodstruktur. | Med läraren som bollplank utvecklar du en applikation där koden har en **god** kodstruktur. | Med läraren som bollplank utvecklar du en applikation där koden **följer MVC** och **följer en given kodstandard.** |
| Funktionalitet | Tillsammans med läraren  utvecklar du en applikation med **enkel** funktionalitet. | Med läraren som bollplank utvecklar du en applikation med **inloggningssystem** och **tillfredsställande** funktionalitet. | Med läraren som bollplank utvecklar du en applikation med ett **inloggningssystem** och **komplex** funktionalitet. |
| Datalagring    | Tillsammans med läraren  utvecklar du en applikation som använder en **enkel** lösning för att spara data mellan sidvisningar. | Med läraren som bollplank utvecklar du en applikation som använder en e**nkel databaslösning** för att spara data mellan sidvisningar. | Med läraren som bollplank utvecklar du en applikation som använder en **komplex databaslösning** för att spara data mellan sidvisningar. |
| Säkerhet       | Tillsammans med läraren vidtar du **enkla** åtgärder för att förhindra att applikationen utnyttjas. | Med läraren som bollplank vidtar du **lite mer avancerade** åtgärder för att förhindra att applikationen utnyttjas. | Med läraren som bollplank vidtar du **avancerade** åtgärder för att förhindra att applikationen utnyttjas. |

### E-nivå

Gemensamt för samtliga aspekter på E-nivå är en brist på självständighet. Detta innebär att den efterfågade funktionaliteten i aspekterna nedan kan till viss del tagits fram tillsammans med läraren.

### C-nivå

Gemensamt för samtliga aspekter på C-nivå är större grad av självständighet än på E-nivå.

### A-nivå

Gemensamt för samtliga aspekter på A-nivå är en större grad av självständighet än på E-nivå.

## Dokumentation
| E                                                            | C                                                            | A                                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Tillsammans med läraren dokumenterar du **översiktligt** din applikations funktionalitet, utvecklingsprocess och säkerhet och använder **med viss säkerhet \*enkel\*** terminologi. | Med läraren som bollplank dokumenterar du **utförligt** din applikations funktionalitet, utvecklingsprocess och säkerhet och använder **med viss säkerhet** ***korrekt\*** terminologi. | Med läraren som bollplank dokumenterar du **utförligt  och nyanserat** din applikations funktionalitet, utvecklingsprocess och säkerhet och **använder med säkerhet \*korrekt\*** terminologi. |

### E-nivå

Eleven har en enkel beskrivning över applikationens funktionalitet (en enkel domänbeskrivning) och ett enkelt er-diagram. Eleven har svårt för begrepp som t.ex *route*, *resurs*, *vy*, *entitet*. Eleven commitar/pushar sin kod till Github varje vecka. Vid lektionens slut sammanfattar eleven enkelt dagens arbete i text och bild i sitt dokument på classroom.

### C-nivå

Eleven har utförlig domänbeskrivning som beskriver olika användares behörigheter, och ett korrekt er-diagram. Eleven har svårt för mer avancerade begrepp som *RESTFUL* och *kardinalitet*. Vid lektionens slut sammanfattar eleven dagens arbete i text och bild i sitt dokument på classroom.

### A-nivå

Eleven har domänbeskrivning likt C-nivå, och använder obehinrdat de flesta begrepp. Applikationens routes är även dokumenterade enligt tex Yardoc. Vid lektionens slut sammanfattar eleven detaljerat dagens arbete i text och bild i sitt dokument på classroom.

## Arkitektur

| E                                                            | C                                                            | A                                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Tillsammans med läraren utvecklar du en applikation där koden har en **enkel** kodstruktur. | Med läraren som bollplank utvecklar du en applikation där koden har en **god** kodstruktur. | Med läraren som bollplank utvecklar du en applikation där koden **följer MVC** och **följer en given kodstandard.** |

### E-nivå

Eleven har i stort sett all logik i `app.rb`,.

Eleven kan upprepa logik som t.ex databasuppkopplingar och valideringar i flera routes snarare än använda `before-block`.

Elevens vyer/routes följer ingen tydlig namngivning

### C-nivå

Eleven har god separation av olika sorters logik.

Eleven har t.ex helper-funktioner för db-uppkoppling, använder before-block och har en någotsånär DRY-kod.

Eleven följer någotsånär REST och har en tydlig namngivning av vyer/routes.

### A-nivå

Eleven följer MVC. I controllerns finns ingen SQL-kod istället är funktionaliteten utflyttad till modellfiler.

Eleven följer REST fullt ut.

## Funktionalitet

| E                                                            | C                                                            | A                                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Tillsammans med läraren  utvecklar du en applikation med **enkel** funktionalitet. | Med läraren som bollplank utvecklar du en applikation med **inloggningssystem** och **tillfredsställande** funktionalitet. | Med läraren som bollplank utvecklar du en applikation med ett **inloggningssystem** och **komplex** funktionalitet. |

### E-nivå

Applikationen erbjuder ett enkelt CRUD-gränssnitt (åtminstone Create/Show/Delete) för någon resurs. 

### C-nivå

Applikationen erbjuder ett enkelt CRUD-gränssnitt för några resurser, varav minst en har en association/relation till en annan resurs. 

Appliktionen har ett inloggninssystem, och det finns skillnad på vad man kan göra beroende på om man är inloggad eller ej.

### A-nivå

Applikationen erbjuder ett CRUD-gränssnit för flera resurser, där flera har associationer/relationer till varandra. Vid uppdatering och borttagning av relaterade resurser förändras även kopplade resurser där så är nödvändigt (t.ex genom `ON DELETE CASCADE`-liknande funktinalitet).

Inloggningssystemet skiljer på vad oinloggade och inloggade användare kan göra, och implementerar ett enkelt behörighetssystem (t.ex guest-user, standard-user, admin).

Eleven använder automatiserade tester (cypress) för att testa någon funktionalitet i applikationen.

## Datalagring

| E                                                            | C                                                            | A                                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Tillsammans med läraren  utvecklar du en applikation som använder en **enkel** lösning för att spara data mellan sidvisningar. | Med läraren som bollplank utvecklar du en applikation som använder en e**nkel databaslösning** för att spara data mellan sidvisningar. | Med läraren som bollplank utvecklar du en applikation som använder en **komplex databaslösning** för att spara data mellan sidvisningar. |

### E-nivå

Eleven har en databas med minst en, korrekt formaterad, tabell (eller eventuellt, i nödfall, enbart sessioner)

### C-nivå

Eleven har en databas med flera tabeller, varav minst två har relationer med varandra

### A-nivå

Eleven har en databas med flera tabeller. Det finns minst en många-till-många-relation (mha en relationstabell). Eleven använder JOINs på minst 1 SQL-fråga.

## Säkerhet

| E                                                            | C                                                            | A                                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Tillsammans med läraren vidtar du **enkla** åtgärder för att förhindra att applikationen utnyttjas. | Med läraren som bollplank vidtar du **lite mer avancerade** åtgärder för att förhindra att applikationen utnyttjas. | Med läraren som bollplank vidtar du **avancerade** åtgärder för att förhindra att applikationen utnyttjas. |

### E-nivå

Om eleven har ett inloggningssystem kontrollerar hen användarnamn/lösenord (eventuellt hårdkodade).

Om eleven har ett inloggningssystem kontrollerar hen åtminstone någon get-route.

### C-nivå

Eleven har ett inloggningssystem, med hashade lösenord i databasen. Eleven säkrar upp routes (både `get` och `post` (både inloggning och att användaren "äger" resursen)

Eleven validerar och escapar användarinput

### A-nivå

Eleven har ett inloggninssystem med hashade lösenord i databasen. Eleven säkrar upp routes och implementerar t.ex logging kring inloggningsförsök och cool-down eller liknande vid hackningsförsök. Eventuellt implementerar eleven "strong params" mha black/whitelist (valbart).
Eleven kan även använda sig av Sinatras CSRF-funktionalitet(valbart).
