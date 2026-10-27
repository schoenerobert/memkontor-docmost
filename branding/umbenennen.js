// Gibt allen Dateien unter assets/ einen neuen Namen je Build und zieht alle Verweise nach.
// Grund: Docmost liefert assets/ mit "Cache-Control: immutable" aus, Cloudflare und Browser behalten eine Datei
// deshalb ein Jahr. Nach dem Umbenennen (Name, Farbe, Sprache) hieße die geänderte Datei sonst wie vorher und alle
// bekämen weiter die alte. Der Zusatz ist ein Hash über den Inhalt aller Dateien: gleicher Build, gleiche Namen.
// Aufruf im Image: node umbenennen.js /app/apps/client/dist
const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

const dist = process.argv[2];
const assets = path.join(dist, "assets");
const alle = [];
(function sammeln(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    e.isDirectory() ? sammeln(p) : alle.push(p);
  }
})(dist);

const hash = crypto.createHash("sha256");
for (const p of alle.sort()) hash.update(p).update(fs.readFileSync(p));
const zusatz = "mk" + hash.digest("hex").slice(0, 8);

const umbenennen = fs.readdirSync(assets).filter((n) => /\.(js|css)$/.test(n));
const neu = new Map(umbenennen.map((n) => [n, n.replace(/\.(js|css)$/, `-${zusatz}.$1`)]));
const reihenfolge = [...neu.keys()].sort((a, b) => b.length - a.length); // längere Namen zuerst, keine Teiltreffer
const muster = new RegExp(reihenfolge.map((n) => n.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")).join("|"), "g");

let dateien = 0;
for (const p of alle) {
  if (!/\.(js|css|html|json|map)$/.test(p)) continue;
  const alt = fs.readFileSync(p, "utf8");
  const text = alt.replace(muster, (m) => neu.get(m));
  if (text !== alt) {
    fs.writeFileSync(p, text);
    dateien++;
  }
}
for (const [a, b] of neu) fs.renameSync(path.join(assets, a), path.join(assets, b));
console.log(`${neu.size} Dateien umbenannt (-${zusatz}), Verweise in ${dateien} Dateien angepasst`);
