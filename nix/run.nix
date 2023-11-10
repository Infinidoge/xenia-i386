{ drv
, pkgs
, pkgs-i386
}:
let
  inherit (pkgs) writeScriptBin lib;

  tmp = "tmp=$(mktemp -d --tmpdir xenia-i386-kernel.XXXX); cd $tmp";
  i386 = "${pkgs.qemu}/bin/qemu-system-i386";
  qemuArgs = "-boot order=a -drive file=os-image.bin,index=0,if=floppy,format=raw -smp 4";
in
lib.mapAttrs (name: value: { type = "app"; program = lib.getExe value; }) {
  vga = writeScriptBin "vga" ''
    ${tmp}
    cp ${drv}/os-image.bin .
    chmod u+rwx os-image.bin
    ${i386} -vga std ${qemuArgs}
  '';

  curses = writeScriptBin "curses" ''
    ${tmp}
    cp ${drv}/os-image.bin .
    chmod u+rwx os-image.bin
    ${i386} -display curses ${qemuArgs}
  '';

  debug = writeScriptBin "debug" ''
    ${tmp}
    cp ${drv}/os-image.bin ${drv}/kernel.elf .
    chmod u+rwx os-image.bin
    ${i386} -display curses -s ${qemuArgs}
  '';

  gdb = writeScriptBin "gdb" ''
    ${tmp}
    cp ${drv}/kernel.elf .
    cp -r ${drv.src}/* .
    ${pkgs-i386.gdb}/bin/i386-elf-gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"
  '';
}
