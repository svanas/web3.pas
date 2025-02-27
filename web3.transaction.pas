unit web3.transaction;

{$MODESWITCH EXTERNALCLASS}

interface

uses
  // pas2js
  JS,
  // web3
  web3.classes;

type
  TSignature = class external name 'ethers.Signature'(TJSObject)
  end;

  // A Transaction describes an operation to be executed on Ethereum by an Externally Owned Account (EOA).
  // It includes who (the "to" address), what (the "data") and how much (the "value" in ether) the operation should entail.
  TTransaction = class external name 'ethers.Transaction'(TJSObject)
  strict private
    FType                : UInt8;      external name 'type';
    FTypeName            : string;     external name 'typeName';
    FTo                  : string;     external name 'to';
    FNonce               : UInt64;     external name 'nonce';
    FGasLimit            : TBigInt;    external name 'gasLimit';
    FGasPrice            : TWei;       external name 'gasPrice';
    FMaxPriorityFeePerGas: TWei;       external name 'maxPriorityFeePerGas';
    FMaxFeePerGas        : TWei;       external name 'maxFeePerGas';
    FData                : string;     external name 'data';
    FValue               : TWei;       external name 'value';
    FChainId             : TBigInt;    external name 'chainId';
    FSignature           : TSignature; external name 'signature';
    FHash                : string;     external name 'hash';
    FUnsignedHash        : string;     external name 'unsignedHash';
    FFrom                : string;     external name 'from';
    FFromPublicKey       : string;     external name 'fromPublicKey';
    FSerialized          : string;     external name 'serialized';
    FUnsignedSerialized  : string;     external name 'unsignedSerialized';
  public
    // Create a copy of this transaction.
    function Clone: TTransaction; external name 'clone';
    // Returns true if this transaction is a legacy transaction (i.e. "type === 0")
    function IsLegacy: Boolean; external name 'isLegacy';
    // Returns true if this transaction is berlin hardform transaction (i.e. "type === 1").
    function IsBerlin: Boolean; external name 'isBerlin';
    // Returns true if this transaction is london hardform transaction (i.e. "type === 2").
    function IsLondon: Boolean; external name 'isLondon';
    // Returns true if this transaction is an EIP-4844 transaction.
    function IsCancun: Boolean; external name 'isCancun';
    // Returns true if signed.
    function IsSigned: Boolean; external name 'isSigned';
    // Return the most "likely" type; currently the highest supported transaction type.
    function InferType: UInt8; external name 'inferType';
    // Validates the explicit properties and returns a list of compatible transaction types.
    function InferTypes: TArray<UInt8>; external name 'inferTypes';
    // The transaction type. If null, the type will be automatically inferred based on explicit properties.
    property &Type: UInt8 read FType write FType;
    // The name of the transaction type.
    property TypeName: string read FTypeName;
    // The "to" address for the transaction
    property &To: string read FTo write FTo;
    // The transaction nonce.
    property Nonce: UInt64 read FNonce write FNonce;
     // The gas limit.
    property GasLimit: TBigInt read FGasLimit write FGasLimit;
    // The gas price. On legacy networks this defines the fee that will be paid. On EIP-1559 networks, this should be "null".
    property GasPrice: TWei read FGasPrice write FGasPrice;
    // The maximum priority fee per unit of gas to pay. On legacy networks this should be "null".
    property MaxPriorityFeePerGas: TWei read FMaxPriorityFeePerGas write FMaxPriorityFeePerGas;
    // The maximum total fee per unit of gas to pay. On legacy networks this should be "null".
    property MaxFeePerGas: TWei read FMaxFeePerGas write FMaxFeePerGas;
    // The transaction data.
    property Data: string read FData write FData;
    // The amount of ether (in wei) to send in this transactions.
    property Value: TWei read FValue write FValue;
    // The chain ID this transaction is valid on.
    property ChainId: TBigInt read FChainId write FChainId;
    // If signed, the signature for this transaction.
    property Signature: TSignature read FSignature write FSignature;
    // The transaction hash, if signed. Otherwise "null".
    property Hash: string read FHash;
    // The pre-image hash of this transaction. This is the digest that a Signer must sign to authorize this transaction.
    property UnsignedHash: string read FUnsignedHash;
    // The sending address, if signed. Otherwise "null".
    property From: string read FFrom;
    // The public key of the sender, if signed. Otherwise "null".
    property FromPublicKey: string read FFromPublicKey;
    // The serialized transaction. This throws if the transaction is unsigned.
    property Serialized: string read FSerialized;
    // The transaction pre-image. The hash of this is the digest which needs to be signed to authorize this transaction.
    property UnsignedSerialized: string read FUnsignedSerialized;
  end;

  TTransactionResponse = class external name 'ethers.TransactionResponse'(TJSObject)
  end;

function Transaction(const chainId: TBigInt; const &to: string; const value: TWei; const data: string = '0x'): TTransaction;

implementation

function Transaction(const chainId: TBigInt; const &to: string; const value: TWei; const data: string): TTransaction;
begin
  Result := TTransaction.New;
  Result.ChainId := chainId;
  Result.&To     := &to;
  Result.Value   := value;
  Result.Data    := data;
end;

end.
