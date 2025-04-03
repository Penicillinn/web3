import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { sepolia, Chain } from "wagmi/chains";
import { http } from "viem";
// from https://cloud.walletconnect.com/
const PROJECTID = "e3242412afd6123ce1dda1de23a8c016";

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

export const defaultChainId = sepolia.id;
