{ mkDerivation, aeson, base, bytestring, directory, filepath, hpack
, MissingH, optparse-applicative, pretty-simple, safe, split
, stdenv, stm, string-conversions, text, thyme, time
}:
mkDerivation {
  pname = "sodiumSierraStrawberry";
  version = "0.1.0.0";
  src = builtins.path { path = ./.; name = "source"; };
  isLibrary = false;
  isExecutable = true;
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    aeson base bytestring directory filepath MissingH
    optparse-applicative pretty-simple safe split stm
    string-conversions text thyme time
  ];
  preConfigure = "hpack";
  license = stdenv.lib.licenses.bsd3;
}
