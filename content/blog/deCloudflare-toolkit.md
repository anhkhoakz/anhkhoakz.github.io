+++
title = 'DeCloudflare Toolkit'
description = ""
date = 2024-01-16T14:57:34+07:00
draft = false
tags = []
author = "anhkhoakz"
+++

---

<summary><h3>Website owner / Web developer</h3></summary>


- Do not use Cloudflare solution, Period.
  - You can do better than that, right? [Here's how to remove Cloudflare subscriptions, plans, domains, or accounts.](https://support.cloudflare.com/hc/en-us/articles/200167776-Removing-subscriptions-plans-domains-or-accounts)


- Want more customers? You know what to do. Hint is "above line".
  - [Hello, you wrote "We take your privacy seriously" but I got "Error 403 Forbidden Anonymous Proxy Not Allowed".](https://it.slashdot.org/story/19/02/19/0033255/stop-saying-we-take-your-privacy-and-security-seriously) Why are you blocking Tor Or VPN? And why are you blocking temporary emails?


- Using Cloudflare will increase chances of an outage. Visitors can't access to your website if your server is down or Cloudflare is down.
  - [Did you really think Cloudflare never go down?](https://www.ibtimes.com/cloudflare-down-not-working-sites-producing-504-gateway-timeout-errors-2618008).


- Using Cloudflare to proxy your "API service", "software update server" or "RSS feed" will harm your customer. A customer called you and said "I can't use your API anymore", and you have no idea what is going on. Cloudflare can silently block your customer. Do you think it is okay?
  - There are many RSS reader client and RSS reader online service. Why are you publishing RSS feed if you're not allowing people to subscribe?


- Do you need HTTPS certificate? Use "Let's Encrypt" or just buy it from CA Company.
- Do you need DNS server? Can't set up your own server? How about them: 
  - [Hurricane Electric Free DNS](https://dns.he.net/)
  - [Dyn.com](https://dyn.com/dns/)
  - [1984 Hosting](https://www.1984hosting.com/)
  - [Afraid.Org (Admin delete your account if you use TOR)](https://freedns.afraid.org/)
  | ----------------------------------------------------------------------------- | -------------------------------------------------------- | ----- |
  | [1984 Hosting](https://www.1984hosting.com/)                                  | No customer support                                      | Free  |
  | [Afraid.Org](https://freedns.afraid.org/)                                     | Admin will delete your account if you create one via Tor | Free  |
  | [DNSMadeEasy](https://dnsmadeeasy.com/)                                       | Limited Queries per month                                | Paid  |
  | [Dyn.com](https://dyn.com/dns/)                                               | -                                                        | Paid  |
  | [Hetzner DNS](https://docs.hetzner.com/dns-console/dns/general/dns-overview/) | -                                                        | ?     |
  | [Hurricane Electric Free DNS](https://dns.he.net/)                            | -                                                        | Free  |
  | [LuaDNS](https://luadns.com/)                                                 | API supported                                            | Free  |
  | [deSEC](https://desec.io/)                                                    | dynamic DNS & API supported                              | Free  |


  ## Why X is not included
  | X                                                               | Reason                                                              |
  | --------------------------------------------------------------- | ------------------------------------------------------------------- |
  | [Namecheap DNS](https://www.namecheap.com/domains/freedns/)     | Using Cloudflare & defended Cloudflare while discussion on Twitter. |
  | [Selectel DNS](https://selectel.ru/en/services/additional/dns/) | Using Cloudflare                                                    |


- Looking for hosting service? Free only? How about them: [Onion Service](http://vww6ybal4bd7szmgncyruucpgfkqahzddi37ktceo3ah7ngmcopnpyyd.onion/en/security/network-security/tor/onionservices-best-practices), [Free Web Hosting Area](https://freewha.com/), [Autistici/Inventati Web Site Hosting](https://www.autinv5q6en4gpf4.onion/services/website), [Github Pages](https://pages.github.com/), [Surge](https://surge.sh/)
  - [Alternatives to Cloudflare](../subfiles/alternative/cloudflare.md)
- Are you using "Cloudflare-ipfs.com"? [Do you know Cloudflare IPFS is bad?](../PEOPLE.md)
- Install Web Application Firewall such as OWASP and Fail2Ban on your server and configure it properly.
  - Blocking Tor is not a solution. Don't punish everyone just for small bad users.
- Redirect or block "Cloudflare Warp" users from accessing your website. And provide a reason if you can.

> IP list: "[Cloudflare’s current IP ranges](../cloudflare_inc/)"

> A: Just block them

```
server {
...
deny 173.245.48.0/20;
deny 103.21.244.0/22;
deny 103.22.200.0/22;
deny 103.31.4.0/22;
deny 141.101.64.0/18;
deny 108.162.192.0/18;
deny 190.93.240.0/20;
deny 188.114.96.0/20;
deny 197.234.240.0/22;
deny 198.41.128.0/17;
deny 162.158.0.0/15;
deny 104.16.0.0/12;
deny 172.64.0.0/13;
deny 131.0.72.0/22;
deny 2400:cb00::/32;
deny 2606:4700::/32;
deny 2803:f800::/32;
deny 2405:b500::/32;
deny 2405:8100::/32;
deny 2a06:98c0::/29;
deny 2c0f:f248::/32;
...
}
```

> B: Redirect to warning page

```
http {
...
geo $iscf {
default 0;
173.245.48.0/20 1;
103.21.244.0/22 1;
103.22.200.0/22 1;
103.31.4.0/22 1;
141.101.64.0/18 1;
108.162.192.0/18 1;
190.93.240.0/20 1;
188.114.96.0/20 1;
197.234.240.0/22 1;
198.41.128.0/17 1;
162.158.0.0/15 1;
104.16.0.0/12 1;
172.64.0.0/13 1;
131.0.72.0/22 1;
2400:cb00::/32 1;
2606:4700::/32 1;
2803:f800::/32 1;
2405:b500::/32 1;
2405:8100::/32 1;
2a06:98c0::/29 1;
2c0f:f248::/32 1;
}
...
}

server {
...
if ($iscf) {rewrite ^ https://example.com/cfwsorry.php;}
...
}

<?php
header('HTTP/1.1 406 Not Acceptable');
echo <<<CFHTML
Thank you for visiting ourwebsite.com!<br />
We are sorry, but we can't serve you because your connection is being intercepted by Cloudflare.<br />
<a href="http://crimeflare.eu.org">Please read why for more information</a>.<br />
CFHTML;
die();
```

- Set up Tor Onion Service or I2P insite if you believe in freedom and welcome anonymous users.
- Ask for advice from other Clearnet/Tor dual website operators and make anonymous friends!


<summary><h3>Software user</h3></summary>

- Discord is using Cloudflare. Alternatives? We recommend [**Briar** (Android)](https://f-droid.org/en/packages/org.briarproject.briar.android/), [Ricochet (PC)](https://ricochet.im/), [Tox + Tor (Android/PC)](https://tox.chat/download.html)

  - Briar includes Tor daemon so you don't have to install Orbot.
  - Qwtch developers, Open Privacy, deleted stop_Cloudflare project from their git service without notice.
- If you use Debian GNU/Linux, or any derivative, subscribe: [bug #831835](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=831835). And if you can, help verify the patch, and help the maintainer come to the right conclusion on whether it should be accepted.
- Always recommend these browsers.

| Name                                                                                    | Developer   | Support                                                    | Comment                       |
| --------------------------------------------------------------------------------------- | ----------- | ---------------------------------------------------------- | ----------------------------- |
| [Ungoogled-Chromium](https://ungoogled-software.github.io/ungoogled-chromium-binaries/) | Eloston     | [ ? ](https://github.com/Eloston/ungoogled-chromium)       | PC (Win, Mac, Linux) _!Tor_   |
| [Bromite](https://www.bromite.org/fdroid)                                               | Bromite     | [ ? ](https://github.com/bromite/bromite/issues)           | Android _!Tor_                |
| [Tor Browser](https://www.torproject.org/download/)                                     | Tor Project | [ ? ](https://support.torproject.org/)                     | PC (Win, Mac, Linux) _Tor_    |
| [Tor Browser Android](https://www.torproject.org/download/#android)                     | Tor Project | [ ? ](https://support.torproject.org/)                     | Android_Tor_                  |
| [Onion Browser](https://itunes.apple.com/us/app/onion-browser/id519296448?mt=8)         | Mike Tigas  | [ ? ](https://github.com/OnionBrowser/OnionBrowser/issues) | Apple iOS_Tor_                |
| [GNU/Icecat](https://www.gnu.org/software/gnuzilla/)                                    | GNU         | [ ? ](https://www.gnu.org/software/gnuzilla/)              | PC (Linux)                    |
| [IceCatMobile](https://f-droid.org/en/packages/org.gnu.icecat/)                         | GNU         | [ ? ](https://lists.gnu.org/mailman/listinfo/bug-gnuzilla) | Android                       |
| [Iridium Browser](https://iridiumbrowser.de/about/)                                     | Iridium     | [ ? ](https://github.com/iridium-browser/iridium-browser/) | PC (Win, Mac, Linux, OpenBSD) |

Other software's privacy is imperfect. This doesn't mean Tor browser is "perfect".
There is no 100% secure nor 100% private on the internet and technology.

- Don't want to use Tor? You can use any browser with Tor daemon.
  - [Note that the Tor project don't like this.](https://support.torproject.org/tbb/tbb-9/) Use Tor Browser if you are able to do so.
- [How to use Chromium with Tor](../subfiles/chromium_tor.md)

Let's talk about other software's privacy.

- [If you really need to use Firefox, pick "Firefox ESR".](https://www.mozilla.org/en-US/firefox/organizations/)

  - [Firefox - Spyware Watchdog](https://spyware.neocities.org/articles/firefox.html)
  - [Firefox rejects free speech, bans free speech](https://web.archive.org/web/20200423010026/https://reclaimthenet.org/firefox-rejects-free-speech-bans-free-speech-commenting-plugin-dissenter-from-its-extensions-gallery/)
  - ["100+ downvotes. It seems like asking a software company to stick to... software is just too much these days."](https://old.reddit.com/r/firefox/comments/gutdiw/weve_got_work_to_do_the_mozilla_blog/fslbbb6/)
  - [Uh, why is Firefox showing me sponsored links in my URL bar?](https://old.reddit.com/r/firefox/comments/jybx2w/uh_why_is_firefox_showing_me_sponsored_links_in/)
  - [Mozilla - Devil Incarnate](https://digdeeper.neocities.org/ghost/mozilla.html)
- [Remember, Mozilla is using Cloudflare service.](https://www.robtex.com/dns-lookup/www.mozilla.org) [They're also using Cloudflare's DNS service on their product.](https://www.theregister.co.uk/2018/03/21/mozilla_testing_dns_encryption/)
- [Mozilla officially rejected this ticket.](https://bugzilla.mozilla.org/show_bug.cgi?id=1426618)
- [Firefox Focus is a joke.](https://github.com/mozilla-mobile/focus-android/issues/1743) [They promised to turn off telemetry but they changed it.](https://github.com/mozilla-mobile/focus-android/issues/4210)
- [PaleMoon/Basilisk developer loves Cloudflare.](https://github.com/mozilla-mobile/focus-android/issues/1743#issuecomment-345993097)

  - [Pale Moon's Archive Server hacked and spread malware for 18 Months](https://reddit.com/r/privacytoolsIO/comments/cc808y/pale_moons_archive_server_hacked_and_spread/)
  - He also hate Tor users - "[Let it be hostile towards Tor. I think most sites should be hostile towards Tor considering its extremely high abuse factor.](https://github.com/yacy/yacy_search_server/issues/314#issuecomment-565932097)"
- [Waterfox have severe "phones home" problem](https://spyware.neocities.org/articles/waterfox.html)
- [Google Chrome is a spyware.](https://www.gnu.org/proprietary/malware-google.en.html)

  - [Google profiles your activity.](https://spyware.neocities.org/articles/chrome.html)
- [SRWare Iron make too many phones home connection.](https://spyware.neocities.org/articles/iron.html) It also connect to google domains.
- [Brave Browser whitelist Facebook/Twitter trackers.](https://www.bleepingcomputer.com/news/security/facebook-twitter-trackers-whitelisted-by-brave-browser/)

  - [Here's more issues.](https://spyware.neocities.org/articles/brave.html)
  - [binance affiliate ID](https://twitter.com/cryptonator1337/status/1269594587716374528)
- [Microsoft Edge lets Facebook run Flash code behind users' backs.](https://www.zdnet.com/article/microsoft-edge-lets-facebook-run-flash-code-behind-users-backs/)
- [Vivaldi does not respect your privacy.](https://spyware.neocities.org/articles/vivaldi.html)
- [Opera spyware level: Extremely High](https://spyware.neocities.org/articles/opera.html)
- Apple iOS: [You shouldn't be using iOS at all, mainly because it is malware.](https://www.gnu.org/proprietary/malware-apple.html)

Therefore we recommend above table only. Nothing else.


<summary><h3>Mozilla Firefox user</h3></summary>

- "Firefox Nightly" will send debug-level information to Mozilla servers without opt-out method.

  - [Mozilla servers are behing Cloudflare](https://www.digwebinterface.com/?hostnames=www.mozilla.org%0D%0Amozilla.Cloudflare-dns.com&type=&ns=resolver&useresolver=8.8.4.4&nameservers=)
- It is possible to prohibit Firefox to connect to Mozilla servers.

  - [Mozilla's policy-templates guide](https://github.com/mozilla/policy-templates/blob/master/README.md)
  - Keep in mind this trick might stop working in later version because Mozilla likes to whitelist themselves.
  - Use firewall and DNS filter to block them completely.

"`/distribution/policies.json`"

```json
"WebsiteFilter": {
"Block": [
"*://*.mozilla.com/*",
"*://*.mozilla.net/*",
"*://*.mozilla.org/*",
"*://webcompat.com/*",
"*://*.firefox.com/*",
"*://*.thunderbird.net/*",
"*://*.cloudflare.com/*"
]
},
```

- ~~Report a bug on mozilla's tracker, telling them not to use Cloudflare.~~ There was a bug report on bugzilla. Many people were posted their concern, however the bug was hidden by the admin in 2018.
- You can disable DoH in Firefox.
  - [Change default DNS provider of firefox](../subfiles/change-firefox-dns.md)


- [If you would like to use non-ISP DNS, consider using OpenNIC Tier2 DNS service or any of non-Cloudflare DNS services.](https://wiki.opennic.org/start)
  - Block Cloudflare with DNS. [Crimeflare DNS](../subfiles/service/publicdns.md)
- You can use Tor as DNS resolver. [If you're not Tor expert, ask question here.](https://tor.stackexchange.com/)

**How?**

1. Download Tor and install it on your computer.
2. Add this line to "torrc" file.
   DNSPort 127.0.0.1:53
3. Restart Tor.
4. Set your computer's DNS server to "127.0.0.1".


<summary><h3>Action</h3></summary>

- Tell others around you about the dangers of Cloudflare.
- [Help improve this repository.](http://crimeflare.eu.org)
  - Both the lists, the arguments against it and the details.
- [Document and make very public where things go wrong with Cloudflare (and similar companies), making sure to mention this repository when you do so](http://crimeflare.eu.org) :)
- Get more people using Tor by default, so they can experience the web from the perspective of different parts of the world.
- Start groups, in social media and meatspace, dedicated to liberating the world from Cloudflare.
- Where appropriate, link to these groups on this repository - this can be a place for coordinating working together as groups.
- [Start a coop that can provide a meaningful non corporate alternative to Cloudflare.](../subfiles/alternative/cloudflare.md)
- Let us know of any alternatives to help at least provide multiple layered defence against Cloudflare.
- If you are a Cloudflare customer, set your privacy settings and wait for them to violate them.
  - [Then bring them under anti-spam/privacy violation charges.](https://twitter.com/thexpaw/status/1108424723233419264)
- If you are in the United States of America and the website in question is a bank or an accountant, try to bring legal pressure under the Gramm–Leach–Bliley Act, or the Americans with Disabilities Act and report back to us how far you get.
- If the website is a government site, try to bring legal pressure under the 1st Amendment of the US Constitution.
- If you are EU citizen, contact the website to send your personal information under the General Data Protection Regulation. If they refuse to give you your information, that's a violation of the law.
- For companies that claim to offer service on their website try reporting them as "false advertising" to consumer protection organizations and BBB. Cloudflare websites are served by Cloudflare servers.
- [The ITU suggest in the US context that Cloudflare is starting to get big enough that antitrust law might be brought down upon them.](https://www.itu.int/en/ITU-T/Workshops-and-Seminars/20181218/Documents/Geoff_Huston_Presentation.pdf)
- It's conceivable that the GNU GPL version 4 could include a provision against storing source code behind such a service, requiring for all GPLv4 and later programs that at least the source code is accessible via a medium that does not discriminate against Tor users.
- [Se vi uzas Mastodon bonvolu sekvi la konton Mitigator](../subfiles/service/altlink.md).


### Comments

> There is always hope in resistance.
>
> Resistance is fertile.
>
> Even some of the darker outcomes comes to be, the very act of resistance trains us to continue to destabilize the dystopic status quo that results.
>
> Resist!

> Someday, you'll understand why we wrote this.

> There isn't anything futuristic about this. We have already lost.

---