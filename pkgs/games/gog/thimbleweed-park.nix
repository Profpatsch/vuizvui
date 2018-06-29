{ lib, buildGame, fetchGog, unzip, libGL, libudev

, ransomeUnbeeped ? true
}:

buildGame rec {
  name = "thimbleweed-park-${version}";
  version = "1.0.958";

  srcs = lib.singleton (fetchGog {
    productId = 1325604411;
    downloadName = "en3installer0";
    sha256 = "141263g749k9h4741q8dyv7149n20zx50rhl0ny8ly6p4yw1spv7";
  }) ++ lib.optional ransomeUnbeeped (fetchGog {
    productId = 1858019230;
    downloadName = "en3installer0";
    sha256 = "1cfll73qazm9nz40n963qvankqkznfjai9g88kgw6xcl40y8jrqn";
  });

  unpackCmd = "${unzip}/bin/unzip -qq \"$curSrc\" 'data/noarch/game/*' || :";

  buildInputs = [ libGL ];

  runtimeDependencies = [ libudev ];

  # A small preload wrapper which changes into the data directory during
  # startup of the main binary.
  buildPhase = ''
    cc -Werror -Wall -std=c11 -shared -xc - -o preload.so -fPIC <<EOF
    #include <stdio.h>
    #include <unistd.h>

    __attribute__((constructor)) static void chdirToData(void) {
      if (chdir("$out/share/thimbleweed-park") == -1) {
        perror("chdir $out/share/thimbleweed-park");
        _exit(1);
      }
    }
    EOF
    patchelf --add-needed "$out/libexec/thimbleweed-park/preload.so" \
      ThimbleweedPark
  '';

  installPhase = ''
    install -vD ThimbleweedPark "$out/bin/thimbleweed-park"
    install -vD preload.so "$out/libexec/thimbleweed-park/preload.so"
    for i in *.ggpack[0-9]*; do
      install -vD -m 0644 "$i" "$out/share/thimbleweed-park/$i"
    done
  '';

  sandbox.paths.required = [
    "$XDG_DATA_HOME/Terrible Toybox/Thimbleweed Park"
  ];
}