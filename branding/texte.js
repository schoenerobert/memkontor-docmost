// Übersetzungsdateien (Docmost-Kern, apps/client/public/locales, AGPL-3.0): nur die angezeigten Texte ändern, nie die
// Schlüssel. Die Schlüssel stehen auch im Code der Enterprise-Seiten, die wir nicht anfassen; mit unveränderten
// Schlüsseln finden sie ihre Texte weiter. Werbung für die Docmost-Bezahlversion wird ein neutraler Hinweis.
// Dazu: Texte, die Docmost im Code verwendet, aber nicht übersetzt hat (sonst steht dort Englisch, z. B. "Created by me"
// auf der Startseite), und Werte, die in der deutschen Datei in Anführungszeichen stehen.
// Aufruf im Image: node texte.js /app/apps/client/dist/locales
const fs = require("fs");
const path = require("path");

const NICHT_ENTHALTEN = { "de-DE": "In dieser Fassung nicht enthalten.", "en-US": "Not included in this edition." };
const FEHLT_DE = {
  "Created by me": "Von mir erstellt",
  "Log out": "Abmelden",
  "Show more": "Mehr anzeigen",
  "Scroll left": "Nach links",
  "Scroll right": "Nach rechts",
  "No favorites yet": "Noch keine Favoriten",
  "No favorite pages": "Noch keine Favoriten",
  "Pages you star will show up here.": "Seiten mit Stern erscheinen hier.",
  "Pages you favorite will show up here.": "Seiten mit Stern erscheinen hier.",
  "Failed to fetch pages": "Seiten konnten nicht geladen werden",
  "Failed to fetch starred pages": "Favoriten konnten nicht geladen werden",
  "Failed to fetch favorite pages": "Favoriten konnten nicht geladen werden",
  "Failed to move page": "Seite konnte nicht verschoben werden",
  "Page moved successfully": "Seite verschoben",
  "Failed to upload image": "Bild konnte nicht hochgeladen werden",
  "Replace image": "Bild ersetzen",
  "Upload file": "Datei hochladen",
  "Change avatar": "Profilbild ändern",
  "Change space icon": "Bereichssymbol ändern",
  "Change workspace icon": "Symbol des Arbeitsbereichs ändern",
  "Uploading import file": "Importdatei wird hochgeladen",
  "Please don't close this tab.": "Bitte diesen Tab nicht schließen.",
  "Page import is in progress. You can check back later if this takes longer.": "Der Import läuft. Wenn es länger dauert, schauen Sie später wieder vorbei.",
  "Failed to upload import file": "Importdatei konnte nicht hochgeladen werden",
  "Import complete": "Import abgeschlossen",
  "Your pages were successfully imported.": "Ihre Seiten wurden importiert.",
  "Page import failed": "Import fehlgeschlagen",
  "Import failed": "Import fehlgeschlagen",
  "Password reset was successful": "Passwort zurückgesetzt",
  "Invalid or expired password reset link": "Der Link zum Zurücksetzen ist ungültig oder abgelaufen",
  "Goto login page": "Zur Anmeldung",
  "Group updated successfully": "Gruppe gespeichert",
  "Group deleted successfully": "Gruppe gelöscht",
  "Added successfully": "Hinzugefügt",
  "Removed successfully": "Entfernt",
  "Skip to main content": "Zum Inhalt springen",
  "Find a user": "Person suchen",
  "Find a label": "Etikett suchen",
  "Text alignment": "Textausrichtung",
  "You have unsaved changes that will be lost.": "Ungespeicherte Änderungen gehen verloren.",
  "Synced to": "Verknüpft mit",
  "Copied. Paste on any page to embed this synced block.": "Kopiert. Auf einer beliebigen Seite einfügen, um diesen verknüpften Block einzubetten.",
  "Edit source": "Quelle bearbeiten",
  "No results": "Keine Treffer",
  "Emoji picker": "Emoji-Auswahl",
  "Previous match (Shift+Enter)": "Vorheriger Treffer (Umschalt+Enter)",
  "Owner, no contributors": "Eigentümer, keine Mitwirkenden",
  "Failed to restrict page": "Seite konnte nicht eingeschränkt werden",
  "Failed to remove page restriction": "Einschränkung konnte nicht entfernt werden",
  "Failed to add permission": "Berechtigung konnte nicht hinzugefügt werden",
  "Failed to remove permission": "Berechtigung konnte nicht entfernt werden",
  "Failed to update permission": "Berechtigung konnte nicht geändert werden",
  "Page not found": "Seite nicht gefunden",
  "Search engine indexing": "Für Suchmaschinen sichtbar",
  "No table of contents.": "Kein Inhaltsverzeichnis.",
  "Change hostname": "Adresse ändern",
  "Failed to update setting": "Einstellung konnte nicht gespeichert werden",
  "Two-factor authentication required": "Zwei-Faktor-Anmeldung erforderlich",
  "Already part of an existing workspace?": "Schon in einem Arbeitsbereich?",
};
const dir = process.argv[2];
for (const sprache of fs.readdirSync(dir)) {
  const datei = path.join(dir, sprache, "translation.json");
  if (!fs.existsSync(datei)) continue;
  const texte = JSON.parse(fs.readFileSync(datei, "utf8"));
  if (sprache === "de-DE") {
    for (const [k, v] of Object.entries(FEHLT_DE)) if (!texte[k]) texte[k] = v;
    for (const [k, v] of Object.entries(texte))  // "\"Schreiben...\"" -> "Schreiben..."
      if (typeof v === "string" && /^".*"$/.test(v) && !/^".*"$/.test(k)) texte[k] = v.slice(1, -1);
  }
  for (const [k, v] of Object.entries(texte)) {
    if (typeof v !== "string") continue;
    texte[k] = /docmost\.com/i.test(v) ? (NICHT_ENTHALTEN[sprache] ?? NICHT_ENTHALTEN["en-US"]) : v.replace(/Docmost/g, "Memkontor");
  }
  fs.writeFileSync(datei, JSON.stringify(texte, null, 2));
}
