# Antiqua Europa

Nuovo progetto autonomo, separato da Patina, Classics e Piston.

## Stato della consegna

- Vetrina responsive originale: avorio, verde bosco, ottone, tipografia serif.
- Interfaccia IT / EN / FR / DE / CZ; i futuri contenuti importati mantengono per ora la lingua originale.
- Ricerca, categorie, paese, ordinamento prezzi, preferiti locali e schede oggetto.
- Sei esempi illustrati originali, chiaramente etichettati demo. Non sono annunci reali.
- Backend Cloudflare Worker + D1 preparato, NON distribuito o collegato.
- Area amministrativa con credenziale server, fonti e costi privati; import JSON autorizzati; gestione stati tramite reimport con stesso ID; scadenza automatica lato query; richieste clienti predisposte ma disattivate.
- Nessun pagamento, feed commerciale o scraping attivo. Nessun dominio configurato.
- 8 test automatici superati; controllati nel browser desktop filtri, cambio lingua, scheda e immagini. Layout mobile presente ma non ancora verificato su dispositivo.

## Avvio locale

Richiede Node 24 per i test e Python 3 per il server statico. Nessuna dipendenza npm.

    npm test
    npm run preview

Aprire http://localhost:8080. In modalità demo la pagina funziona senza backend.

## GitHub

Destinazione prevista: `anomaly73bit/antiqua` (account collegato verificato).
Repository creato dall’utente e pubblicazione su main autorizzata il 26 ottobre 2026.
Il backend richiede ancora configurazione e distribuzione separate.
Il workflow Pages parte sui push a main o manualmente; nessuna esecuzione periodica.
Prima della pubblicazione: Settings → Pages → Source → GitHub Actions; quindi avviare Publish gallery sul branch approvato.
Il workflow pubblica SOLO `public/`. Mai includere esportazioni D1, fonti, feed privati o credenziali nel repository, anche in un branch.

## Backend Cloudflare (da attivare)

Con CLI Wrangler ufficiale installata e autenticata:

    cd worker
    npx wrangler d1 create antiqua-europa

Inserire il database_id restituito in wrangler.jsonc, quindi:

    npx wrangler d1 execute antiqua-europa --remote --file schema.sql
    npx wrangler secret put ADMIN_TOKEN
    npx wrangler deploy

Usare un segreto casuale di almeno 32 caratteri inserito nel prompt CLI; mai in file, commit o chat.
Aggiornare `public/config.js` con l'URL HTTPS effettivo del Worker e `mode: "live"`.
Impostare ALLOWED_ORIGIN all'origine esatta del frontend (senza path); aggiungere l'origine del sottodominio quando definita.
Conservare `ENQUIRIES_ENABLED: "false"` fino a pubblicazione di privacy, contatto e identità del venditore, condizioni e policy di conservazione dati. Le richieste richiedono anche RATE_LIMITER e il percorso Cloudflare con CF-Connecting-IP.
La chiave admin è conservata in memoria nella pagina, mai in localStorage. Backend fail-closed se chiave o DB mancano.
Per la produzione aggiungere Cloudflare Access/MFA davanti all'area admin e una policy di conservazione/cancellazione delle richieste. L'API attuale mostra fino a 1000 prodotti e 500 richieste: implementare paginazione prima di superare tali volumi.

## Importazioni e prezzi

Importare solo dati e immagini per cui siano disponibili autorizzazioni. Le foto dei fornitori dovrebbero essere copiate, con permesso, su storage proprio: URL originali delle immagini potrebbero rivelare il fornitore anche se source_url è privato.
L'import è autenticato, transazionale (D1 batch), massimo 100 record. source_url è univoco per evitare duplicati dello stesso annuncio; duplicati tra siti diversi richiedono revisione.
Esempio di record (NON caricare come annuncio reale):

```json
[{
  "id": "partner-001",
  "title": "Titolo autorizzato",
  "description": "Descrizione autorizzata e verificata",
  "category": "Mobili",
  "country": "Italia",
  "era": "1900",
  "image": "https://YOUR-OWN-ASSET-HOST.example/item.jpg",
  "cost_cents": 100000,
  "markup_bps": 1500,
  "source_url": "https://supplier.example/item/001",
  "permission_reference": "Riferimento accordo effettivo",
  "rights_confirmed": true,
  "status": "draft",
  "expires_at": "2026-11-30T23:59:59Z"
}]
```

Stati: draft, published, sold, archived. Il frontend pubblico espone solo published non scaduti, tramite lista esplicita di campi. Non espone fonte, costo, ricarico o accordi. Nessuna traduzione automatica dei nuovi annunci è ancora implementata. Nessuna sincronizzazione automatica verso portali terzi è attiva.

## Monetizzazione proposta

Partire come servizio di ricerca e acquisto assistito, con disponibilità confermata prima di raccogliere pagamenti. Ricarico iniziale ipotetico del 15%, configurabile per articolo; non è un dato di mercato né una previsione di ricavo.

- Costo fornitore 1.000 € → prezzo 1.150 € → differenza 150 € prima di costi, imposte, commissioni di pagamento, resi e trasporto.
- 10 vendite al mese a queste condizioni → 1.500 € di differenza complessiva prima dei costi; scenario illustrativo, non utile netto garantito.
- Il 15% sul costo equivale al 13,04% sul prezzo di vendita.
- Per oggetti piccoli valutare un compenso minimo esplicito nel preventivo, per esempio 49 €, anziché aggiungere costi nascosti a fine acquisto.
- In una fase successiva: vetrine a pagamento per antiquari, inserzioni sponsorizzate chiaramente indicate e servizi di ricerca su commissione.

Fonte commerciale riservata e identità del venditore sono concetti diversi. Se PACIFIC rivende come venditore contrattuale, deve assumere le relative responsabilità. Se intermedia per il commerciante originale, il cliente deve conoscere chi gli vende e a quali condizioni. Il modello contrattuale e IVA (inclusa eventuale disciplina del margine) va definito prima del checkout. Il calcolo implementato è aritmetico, non un motore fiscale.
Riferimento: https://europa.eu/youreurope/business/selling-in-eu/selling-goods-services/ecommerce-distance-selling/index_en.htm

## Dominio

Scegliere il sottodominio dopo aver approvato il nome. Con GitHub Pages impostare prima il custom domain nelle impostazioni del repository, poi il CNAME DNS Cloudflare verso `anomaly73bit.github.io` e verificare HTTPS. Il DNS da solo non ospita l'API: il Worker deve essere distribuito separatamente.

## Prossimi passi reali

1. Creare il repository, caricare un branch di revisione e pubblicare la demo approvata.
2. Concordare fornitori/feed autorizzati e contratti di intermediazione o rivendita.
3. Attivare Worker, database, autenticazione e storage immagini proprio.
4. Pubblicare dati legali, privacy e condizioni; definire imposte e trasporto.
5. Importare un primo catalogo verificato; attivare richieste e successivamente pagamenti.
