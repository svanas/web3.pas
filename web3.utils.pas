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

implementation

uses
  web3;

const
  Decimals: array[TDenomination] of Byte = (
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
