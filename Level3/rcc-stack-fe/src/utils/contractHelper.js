import { getContract as viemGetContract } from "viem";
import { viemClients } from "./viem";
import { defaultChainId } from "./wagmi";
export const getContract = ({
  abi,
  address,
  chainId = defaultChainId,
  signer,
}) => {
  const contract = viemGetContract({
    abi,
    address,
    client: {
      public: viemClients[chainId],
      wallet: signer,
    },
  });
  return {
    ...contract,
    account: signer?.account,
    chain: signer?.chain,
  };
};
