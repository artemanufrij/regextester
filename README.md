<div>
  <h1 align="center">RegEx Tester</h1>
  <h3 align="center">A simple regex tester</h3>
  <p align="center">Designed for <a href="https://elementary.io"> elementary OS</p>
</div>
<a href="https://liberapay.com/Artem/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>
<p align="center">
  <a href="https://appcenter.elementary.io/com.github.artemanufrij.regextester">
    <img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter">
  </a>
</p>

<p align="center">
<img src="Screenshot.png"/>
</p>

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
