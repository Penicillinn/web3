import { sepolia, localhost } from "viem/chains";
import { createPublicClient, http } from "viem";
export const viemClients = {
  [sepolia.id]: createPublicClient({
    chain: sepolia,
    transport: http(
      "https://sepolia.infura.io/v3/d8ed0bd1de8242d998a1405b6932ab33"
    ),
  }),
  [localhost.id]: createPublicClient({
    chain: localhost,
    transport: http("http://localhost:8545"),
  }),
};
