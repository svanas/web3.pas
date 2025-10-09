{******************************************************************************}
{                                                                              }
{                                  erc20.pas                                   }
{                                                                              }
{             Copyright(c) 2025 Stefan van As <svanas@runbox.com>              }
{            Github Repository <https://github.com/svanas/web3.pas>            }
{                                                                              }
{                        Distributed under GNU GPL v3.0                        }
{                                                                              }
{******************************************************************************}

unit erc20;

interface

uses
  // Delphi
  System.SysUtils,
  // pas2js
  JS,
  // web3
  web3;

type
  IReadOnlyERC20 = interface
    {----------------------------- erc20 standard -----------------------------}
    function Name: string; async;
    function Symbol: string; async;
    function Decimals: TBigInt; async;
    function TotalSupply: TBigInt; async;
    function BalanceOf(const owner: string): TBigInt; async;
    function Allowance(const owner, spender: string): TBigInt; async;
    {-------------------------------- helpers ---------------------------------}
    function Scale(const amount: string): TBigInt; async;     // from string-with-decimals to BigInt
    function Unscale(const amount: TBigInt): string; async;   // from BigInt to string-with-decimals
    function ScaleEx(const amount: Double): TBigInt; async;   // from floating point to BigInt
    function UnscaleEx(const amount: TBigInt): Double; async; // from BigInt to floating piont
  end;

  IReadWriteERC20 = interface(IReadOnlyERC20)
    function Approve(const spender: string; const value: TBigInt): TTransactionResponse; async;
    function Transfer(const &to: string; const value: TBigInt): TTransactionResponse; async;
    function TransferFrom(const from, &to: string; const value: TBigInt): TTransactionResponse; async;
  end;

function ReadOnly(const address: string): IReadOnlyERC20;
function ReadWrite(const address: string): IReadWriteERC20; async;

implementation

const ABI = '''
[
  {
    "constant": true,
    "inputs": [],
    "name": "name",
    "outputs": [
      {
        "name": "",
        "type": "string"
      }
    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "symbol",
    "outputs": [
      {
        "name": "",
        "type": "string"
      }
    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "decimals",
    "outputs": [
      {
        "name": "",
        "type": "uint8"
      }
    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "totalSupply",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "_owner",
        "type": "address"
      }
    ],
    "name": "balanceOf",
    "outputs": [
      {
        "name": "balance",
        "type": "uint256"
      }
    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "_owner",
        "type": "address"
      },
      {
        "name": "_spender",
        "type": "address"
      }
    ],
    "name": "allowance",
    "outputs": [
      {
        "name": "remaining",
        "type": "uint256"
      }
    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_to",
        "type": "address"
      },
      {
        "name": "_value",
        "type": "uint256"
      }
    ],
    "name": "transfer",
    "outputs": [
      {
        "name": "success",
        "type": "bool"
      }
    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_from",
        "type": "address"
      },
      {
        "name": "_to",
        "type": "address"
      },
      {
        "name": "_value",
        "type": "uint256"
      }
    ],
    "name": "transferFrom",
    "outputs": [
      {
        "name": "success",
        "type": "bool"
      }
    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_spender",
        "type": "address"
      },
      {
        "name": "_value",
        "type": "uint256"
      }
    ],
    "name": "approve",
    "outputs": [
      {
        "name": "success",
        "type": "bool"
      }
    ],
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "name": "_from",
        "type": "address"
      },
      {
        "indexed": true,
        "name": "_to",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "_value",
        "type": "uint256"
      }
    ],
    "name": "Transfer",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "name": "_owner",
        "type": "address"
      },
      {
        "indexed": true,
        "name": "_spender",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "_value",
        "type": "uint256"
      }
    ],
    "name": "Approval",
    "type": "event"
  }
]
''';

{------------------------------- TReadOnlyERC20 -------------------------------}

type
  TReadOnlyERC20 = class(TInterfacedObject, IReadOnlyERC20)
  private
    FContract: TContract;
  public
    function Name: string; async;
    function Symbol: string; async;
    function Decimals: TBigInt; async;
    function TotalSupply: TBigInt; async;
    function BalanceOf(const owner: string): TBigInt; async;
    function Allowance(const owner, spender: string): TBigInt; async;
    function Scale(const amount: string): TBigInt; async;
    function Unscale(const amount: TBigInt): string; async;
    function ScaleEx(const amount: Double): TBigInt; async;
    function UnscaleEx(const amount: TBigInt): Double; async;
    constructor Create(const aContract: TContract);
  end;

constructor TReadOnlyERC20.Create(const aContract: TContract);
begin
  inherited Create;
  FContract := aContract;
end;

function TReadOnlyERC20.Name: string;
begin
  Result := await(string, FContract.Call('name'));
end;

function TReadOnlyERC20.Symbol: string;
begin
  Result := await(string, FContract.Call('symbol'));
end;

function TReadOnlyERC20.Decimals: TBigInt;
begin
  Result := await(TBigInt, FContract.Call('decimals'));
end;

function TReadOnlyERC20.TotalSupply: TBigInt;
begin
  Result := await(TBigInt, FContract.Call('totalSupply'));
end;

function TReadOnlyERC20.BalanceOf(const owner: string): TBigInt;
begin
  Result := await(TBigInt, FContract.Call('balanceOf', [owner]));
end;

function TReadOnlyERC20.Allowance(const owner, spender: string): TBigInt;
begin
  Result := await(TBigInt, FContract.Call('allowance', [owner, spender]));
end;

function TReadOnlyERC20.Scale(const amount: string): TBigInt;
begin
  Result := Ethers.ParseUnits(amount, await(TBigInt, Self.Decimals).ToUInt);
end;

function TReadOnlyERC20.Unscale(const amount: TBigInt): string;
begin
  Result := Ethers.FormatUnits(amount, await(TBigInt, Self.Decimals).ToUInt);
end;

function TReadOnlyERC20.ScaleEx(const amount: Double): TBigInt;
begin
  Result := Ethers.ParseUnits(FloatToStr(amount, TFormatSettings.Invariant), await(TBigInt, Self.Decimals).ToUInt);
end;

function TReadOnlyERC20.UnscaleEx(const amount: TBigInt): Double;
begin
  Result := StrToFloat(Ethers.FormatUnits(amount, await(TBigInt, Self.Decimals).ToUInt), TFormatSettings.Invariant);
end;

{------------------------------ TReadWriteERC20 -------------------------------}

type
  TReadWriteERC20 = class(TReadOnlyERC20, IReadWriteERC20)
  public
    function Approve(const spender: string; const value: TBigInt): TTransactionResponse; async;
    function Transfer(const &to: string; const value: TBigInt): TTransactionResponse; async;
    function TransferFrom(const from, &to: string; const value: TBigInt): TTransactionResponse; async;
  end;

function TReadWriteERC20.Approve(const spender: string; const value: TBigInt): TTransactionResponse;
begin
  Result := await(TTransactionResponse, FContract.Call('approve', [spender, value]));
end;

function TReadWriteERC20.Transfer(const &to: string; const value: TBigInt): TTransactionResponse;
begin
  Result := await(TTransactionResponse, FContract.Call('transfer', [&to, value]));
end;

function TReadWriteERC20.TransferFrom(const from, &to: string; const value: TBigInt): TTransactionResponse;
begin
  Result := await(TTransactionResponse, FContract.Call('transferFrom', [from, &to, value]));
end;

{-------------------------------- constructors --------------------------------}

function ReadOnly(const address: string): IReadOnlyERC20;
begin
  Result := TReadOnlyERC20.Create(TContract.New(address, JS.toArray(TJSJSON.parse(erc20.ABI)), web3.Provider));
end;

function ReadWrite(const address: string): IReadWriteERC20;
begin
  Result := TReadWriteERC20.Create(TContract.New(address, JS.toArray(TJSJSON.parse(erc20.ABI)), await(TJsonRpcSigner, web3.Signer)));
end;

end.
