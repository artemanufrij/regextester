# RegEx Tester

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.artemanufrij.regextester)

### A simple regex tester designed for [elementary OS](https://elementary.io)

![screenshot](Screenshot.png)


### Hot to build from github.

* Clone repository and move into folder
```
git clone https://github.com/artemanufrij/regextester.git
cd regextester
```

* Create **build** folder, compile and start Regextester
```
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
./src/com.github.artemanufrij.regextester
```

* (optional) Install on your system
```
sudo make install
```
