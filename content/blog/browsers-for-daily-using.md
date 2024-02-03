+++
title = 'Browsers for Daily Using'
description = 'This is '
date = 2024-01-11
categories = [
    "privacy",
    "browser",
]
author = "anhkhoakz"
+++

- [Gecko Engine](#gecko-engine)
  - [Firefox, but hardened](#firefox-but-hardened)
  - [LibreWolf](#librewolf)
  - [Mullvad Browser](#mullvad-browser)
- [Blink Engine](#blink-engine)
  - [Ungoogled Chromium](#ungoogled-chromium)
  - [Brave Browser](#brave-browser)
- [Extensions](#extensions)
  - [uBlock Origin](#ublock-origin)
  - [CanvasBlocker (If you disable resistfingeprinting)](#canvasblocker-if-you-disable-resistfingeprinting)
  - [1Password or BitWarden](#1password-or-bitwarden)
  - [Dark Reader](#dark-reader)
  - [LanguageTool](#languagetool)
  - [Greasemonkey](#greasemonkey)
  - [LibRedirect](#libredirect)
  - [Omnivore](#omnivore)
  - [SimpleLogin](#simplelogin)
  - [Skip Redirect](#skip-redirect)
- [Conclusion](#conclusion)

From [Wikipedia: Comparison of Browser Engines,](https://wikiless.org/wiki/Comparison_of_browser_engines?lang=en) there are 4 browser engines that have **active** status: WebKit, Blink, Gecko, and Goanna. In this blog, I'll delve into the two most popular: [Gecko (Firefox-based)](#gecko-engine) and [Blink (Chromium-based)](#blink-engine).

## Gecko Engine

### Firefox, but hardened

This is my first choice when it comes to a browser for privacy. I love the Firefox browser, but I don't really like the way Mozilla develops it.

You can download Firefox on [Mozilla's website](https://www.mozilla.org/firefox/). But I don't recommend it because of the [download token](https://bugzilla.mozilla.org/show_bug.cgi?id=1677497#c0).

You can download it from [Mozilla's FTP website](https://ftp.mozilla.org/pub/firefox/releases/), by this way, you can choose any version of Firefox and download it without the token. You can decide whether the latest, extended support release, or EME-free version.

The default Mozilla Firefox will come with a large amount of telemetry and add-ons, which you don't really love to use.

For better privacy, you can config in `about:config` or use the `user.js` file, but it takes knowledge, time, and effort to review and make changes. So you will need a template to configure the browser.

There are three levels of hardening Firefox:
1. Easy: [Betterfox](https://github.com/yokoffing/Betterfox)
2. Medium: [arkenfox](https://github.com/arkenfox/user.js)
3. Hard: [Narsil](https://codeberg.org/Narsil/user.js/src/branch/main/desktop)

It depends on you to select which one is appropriate. Betterfox provides a slight change to Firefox, which doesn't affect the your experience too much. 

On the other hand, Narsil provides the maximum privacy and security on Firefox, but it will change the way you use Firefox.

If you want balance, choose arkenfox, it's the gold standard for Firefox.

For comparison, you can use the PowerShell script [Compare-UserJS](https://github.com/claustromaniac/Compare-UserJS) to pick the most appropriate for yourself.

And because they're templates, they are not fit for your use case. So you'll need a `user-overrides.js` to have your own modifications; you can check out the documentation for this one at [the Arkenfox Wiki](https://github.com/arkenfox/user.js/wiki/3.1-Overrides).

### LibreWolf

Home page: [LibreWolf](https://librewolf.net/)

Config file: [librewolf.cfg](https://codeberg.org/librewolf/settings/raw/branch/master/librewolf.cfg)

This project brings a mindless way to use Firefox without worrying about how to configure it. It looks like Ungoogled Chromium to Google Chrome.

But I have had some bad experiences when using it:
1. It's not able to use 1Password biometrics because [it lacks a code signature](https://1password.community/discussion/comment/633723/#Comment_633723). But it can work well with Bitwarden or KeePassXC.
     - I have the solution at: [Extending support for trusted web browsers](https://1password.community/discussion/140735/extending-support-for-trusted-web-browsers#latest).
2. Lacking of auto-update capacities raises a concern about security and [zero-day vulnerability](https://wikiless.org/wiki/Zero-day_(computing)?lang=en). But it can be fixed by using packet manager or using [LibreWolf WinUpdater](https://codeberg.org/ltguillaume/librewolf-winupdater).

So if you want a mindless way to use Firefox, don't use 1Password, and don't need a built-in updater, LibreWolf will be the best for you.

### Mullvad Browser

Home page: [Mullvad Browser](https://mullvad.net/en/browser)

Modifications: [Hard facts](https://mullvad.net/en/browser/hard-facts).

> Mullvad Browser is a collaboration between Mullvad VPN and the Tor Project.

This is the new one; I have not tried it yet, but it makes 0 connections in the initial. This should be a strong competitor to LibreWolf, comes with strong privacy and anti-fingerprinting features. 

It has 3 extensions built-in: uBlock Origin, NoScript, and Mullvad Browser Extension. It includes auto-updates and creating new identity features.

## Blink Engine

### Ungoogled Chromium

Home page: [ungoogled-chromium](https://ungoogled-software.github.io/)

Binary download: [Latest versions](https://ungoogled-software.github.io/ungoogled-chromium-binaries/)

> A lightweight approach to removing Google web service dependency

This is Chromium, so it will provide you with a bunch of extensions that will make your life easier.

It seems like this is the only browser based on chromiu, and I will recommend my friends use it. You just need to make some modifications, and it will work like Brave.

You'll have to install [an extension](https://github.com/NeverDecaf/chromium-web-store) to be able to install extensions from the Chrome Web Store.

Here are some `chrome://flags` I use:
- #extension-mime-request-handling: `Always prompt for install`
- #chrome-labs: `Disabled`

### Brave Browser

This is the most popular browser when you know the word **privacy**, and choose an alternative to Google Chrome.

But it has a lot of issues and features that make me don't want to use it anymore:
1. It has 7 connections when you first install it.
2. They have sponsored ads on browsers.
3. Brave Rewards needs a KYC account to use it.

I used the Brave browser, but I'm not happy with it anymore. Anything it provides is just a cut-off of some extensions. And if you have an extension, it will do better.

However, anything is better than Chrome, and you can have [some configurations](https://www.privacyguides.org/en/desktop-browsers/#recommended-configuration_1) to make Brave more private.

## Extensions

### [uBlock Origin](https://addons.mozilla.org/firefox/addon/ublock-origin/)
-  Blocking Mode: [Medium](https://github.com/gorhill/uBlock/wiki/Blocking-mode:-medium-mode)
-  Enable `AdGuard URL Tracking Protection`
-  Import [➗ Actually Legitimate URL Shortener Tool](https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt)
### [CanvasBlocker](https://addons.mozilla.org/en-US/firefox/addon/canvasblocker/) (If you disable resistfingeprinting)
### Skip Redirect
### 1Password or BitWarden
### SimpleLogin
### Firefox Multi-Account Containers
### LibRedirect
### Dark Reader
### Greasemonkey
### Omnivore
### Linguist
### LanguageTool

## Conclusion

In conclusion, there is absolutely no such thing as the best browser for anything. It depends on you; it will only have a less bad browser. You can base your decision on my article; it is just something I gathered from the Internet. In my case, I'll recommend using [Firefox hardened](#firefox-but-hardened) and [Ungoogled chromium](#ungoogled-chromium) because they fit my needs. However, the ideal choice varies for each user, and the goal is to find a browser that meets their unique criteria.

---

