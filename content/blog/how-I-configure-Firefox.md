+++
title = 'How I Configure Firefox'
description = "Some tips to configure Firefox"
date = 2024-01-15T10:47:43+07:00
draft = false
tags = []
author = "anhkhoakz"
+++
---

I've recommended to all of you [Browsers for Daily Using]({{< relref
"browsers-for-daily-using.md" >}}).

This is not a tutorial; it's just how I configure Firefox. You can find more
information in the [arkenfox wiki](https://github.com/arkenfox/user.js/wiki).

### Step 1: Install Firefox

Download and install Firefox from [Mozilla's FTP
website](https://ftp.mozilla.org/pub/firefox/releases).

You can choose your OS and decide whether to include
[EME](https://hsivonen.fi/eme/) or not. You can also select the language, but I
recommend using the `en-US` version. This version downloads Mozilla Firefox
without a [download
token](https://bugzilla.mozilla.org/show_bug.cgi?id=1677497#c0).

Don't worry about outdated versions; Firefox will automatically update when you
first run it.

### Step 2: Obtaining user.js

You can configure Firefox yourself by entering `about:config` into the address
bar, but I'll make it easier for you.

1. Download a `user.js`. You can choose:

    - **Easy**: [Betterfox](https://github.com/yokoffing/Betterfox/)

    - **Medium**: [arkenfox](https://github.com/arkenfox/user.js/)

    - **Hard**: [Narsil](https://git.nixnet.services/Narsil/desktop_user.js/)

    You can download it using `git clone`, `curl -O`, or by clicking the
`Download` button. Downloading a single `user.js` file is sufficient, but
downloading the entire project is recommended.

2. Turn off your network. You don't want Firefox to make any
[connections](https://sizeof.cat/post/web-browser-telemetry/#mozilla-firefox)
when you first run it.

3. Start Firefox and enter `about:profiles` in the address bar.

4. Create a new profile and ensure it's marked as `Default Profile: yes`.

5. Copy the `Root Directory` and exit Firefox.

6. Navigate to your profile directory and delete all contents from the new
profile:

    ```sh
    cd /path/to/your/profile && rm -rf *
    ```

7. Copy the `user.js` file into the profile folder:

    ```sh
    cp /path/to/user.js /path/to/your/profile

    ```

### Step 3: Customize User Overrides

A `user.js` file is like a uniform; it is made to fit everyone but may not fit
you perfectly. You'll need some configurations to make it work best for you.

You can customize it by editing the `user.js` file directly or creating a
`user-overrides.js` file to override specific settings.

Here are some configurations I recommend for anyone using arkenfox:

- `extensions.pocket.enabled`: `False`

- `identity.fxaccounts.enabled`: `False`

- `browser.preferences.moreFromMozilla`: `False`

I'm currently using arkenfox for ease of use. You can check out my
[`user-overrides.js`](https://paste.sr.ht/~anhkhoakz/928da4827f209d1963c125669e842a4e1ee3876a).
However, as I mentioned, it will only fit my needs.

For more tutorials, please follow [this
guide](https://github.com/arkenfox/user.js/wiki/3.1-Overrides).

### Step 4: Install Updater Script

Install
[updater.sh](https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh)
by following [these
instructions](https://github.com/arkenfox/user.js/wiki/3.4-Apply-&-Update-&-Maintain).
Download the required files:

```sh
curl -O https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.sh
curl -O https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh
```

Set permissions and execute:

```sh
chmod +x ./prefsCleaner.sh
chmod +x ./updater.sh
./updater.sh
./prefsCleaner.sh
```

### Step 5: Restart Firefox

### Step 6: Install Essential Extensions

Here are some essential extensions I recommend:

1. [uBlock Origin](https://github.com/gorhill/uBlock)

2. [Multi-Account
Containers](https://github.com/mozilla/multi-account-containers)

3. [Skip Redirect](https://github.com/sblask/webextension-skip-redirect)

Check out additional extensions
[url](https://github.com/arkenfox/user.js/wiki/4.1-Extensions).

### Step 7: Choose a Search Engine

Consider using alternative search engines such as
[searx](https://searx.github.io/searx/). Learn more about search engine options
[url](https://digdeeper.neocities.org/articles/search).

### Custom Version of Firefox

For a hassle-free alternative, explore [Librewolf](https://librewolf.net/) as a
custom version of Firefox.

---
