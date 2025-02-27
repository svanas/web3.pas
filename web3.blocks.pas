unit web3.blocks;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS;

type
  // TBlock represents the data associated with a full block on Ethereum.
  TBlock = class external name 'ethers.Block'(TJSObject)
  end;

implementation

end.
