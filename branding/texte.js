// Übersetzungsdateien (Docmost-Kern, apps/client/public/locales, AGPL-3.0): nur die angezeigten Texte ändern, nie die
// Schlüssel. Die Schlüssel stehen auch im Code der Enterprise-Seiten, die wir nicht anfassen; mit unveränderten
// Schlüsseln finden sie ihre Texte weiter. Werbung für die Docmost-Bezahlversion wird ein neutraler Hinweis.
// Aufruf im Image: node texte.js /app/apps/client/dist/locales
const fs = require("fs");
const path = require("path");

const NICHT_ENTHALTEN = { "de-DE": "In dieser Fassung nicht enthalten.", "en-US": "Not included in this edition." };
const dir = process.argv[2];
for (const sprache of fs.readdirSync(dir)) {
  const datei = path.join(dir, sprache, "translation.json");
  if (!fs.existsSync(datei)) continue;
  const texte = JSON.parse(fs.readFileSync(datei, "utf8"));
  for (const [k, v] of Object.entries(texte)) {
    if (typeof v !== "string") continue;
    texte[k] = /docmost\.com/i.test(v) ? (NICHT_ENTHALTEN[sprache] ?? NICHT_ENTHALTEN["en-US"]) : v.replace(/Docmost/g, "Memkontor");
  }
  fs.writeFileSync(datei, JSON.stringify(texte, null, 2));
}
