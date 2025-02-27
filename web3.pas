unit web3;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS,
  // web3
  web3.classes, web3.provider;

const
  // To remember the differences between the block tags you can think of them in the order of oldest to newest block numbers: earliest < finalized < safe < latest < pending
  BLOCK_EARLIEST  = 'earliest';  // The lowest numbered block the client has available. Intuitively, you can think of this as the first block created.
  BLOCK_FINALIZED = 'finalized'; // The most recent crypto-economically secure block, that has been accepted by >2/3 of validators. Typically finalized in two epochs. Cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is very unlikely to be re-orged.
  BLOCK_SAFE      = 'safe';      // The most recent crypto-economically secure block, cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is "unlikely" to be re-orged.
  BLOCK_LATEST    = 'latest';    // The most recent block in the canonical chain observed by the client, this block may be re-orged out of the canonical chain even under healthy/normal conditions. Intuitively, this block is the most recent block observed by the client.
  BLOCK_PENDING   = 'pending';   // A sample next block built by the client on top of latest and containing the set of transactions usually taken from local mempool. Intuitively, you can think of these as blocks that have not been mined yet.
  // safe and finalized are new blog tags introduced after The Merge that define commitment levels for block finality. Unlike latest which increments one block at a time (ex 101, 102, 103), safe and finalized increment every "epoch" (32 blocks), which is every ~6 minutes assuming an average ~12 second block times.

type
  TEthers = class external name 'ethers'(TJSObject)
  private
    FBrowserProvider: TBrowserProviderClass; external name 'BrowserProvider';
    FVersion: string; external name 'version';
  public
    function ParseEther(const ether: string): TWei; external name 'parseEther';
    function FormatEther(const wei: TWei): string; external name 'formatEther';
    function ParseUnits(const value: string; const decimals: Byte): TWei; external name 'parseUnits';
    function FormatUnits(const value: TWei; const decimals: Byte): string; external name 'formatUnits';
    function GetDefaultProvider: TJsonRpcProvider; external name 'getDefaultProvider';
    property BrowserProvider: TBrowserProviderClass read FBrowserProvider;
    property Version: string read FVersion;
  end;

const
  Ethers  : TEthers; external name 'window.ethers';   // injected by ethers.js
  Ethereum: JSValue; external name 'window.ethereum'; // injected by your crypto wallet (probably MetaMask)

implementation

end.
