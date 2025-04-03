import { useChainId, useWalletClient } from "wagmi";
import { useMemo } from "react";
import { stakeAbi } from "../assets/abis/counter";
import { getContract } from "../utils/contractHelper";
export function useContract(address, abi, options) {
  const currentChainId = useChainId();
  const chainId = options?.chainId || currentChainId;
  const { data: walletClient } = useWalletClient();

  return useMemo(() => {
    if (!address || !abi || !chainId) return null;
    try {
      return getContract({
        abi,
        address,
        chainId,
        signer: walletClient,
      });
    } catch (error) {
      console.error("Failed to get contract", error);
      return null;
    }
  }, [address, abi, chainId, walletClient]);
}

export const useStakeContract = () => {
  const address = process.env.NEXT_PUBLIC_COUNTER_CONTRACT_ADDRESS;
  return useContract(address, stakeAbi);
};
