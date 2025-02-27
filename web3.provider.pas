unit web3.provider;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS,
  // web3
  web3.classes, web3.signer;

type
  TAbstractProvider = class abstract external name 'ethers.AbstractProvider'(TJSObject)
  public
    function GetBlockNumber: UInt64; async; external name 'getBlockNumber';
    function GetBalance(const address: string): TWei; async; external name 'getBalance'; overload;
    function GetBalance(const address, block: string): TWei; async; external name 'getBalance'; overload;
    function GetTransactionCount(const address: string): UInt64; async; external name 'getTransactionCount'; overload;
    function GetTransactionCount(const address, block: string): UInt64; async; external name 'getTransactionCount'; overload;
    function GetNetwork: TNetwork; async; external name 'getNetwork';
    function GetFeeData: TFeeData; async; external name 'getFeeData';
  end;

  TJsonRpcApiProvider = class abstract external name 'ethers.JsonRpcApiProvider'(TAbstractProvider)
  public
    function GetSigner: TJsonRpcSigner; async; external name 'getSigner';
  end;

  TBrowserProvider = class external name 'ethers.BrowserProvider'(TJsonRpcApiProvider)
  public
    constructor New(const ethereum: JSValue);
  end;
  TBrowserProviderClass = class of TBrowserProvider;

  TJsonRpcProvider = class external name 'ethers.JsonRpcProvider'(TJsonRpcApiProvider)
  end;

implementation

end.
