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

  TAbstractProvider = class abstract external name 'AbstractProvider'(TJSObject)
  end;

  TJsonRpcApiProvider = class abstract external name 'JsonRpcApiProvider'(TAbstractProvider)
  end;

  TBrowserProvider = class external name 'BrowserProvider'(TJsonRpcApiProvider)
  public
    constructor new(const ethereum: JSValue);
  end;
  TBrowserProviderClass = class of TBrowserProvider;

  TJsonRpcProvider = class external name 'JsonRpcProvider'(TJsonRpcApiProvider)
  end;

  TEthers = class external name 'ethers'(TJSObject)
  private
    FBrowserProvider: TBrowserProviderClass; external name 'BrowserProvider';
  public
    function ParseEther(const ether: string): TWei; external name 'parseEther';
    function FormatEther(const wei: TWei): string; external name 'formatEther';
    function ParseUnits(const value: string; const decimals: Byte): TWei; external name 'parseUnits';
    function FormatUnits(const value: TWei; const decimals: Byte): string; external name 'formatUnits';
    function GetDefaultProvider: TJsonRpcProvider; external name 'getDefaultProvider';
    property BrowserProvider: TBrowserProviderClass read FBrowserProvider;
  end;

function WeiToHex(const value: TWei): string;
function HexToWei(const value: string): TWei;

const
  Ethers  : TEthers; external name 'window.ethers';
  Ethereum: JSValue; external name 'window.ethereum';

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
