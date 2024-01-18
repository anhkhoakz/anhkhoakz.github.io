+++
title = 'Tuta Mail Review'
date = 2024-01-11
draft = true
categories = [
]
+++

![Tuta Logo](https://tuta.com/resources/images/press/tutanota-red-gray-font-logo.svg)

- [Advantages](#advantages)
  - [End-to-end encryption](#end-to-end-encryption)
  - [Audited](#audited)
  - [Affordable price](#affordable-price)
  - [Renewable energy](#renewable-energy)
  - [Ads free](#ads-free)
  - [Open-source](#open-source)
  - [Becoming LibreJS Compliant](#becoming-librejs-compliant)
  - [Responsiveness](#responsiveness)
- [Disadvantages](#disadvantages)
  - [Lacking of PGP](#lacking-of-pgp)
  - [Lacking mail client](#lacking-mail-client)
  - [Logging](#logging)
    - [Storing anonymized IP](#storing-anonymized-ip)
    - [Storing metadata](#storing-metadata)
    - [Storing credit card data](#storing-credit-card-data)
  - [Blocking anonymous users](#blocking-anonymous-users)
  - [Slow](#slow)
  - [Many updates](#many-updates)
  - [Marked as spam](#marked-as-spam)
  - [Insufficient storage space](#insufficient-storage-space)
  - [Fourteen Eyes Countries](#fourteen-eyes-countries)
- [Thought / User experience](#thought--user-experience)
- [Conclusion](#conclusion)
- [Definition](#definition)
- [Reference](#reference)

# Advantages
## End-to-end encryption
If you're using really secured, privacy email service and the people you're communicating using Gmail. It's all useless.
If they do use Tuta. It's automatically encrypted.
But you can use end-to-end encryption with shared password although the non-Tuta one. 
You can use [Signal](https://signal.org/) to share your password or face to face.

It is very easy to encrypt with Tuta than PGP.
## Audited
https://github.com/tutao/tutanota/issues/601#issuecomment-435793028

https://github.com/tutao/tutanota/issues/2787#issue-820967298

## Affordable price
![Tuta Personal Plan](https://pixelfed.social/storage/m/_v2/624143499767577403/bf4779419-8cf74f/gSnilXVbMuTt/bvBXPFzRaiXcXnU88tRCylH0VZ5wdUBdl3NTabtj.png)

## Renewable energy
[Sustainability at Tuta](https://tuta.com/sustainability)


## Ads free

## Open-source
[A team of open source enthusiasts](https://tuta.com/open-source)

[Tutanota for Open Source Projects](https://tuta.com/blog/posts/tutanota-for-open-source-teams/)

## Becoming LibreJS Compliant
[](https://www.fsf.org/resources/webmail-systems)


## Responsiveness
They are quite good at keeping their customers informed, clearly explaining reasons for changes and developments. They have a good blog and web presence and are generally touted as a good alternative for email in the privacy communities.




# Disadvantages
## Lacking of PGP
Sharing password is not easy, and PGP can resolve it with public key.
I know that PGP is not quantum resist. But don't support other encryption method like PGP can c
> ### Why does Tuta Mail not use PGP?
> Tuta uses standard algorithms also being used by PGP (AES 128 / RSA 2048) for encrypting the entire mailbox. Tuta does not use an implementation of PGP itself because PGP lacks important requirements that we plan to fix with Tuta:
>
> PGP does not encrypt the subject line (already achieved in Tuta),
>
> PGP algorithms can't be easily updated (which we need to do when updating to post-quantum secure algorithms),
>
> PGP has no option for Perfect Forward Secrecy (already achieved in our post-quantum prototype).
>
> In Tuta we can easily update the algorithms, and we plan to replace the current algorithms with quantum secure hybrid protocol in the near future. The flexibility of Tuta enables us to integrate an encrypted calendar, encrypted cloud storage and many more features much easier and faster than it would have been possible with an implementation of PGP.


## Lacking mail client
Not using mail client make Tuta can technically serve you a malicious login page to steal your credential and decrypt all of yours.

Mail client support is crucial because it lets you choose a program that fits your workflow, avoiding dependence on provider-specific changes.

Mail clients remain consistent, unlike webmail that can change unexpectedly.

They use standardized protocols, giving you control over downloaded emails.

Importantly, mail clients support robust encryption like PGP, enhancing security compared to some webmail providers.


## Logging
> In order to maintain email server operations, for error diagnosis and for prevention of abuse, mail server logs are stored max. 7 days. These logs contain sender and recipient email addresses and time of connection but no customer IP addresses. Storage takes place for the purposes of the legitimate interests pursued by the controller according to Art. 6 para. 1 p. 1 lit. f\) GDPR.

### Storing anonymized IP
> In order to maintain operations, for prevention of abuse and and for visitors analysis, IP addresses of users are processed. Storage only takes place for IP addresses made anonymous which are therefore not personal data any more. This processing takes place for the purposes of the legitimate interests pursued by the controller according to Art. 6 para. 1 p. 1 lit. f) GDPR.

### Storing metadata

### Storing credit card data
> With the exception of payment data, we will not disclose your personal data including your email address to third parties. However, we can be legally bound to provide content data (in case of a valid court order) and inventory data to prosecution services. There will be no sale of data.

> For the execution of credit card payments your credit card data will be shared with our payment service provider [Braintree](https://www.braintreepayments.com/). This includes the transfer of personal data into a third country (USA). [An agreement entered into with Braintree](https://www.braintreepayments.com/assets/Braintree-PSA-Model-Clauses-March2018.pdf) defines appropriate safeguards and demands that the data is only processed in compliance with the GDPR and only for the purpose of execution of payments.


## Blocking anonymous users
![Tuta block](https://digdeeper.neocities.org/images/tutanota_anon.png)

## Slow
Because of strong encryption, your email takes time to load, switch boxes, delete, and save messages.

## Many updates
Regularly update software is a good thing, but Tuta has many notifications on inbox which can be bothered when log on.

## Marked as spam
Who are the people use encrypted email? The privacy guy is one of them. There are hackers, spammer, ... who use the services.

Instead of blocking the trouble one, some service provider choose block the domain.

## Insufficient storage space
Google comes with 15Gb as the default. And Tuta comes with 1Gb.

It is easy to understand that cost to maintain a server is expensive. And giving a large storage for free users lead the business come to the end.

Their paid plan also [affordable](#affordable-price), so you can upgrade to the premium one without hesitation.

## Fourteen Eyes Countries
https://tuta.com/blog/posts/fourteen-eyes-countries/
https://en.wikipedia.org/wiki/UKUSA_Agreement


# Thought / User experience

# Conclusion


# Definition
PGP: 
Email client: 



# Reference
[DigDeeper - E-mail providers - which one to choose?](https://digdeeper.neocities.org/articles/email#Tutanota)

[Tuta - Innovative encryption: Tutanota makes encryption easily accessible to all](https://tuta.com/blog/posts/innovative-encryption/)

[The Privacy Dad - Why my Friend Quit Tutanota](https://theprivacydad.com/why-my-friend-quit-tutanota/)