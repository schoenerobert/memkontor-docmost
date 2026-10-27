#!/bin/sh
# Mails von Docmost auf Deutsch (Sie-Form) und mit Memkontor statt Docmost: Einladung, Einladung angenommen, Passwort
# vergessen, Passwort geändert, samt Betreffzeilen. Nur Kern-Dateien (AGPL-3.0), keine Enterprise-Datei.
# Hinweis-Mails zu Kommentaren und Seitenänderungen bleiben vorerst Englisch.
# Aufruf im Image: sh mails.sh /app/apps/server/dist
set -eu
cd "$1"
m=integrations/transactional/emails
sed -i \
  -e 's/"Hi there,"/"Guten Tag,"/' \
  -e 's/"You have been invited to Docmost."/"Sie wurden zu Memkontor eingeladen, dem Firmengedächtnis Ihres Unternehmens."/' \
  -e 's/"Please click the button below to accept this invitation."/"Mit dem Knopf unten nehmen Sie die Einladung an und legen Ihr Passwort fest."/' \
  -e 's/"Accept Invite"/"Einladung annehmen"/' \
  $m/invitation-email.js
sed -i \
  -e 's/"Hi there,"/"Guten Tag,"/' \
  -e 's/") has accepted your invitation, and is now a member of the workspace."/") hat Ihre Einladung angenommen und ist jetzt in Memkontor dabei."/' \
  $m/invitation-accepted-email.js
sed -i \
  -e 's/"Hi ",/"Guten Tag ",/' \
  -e 's/"We received a request from you to reset your password."/"Sie haben angefordert, Ihr Passwort zurückzusetzen."/' \
  -e 's/" Click here to set a new password"/"Hier ein neues Passwort festlegen"/' \
  -e 's/"This link is valid for 30 minutes."/"Der Link gilt 30 Minuten."/' \
  -e 's/"If you did not request a password reset, please ignore this email."/"Falls Sie das nicht angefordert haben, ignorieren Sie diese E-Mail einfach."/' \
  $m/forgot-password-email.js
sed -i \
  -e 's/"Hi ",/"Guten Tag ",/' \
  -e 's/"This is a confirmation that your password has been changed."/"Ihr Passwort wurde geändert. Falls Sie das nicht waren, wenden Sie sich bitte an Ihren Administrator."/' \
  $m/change-password-email.js
sed -i 's/" Docmost, All Rights Reserved "/" Memkontor "/' integrations/transactional/partials/partials.js
sed -i \
  -e "s/subject: 'Your password has been changed'/subject: 'Ihr Memkontor-Passwort wurde geändert'/g" \
  -e "s/subject: 'Reset your password'/subject: 'Passwort für Memkontor zurücksetzen'/" \
  core/auth/services/auth.service.js
sed -i \
  -e 's/has accepted your Docmost invite`/hat Ihre Einladung zu Memkontor angenommen`/' \
  -e 's/invited you to Docmost`/lädt Sie zu Memkontor ein`/' \
  core/workspace/services/workspace-invitation.service.js
# Bau bricht ab, wenn eine Ersetzung nicht gegriffen hat (z. B. nach einem Docmost-Update)
for muster in "Einladung annehmen" "Hier ein neues Passwort festlegen" "Ihr Passwort wurde geändert" "hat Ihre Einladung angenommen"; do
  grep -rq "$muster" $m || { echo "Mail-Text fehlt: $muster"; exit 1; }
done
grep -q "Passwort für Memkontor zurücksetzen" core/auth/services/auth.service.js
grep -q "lädt Sie zu Memkontor ein" core/workspace/services/workspace-invitation.service.js
grep -q '" Memkontor "' integrations/transactional/partials/partials.js
