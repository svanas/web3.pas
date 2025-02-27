unit web3;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS,
  // web3
  web3.classes, web3.provider;

type
  TEthers = class external name 'ethers'(TJSObject)
  strict private
    FBrowserProvider: TBrowserProviderClass; external name 'BrowserProvider';
    FVersion: string; external name 'version';
  public
    function ParseEther(const ether: string): TWei; external name 'parseEther'; // Converts the decimal string to TWei
    function FormatEther(const wei: TWei): string; external name 'formatEther'; // Converts TWei into a decimal string

    function ParseUnits(const value: string; const decimals: UInt8): TWei; external name 'parseUnits';
    function FormatUnits(const value: TWei; const decimals: UInt8): string; external name 'formatUnits';

    function GetDefaultProvider: TJsonRpcProvider; external name 'getDefaultProvider';
    property BrowserProvider: TBrowserProviderClass read FBrowserProvider;

    property Version: string read FVersion;
  end;

const
  Ethers  : TEthers; external name 'window.ethers';   // injected by ethers.js
  Ethereum: JSValue; external name 'window.ethereum'; // injected by your crypto wallet (probably MetaMask)

implementation

end.
