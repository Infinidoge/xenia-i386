{ stdenvNoCC
, pkgs-i386
, nasm
}:
stdenvNoCC.mkDerivation {
  name = "xenia-i386";
  src = ../src;

  preferLocalBuild = true;
  allowSubstitutes = false;

  nativeBuildInputs = [ pkgs-i386.gcc pkgs-i386.binutils nasm ];

  postPatch = ''
    cp ${./Makefile} Makefile
  '';

  buildPhase = ''
    make os-image.bin
    make kernel.bin
    make kernel.elf
  '';

  installPhase = ''
    mkdir -p $out
    cp os-image.bin kernel.bin kernel.elf $out
  '';
}
