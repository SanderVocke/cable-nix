{ lib
, python3
, fetchFromGitHub
, qt6
, aj-snapshot
, jack_delay
, jack-client
, hicolor-icon-theme
, makeWrapper
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cable";
  version = "0.9.25";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "magillos";
    repo = "Cable";
    rev = version;
    hash = "sha256-nTNuqM5X28C48xhaK7GnP1lsKYD4cNldwzggUGxQ5Qg=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    makeWrapper
  ] ++ (with python3.pkgs; [
    setuptools
    wheel
  ]);

  # Python dependencies mapped from PKGBUILD 'depends'
  propagatedBuildInputs = with python3.pkgs; [
    pyqt6
    jack-client
    requests
    pyalsaaudio
    packaging
    dbus-python
  ];

  # Runtime dependencies that the application calls as subprocesses or uses for icons
  buildInputs = [
    aj-snapshot
    jack_delay
    hicolor-icon-theme
    qt6.qtbase
  ];

  postInstall = ''
    # Create the directory structure for icons and desktop files
    mkdir -p $out/share/icons/hicolor/scalable/apps
    mkdir -p $out/share/applications
    mkdir -p $out/share/cable

    # Manually install assets as specified in the original PKGBUILD 'package()' function
    cp "jack-plug.svg" "$out/share/icons/hicolor/scalable/apps/jack-plug.svg"
    cp "com.github.magillos.cable.desktop" "$out/share/applications/com.github.magillos.cable.desktop"
    cp "connection-manager.py" "$out/share/cable/connection-manager.py"

    # Wrap the final binary to ensure external CLI tools are found in the PATH
    # and that the connection-manager.py is accessible if the app looks for it in $out.
    wrapProgram $out/bin/cable \
      --prefix PATH : ${lib.makeBinPath [ aj-snapshot jack_delay ]} \
      --set CABLE_RESOURCES_DIR "$out/share/cable"
  '';

  # Ensures the app doesn't crash on Wayland/X11 by providing proper Qt platform plugins
  dontWrapQtApps = false;

  meta = with lib; {
    description = "A PyQt6 application to dynamically modify Pipewire and Wireplumber settings";
    homepage = "https://github.com/magillos/Cable";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cable";
  };
}