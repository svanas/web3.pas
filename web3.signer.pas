unit web3.signer;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS;

type
  TAbstractSigner = class abstract external name 'AbstractSigner'(TJSObject)

  end;

  TJsonRpcSigner = class external name 'JsonRpcSigner'(TAbstractSigner)

  end;

  TBaseWallet = class external name 'BaseWallet'(TAbstractSigner)

  end;

implementation

end.
