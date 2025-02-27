unit web3.utils;

interface

uses
  web3.classes;

type
  TDenomination = (
    wei,
    kwei,
    babbage,
    femtoether,
    mwei,
    lovelace,
    picoether,
    gwei,
    shannon,
    nanoether,
    nano,
    szabo,
    microether,
    micro,
    finney,
    milliether,
    milli,
    ether,
    kether,
    grand,
    mether,
    gether,
    tether
  );

function ToWei(const value: string; const from: TDenomination): TWei;  // convert string to wei
function FromWei(const value: TWei; const &to: TDenomination): string; // convert wei to string

const
  // To remember the differences between the block tags you can think of them in the order of oldest to newest block numbers: earliest < finalized < safe < latest < pending
  BLOCK_EARLIEST  = 'earliest';  // The lowest numbered block the client has available. Intuitively, you can think of this as the first block created.
  BLOCK_FINALIZED = 'finalized'; // The most recent crypto-economically secure block, that has been accepted by >2/3 of validators. Typically finalized in two epochs. Cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is very unlikely to be re-orged.
  BLOCK_SAFE      = 'safe';      // The most recent crypto-economically secure block, cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is "unlikely" to be re-orged.
  BLOCK_LATEST    = 'latest';    // The most recent block in the canonical chain observed by the client, this block may be re-orged out of the canonical chain even under healthy/normal conditions. Intuitively, this block is the most recent block observed by the client.
  BLOCK_PENDING   = 'pending';   // A sample next block built by the client on top of latest and containing the set of transactions usually taken from local mempool. Intuitively, you can think of these as blocks that have not been mined yet.
  // safe and finalized are new blog tags introduced after The Merge that define commitment levels for block finality. Unlike latest which increments one block at a time (ex 101, 102, 103), safe and finalized increment every "epoch" (32 blocks), which is every ~6 minutes assuming an average ~12 second block times.

implementation

uses
  web3;

const
  Decimals: array[TDenomination] of UInt8 = (
    0,   // wei
    3,   // kwei
    3,   // babbage
    3,   // femtoether
    6,   // mwei
    6,   // lovelace
    6,   // picoether
    9,   // gwei
    9,   // shannon
    9,   // nanoether
    9,   // nano
    12,  // szabo
    12,  // microether
    12,  // micro
    15,  // finney
    15,  // milliether
    15,  // milli
    18,  // ether
    21,  // kether
    21,  // grand
    24,  // mether
    27,  // gether
    30); // tether

function ToWei(const value: string; const from: TDenomination): TWei;
begin
  Result := Ethers.ParseUnits(value, Decimals[from]);
end;

function FromWei(const value: TWei; const &to: TDenomination): string;
begin
  Result := Ethers.FormatUnits(value, Decimals[&to]);
end;

end.
