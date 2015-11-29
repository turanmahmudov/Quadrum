TEMPLATE = app
TARGET = account_plugin

load(ubuntu-click)

QT += qml quick

RESOURCES += account_plugin.qrc

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target


