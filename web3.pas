unit web3;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS,
  // web3
  web3.misc, web3.provider;

type
  TEthers = class external name 'ethers'(TJSObject)
  strict private
    FBrowserProvider: TBrowserProviderClass; external name 'BrowserProvider';
    FVersion: string; external name 'version';
  public
    // Returns True if value is a valid address.
    function IsAddress(const value: string): Boolean; external name 'isAddress';
    // Convert ether (string) to TWei & convert TWei into ether (string)
    function ParseEther(const ether: string): TWei; external name 'parseEther';
    function FormatEther(const wei: TWei): string; external name 'formatEther';
    // Convert decimal string to TWei & convert TWei into a decimal string
    function ParseUnits(const value: string; const decimals: UInt8): TWei; external name 'parseUnits';
    function FormatUnits(const value: TWei; const decimals: UInt8): string; external name 'formatUnits';
    // The default provider, which is backed by a variety of third-party services (such as Infura, for example)
    function GetDefaultProvider: TJsonRpcProvider; external name 'getDefaultProvider';
    // TBrowserProvider is intended to wrap an injected provider which adheres to the EIP-1193 standard
    property BrowserProvider: TBrowserProviderClass read FBrowserProvider;
    // The current version of Ethers
    property Version: string read FVersion;
  end;

const
  Ethers  : TEthers; external name 'window.ethers';   // injected by ethers.js
  Ethereum: JSValue; external name 'window.ethereum'; // injected by your crypto wallet (probably MetaMask)

implementation

end.
