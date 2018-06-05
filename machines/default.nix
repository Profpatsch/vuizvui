with import ../lib;

{
  aszlig = {
    dnyarri   = callMachine ./aszlig/dnyarri.nix {};
    kzerza    = callMachine ./aszlig/kzerza.nix {};
    meshuggah = callMachine ./aszlig/meshuggah.nix {};
    tishtushi = callMachine ./aszlig/tishtushi.nix {};
    managed = {
      brawndo = callMachine ./aszlig/managed/brawndo.nix {};
      shakti  = callMachine ./aszlig/managed/shakti.nix {};
      tyree   = callMachine ./aszlig/managed/tyree.nix {};
    };
  };
  devhell = {
    eris       = callMachine devhell/eris.nix {};
    skunkworks = callMachine devhell/skunkworks.nix {};
    titan      = callMachine devhell/titan.nix {};
  };
  labnet.labtops = {
    inherit (callNetwork ./labnet/labtops.nix {}) labtop;
    hannswurscht = callMachine ./labnet/hannswurscht.nix {};
  };
  profpatsch = {
    katara = callMachine ./profpatsch/katara.nix {};
    haku   = callMachine ./profpatsch/haku.nix {};
    mikiya = callMachine ./profpatsch/mikiya.nix {};
  };
  misc = {
    mailserver = callMachine ./misc/mailserver.nix {};
  };
  sternenseemann = {
    fliewatuet   = callMachine ./sternenseemann/fliewatuet.nix {};
    schnurrkadse = callMachine ./sternenseemann/schnurrkadse.nix {};
    schaf        = callMachine ./sternenseemann/schaf.nix {};
  };
}
