# web3.pas

web3.pas is a SDK for creating decentralized Web apps in [Embarcadero Delphi](https://www.embarcadero.com/products/delphi).

web3.pas is built upon [TMS Web Core](https://www.tmssoftware.com/site/tmswebcore.asp), a framework for creating modern web applications in Delphi.

Under the hood, web3.pas is powered by [ethers.js](https://ethers.org) — a JavaScript library designed to enable developers to interact with the Ethereum blockchain and the larger Ethereum ecosystem.

Ethers.js gets downloaded at runtime and as such you don’t need to install it. But you do need [Delphi Community Edition](https://www.embarcadero.com/products/delphi/starter) and [TMS Web Core](https://www.tmssoftware.com/site/tmswebcore.asp#downloads).

Last but not least, you need a browser-based crypto wallet. Please follow the below steps to install MetaMask into your web browser.

## Installation

1. Clone this repo to a directory of your choosing, for example `C:\Projects\web3.pas`
1. Launch Delphi and start a new TMS Web Core project via _File > New > Other > TMS Web > TMS Web Application_
1. Save your application to a directory of your choosing
1. Click on: _Project > Add to Project_ and add `web3.pas` (the unit, not the directory) to your project
1. Run your application (F9)
1. Navigate to https://metamask.io/
1. Click on: Get MetaMask
1. Follow the instructions and install MetaMask into your web browser

## Configuration

Before you can use web3.pas in your TMS Web Core project, you will need to manually add the following snippet to the `<head>` section of your project's HTML document:

```html
<script type="module">
  import { ethers } from "https://cdn.jsdelivr.net/npm/ethers@6/dist/ethers.min.js";
  window.ethers = ethers;
</script>
```

Assuming you have added `web3` to your uses clause, you can now call into a global singleton named `Ethers`:

```delphi
var
  wei: TWei;
begin
  wei := Ethers.ParseEther('1.0');
  ShowMessage(wei.ToString);
end;
```

## Connecting to Ethereum

The very first thing needed to begin interacting with the blockchain is connecting to it using a [Provider](https://docs.ethers.org/v6/api/providers/#Provider):

```delphi
var
  provider: TJsonRpcProvider;
begin
  if not Assigned(Ethereum) then
    // If MetaMask is not installed, we use the default provider, which is backed
    // by a variety of third-party services (such as Infura).
    provider := Ethers.GetDefaultProvider
  else
    // Connect to the MetaMask EIP-1193 object. This is a standard protocol that
    // allows Ethers access to make all read-only requests through MetaMask.
    provider := Ethers.BrowserProvider.New(Ethereum);
  ...
end;
```

The above snippet will give you read-only access to the blockchain. When requesting write access to the blockchain - such as sending a transaction - MetaMask will show a pop-up to the user asking for permission.

## Interacting with the Blockchain

Once you have a [Provider](https://docs.ethers.org/v6/api/providers/#Provider), you have a read-only connection to the data on the blockchain. This can be used to query the current account state, fetch historic logs, look up contract code and so on.

```delphi
// Look up the current block number (i.e. height)
console.log(await(UInt64, provider.GetBlockNumber));

// Get the current balance of an account (by address or ENS name)
balance := await(TWei, provider.GetBalance('vitalik.eth'));

// Since the balance is in wei, you may wish to display it in ether instead.
console.log(Ethers.FormatEther(balance));

// Get the next nonce required to send a transaction
console.log(await(UInt64, provider.GetTransactionCount('vitalik.eth')));
```

## Sending Transactions

To write to the blockchain you need access to a private key. In most cases, those private keys are not accessible directly to your code, and instead you make requests via a [Signer](https://docs.ethers.org/v6/api/providers/#Signer), which dispatches the request to a service (such as [MetaMask](https://metamask.io/)) which provides strictly gated access and requires feedback to the user to approve or reject operations:

```delphi
var
  provider: TJsonRpcProvider;
  signer  : TJsonRpcSigner;
begin
  signer := nil;
  if Assigned(Ethereum) then
  begin
    // Connect to the MetaMask EIP-1193 object. This is a standard protocol that
    // allows Ethers access to make all read-only requests through MetaMask.
    provider := Ethers.BrowserProvider.New(Ethereum);
    // It also provides an opportunity to request access to write operations, which
    // will be performed by the private key that MetaMask manages for the user.
    signer := await(TJsonRpcSigner, provider.GetSigner);
  end else
    // If MetaMask is not installed, we use the default provider, which is backed
    // by a variety of third-party services (such as Infura).
    // They do not have private keys installed, so they only have read-only access.
    provider := Ethers.GetDefaultProvider;
  ...
end;
```

Once you have a [Signer](https://docs.ethers.org/v6/api/providers/#Signer), you can have MetaMask sign your transaction and broadcast it to the network:

```delphi
// When sending a transaction, the value is in wei, so ParseEther converts ether to wei.
tx := Transaction(
  '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045', // To: vitalik.eth
  Ethers.ParseEther('1.0')                      // Value
);

// Send tx to the network
response := await(TTransactionResponse, signer.SendTransaction(tx));
console.log(response.Hash); // the transaction hash

// Often you may wish to wait until the transaction is mined
receipt := await(TTransactionReceipt, response.Wait);
console.log(receipt.Status); // 1 for success, 0 for failure
```

## Learn more

The [ethers.js documentation](https://docs.ethers.org/v6/) covers many of the most common operations that developers require.

## License

Distributed under the [GPL-3.0](https://github.com/svanas/web3.pas/blob/master/LICENSE) license.

## Commercial support and training

Commercial support and training is available from [Stefan](https://svanas.github.io/).
