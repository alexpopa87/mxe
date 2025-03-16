# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libusb1
$(PKG)_WEBSITE  := https://libusb.info/
$(PKG)_DESCR    := LibUsb-1.0
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.20-rc3-event-abstraction-v4
$(PKG)_CHECKSUM := 58fee7f3f05fda209d14c55763df36ab86028bd9ab82c9bb74f1d5ab3208bcfd
$(PKG)_SUBDIR   := libusb-event-abstraction-v4
$(PKG)_FILE     := libusb-event-abstraction-v4.zip
$(PKG)_URL      := https://github.com/uwehermann/libusb/archive/event-abstraction-v4.zip
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/libusb/files/libusb-1.0/' | \
    grep -i 'libusb/files/libusb-1.0' | \
    $(SED) -n 's,.*/libusb-1.0/libusb-\([0-9\.]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -i && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS=-D_WIN32_WINNT=0x0500
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Wextra -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libusb1.exe' \
        `'$(TARGET)-pkg-config' libusb-1.0 --cflags --libs`
endef
