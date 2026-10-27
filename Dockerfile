# Docmost mit Memkontor-Erscheinungsbild. Geändert wird nur die fertige Oberfläche: Name (Titel, Kopfzeile,
# Login-Seite, Texte), Icons, Akzentfarbe Teal statt Blau, Deutsch auch vor dem Login (die englische Textdatei bekommt die deutschen Texte, Docmost lädt vor der Anmeldung immer Englisch) und ein Link auf den Quellcode (AGPL-3.0 verlangt, dass Nutzer übers Netz an den
# Quellcode der geänderten Fassung kommen). Der Menüpunkt 'Lizenz & Edition' (Werbung für Docmost Enterprise) ist
# ausgeblendet. Danach bekommen alle Oberflächen-Dateien neue Namen (umbenennen.js), sonst liefern Cloudflare und
# Browser die alten aus, weil Docmost sie als unveränderlich markiert. Server, Datenbank und Lizenzhinweise bleiben unverändert.
# Der Name Docmost bleibt dort, wo er technisch ist (JWT-Aussteller, Mails, Kleinbuchstaben wie docmost.com).
FROM docmost/docmost:0.96.0@sha256:b56947fcfd08aab8fae12a377e1792784786adbf8b96e4281f14ef4fc072685a
ARG QUELLCODE_URL=https://github.com/schoenerobert/memkontor-docmost
USER root
COPY branding/icons/ /app/apps/client/dist/icons/
COPY branding/umbenennen.js /tmp/umbenennen.js
RUN cd /app/apps/client/dist \
 && find . -type f \( -name '*.js' -o -name '*.json' -o -name '*.html' \) -exec sed -i 's/Docmost/Memkontor/g' {} + \
 && sed -i 's/"#222"/"#0C0C0C"/g' manifest.json \
 && link="<a href=\"${QUELLCODE_URL}\" target=\"_blank\" rel=\"noopener\" style=\"position:fixed;right:8px;bottom:4px;font:11px sans-serif;color:rgb(138,138,138);text-decoration:none;z-index:1\">Quellcode (AGPL)</a>" \
 && sed -i "s|</body>|${link}</body>|" index.html \
 && cp locales/de-DE/translation.json locales/en-US/translation.json \
 && sed -i 's|path:`/settings/license`}|path:`/settings/license`,env:`cloud`}|' assets/index-*.js \
 && grep -q 'path:`/settings/license`,env:`cloud`}' assets/index-*.js \
 && farbe="<style>:root{--mantine-primary-color-filled:#0C9A8A!important;--mantine-primary-color-filled-hover:#0A8578!important;--mantine-primary-color-light:rgba(12,154,138,.1)!important;--mantine-primary-color-light-hover:rgba(12,154,138,.16)!important;--mantine-primary-color-light-color:#0C9A8A!important;--mantine-color-anchor:#0C9A8A!important}</style>" \
 && sed -i "s|</head>|${farbe}</head>|" index.html \
 && test -z "$(find . -type f \( -name '*.js' -o -name '*.json' -o -name '*.html' \) -exec grep -l Docmost {} +)" \
 && node /tmp/umbenennen.js /app/apps/client/dist \
 && rm /tmp/umbenennen.js \
 && chown -R node:node /app/apps/client/dist
USER node
