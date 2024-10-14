#export SMTP_SERVER="mail.dev.kstadium.io"
#export SMTP_PORT="587"
#export SENDER_EMAIL="sender@{SMTP_SERVER}"
#export RECIPIENT_EMAIL="recipient@{SMTP_SERVER}"
#export EMAIL_SUBJECT="Test email subject"
#export EMAIL_BODY="This is a test email sent via telnet."
#
#{
#    echo "HELO example.com"
#    echo "MAIL FROM:<$SENDER_EMAIL>"
#    echo "RCPT TO:<$RECIPIENT_EMAIL>"
#    echo "Subject: $EMAIL_SUBJECT"
#    echo "$EMAIL_BODY"
#} | sendmail -t  $SMTP_SERVER:$SMTP_PORT



#export SMTPServer=localhost
export SMTPDomain=dev.kstadium.io
export SMTPServer=email-smtp.ap-northeast-2.amazonaws.com
export SMTPPort=587
export SMTPUsername=`echo -n "AKIA5ISTH5MDPIX6K4NZ" | openssl enc -base64`
export SMTPPassword=`echo -n "BB3rjsTFIbIAZ31bFzZbWaJmdkz48d2W9ahcEWesJImo" | openssl enc -base64`
export MAILFrom=noreply@${SMTPDomain}
export MAILTo=dorian.kim@mail.dev.kstadium.io



cat <<EOF > input.txt
EHLO ${SMTPDomain}
AUTH LOGIN
${SMTPUsername}
${SMTPPassword}
MAIL FROM: ${MAILFrom}
RCPT TO: ${MAILTo}
DATA
From: Sender Name <noreply@${SMTPDomain}>
To: ${MAILTo}
Subject: Amazon SES SMTP test
dorian open ssl test mail
.
QUIT
EOF


openssl s_client -crlf -quiet -starttls smtp -connect ${SMTPServer}:${SMTPPort} < input.txt

