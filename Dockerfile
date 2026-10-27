# Docmost mit Memkontor-Erscheinungsbild. Geändert wird nur der Kern von Docmost (AGPL-3.0), nie Dateien aus den
# ee-Verzeichnissen: die stehen unter der Docmost Enterprise License, deren Änderungen nur mit Abo genutzt werden dürfen.
#
# Kern-Änderungen, alle in der fertigen Oberfläche:
#   - der Name als eigener Text (`Docmost`) in Kopfzeile, Login-Seite, Titel (app-header, auth-layout, config,
#     home-ai-prompt, public-space-directory-page), nicht in Übersetzungsschlüsseln
#   - Übersetzungen: nur die angezeigten Texte (branding/texte.js), Deutsch auch vor dem Login (Docmost lädt vor der
#     Anmeldung immer die englische Datei, sie bekommt die deutschen Texte)
#   - Icons, Farben nur Schwarz, Weiß und Teal (branding/farben.css), Menüpunkt "Lizenz & Edition" ausgeblendet
#     (settings-sidebar), dort "API keys" (Bezahlversion) ersetzt durch "KI-Zugang", eine Seite des MCP (/schluessel);
#     ein kleines Skript lädt sie als eigene Seite statt über den Router der Oberfläche
#   - Link auf den Quellcode, wie AGPL-3.0 § 13 verlangt
#   - Mails (Einladung, Passwort, Hinweise) auf Deutsch und mit Memkontor-Absender (branding/mails.sh, Server-Kern)
# Die Enterprise-Seiten (ai-chat, ai-settings, user-api-keys) bleiben Byte für Byte, wie Docmost sie ausliefert; der
# Bau bricht ab, wenn sich dort etwas ändert. Server, Datenbank und Lizenzhinweise bleiben unverändert.
# Zwischenspeicher: siehe Caddyfile, nicht hier.
FROM docmost/docmost:0.96.0@sha256:b56947fcfd08aab8fae12a377e1792784786adbf8b96e4281f14ef4fc072685a
ARG QUELLCODE_URL=https://github.com/schoenerobert/memkontor-docmost
USER root
COPY branding/icons/ /app/apps/client/dist/icons/
COPY branding/texte.js /tmp/texte.js
COPY branding/mails.sh /tmp/mails.sh
COPY branding/farben.css /tmp/farben.css
RUN cd /app/apps/client/dist \
 && ee='assets/(ai-chat|ai-settings|user-api-keys)-[^/]*\.js$' \
 && ee_vorher=$(find assets -type f | grep -E "$ee" | sort | xargs sha256sum) \
 && find assets -name '*.js' | grep -v -E "$ee" | xargs sed -i 's/`Docmost`/`Memkontor`/g' \
 && sed -i 's/Docmost/Memkontor/g' index.html manifest.json \
 && sed -i 's/"#222"/"#0C0C0C"/g' manifest.json \
 && sed -i 's|path:`/settings/license`}|path:`/settings/license`,env:`cloud`}|' assets/index-*.js \
 && grep -q 'path:`/settings/license`,env:`cloud`}' assets/index-*.js \
 && sed -i 's|{label:`API keys`,icon:\([A-Za-z_$]*\),path:`/settings/account/api-keys`,feature:[A-Za-z_$.]*}|{label:`KI-Zugang`,icon:\1,path:`/schluessel`}|' assets/index-*.js \
 && grep -q 'label:`KI-Zugang`' assets/index-*.js \
 && node /tmp/texte.js locales && rm /tmp/texte.js \
 && cp locales/de-DE/translation.json locales/en-US/translation.json \
 && link="<a href=\"${QUELLCODE_URL}\" target=\"_blank\" rel=\"noopener\" style=\"position:fixed;right:8px;bottom:4px;font:11px sans-serif;color:rgb(138,138,138);text-decoration:none;z-index:1\">Quellcode (AGPL)</a>" \
 && sed -i "s|</body>|${link}</body>|" index.html \
 && seiten="<script>document.addEventListener('click',function(e){var a=e.target.closest?e.target.closest('a[href=\"/schluessel\"]'):null;if(a){e.preventDefault();e.stopPropagation();location.href='/schluessel'}},true)</script>" \
 && sed -i "s|</body>|${seiten}</body>|" index.html \
 && farbe="<style>$(tail -1 /tmp/farben.css)</style>" \
 && sed -i "s|</head>|${farbe}</head>|" index.html && rm /tmp/farben.css \
 && grep -q "mantine-color-red-filled:#0C0C0C" index.html \
 && test -n "$ee_vorher" \
 && test "$ee_vorher" = "$(find assets -type f | grep -E "$ee" | sort | xargs sha256sum)" \
 && chown -R node:node /app/apps/client/dist
RUN sh /tmp/mails.sh /app/apps/server/dist && rm /tmp/mails.sh
USER node
