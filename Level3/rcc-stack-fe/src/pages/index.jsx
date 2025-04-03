import { useCallback, useEffect, useState } from "react";
import { useAccount, useWalletClient } from "wagmi";
import { zeroAddress, formatEther, parseEther } from "viem";
import { waitForTransactionReceipt } from "viem/actions";
import { toast } from "react-toastify";
import Card from "../components/card";
import { useStakeContract } from "../hooks/useContract";
import { Pid } from "../constants";
const Home = () => {
  const [stakedAmount, setStakedAmount] = useState(0);
  const [amount, setAmount] = useState("");
  const stakeContract = useStakeContract();
  const { address, isConnected } = useAccount();
  const { data } = useWalletClient();

  const getStakedAmount = useCallback(async () => {
    if (!address || !stakeContract) return;
    const res = await stakeContract?.read.stakingBalance([Pid, address]);
    setStakedAmount(formatEther(res));
  }, [stakeContract, address]);

  const handleAdd = useCallback(async () => {
    if (!stakeContract) return;
    const tx = await stakeContract?.write.addPool([
      zeroAddress,
      200,
      0,
      2,
      false,
    ]);
    await waitForTransactionReceipt(data, { hash: tx });
    toast.success("创建成功");
    getStakedAmount();
  });

  const handleStake = useCallback(async () => {
    if (!amount) {
      toast.error("Please enter the deposit amount");
      return;
    }
    try {
      const tx = await stakeContract?.write.depositETH([], {
        value: parseEther(amount),
      });
      await waitForTransactionReceipt(data, { hash: tx });
      setAmount("");
      toast.success("存款成功");
      getStakedAmount();
    } catch (error) {
      console.error("Stake error: ", error);
    }
  }, [amount, stakeContract]);

  useEffect(() => {
    getStakedAmount();
  }, [getStakedAmount]);

  return (
    <Card>
      {/* <button onClick={handleAdd}>添加eth池子</button> */}
      <div>Staked Amount: {stakedAmount} ETH</div>
      <div className="my-3">
        <input
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          type="text"
          className="w-full p-2 border border-gray-300 rounded-md"
          placeholder="Please enter the deposit amount"
        />
      </div>
      {isConnected ? (
        <button
          onClick={handleStake}
          className="w-full p-2 bg-blue-500 text-white rounded-md cursor-pointer"
        >
          Stake
        </button>
      ) : (
        <div className="text-center text-xl">Please connect the wallet</div>
      )}
    </Card>
  );
};

export default Home;
