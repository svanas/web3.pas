unit web3.provider;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS,
  // web3
  web3.blocks, web3.misc, web3.signer, web3.transaction;

type
  TAbstractProvider = class abstract external name 'ethers.AbstractProvider'(TJSObject)
  public
    // Get the account balance (in wei) of address.
    function GetBalance(const address: string): TWei; async; external name 'getBalance'; overload;
    // Get the account balance (in wei) of address. If the node supports archive access for the specified block, the balance is as of that block.
    function GetBalance(const address, block: string): TWei; async; external name 'getBalance'; overload;
    // Get the current block number.
    function GetBlockNumber: UInt64; async; external name 'getBlockNumber';
    // Get the best guess at the recommended TFeeData.
    function GetFeeData: TFeeData; async; external name 'getFeeData';
    // Get the connected TNetwork.
    function GetNetwork: TNetwork; async; external name 'getNetwork';
    // Resolves to the transaction for hash.
    function GetTransaction(const hash: string): TTransactionResponse; async; external name 'getTransaction';
    // Get the number of transactions ever sent for address.
    function GetTransactionCount(const address: string): UInt64; async; external name 'getTransactionCount'; overload;
    // Get the number of transactions ever sent for address. If the node supports archive access for the specified block, the transaction count is as of that block.
    function GetTransactionCount(const address, block: string): UInt64; async; external name 'getTransactionCount'; overload;
    // Resolves to the transaction receipt for transaction hash, if mined.
    function GetTransactionReceipt(const hash: string): TTransactionReceipt; async; external name 'getTransactionReceipt';
    // Resolves to the ENS name associated for the address (or null if unconfigured).
    function LookupAddress(const address: string): string; async; external name 'lookupAddress';
    // Resolves to the address configured for the ENS name (or null if unconfigured).
    function ResolveName(const name: string): string; async; external name 'resolveName';
    // Resolves to the specified block once it has been mined.
    function WaitForBlock(const block: string): TBlock; async; external name 'waitForBlock';
    // Waits until the transaction is mined.
    function WaitForTransaction(const hash: string): TTransactionReceipt; async; external name 'waitForTransaction';
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
