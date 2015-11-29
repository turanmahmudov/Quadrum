TEMPLATE = app
TARGET = Quadrum

load(ubuntu-click)

QT += qml quick

SOURCES += main.cpp

RESOURCES += Quadrum.qrc

OTHER_FILES += Quadrum.apparmor \
               Quadrum.desktop \
               quadrum.application \
               quadrum.provider \
               quadrump.json \
               quadrum.service \
               Quadrum.png \
               js/scripts.js

#specify where the config files are installed to
config_files.path = /Quadrum
config_files.files += $${OTHER_FILES}
message($$config_files.files)
INSTALLS+=config_files

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

