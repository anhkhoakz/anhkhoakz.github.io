+++
title = 'How I Configure Firefox'
description = ""
date = 2024-01-15T10:47:43+07:00
draft = true
tags = []
author = "anhkhoakz"
+++

---

I've recommend to all of you about [Browsers for Daily Using]({})

And this is not a tutorial, it's just how I configure Firefox. You can have more information when look at [arkenfox wiki](https://github.com/arkenfox/user.js/wiki).

### Step 1: Install Firefox

Download and install Firefox from [Mozilla's FTP website](https://ftp.mozilla.org/pub/firefox/releases/121.0/).

You can choose which OS you're using and decide will it have [EME](https://hsivonen.fi/eme/) or not, you will be able to choose language but I will recommend using `en-US` version. It will download the Mozilla Firefox version without [download token](https://bugzilla.mozilla.org/show_bug.cgi?id=1677497#c0).

Don't worry about out-dated-version, it will automatically update when your first running.

### Step 2: Obtaining user.js

You can configure Firefox by yourself by entering `about:config` into the address bar but I will get it easy for you.

1. Download a `user.js`, you can choose:

    1. Easy: [Betterfox](https://github.com/yokoffing/Betterfox/)
    2. Medium: [arkenfox](https://github.com/arkenfox/user.js/)
    3. Hard: [Narsil](https://git.nixnet.services/Narsil/desktop_user.js/)

    You can easily download it by `git clone` or `curl -O` command. Or you just only clicking on `Download` button. Downloading a single `user.js` file is enough but downloading the whole project is recommended.

2. Turning off network. You don't want Firefox make any [connections](https://sizeof.cat/post/web-browser-telemetry/#mozilla-firefox) when you first running it.
3. Start Firefox and enter `about:profiles` in the address bar.
4. Create a new profile and ensure it's marked as `Default Profile: yes`.
5. Copy the `Root Directory` and exit.
6. Move to your profiles and delete all contents from the new profile.
    ```sh
    cd /path/to/your/profile && rm -r *
    ```
7. Copy `user.js` file into the folder profile.
    ```shell
    cp /path/to/user.js /path/to/your/profile
    ```

### Step 3: Customize User Overrides

A `user.js` file likes a uniform, it made to fit everyone, and will not fit with you. You'll need some configurations to make it works best for you.

You can

I'll recommend you some configures which I think anyone will need it if using arkenfox:

-   `extensions.pocket.enabled`: `False`
-   `identity.fxaccounts.enabled`: `False`
-   `browser.preferences.moreFromMozilla`: `False`

I'm currently using arkenfox for ease of use. You can have a look at my [`user-overrides.js`](https://codeberg.org/anhkhoakz/arkenfox_user-overrides). But as I said, it will only fit my needs.

For more tutorial, please following [this tutorial](https://github.com/arkenfox/user.js/wiki/3.1-Overrides)

### Step 4: Install Updater Script

Install [updater.sh](https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh) by following [these instructions](https://github.com/arkenfox/user.js/wiki/3.4-Apply-&-Update-&-Maintain). Download the required files:

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

6. [uBlock Origin](https://github.com/gorhill/uBlock)
7. [Multi-Account Containers](https://github.com/mozilla/multi-account-containers)
8. [Skip Redirect](https://github.com/sblask/webextension-skip-redirect)

Check out additional extensions [here](https://github.com/arkenfox/user.js/wiki/4.1-Extensions).

### Step 7: Choose a Search Engine

Consider using alternative search engines such as [searx](https://searx.github.io/searx/). Learn more about search engine options [here](https://digdeeper.neocities.org/articles/search).

### Custom version of Firefox

For a hassle-free alternative, explore [Librewolf](https://librewolf.net/) as a custom version of Firefox.

---
