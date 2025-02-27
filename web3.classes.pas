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

  TNetwork = class external name 'ethers.Network'(TJSObject)
  strict private
    FChainId: TBigInt; external name 'chainId';
    FName: string; external name 'name';
  public
    property ChainId: TBigInt read FChainId;
    property Name: string read FName;
  end;

  TFeeData = class external name 'ethers.FeeData'(TJSObject)
  strict private
    FGasPrice: TWei; external name 'gasPrice';
    FMaxFeePerGas: TWei; external name 'maxFeePerGas';
    FMaxPriorityFeePerGas: TWei; external name 'maxPriorityFeePerGas';
  public
    property GasPrice: TWei read FGasPrice;
    property MaxFeePerGas: TWei read FMaxFeePerGas;
    property MaxPriorityFeePerGas: TWei read FMaxPriorityFeePerGas;
  end;

function BigInt(const value: UInt8): TBigInt;

function WeiToHex(const value: TWei): string;
function HexToWei(const value: string): TWei;

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
