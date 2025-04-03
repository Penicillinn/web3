### 技术栈

```
react + viem + wagmi + nextjs + tailwindcss
```

### hardhat 本地部署合约

```
RCC 合约地址
0x96F8565658e7718aFe4589E47f251B7EdEB3d631

RCCStake 合约地址
0x204C404a2A8F3C8Ad088eEb88f3fd4d3D76a0C9e
```

### Ganache 客户端本地启动网络

```
chanId: 1337
rpcUrl: http://127.0.0.1:8545
```

### rainbowKit 添加本网络

```javascript
const localnet: Chain = {
  id: 1337,
  name: "Localhost ganache",
  nativeCurrency: { name: "Ether", symbol: "ETH", decimals: 18 },
  rpcUrls: {
    default: {
      http: ["http://127.0.0.1:8545"],
    },
  },
  blockExplorers: undefined, // 如果有区块浏览器，可以在这里定义
};

export const config = getDefaultConfig({
  appName: "RCC Stake",
  projectId: PROJECTID,
  chains: [sepolia, localnet],
  transports: {
    // 替换之前 不可用的 https://rpc.sepolia.org/
    [sepolia.id]: http(
      "https://sepolia.infura.io/v3/d8ed0bd1de8242d998a1405b6932ab33"
    ),
    [localnet.id]: http("http://127.0.0.1:8545"),
  },
  ssr: true,
});
```
