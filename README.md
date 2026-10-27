# Memkontor: Docmost mit eigenem Erscheinungsbild

Dieses Repository enthält den Quellcode der geänderten Docmost-Fassung, die Memkontor betreibt. Memkontor nutzt
[Docmost](https://github.com/docmost/docmost) 0.96.0 (AGPL-3.0) unverändert und passt nur die fertige Oberfläche an.

## Was geändert ist (Stand 27.10.2026, Mails ergänzt am selben Tag)

Geändert ist nur der Kern von Docmost (AGPL-3.0), und nur die fertige Oberfläche:

- Name: wo die Oberfläche "Docmost" als eigenen Text zeigt (Kopfzeile, Login-Seite, Titel), steht "Memkontor".
- Texte: in den Übersetzungsdateien nur die angezeigten Texte, nie die Schlüssel (`branding/texte.js`). Hinweise auf
  die Docmost-Bezahlversion werden zu "In dieser Fassung nicht enthalten." Deutsch gilt auch vor der Anmeldung.
- Icons: eigene Icons (`branding/icons/`, erzeugt mit `branding/icons_erzeugen.py`).
- Farbe: Akzentfarbe Teal statt Blau.
- Menü: der Eintrag "Lizenz & Edition" ist ausgeblendet.
- Mails: Einladung, Einladung angenommen, Passwort vergessen und Passwort geändert auf Deutsch, mit Memkontor statt
  Docmost, samt Betreffzeilen (`branding/mails.sh`, Server-Kern).
- Ein Link "Quellcode (AGPL)" unten rechts führt hierher.

Nicht geändert: Dateien aus den Enterprise-Verzeichnissen von Docmost (`apps/client/src/ee`, `apps/server/src/ee`,
`packages/ee`). Sie stehen unter der Docmost Enterprise License. Der Bau prüft, dass die daraus gebauten Dateien Byte
für Byte unverändert bleiben, und bricht sonst ab. Memkontor nutzt keine Enterprise-Funktion. Server, Datenbank und
alle Lizenzhinweise von Docmost bleiben unverändert.

## Bauen und starten

`compose.beispiel.yml` startet diese Fassung mit Postgres, Redis und Caddy (`Caddyfile`: kurze Zwischenspeicher-Zeiten,
weil die Oberfläche beim Bau geändert wird). Jeder Dienst läuft in einem eigenen Container, Datenbank und Redis nur in
einem internen Netz.


```bash
docker build -t memkontor-docmost .
```

Das `Dockerfile` setzt auf dem offiziellen Image `docmost/docmost:0.96.0` auf, per Digest gepinnt. Der vollständige
Quellcode von Docmost 0.96.0 liegt unter https://github.com/docmost/docmost/tree/v0.96.0.

## Lizenz

AGPL-3.0, wie Docmost. Siehe `LICENSE`. Docmost ist eine Marke ihrer Inhaber; Memkontor ist kein Produkt von Docmost.
