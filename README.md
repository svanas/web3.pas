# pas2web3

pas2web3 is a SDK for creating decentralized web apps in [Embarcadero Delphi](https://www.embarcadero.com/products/delphi).

pas2web3 is built upon [TMS Web Core](https://www.tmssoftware.com/site/tmswebcore.asp), a framework for creating modern web applications in Delphi.

Under the hood, pas2web3 is powered by [ethers.js](https://ethers.org) — a JavaScript library designed to enable developers to interact with the Ethereum blockchain and the larger Ethereum ecosystem.

Ethers.js is included with pas2web3 and as such you don’t need to download and install it. But you do need [Delphi Community Edition](https://www.embarcadero.com/products/delphi/starter) and [TMS Web Core](https://www.tmssoftware.com/site/tmswebcore.asp#downloads).

### Setup

Before you can use pas2web3 in your TMS Web Core project, you will need to manually add the following snippet to the `<head>` section of your project's HTML document:

```html
<script type="module">
  import { ethers } from "https://cdnjs.cloudflare.com/ajax/libs/ethers/6.7.0/ethers.min.js";
  window.ethers = ethers;
</script>
```

Assuming you have added the pas2web3 directory to your TMS Web Source Path and you have added `web3` to your uses clause, here is how to call into a global singleton named `Ethers`:

```delphi
var
  value: TWei;
begin
  value := Ethers.ParseEther('1.0');
  ShowMessage(WeiToHex(value));
end;
```
