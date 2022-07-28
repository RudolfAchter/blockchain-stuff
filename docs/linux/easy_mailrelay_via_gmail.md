# Easy Mail Relay via Gmail

- <https://www.cyberciti.biz/faq/postfix-smtp-authentication-for-mail-servers/>

My ISP requires that mail from my dynamic IP to our small business email addresses uses their outgoing SMTP servers. This is probably done to reduce abuse and spam but now I’m not able to send email and local Postfix log file displays authentication failure message. How do I relay mail through my mail ISP servers using Postfix SMTP under Linux / UNIX like operating systems?

Postfix has a method of authentication using SASL. It can use a text file or MySQL table as a special password database.

ADVERTISEMENT
Configure SMTP AUTH for mail servers
Create a text file as follows:

```bash
P=/etc/postfix/password
vi $P
```

The format of the client password file is as follows:

```text
smtp.isp.com          username:password
smtp.vsnl.in          vivek@vsnl.in:mySecretePassword
```

Save and close the file. Set permissions:

```bash
chown root:root $P
chmod 0600 $P
postmap hash:$P
```

Enable SMTP AUTH
Open main.cf file, enter:

```bash
vi /etc/postfix/main.cf
```

Append following config directives:

```text
relayhost = smtp.vsnl.in
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/password
smtp_sasl_security_options =
```

Where,

```text
relayhost = smtp.vsnl.in                                : Rely all mail via smtp.vsnl.in ISP mail server.
smtp_sasl_auth_enable = yes                             : Cyrus-SASL support for authentication of mail servers.
smtp_sasl_password_maps = hash:/etc/postfix/password    : Set path to sasl_passwd.
smtp_sasl_security_options =                            : Finally, allow Postfix to use anonymous and plaintext authentication by leaving it empty.
```
Save and close the file. Restart Postfix:

```bash
/etc/init.d/postfix reload
```

Test your setup by sending a text email:

```bash
echo 'This is a test.' > /tmp/test
mail -s 'Test' you@example.com < /tmp/test 
# tail -f /var/log/maillog 
# rm /tmp/test
```