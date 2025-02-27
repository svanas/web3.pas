unit web3.classes;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS;

type
  TBigInt = class external name 'BigInt'(TJSObject)
  public
    function ToString(const base: Integer): string; external name 'toString';
  end;

  TWei = TBigInt;

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

function BigInt(const value: UInt8): TBigInt;

function WeiToHex(const value: TWei): string; // converts TWei to a hexadecimal string
function HexToWei(const value: string): TWei; // converts a hexadecimal string to TWei

implementation

function BigInt(const value: UInt8): TBigInt;
asm
  return BigInt(value);
end;

function WeiToHex(const value: TWei): string;
begin
  Result := '0x' + value.ToString(16);
end;

function HexToWei(const value: string): TWei;
asm
  return BigInt(value);
end;

end.
