export SMTPDomain=dev.kstadium.io
export SMTPServer=localhost
export SMTPPort=1587
export SMTPUsername=`echo -n "AKIA5ISTH5MDEDZFIWE6" | openssl enc -base64`
export SMTPPassword=`echo -n "BFdCIJFAC2N0+8NdD9T0FqGDZozoJ1EpezKToLd50ekb" | openssl enc -base64`
export MAILFrom=noreply@${SMTPDomain}
export MAILTo=dorian.kim@kstadium.io


#${SMTPUsername}
#${SMTPPassword}
#AUTH LOGIN

cat <<EOF > input.txt
EHLO ${SMTPDomain}
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
