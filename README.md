# pas2web3

pas2web3 is a SDK for creating decentralized web apps in [Embarcadero Delphi](https://www.embarcadero.com/products/delphi).

pas2web3 is built upon [TMS Web Core](https://www.tmssoftware.com/site/tmswebcore.asp), a framework for creating modern web applications in Delphi.

Under the hood, pas2web3 is powered by [ethers.js](https://ethers.org) — a JavaScript library designed to enable developers to interact with the Ethereum blockchain and the larger Ethereum ecosystem.

Ethers.js is included with pas2web3 and as such you don’t need to download and install it. But you do need [Delphi Community Edition](https://www.embarcadero.com/products/delphi/starter) and [TMS Web Core](https://www.tmssoftware.com/site/tmswebcore.asp#downloads).

The other thing you need is a browser-based crypto wallet. Please follow the below steps to install MetaMask into your web browser.

### Installation

1. Clone this repo to a directory of your choosing, for example `C:\Projects\pas2web3`
2. Start Delphi. Click on: _Tools > Options > Language > Delphi > Library_
3. Add `C:\Projects\pas2web3` to the Library Path
4. Start a new TMS Web Core project via _File > New > Other > TMS Web > TMS Web Application_
5. Click on: _Project > Options > TMS Web > Compile_
6. Make sure the Target is set to `All configurations - All platforms`
7. Add `C:\Projects\pas2web3` to the Source Path
8. Run your application (F9)
9. Navigate to https://metamask.io/
10. Click on: Get MetaMask
11. Follow the instructions and install MetaMask into your web browser

Please note you will need to repeat steps 5-7 every time you start a new TMS Web Core project.

### Configuration

Before you can use pas2web3 in your TMS Web Core project, you will need to manually add the following snippet to the `<head>` section of your project's HTML document:

```html
<script type="module">
  import { ethers } from "https://cdnjs.cloudflare.com/ajax/libs/ethers/6.7.0/ethers.min.js";
  window.ethers = ethers;
</script>
```

Assuming you have added `web3` to your uses clause, here is how to call into a global singleton named `Ethers`:

```delphi
var
  wei: TWei;
begin
  wei := Ethers.ParseEther('1.0');
  ShowMessage(WeiToHex(wei));
end;
```

### Connecting to Ethereum

This very first thing needed to begin interacting with the blockchain is connecting to it using a [Provider](https://docs.ethers.org/v6/api/providers/#Provider).

```delphi
var
  provider: TJsonRpcApiProvider;
begin
  if not Assigned(Ethereum) then
    provider := Ethers.GetDefaultProvider
  else
    provider := Ethers.BrowserProvider.New(Ethereum);
  console.log(provider);
end;
```

The above snippet will give you read-only access to the blockchain. When requesting write access to the blockchain, such as sending a transaction, MetaMask will show a pop-up to the user asking for permission.

### Learn more

This is a very short introduction, but covers many of the most common operations that developers require and provides a starting point for those newer to Ethereum: https://docs.ethers.org/v6/getting-started/
