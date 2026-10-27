# Memkontor: Docmost mit eigenem Erscheinungsbild

Dieses Repository enthält den Quellcode der geänderten Docmost-Fassung, die Memkontor betreibt. Memkontor nutzt
[Docmost](https://github.com/docmost/docmost) 0.96.0 (AGPL-3.0) unverändert und passt nur die fertige Oberfläche an.

## Was geändert ist

- Name: "Docmost" heißt in der Oberfläche "Memkontor" (Titel, Kopfzeile, Login-Seite, Texte).
- Icons: eigene Icons (`branding/icons/`, erzeugt mit `branding/icons_erzeugen.py`).
- Farbe: Akzentfarbe Teal statt Blau.
- Sprache: deutsche Texte auch vor der Anmeldung.
- Menü: der Eintrag "Lizenz & Edition" ist ausgeblendet.
- Dateinamen: alle Oberflächen-Dateien bekommen je Build einen neuen Namen (`branding/umbenennen.js`), damit
  Browser und Zwischenspeicher die geänderte Fassung laden.
- Ein Link "Quellcode (AGPL)" unten rechts führt hierher.

Server, Datenbank und alle Lizenzhinweise von Docmost bleiben unverändert. Den Enterprise-Teil von Docmost
(eigene Lizenz) nutzt Memkontor nicht.

## Bauen

```bash
docker build -t memkontor-docmost .
```

Das `Dockerfile` setzt auf dem offiziellen Image `docmost/docmost:0.96.0` auf, per Digest gepinnt. Der vollständige
Quellcode von Docmost 0.96.0 liegt unter https://github.com/docmost/docmost/tree/v0.96.0.

## Lizenz

AGPL-3.0, wie Docmost. Siehe `LICENSE`. Docmost ist eine Marke ihrer Inhaber; Memkontor ist kein Produkt von Docmost.
