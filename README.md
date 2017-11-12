# RegEx Tester

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.artemanufrij.regextester)

### A simple regex tester designed for [elementary OS](https://elementary.io)

![screenshot](Screenshot.png)

## Donations
If you liked _Regex Tester_, and would like to support it's development of this app and more, consider [buying me a coffee](https://www.paypal.me/ArtemAnufrij) :)

## Install from Github.

As first you need elementary SDK
```
sudo apt install elementary-sdk
```

Clone repository and change directory
```
git clone https://github.com/artemanufrij/regextester.git
cd regextester
```

Create **build** folder, compile and start Regextester
```
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
./src/com.github.artemanufrij.regextester
```

(optional) Install Regextester on your system
```
sudo make install
```
