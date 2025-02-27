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

  TNetwork = class external name 'Network'(TJSObject)
  private
    FChainId: TBigInt; external name 'chainId';
    FName: string; external name 'name';
  public
    property ChainId: TBigInt read FChainId;
    property Name: string read FName;
  end;

  TFeeData = class external name 'FeeData'(TJSObject)
  private
    FGasPrice: TBigInt; external name 'gasPrice';
    FMaxFeePerGas: TBigInt; external name 'maxFeePerGas';
    FMaxPriorityFeePerGas: TBigInt; external name 'maxPriorityFeePerGas';
  public
    property GasPrice: TBigInt read FGasPrice;
    property MaxFeePerGas: TBigInt read FMaxFeePerGas;
    property MaxPriorityFeePerGas: TBigInt read FMaxPriorityFeePerGas;
  end;

function WeiToHex(const value: TWei): string;
function HexToWei(const value: string): TWei;

implementation

function WeiToHex(const value: TWei): string;
begin
  Result := '0x' + value.ToString(16);
end;

function HexToWei(const value: string): TWei;
asm
  return BigInt(value);
end;

end.
