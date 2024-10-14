#개인테스트용임
openssl req -new -newkey rsa:2048 -nodes -keyout kimutae.iptime.org.key -out kimutae.iptime.org.csr -subj "/CN=kimutae.iptime.org"
cat kimutae.iptime.org.csr | base64 | tr -d '\n'
