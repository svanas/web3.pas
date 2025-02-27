unit web3.blocks;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS,
  // web3
  web3.misc;

type
  // TBlock represents the data associated with a full block on Ethereum.
  TBlock = class external name 'ethers.Block'(TJSObject)
  strict private
    FBaseFeePerGas: TWei;           external name 'baseFeePerGas';
    FDate         : TJSDate;        external name 'date';
    FDifficulty   : TBigInt;        external name 'difficulty';
    FExtraData    : string;         external name 'extraData';
    FGasLimit     : TBigInt;        external name 'gasLimit';
    FGasUsed      : TBigInt;        external name 'gasUsed';
    FHash         : string;         external name 'hash';
    FLength       : UInt64;         external name 'length';
    FMiner        : string;         external name 'miner';
    FNumber       : UInt64;         external name 'number';
    FParentHash   : string;         external name 'parentHash';
    FTimestamp    : UInt64;         external name 'timestamp';
    FTransactions : TArray<string>; external name 'transactions';
  public
    {-------------------------------- methods ---------------------------------}
    // Returns True if this block is an EIP-2930 block.
    function IsLondon: Boolean; external name 'isLondon';
    // Returns True if this block been mined.
    function IsMined: Boolean; external name 'isMined';
    {------------------------------- properties -------------------------------}
    // The base fee per gas that all transactions in this block were charged.
    // This adjusts after each block, depending on how congested the network is.
    property BaseFeePerGas: TWei read FBaseFeePerGas;
    // The date this block was included at.
    property Date: TJSDate read FDate;
    // The difficulty target.
    // On legacy networks, this is the proof-of-work target required for a block to meet the protocol rules to be included.
    property Difficulty: TBigInt read FDifficulty;
    // Any extra data the validator wished to include.
    property ExtraData: string read FExtraData;
    // The total gas limit for this block.
    property GasLimit: TBigInt read FGasLimit;
    // The total gas used in this block.
    property GasUsed: TBigInt read FGasUsed;
    // The block hash.
    property Hash: string read FHash;
    // The number of transactions in this block.
    property Length: UInt64 read FLength;
    // The miner coinbase address, which receives any subsidies for including this block.
    property Miner: string read FMiner;
    // The block number, sometimes called the block height. This is a sequential number that is one higher than the parent block.
    property Number: UInt64 read FNumber;
    // The block hash of the parent block.
    property ParentHash: string read FParentHash;
    // The timestamp for this block, which is the number of seconds since epoch that this block was included.
    property Timestamp: UInt64 read FTimestamp;
    // Returns the list of transaction hashes, in the order they were executed within the block.
    property Transactions: TArray<string> read FTransactions;
  end;

const
  // To remember the differences between the block tags you can think of them in the order of oldest to newest block numbers: earliest < finalized < safe < latest < pending
  BLOCK_EARLIEST  = 'earliest';  // The lowest numbered block the client has available. Intuitively, you can think of this as the first block created.
  BLOCK_FINALIZED = 'finalized'; // The most recent crypto-economically secure block, that has been accepted by >2/3 of validators. Typically finalized in two epochs. Cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is very unlikely to be re-orged.
  BLOCK_SAFE      = 'safe';      // The most recent crypto-economically secure block, cannot be re-orged outside of manual intervention driven by community coordination. Intuitively, this block is "unlikely" to be re-orged.
  BLOCK_LATEST    = 'latest';    // The most recent block in the canonical chain observed by the client, this block may be re-orged out of the canonical chain even under healthy/normal conditions. Intuitively, this block is the most recent block observed by the client.
  BLOCK_PENDING   = 'pending';   // A sample next block built by the client on top of latest and containing the set of transactions usually taken from local mempool. Intuitively, you can think of these as blocks that have not been mined yet.
  // safe and finalized are new blog tags introduced after The Merge that define commitment levels for block finality. Unlike latest which increments one block at a time (ex 101, 102, 103), safe and finalized increment every "epoch" (32 blocks), which is every ~6 minutes assuming an average ~12 second block times.

implementation

end.
