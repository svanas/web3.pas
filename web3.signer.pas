unit web3.signer;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS;

type
  TAbstractSigner = class abstract external name 'ethers.AbstractSigner'(TJSObject)
  public
    function SendTransaction(const tx: TJSObject): TTransactionResponse; async; external name 'sendTransaction';
  end;

  TJsonRpcSigner = class external name 'ethers.JsonRpcSigner'(TAbstractSigner);

  TBaseWallet = class external name 'ethers.BaseWallet'(TAbstractSigner);

implementation

end.
