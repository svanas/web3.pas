unit web3.signer;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS,
  // web3
  web3.transaction;

type
  TAbstractSigner = class abstract external name 'ethers.AbstractSigner'(TJSObject)
  public
    function SendTransaction(const tx: TTransaction): TTransactionResponse; async; external name 'sendTransaction';
  end;

  TJsonRpcSigner = class external name 'ethers.JsonRpcSigner'(TAbstractSigner)

  end;

  TBaseWallet = class external name 'ethers.BaseWallet'(TAbstractSigner)

  end;

implementation

end.
