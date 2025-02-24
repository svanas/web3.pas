unit web3;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS;

type
  TWei = class external name 'BigInt'(TJSObject)
  public
    function ToString(Base: Integer): string; external name 'toString';
  end;

  TEthers = class external name 'ethers'(TJSObject)
  public
    function ParseEther(const ether: string): TWei; external name 'parseEther';
  end;

function WeiToHex(const value: TWei): string;
function HexToWei(const value: string): TWei;

const
  Ethers: TEthers; external name 'window.ethers';

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
