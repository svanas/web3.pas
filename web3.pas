unit web3;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS;

type
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

  {---------------------------------- TBlock ----------------------------------}

  // TBlock represents the data associated with a full block on Ethereum.
  TBlock = class external name 'ethers.Block'(TJSObject)
  strict private
    FBaseFeePerGas: TWei;                external name 'baseFeePerGas';
    FDate         : TJSDate;             external name 'date';
    FDifficulty   : TBigInt;             external name 'difficulty';
    FExtraData    : string;              external name 'extraData';
    FGasLimit     : TBigInt;             external name 'gasLimit';
    FGasUsed      : TBigInt;             external name 'gasUsed';
    FHash         : string;              external name 'hash';
    FLength       : UInt64;              external name 'length';
    FMiner        : string;              external name 'miner';
    FNumber       : UInt64;              external name 'number';
    FParentHash   : string;              external name 'parentHash';
    FProvider     : TJsonRpcApiProvider; external name 'provider';
    FTimestamp    : UInt64;              external name 'timestamp';
    FTransactions : TArray<string>;      external name 'transactions';
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
    property Provider: TJsonRpcApiProvider read FProvider;
    // The timestamp for this block, which is the number of seconds since epoch that this block was included.
    property Timestamp: UInt64 read FTimestamp;
    // Returns the list of transaction hashes, in the order they were executed within the block.
    property Transactions: TArray<string> read FTransactions;
  end;

const
  // To remember the differences between the block tags you can think of them in the order of oldest to newest block numbers: earliest < finalized < safe < latest < pending
  BLOCK_EARLIEST  = 'earliest';  // The lowest numbered block the client has available. Intuitively, you can think of this as the first block created.
  BLOCK_FINALIZED = 'finalized'; // The most recent crypto-economically secure block, that has been accepted by >2/3 of validators. Typically finalized in two epochs. Cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is very unlikely to be re-orged.
  BLOCK_SAFE      = 'safe';      // The most recent crypto-economically secure block, cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is "unlikely" to be re-orged.
  BLOCK_LATEST    = 'latest';    // The most recent block in the canonical chain observed by the client, this block may be re-orged out of the canonical chain even under healthy/normal conditions. Intuitively, this block is the most recent block observed by the client.
  BLOCK_PENDING   = 'pending';   // A sample next block built by the client on top of latest and containing the set of transactions usually taken from local mempool. Intuitively, you can think of these as blocks that have not been mined yet.
  // safe and finalized are new blog tags introduced after The Merge that define commitment levels for block finality. Unlike latest which increments one block at a time (ex 101, 102, 103), safe and finalized increment every "epoch" (32 blocks), which is every ~6 minutes assuming an average ~12 second block times.

  {--------------------------------- TEthers ----------------------------------}

type
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

const
  MaxUint256: TBigInt; external name 'ethers.MaxUint256'; // constant for the maximum value for an uint256
  MinInt256 : TBigInt; external name 'ethers.MinInt256';  // constant for the minimum value for an int256
  MaxInt256 : TBigInt; external name 'ethers.MaxInt256';  // constant for the maximum value for an int256

const
  Ethers  : TEthers; external name 'window.ethers';   // injected by ethers.js
  Ethereum: JSValue; external name 'window.ethereum'; // injected by your crypto wallet (probably MetaMask)

implementation

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

end.
