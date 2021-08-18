# FreeTDM
http://wiki.freeswitch.org/wiki/FreeTDM

# mod_freetdm

## Table of Contents

* [Table of Contents](#table-of-contents)
  * [Build and install mod_freetdm](#build-and-install-mod_freetdm)

## Build and install mod_freetdm

Change to a directory where the FreeSWITCH sources will be compiled

```console
cd /usr/src
```

Clone the FreeSWITCH repository into the above directory

```console
git clone https://github.com/signalwire/freeswitch.git
```

Perform an initial bootstrap of FreeSWITCH so that a `modules.conf` file is created

```console
./bootstrap.sh
```

Add the mod_freetdm to `modules.conf` so that an out-of-source build will be performed

```console
mod_freetdm|https://github.com/freeswitch/freetdm.git -b master
```

Configure, build and install FreeSWITCH

```console
./configure
make
make install
```

The following commands will build and install *only* mod_freetdm

```console
make mod_freetdm
make mod_freetdm-install
```

To run mod_freetdm within FreeSWITCH, perform the following two steps

```console
Add mod_freetdm to freeswitch/conf/autoload_configs/modules.conf.xml
Add freetdm.conf.xml to freeswitch/conf/autoload_configs
```
