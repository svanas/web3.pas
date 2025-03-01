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
