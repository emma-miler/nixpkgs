{
  fetchFromGitHub,
  glib,
  gtk3,
  iproute2,
  kdePackages,
  lib,
  libappindicator,
  libappindicator-gtk2,
  libappindicator-gtk3,
  libayatana-appindicator,
  libsoup_3,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "snx-rs";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "ancwrd1";
    repo = "snx-rs";
    tag = "v${version}";
    hash = "sha256-5kPXwnPjWoBHTzgSCkyaTvkKfPzaNkzjwnB/zSXnyiA=";
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    iproute2
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    kdePackages.kstatusnotifieritem
    libappindicator
    libappindicator-gtk2
    libappindicator-gtk3
    libayatana-appindicator
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  checkFlags = [
    "--skip=platform::linux::net::tests::test_default_ip"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "isakmp-0.1.0" = "sha256-3ZiJS+JI8c3Segv3UmVY/f2Ms5/u6sH3iR9Y8L7fGj4=";
    };
  };

  meta = {
    description = "Open source Linux client for Checkpoint VPN tunnels";
    homepage = "https://github.com/ancwrd1/snx-rs";
    license = lib.licenses.agpl3Plus;
    changelog = "https://github.com/ancwrd1/snx-rs/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      shavyn
    ];
    mainProgram = "snx-rs";
  };
}
