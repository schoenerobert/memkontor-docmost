#!/bin/sh
# Mails von Docmost auf Deutsch (Sie-Form) und mit Memkontor statt Docmost: Einladung, Einladung angenommen, Passwort
# vergessen, Passwort geändert, Hinweise zu Kommentaren, Erwähnungen, Seitenänderungen, Freigaben und die Übersicht,
# jeweils samt Betreffzeile. Nur Kern-Dateien (AGPL-3.0), keine Enterprise-Datei. Die Mails zur Seiten-Verifizierung
# gehören zu einer Enterprise-Funktion und bleiben, wie sie sind.
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
# Hinweis-Mails. Docmost setzt die Sätze aus Teilen zusammen (Name, Text, Seitentitel), deshalb ist der deutsche Satz
# so gebaut, dass er ohne Umstellen der Teile funktioniert, z. B. "Anna hat kommentiert: Mängelliste."
for f in comment-created comment-mention comment-resolved page-mention permission-granted; do
  sed -i -e 's/"Hi there,"/"Guten Tag,"/' -e 's/"View")/"Öffnen")/' $m/$f-email.js
done
sed -i 's/" commented on"/" hat kommentiert:"/' $m/comment-created-email.js
sed -i 's/" mentioned you in a comment on"/" hat Sie in einem Kommentar erwähnt:"/' $m/comment-mention-email.js
sed -i 's/" resolved a comment on"/" hat einen Kommentar erledigt:"/' $m/comment-resolved-email.js
sed -i 's/" mentioned you in"/" hat Sie erwähnt in"/' $m/page-mention-email.js
sed -i -e 's/" gave you "/" hat Ihnen "/' -e 's/" access to"/"rechte gegeben für"/' $m/permission-granted-email.js
sed -i \
  -e 's/"Hi ",/"Guten Tag ",/' \
  -e 's/" updated"/" hat"/' \
  -e 's/"in the "/"im Bereich "/' \
  -e 's/" space\.")/" geändert.")/' \
  -e 's/"View page"/"Seite öffnen"/' \
  $m/page-update-email.js
sed -i \
  -e 's/"Hi ",/"Guten Tag ",/' \
  -e 's/"There ",/"Neu für Sie:",/' \
  -e "s/totalUpdates === 1 ? 'has' : 'have',/'',/" \
  -e 's/" been",/"",/' \
  -e 's/" update",/" Änderung",/' \
  -e "s/totalUpdates === 1 ? '' : 's'),/totalUpdates === 1 ? '' : 'en'),/" \
  -e 's/"since your last update\."/"seit Ihrer letzten Übersicht."/' \
  -e 's/"Edited by "/"Geändert von "/' \
  $m/page-update-digest-email.js
n=core/notification/services
sed -i \
  -e 's/`${actor.name} mentioned you in a comment`/`${actor.name} hat Sie in einem Kommentar erwähnt`/' \
  -e 's/`${actor.name} commented on ${pageTitle}`/`${actor.name} hat ${pageTitle} kommentiert`/' \
  -e 's/`${actor.name} resolved a comment on ${pageTitle}`/`${actor.name} hat einen Kommentar zu ${pageTitle} erledigt`/' \
  $n/comment.notification.js
sed -i \
  -e 's/`${actor.name} mentioned you in ${pageTitle}`/`${actor.name} hat Sie in ${pageTitle} erwähnt`/' \
  -e "s/role === 'writer' ? 'edit' : 'view'/role === 'writer' ? 'Schreib' : 'Lese'/" \
  -e 's/`${actor.name} gave you ${accessLabel} access to ${pageTitle}`/`${actor.name} hat Ihnen ${accessLabel}rechte für ${pageTitle} gegeben`/' \
  -e 's/`${actor.name} updated ${pageTitle}`/`${actor.name} hat ${pageTitle} geändert`/' \
  -e 's/`Your digest: ${pageUpdates.length} page ${/`Ihre Übersicht: ${pageUpdates.length} ${/' \
  -e "s/'update' : 'updates'}\`/'Änderung' : 'Änderungen'}\`/" \
  $n/page.notification.js
# Bau bricht ab, wenn eine Ersetzung nicht gegriffen hat (z. B. nach einem Docmost-Update)
for muster in "Einladung annehmen" "Hier ein neues Passwort festlegen" "Ihr Passwort wurde geändert" "hat Ihre Einladung angenommen" \
  "hat kommentiert:" "in einem Kommentar erwähnt:" "Kommentar erledigt:" "hat Sie erwähnt in" "rechte gegeben für" \
  "im Bereich " "Seite öffnen" "seit Ihrer letzten Übersicht." "Geändert von "; do
  grep -rq "$muster" $m || { echo "Mail-Text fehlt: $muster"; exit 1; }
done
grep -q "Passwort für Memkontor zurücksetzen" core/auth/services/auth.service.js
grep -q "lädt Sie zu Memkontor ein" core/workspace/services/workspace-invitation.service.js
grep -q '" Memkontor "' integrations/transactional/partials/partials.js
for f in comment-created comment-mention comment-resolved page-mention permission-granted page-update page-update-digest; do
  ! grep -qE '"(Hi there,|View|Hi )"' $m/$f-email.js || { echo "Englischer Rest in $f"; exit 1; }
done
[ "$(grep -c 'hat .*kommentiert`\|in einem Kommentar erwähnt`\|Kommentar zu .* erledigt`' $n/comment.notification.js)" -eq 3 ]
[ "$(grep -c "erwähnt\`\|rechte für .* gegeben\`\|geändert\`\|'Änderungen'}\`\|'Schreib' : 'Lese'" $n/page.notification.js)" -eq 5 ]
