# YEARN-REGISTRY

### How to run tests on mainnet:

- `npm i -g ganache-cli`
- `npm i`
- replace YOUR_INFURA_API_KEY on `package.json`
- `npm run ganache:mainnet` (console 1)
- `npm run test` (console 2)


### How will work when deployed:

calls to `getVaultInfo(address _vault)` will return:
```json
(
  controller: '0x9E65Ad11b299CA0Abefc2799dDB6314Ef2d91080',
  token: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
  strategy: '0x932fc4fd0eEe66F22f1E23fBA74D7058391c0b15',
  isWrapped: false,
  isDelegated: false
)
```