SMTP_SERVER="smtp.example.com"
SMTP_PORT="25"
SENDER_EMAIL="sender@example.com"
RECIPIENT_EMAIL="recipient@example.com"
EMAIL_SUBJECT="Test email subject"
EMAIL_BODY="This is a test email sent via telnet."

{
    echo "HELO example.com"
    sleep 2
    echo "MAIL FROM:<$SENDER_EMAIL>"
    sleep 2
    echo "RCPT TO:<$RECIPIENT_EMAIL>"
    sleep 2
    echo "DATA"
    sleep 2
    echo "Subject: $EMAIL_SUBJECT"
    echo "$EMAIL_BODY"
    echo "."
    sleep 2
    echo "QUIT"
} | telnet $SMTP_SERVER $SMTP_PORT

