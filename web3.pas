{******************************************************************************}
{                                                                              }
{                                   web3.pas                                   }
{                                                                              }
{             Copyright(c) 2025 Stefan van As <svanas@runbox.com>              }
{            Github Repository <https://github.com/svanas/web3.pas>            }
{                                                                              }
{                        Distributed under GNU GPL v3.0                        }
{                                                                              }
{******************************************************************************}

unit web3;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS;

type // forward declarations
  TBlock               = class;
  TTransactionReceipt  = class;
  TTransactionResponse = class;

  // Ether has various denominations just like any other currency. Wei is the smallest denomination.
  TDenomination = (
    wei,    // 1 ether = 1000000000000000000 wei
    kwei,   // 1 ether = 1000000000000000 kwei
    mwei,   // 1 ether = 1000000000000 mwei
    gwei,   // 1 ether = 1000000000 gwei
    szabo,  // 1 ether = 1000000 szabo
    finney, // 1 ether = 1000 finney
    ether,  // 1 ether = 1 ether
    kether, // 1 ether = 0.001 kether
    mether, // 1 ether = 0.000001 mether
    gether, // 1 ether = 0.000000001 gether
    tether  // 1 ether = 0.000000000001 tether
  );

  TBigInt = class external name 'BigInt'(TJSObject)
  public
    function ToString(const base: Integer): string; external name 'toString';
  end;

  TBigIntHelper = class helper for TBigInt
  public
    function ToInt : NativeInt;
    function ToUInt: NativeUInt;
  end;

  TWei = TBigInt;

  {--------------------------------- TNetwork ---------------------------------}

  // TNetwork provides access to a chain's properties and allows for plug-ins to extend functionality.
  TNetwork = class external name 'ethers.Network'(TJSObject)
  strict private
    FChainId: TBigInt; external name 'chainId';
    FName   : string;  external name 'name';
  public
    // The network chain ID, see: chainlist.org
    property ChainId: TBigInt read FChainId;
    // The network common name. This is the canonical name, as networks migh have multiple names.
    property Name: string read FName;
  end;

  {--------------------------------- TFeeData ---------------------------------}

  // TFeeData wraps all the fee-related values associated with the network.
  TFeeData = class external name 'ethers.FeeData'(TJSObject)
  strict private
    FGasPrice            : TWei; external name 'gasPrice';
    FMaxFeePerGas        : TWei; external name 'maxFeePerGas';
    FMaxPriorityFeePerGas: TWei; external name 'maxPriorityFeePerGas';
  public
    // The gas price for legacy networks.
    property GasPrice: TWei read FGasPrice;
    // The maximum fee to pay per gas.
    // The base fee per gas is defined by the network and based on congestion, increasing the cost during times of heavy load and lowering when less busy.
    // The actual fee per gas will be the base fee for the block and the priority fee, up to the max fee per gas.
    // This will be null on legacy (i.e. pre-EIP-1559) networks
    property MaxFeePerGas: TWei read FMaxFeePerGas;
    // The additional amout to pay per gas to encourage a validator to include the transaction.
    // The purpose of this is to compensate the validator for the adjusted risk for including a given transaction.
    // This will be null on legacy (i.e. pre-EIP-1559) networks
    property MaxPriorityFeePerGas: TWei read FMaxPriorityFeePerGas;
  end;

  {------------------------------ TJsonRpcSigner ------------------------------}

  TAbstractSigner = class abstract external name 'ethers.AbstractSigner'(TJSObject);

  TJsonRpcSigner = class external name 'ethers.JsonRpcSigner'(TAbstractSigner)
  public
    function SendTransaction(const tx: TJSObject): TTransactionResponse; async; external name 'sendTransaction';
  end;

  {--------------------------------- Providers --------------------------------}

  // TAbstractProvider provides a base class for other sub-classes to implement the Provider API
  TAbstractProvider = class abstract external name 'ethers.AbstractProvider'(TJSObject)
  public
    // Get the account balance (in wei) of address.
    function GetBalance(const address: string): TWei; async; external name 'getBalance'; overload;
    // Get the account balance (in wei) of address. If the node supports archive access for the specified block, the balance is as of that block.
    function GetBalance(const address, block: string): TWei; async; external name 'getBalance'; overload;
    // Resolves the specified block
    function GetBlock(const block: string): TBlock; async; external name 'getBlock';
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

  TJsonRpcProvider = class external name 'ethers.JsonRpcApiProvider'(TAbstractProvider)
  public
    // Resolves the signer managed by MetaMask
    function GetSigner: TJsonRpcSigner; async; external name 'getSigner';
  end;

  TBrowserProvider = class external name 'ethers.BrowserProvider'(TJsonRpcProvider)
  public
    constructor New(const ethereum: JSValue);
  end;
  TBrowserProviderClass = class of TBrowserProvider;

  {---------------------------------- TBlock ----------------------------------}

  // TBlock represents the data associated with a full block on Ethereum.
  TBlock = class external name 'ethers.Block'(TJSObject)
  strict private
    FBaseFeePerGas: TWei;              external name 'baseFeePerGas';
    FDate         : TJSDate;           external name 'date';
    FDifficulty   : TBigInt;           external name 'difficulty';
    FExtraData    : string;            external name 'extraData';
    FGasLimit     : TBigInt;           external name 'gasLimit';
    FGasUsed      : TBigInt;           external name 'gasUsed';
    FHash         : string;            external name 'hash';
    FLength       : UInt64;            external name 'length';
    FMiner        : string;            external name 'miner';
    FNumber       : UInt64;            external name 'number';
    FParentHash   : string;            external name 'parentHash';
    FProvider     : TAbstractProvider; external name 'provider';
    FTimestamp    : UInt64;            external name 'timestamp';
    FTransactions : TArray<string>;    external name 'transactions';
  public
    {-------------------------------- methods ---------------------------------}
    // Get the transaction at index (or hash) within this block.
    function GetTransaction(const index: UInt64): TTransactionResponse; async; external name 'getTransaction'; overload;
    function GetTransaction(const hash: string): TTransactionResponse; async; external name 'getTransaction'; overload;
    // Returns True if this block is an EIP-2930 block.
    function IsLondon: Boolean; external name 'isLondon';
    // Returns True if this block been mined.
    function IsMined: Boolean; external name 'isMined';
    {------------------------------- properties -------------------------------}
    // The base fee per gas that all transactions in this block were charged.
    // This adjusts after each block, depending on how congested the network is.
    property BaseFeePerGas: TWei read FBaseFeePerGas;
    // The date this block was included at.
    property Date: TJSDate read FDate;
    // The difficulty target.
    // On legacy networks, this is the proof-of-work target required for a block to meet the protocol rules to be included.
    property Difficulty: TBigInt read FDifficulty;
    // Any extra data the validator wished to include.
    property ExtraData: string read FExtraData;
    // The total gas limit for this block.
    property GasLimit: TBigInt read FGasLimit;
    // The total gas used in this block.
    property GasUsed: TBigInt read FGasUsed;
    // The block hash.
    property Hash: string read FHash;
    // The number of transactions in this block.
    property Length: UInt64 read FLength;
    // The miner coinbase address, which receives any subsidies for including this block.
    property Miner: string read FMiner;
    // The block number, sometimes called the block height. This is a sequential number that is one higher than the parent block.
    property Number: UInt64 read FNumber;
    // The block hash of the parent block.
    property ParentHash: string read FParentHash;
    // The provider connected to the block used to fetch additional details if necessary.
    property Provider: TAbstractProvider read FProvider;
    // The timestamp for this block, which is the number of seconds since epoch that this block was included.
    property Timestamp: UInt64 read FTimestamp;
    // Returns the list of transaction hashes, in the order they were executed within the block.
    property Transactions: TArray<string> read FTransactions;
  end;

  {---------------- TTransactionResponse & TTransactionReceipt ----------------}

  // ECDSA signature with its (r, s) properties. Supports DER & compact representations.
  TSignature = class external name 'ethers.Signature'(TJSObject);

  // TTransactionResponse includes all properties about a transaction that was sent to the network, which may or may not be included in a block.
  TTransactionResponse = class external name 'ethers.TransactionResponse'(TJSObject)
  strict private
    FBlockHash           : string;           external name 'blockHash';
    FBlockNumber         : UInt64;           external name 'blockNumber';
    FChainId             : TBigInt;          external name 'chainId';
    FData                : string;           external name 'data';
    FFrom                : string;           external name 'from';
    FGasLimit            : TBigInt;          external name 'gasLimit';
    FGasPrice            : TWei;             external name 'gasPrice';
    FHash                : string;           external name 'hash';
    FIndex               : UInt64;           external name 'index';
    FMaxFeePerGas        : TWei;             external name 'maxFeePerGas';
    FMaxPriorityFeePerGas: TWei;             external name 'maxPriorityFeePerGas';
    FNonce               : UInt64;           external name 'nonce';
    FProvider            : TAbstractProvider external name 'provider';
    FSignature           : TSignature;       external name 'signature';
    FTo                  : string;           external name 'to';
    FType                : UInt8;            external name 'type';
    FValue               : TWei;             external name 'value';
  public
    {-------------------------------- methods ---------------------------------}
    // Resolves to the number of confirmations this transaction has.
    function Confirmations: UInt64; async; external name 'confirmations';
    // Resolves to the block that this transaction was included in. This will return null if the transaction has not been included yet.
    function GetBlock: TBlock; async; external name 'getBlock';
    // Resolves to this transaction being re-requested from the provider.
    // This can be used if you have an unmined transaction and wish to get an up-to-date populated instance.
    function GetTransaction: TTransactionResponse; async; external name 'getTransaction';
    // Returns True if the transaction is a Berlin (i.e. type == 1) transaction.
    function IsBerlin: Boolean; external name 'isBerlin';
    // Returns True if the transaction is a Cancun (i.e. type == 3) transaction.
    function IsCancun: Boolean; external name 'isCancun';
    // Returns True if the transaction is a legacy (i.e. type == 0) transaction.
    function IsLegacy: Boolean; external name 'isLegacy';
    // Returns True if the transaction is a London (i.e. type == 2) transaction.
    function IsLondon: Boolean; external name 'isLondon';
    // Returns True if this transaction has been included with a block. This is effective only as of the time the TTransactionResponse was instantiated.
    function IsMined: Boolean; external name 'isMined';
    // Resolves once this transaction has been mined.
    function Wait: TTransactionReceipt; async; external name 'wait';
    {------------------------------- properties -------------------------------}
    // The blockHash of the block that this transaction was included in. This is "null" for pending transactions.
    property BlockHash: string read FBlockHash;
    // The block number of the block that this transaction was included in. This is "null" for pending transactions.
    property BlockNumber: UInt64 read FBlockNumber;
    // The chain ID, see: chainlist.org
    property ChainId: TBigInt read FChainId;
    // The transaction data.
    property Data: string read FData;
    // The sender of this transaction.
    property From: string read FFrom;
    // The maximum units of gas this transaction can consume. If execution exceeds this, the transaction is reverted and the sender is charged for the full amount, despite no state changes being made.
    property GasLimit: TBigInt read FGasLimit;
    // The gas price can have various values, depending on the network.
    // In modern networks, for transactions that are included this is the effective gas price (the fee per gas that was actually charged), while for transactions that have not been included yet is the maxFeePerGas.
    // For legacy transactions, or transactions on legacy networks, this is the fee that will be charged per unit of gas the transaction consumes.
    property GasPrice: TWei read FGasPrice;
    // The transaction hash.
    property Hash: string read FHash;
    // The index within the block that this transaction resides at.
    property Index: UInt64 read FIndex;
    // The maximum fee (per unit of gas) to allow this transaction to charge the sender.
    property MaxFeePerGas: TWei read FMaxFeePerGas;
    // The maximum priority fee (per unit of gas) to allow a validator to charge the sender.
    property MaxPriorityFeePerGas: TWei read FMaxPriorityFeePerGas;
    // The nonce, which is used to prevent replay attacks and offer a method to ensure transactions from a given sender are explicitly ordered.
    // When sending a transaction, this must be equal to the number of transactions ever sent by the sender.
    property Nonce: UInt64 read FNonce;
    // The provider this is connected to, which will influence how its methods will resolve its async inspection methods.
    property Provider: TAbstractProvider read FProvider;
    // The signature for this transaction.
    property Signature: TSignature read FSignature;
    // The receiver of this transaction.
    property &To: string read FTo;
    // The EIP-2718 transaction envelope type. This is 0 for legacy transactions types.
    property &Type: UInt8 read FType;
    // The value of this transaction in wei.
    property Value: TWei read FValue;
  end;

  // TTransactionReceipt includes additional information about a transaction that is only available after it has been mined.
  TTransactionReceipt = class external name 'ethers.TransactionReceipt'(TJSObject)
  strict private
    FBlockHash        : string;            external name 'blockHash';
    FBlockNumber      : UInt64;            external name 'blockNumber';
    FContractAddress  : string;            external name 'contractAddress';
    FCumulativeGasUsed: TBigInt;           external name 'cumulativeGasUsed';
    FFee              : TWei;              external name 'fee';
    FFrom             : string;            external name 'from';
    FGasPrice         : TWei;              external name 'gasPrice';
    FGasUsed          : TBigInt;           external name 'gasUsed';
    FHash             : string;            external name 'hash';
    FIndex            : UInt64;            external name 'index';
    FProvider         : TAbstractProvider; external name 'provider';
    FStatus           : UInt8;             external name 'status';
    FTo               : string;            external name 'to';
    FType             : UInt8;             external name 'type';
  public
    {-------------------------------- methods ---------------------------------}
    // Resolves to the number of confirmations this transaction has.
    function Confirmations: UInt64; async; external name 'confirmations';
    // Resolves to the block this transaction occurred in.
    function GetBlock: TBlock; async; external name 'getBlock';
    // Resolves to the transaction this transaction occurred in.
    function GetTransaction: TTransactionResponse; async; external name 'getTransaction';
    {------------------------------- properties -------------------------------}
    // The block hash of the block this transaction was included in.
    property BlockHash: string read FBlockHash;
    // The block number of the block this transaction was included in.
    property BlockNumber: UInt64 read FBlockNumber;
    // The address of the contract if the transaction was directly responsible for deploying one.
    property ContractAddress: string read FContractAddress;
    // The amount of gas used by all transactions within the block for this and all transactions with a lower index.
    property CumulativeGasUsed: TBigInt read FCumulativeGasUsed;
    // The total fee for this transaction, in wei.
    property Fee: TWei read FFee;
    // The sender of the transaction.
    property From: string read FFrom;
    // The actual gas price used during execution.
    // Due to the complexity of EIP-1559 this value can only be calculated after the transaction has been mined, since the base fee is protocol-enforced.
    property GasPrice: TWei read FGasPrice;
    // The actual amount of gas used by this transaction.
    property GasUsed: TBigInt read FGasUsed;
    // The transaction hash.
    property Hash: string read FHash;
    // The index of this transaction within the block.
    property Index: UInt64 read FIndex;
    // The provider connected to the log used to fetch additional details if necessary.
    property Provider: TAbstractProvider read FProvider;
    // The status of this transaction, indicating success (i.e. 1) or a revert (i.e. 0)
    property Status: UInt8 read FStatus;
    // The address the transaction was sent to.
    property &To: string read FTo;
    // The EIP-2718 transaction type.
    property &Type: UInt8 read FType;
  end;

  TBaseContract = class abstract external name 'ethers.BaseContract'(TJSObject)
  public
    constructor New(const target: string; const abi: TJSArray; const provider: TAbstractProvider); overload;
    constructor New(const target: string; const abi: TJSArray; const signer: TJsonRpcSigner); overload;
  end;

  TContract = class external name 'ethers.Contract'(TBaseContract);

  TContractHelper = class helper for TContract
  public
    function Call(const method: string; const args: TArray<JSValue> = []): TJSPromise;
  end;

  {--------------------------------- TEthers ----------------------------------}

  TEthers = class external name 'ethers'(TJSObject)
  strict private
    FBrowserProvider: TBrowserProviderClass; external name 'BrowserProvider';
    FVersion: string; external name 'version';
  public
    // Returns True if value is a valid address.
    function IsAddress(const value: string): Boolean; external name 'isAddress';
    // Convert ether (string) to wei & convert wei into ether (string)
    function ParseEther(const ether: string): TWei; external name 'parseEther';
    function FormatEther(const wei: TWei): string; external name 'formatEther';
    // Convert decimal string to wei & convert wei into a decimal string
    function ParseUnits(const value: string; const decimals: UInt8): TWei; external name 'parseUnits';
    function FormatUnits(const value: TWei; const decimals: UInt8): string; external name 'formatUnits';
    // The default provider, which is backed by a variety of third-party services (such as Infura, for example)
    function GetDefaultProvider: TJsonRpcProvider; external name 'getDefaultProvider';
    // TBrowserProvider is intended to wrap an injected provider which adheres to the EIP-1193 standard
    property BrowserProvider: TBrowserProviderClass read FBrowserProvider;
    // The current version of Ethers
    property Version: string read FVersion;
  end;

function WeiToHex(const value: TWei): string; // converts wei to a hexadecimal string
function HexToWei(const value: string): TWei; // converts a hexadecimal string to wei

function StrToWei(const value: string; const from: TDenomination): TWei; // convert decimal string to wei
function WeiToStr(const value: TWei; const &to: TDenomination): string;  // convert wei to decimal string

function Transaction(const &to: string; const value: TWei; const data: string = '0x'): TJSObject; overload;
function Transaction(const from, &to: string; const value: TWei; const data: string = '0x'): TJSObject; overload;

const
  MaxUint256: TBigInt; external name 'ethers.MaxUint256'; // constant for the maximum value for an uint256
  MinInt256 : TBigInt; external name 'ethers.MinInt256';  // constant for the minimum value for an int256
  MaxInt256 : TBigInt; external name 'ethers.MaxInt256';  // constant for the maximum value for an int256

const
  Ethers  : TEthers; external name 'window.ethers';   // injected by ethers.js
  Ethereum: JSValue; external name 'window.ethereum'; // injected by your crypto wallet (probably MetaMask)

const
  // To remember the differences between the block tags you can think of them in the order of oldest to newest block numbers: earliest < finalized < safe < latest < pending
  BLOCK_EARLIEST  = 'earliest';  // The lowest numbered block the client has available. Intuitively, you can think of this as the first block created.
  BLOCK_FINALIZED = 'finalized'; // The most recent crypto-economically secure block, that has been accepted by >2/3 of validators. Typically finalized in two epochs. Cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is very unlikely to be re-orged.
  BLOCK_SAFE      = 'safe';      // The most recent crypto-economically secure block, cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is "unlikely" to be re-orged.
  BLOCK_LATEST    = 'latest';    // The most recent block in the canonical chain observed by the client, this block may be re-orged out of the canonical chain even under healthy/normal conditions. Intuitively, this block is the most recent block observed by the client.
  BLOCK_PENDING   = 'pending';   // A sample next block built by the client on top of latest and containing the set of transactions usually taken from local mempool. Intuitively, you can think of these as blocks that have not been mined yet.
  // safe and finalized are new blog tags introduced after The Merge that define commitment levels for block finality. Unlike latest which increments one block at a time (ex 101, 102, 103), safe and finalized increment every "epoch" (32 blocks), which is every ~6 minutes assuming an average ~12 second block times.

implementation

uses
  // Delphi
  System.SysUtils;

function TBigIntHelper.ToInt: NativeInt;
begin
  Result := StrToInt(Self.ToString);
end;

function TBigIntHelper.ToUInt: NativeUInt;
begin
  Result := StrToUInt(Self.ToString);
end;

const
  Decimals: array[TDenomination] of UInt8 = (
    0,   // wei
    3,   // kwei
    6,   // mwei
    9,   // gwei
    12,  // szabo
    15,  // finney
    18,  // ether
    21,  // kether
    24,  // mether
    27,  // gether
    30); // tether

function WeiToHex(const value: TWei): string;
begin
  Result := '0x' + value.ToString(16);
end;

function HexToWei(const value: string): TWei;
asm
  return BigInt(value);
end;

function StrToWei(const value: string; const from: TDenomination): TWei;
begin
  Result := Ethers.ParseUnits(value, Decimals[from]);
end;

function WeiToStr(const value: TWei; const &to: TDenomination): string;
begin
  Result := Ethers.FormatUnits(value, Decimals[&to]);
end;

function Transaction(const &to: string; const value: TWei; const data: string): TJSObject;
begin
  Result := TJSObject.New;
  Result['to']    := &to;
  Result['value'] := value;
  Result['data']  := data;
end;

function Transaction(const from, &to: string; const value: TWei; const data: string): TJSObject;
begin
  Result := web3.Transaction(&to, value, data);
  Result['from'] := from;
end;

function TContractHelper.Call(const method: string; const args: TArray<JSValue>): TJSPromise;
var
  func, return: JSValue;
begin
  func := Self[method];
  if not JS.isFunction(func) then
    raise Exception.Create(method + ' is not a function');
  return := TJSFunction(func).apply(Self, args);
  if not(JS.isObject(return) and JS.isFunction(JS.toObject(return)['then'])) then
    raise Exception.Create(method + '() is not async');
  Result := TJSPromise(return);
end;

end.
